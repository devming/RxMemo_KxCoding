//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by devming on 2020/01/13.
//  Copyright © 2020 devming. All rights reserved.
//

/**
 Step 14. 메모 보기 화면 구현
 */
import UIKit
import RxSwift
import RxCocoa

class MemoDetailViewController: UIViewController, ViewModelBindableType {

    var viewModel: MemoDetailViewModel!
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        /// tableView binding
        viewModel.contents
            .bind(to: listTableView.rx.items) { tableView, row, value in
                switch row {
                /// 첫번째 cell
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")!
                    cell.textLabel?.text = value
                    return cell
                /// 두번째 cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell")!
                    cell.textLabel?.text = value
                    return cell
                default:
                    fatalError()
                }
            }
            .disposed(by: rx.disposeBag)
        
        editButton.rx.action = viewModel.makeEditAction()
        
        deleteButton.rx.action = viewModel.makeDeleteAction()
        
        shareButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)/// double tap 막기
            .subscribe(onNext: { [weak self] _ in
                guard let memo = self?.viewModel.memo.content else { return }
                
                let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
                self?.present(vc, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
//        /// 기본으로 제공되는 navigationController의 back button을 대체하는 코드
//        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
//        viewModel.title
//            .drive(backButton.rx.title)
//            .disposed(by: rx.disposeBag)
//        backButton.rx.action = viewModel.popAction
//        navigationItem.hidesBackButton = true
//        navigationItem.leftBarButtonItem = backButton
    }
}

