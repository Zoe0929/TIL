//
//  UseCase.swift
//  Network_Practice
//
//  Created by 이지희 on 6/12/24.
//

import Foundation

// UseCase 비즈니스 로직 처리
protocol GetUserUseCase {
    func execute(id: Int) async throws -> User
}

class GetUserUseCaseImpl: GetUserUseCase {
    private let testRepository: TestRepository

    init(testRepository: TestRepository) {
        self.testRepository = testRepository
    }

    func execute(id: Int) async throws -> User {
        return try await testRepository.getUser(id: id)
    }
}
