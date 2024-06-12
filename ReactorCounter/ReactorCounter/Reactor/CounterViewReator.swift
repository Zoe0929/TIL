//
//  CounterViewReator.swift
//  ReactorCounter
//
//  Created by 이지희 on 6/13/24.
//

import Foundation

import ReactorKit

class CounterViewReator: Reactor {
    
    var initialState: State = State(value: 0, isShowing: false, isLoading: false)
    
    /// Action : user interaction +, - 버튼 누른 경우
    enum Action {
        case increase
        case decrease
    }
    
    /// Mutation: Action과 State의 브릿지 역할, 값 증가, 감소 / indicator 숨김 여부, 활성화 여부
    enum Mutation {
        case increaseValue
        case decreaseValue
        case setShowing(Bool)
        case setLoading(Bool)
    }
    
    /// State: view의 상태
    struct State {
        var value: Int
        var isShowing: Bool
        var isLoading: Bool
    }
    
    /// 각각의 action이 들어왔을 때 어떻게 행동하라고 하는 것 -> observable 사용
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .increase:
            return Observable.concat([
                Observable.just(Mutation.setShowing(true)),
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.increaseValue).delay(.microseconds(500), scheduler:MainScheduler.instance),
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setShowing(false)),
            ])
        case .decrease:
            return Observable.concat([
                Observable.just(Mutation.setShowing(true)),
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.decreaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),  // indicator가 잘 동작하는지 확인하기 위한 delay
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setShowing(false)),
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .increaseValue:
            newState.value += 1
        case .decreaseValue:
            newState.value -= 1
        case let .setShowing(isShowing):
            newState.isShowing = isShowing
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        
        return newState
    }
}
