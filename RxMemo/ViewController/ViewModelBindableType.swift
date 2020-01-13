//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by devming on 2020/01/13.
//  Copyright © 2020 devming. All rights reserved.
//

import UIKit

///vc에서 이 프로토콜을 채용할 것임
protocol ViewModelBindableType {
    /// view model의 타입은 view controller마다 달라지기 때문에 프로토콜을 generic프로토콜로 생성할 것임.
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

/// vc에 추가된 vm속성의 실제 vm을 저장하고 bindViewModel메소드를 자동으로 호출하는 메소드를 구현한다.
extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        /// 개별 view controller에서 bindViewModel메소드를 직접 호출할 필요가 없어짐.
        bindViewModel()
    }
}
