//
//  APIContainer.swift
//  Network_Practice
//
//  Created by 이지희 on 6/12/24.
//

import Foundation

class MockAppDIContainer {
    static let shared = MockAppDIContainer()

    private init() {}

    func makeMockNetworkService() -> NetworkServiceProtocol {
        return MockNetworkService()
    }

    func makeMockUserRepository() -> TestRepository {
        return MockRepositoryImpl(networkService: makeMockNetworkService())
    }

    func makeMockGetUserUseCase() -> GetUserUseCase {
        return GetUserUseCaseImpl(userRepository: makeMockUserRepository())
    }
}
