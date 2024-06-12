import Foundation

import Alamofire

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) async throws -> T {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: endpoint.method,
                       parameters: endpoint.parameters,
                       headers: endpoint.headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode {
                            continuation.resume(throwing: NetworkError.serverError(statusCode: statusCode))
                        } else {
                            continuation.resume(throwing: error)
                        }
                    }
                }
        }
    }
}
