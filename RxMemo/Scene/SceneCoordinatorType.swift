//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by devming on 2020/01/13.
//  Copyright © 2020 devming. All rights reserved.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    /// 새로운 scene을 표시한다.
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    /// 현재 scene을 닫고 이전 scene으로 돌아간다.
    @discardableResult
    func close(animated: Bool) -> Completable
    
    
}
