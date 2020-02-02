//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by devming on 2020/01/13.
//  Copyright © 2020 devming. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Action

class MemoListViewController: UIViewController, ViewModelBindableType {
    var viewModel: MemoListViewModel!
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func bindViewModel() {
        /// viewModel에 저장되어있는 title을 navigationItem에 binding
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        /// 메모목록을 tableView에 binding
        viewModel.memoList
            .bind(to: listTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: rx.disposeBag)
        
        addButton.rx.action = viewModel.makeCreateAction()
        
        /// tableView에서 메모를 선택하면, viewModel을 통해 detailAction을 전달하고, 선택한 cell은 선택해제 합니다.
        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected)
            .do(onNext: { [unowned self] (_, indexPath) in
                self.listTableView.deselectRow(at: indexPath, animated: true)
            })
            .map { $0.0 }
            .bind(to: viewModel.detailAction.inputs)    /// 선택한 메모가 detailAction에 구현된 코드가 실행된다.
            .disposed(by: rx.disposeBag)
        
        /// Step 20. 메모 삭제
        /// modelDeleted메소드는 ControlEvent이벤트 리턴.
        /// ControlEvent는 삭제하면 next이벤트 방출
        listTableView.rx.modelDeleted(Memo.self)
            .bind(to: viewModel.deleteAction.inputs)
            .disposed(by: rx.disposeBag)
    }
}
