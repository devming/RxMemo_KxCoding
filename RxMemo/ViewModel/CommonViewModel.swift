//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by devming on 2020/01/13.
//  Copyright © 2020 devming. All rights reserved.
//

import RxSwift
import RxCocoa


class CommonViewModel: NSObject {
    /// 앱을 구성하는 모든 scene은 navigation controller에 embed 되기 때문에 navigation title이 필요.
    let title: Driver<String>
    /// 프로토콜 선언 -> 의존성을 쉽게 수정할 수 있음
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoStorageType
    
    /// 생성자 - 속성 초기화
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
    
}
