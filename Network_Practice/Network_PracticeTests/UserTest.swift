//
//  UserTest.swift
//  Network_PracticeTests
//
//  Created by 이지희 on 6/12/24.
//

import XCTest
@testable import Network_Practice

class UserRepositoryTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var testRepository: TestRepository!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        testRepository = MockRepositoryImpl(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        mockNetworkService = nil
        testRepository = nil
        super.tearDown()
    }
    
    func testGetUserSuccess() async throws {
        let mockJson = """
                {
                    "id": 1,
                    "name": "Mock User"
                }
                """
        
        let mockData = mockJson.data(using: .utf8)!
        mockNetworkService.mockData = mockData
        
        // getUser 메소드를 호출합니다.
        let user = try await testRepository.getUser(id: 1)
        
        // 결과를 검증합니다.
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.name, "Mock User")
    }
    
    func testGetUserFailure() async throws {
        // Mock 에러를 설정합니다.
        mockNetworkService.error = NetworkError.noData
        
        do {
            // getUser 메소드를 호출합니다.
            let _ = try await testRepository.getUser(id: 1)
            XCTFail("Expected to throw an error, but it did not")
        } catch {
            // 에러가 발생했는지 검증합니다.
            XCTAssertEqual(error as? NetworkError, NetworkError.noData)
        }
    }
}


//UseCase 테스트
class GetUserUseCaseTests: XCTestCase {
    var mockUserRepository: MockRepository!
    var getUserUseCase: GetUserUseCase!
    
    override func setUp() {
        super.setUp()
        mockUserRepository = MockRepository()
        getUserUseCase = GetUserUseCaseImpl(testRepository: mockUserRepository)
    }
    
    override func tearDown() {
        mockUserRepository = nil
        getUserUseCase = nil
        super.tearDown()
    }
    
    func testExecuteSuccess() async throws {
        // JSON Mock 데이터를 설정합니다.
        let mockJson = """
            {
                "id": 1,
                "name": "Mock User"
            }
            """
        let mockData = mockJson.data(using: .utf8)!
        let mockUser = try! JSONDecoder().decode(User.self, from: mockData)
        mockUserRepository.mockUser = mockUser
        
        let user = try await getUserUseCase.execute(id: 1)
        
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.name, "Mock User")
    }
    
    func testExecuteFailure() async throws {
        // Mock 에러를 설정합니다.
        mockUserRepository.error = NetworkError.noData
        
        do {
            // execute 메소드를 호출합니다.
            let _ = try await getUserUseCase.execute(id: 1)
            XCTFail("Expected to throw an error, but it did not")
        } catch {
            // 에러가 발생했는지 검증합니다.
            XCTAssertEqual(error as? NetworkError, NetworkError.noData)
        }
    }
}
