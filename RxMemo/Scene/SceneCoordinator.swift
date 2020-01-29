//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by devming on 2020/01/13.
//  Copyright © 2020 devming. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension UIViewController {
    /// Step 17. 보기화면으로 넘어가지 않는 현상 수정
    /// - SceneCoordinator를 구현할 때 가장 주의해야하는 부분은 vc를 embed하고 있는 controller가 아니라 '실제 화면에 표시되어 있는 vc'를 기준으로 전환을 처리해야 한다.
    var sceneViewController: UIViewController {
        return self.children.first ?? self
    }
}

class SceneCoordinator: SceneCoordinatorType {
    private let bag = DisposeBag()
    
    /// SceneCoordinator는 화면 전환을 담당하기 때문에 window 인스턴스와 현재 화면에 표시되어있는 scene을 가지고 있어야한다.
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        /// 전환결과를 방출할 subject
        let subject = PublishSubject<Void>()
        let target = scene.instantiate()
        
        /// transition style에 따라 실제 전환 구현
        switch style {
        case .root: /// 그냥 root를 바꿔주면 됨.
            currentVC = target.sceneViewController
            window.rootViewController = target
            subject.onCompleted()
        case .push: /// # navigation controller에 embed되어 있을 때만 유의미함. 없으면 에러
            print(currentVC)
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            /// back button
            nav.rx.willShow
                .subscribe(onNext: { [unowned self] evt in
                    self.currentVC = evt.viewController.sceneViewController
                    
                }).disposed(by: bag)
            
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
            
            subject.onCompleted()
        case .modal:
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentVC = target.sceneViewController
        }
        
        return subject.ignoreElements()
    }
    
    @discardableResult
    func close(animated: Bool) -> Completable {
        return Completable.create { [unowned self] completable in
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC.sceneViewController
                    completable(.completed)
                }
            } else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.first!
                completable(.completed)
            } else {
                completable(.error(TransitionError.unknown))
            }
            
            return Disposables.create()
        }
    }
    
}
