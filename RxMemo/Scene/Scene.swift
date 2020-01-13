//
//  Scene.swift
//  RxMemo
//
//  Created by devming on 2020/01/13.
//  Copyright © 2020 devming. All rights reserved.
//

import UIKit

/// 앱에서 구현할 Scene을 열거형으로
enum Scene {
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}

/// storyboard에 있는 scene을 생성하고, 연관값에 저장된 viewmodel을 binding해서 리턴하는 메소드를 구현
extension Scene {
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .list(let viewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else {
                fatalError()
            }
            
            guard var listVC = nav.viewControllers.first as? MemoListViewController else {
                fatalError()
            }
            
            listVC.bind(viewModel: viewModel)
            return nav
        case .detail(let viewModel):
            guard var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else {
                fatalError()
            }
            
            detailVC.bind(viewModel: viewModel)
            return detailVC
        case .compose(let viewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else {
                fatalError()
            }
            
            guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else {
                fatalError()
            }
            
            composeVC.bind(viewModel: viewModel)
            return nav
        }
    
        
    }
}
