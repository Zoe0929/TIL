//
//  ViewController.swift
//  ReactorCounter
//
//  Created by 이지희 on 6/13/24.
//

import UIKit

import RxSwift
import RxCocoa
import ReactorKit


/// StoryBoardView(View)를 채택, reactor프로퍼티와 bind method 구현 필요
final class ViewController: UIViewController, StoryboardView {
    var disposeBag = DisposeBag()
    
    let increaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    let decreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .black
        return label
    }()
    
    let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    ///  bind(reactor:) method는 viewDidLoad 이후에 호출되기 때문에 viewDidLoad에서 Reactor 인스턴스를 주입
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = CounterViewReator()
        setUI()
    }
    
    /// 파라미터 타입을 원하는 Reactor 타입으로 변경
    /// Action을 Reactor로 전달해주고 Reactor로부터 State를 받아서 UI로 뿌려주는 역할
    func bind(reactor: CounterViewReator) {
        increaseButton.rx.tap                   // 버튼 이벤트를
            .map { Reactor.Action.increase }    // Action으로 변환해서
            .bind(to: reactor.action)           // reactor에 binding
            .disposed(by: disposeBag)
        
        decreaseButton.rx.tap
            .map { Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state                           // reactor한테 state를 받아서
            .map { "\($0.value)" }              // value 값만 뽑은 뒤에
            .distinctUntilChanged()             // 이전 값하고 달라졌으면
            .bind(to: valueLabel.rx.text)       // label 텍스트로 설정
            .disposed(by: disposeBag)
        
        reactor.state
            .map { !$0.isShowing }
            .distinctUntilChanged()
            .bind(to: indicatorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        [increaseButton,
         decreaseButton,
         valueLabel,
         indicatorView].forEach { subView in
            view.addSubview(subView)
        }
    }
    
    private func setConstraints() {
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            increaseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            increaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            decreaseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            decreaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            valueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30)
        ])
    }
    
}

