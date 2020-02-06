//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by devming on 2020/01/13.
//  Copyright © 2020 devming. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MemoComposeViewModel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
        
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: rx.disposeBag)
        
        /// TextView Keyboard 조절
        ///
        /// 해당 notification이 전달될 때 마다 새로운 next이벤트를 방출하는 옵저버블을 리턴한다.
        let willShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 }
        
        let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { noti -> CGFloat in 0 }
        
        /// 두 옵저버블 merge
        
        let keyboardObservable = Observable.merge(willShowObservable, willHideObservable).share()
        
        keyboardObservable
            .subscribe(onNext: { [weak self] height in
                guard let `self` = self else { return }
                
                var inset = self.contentTextView.contentInset
                inset.bottom = height
                
                var scrollInset = self.contentTextView.scrollIndicatorInsets
                scrollInset.bottom = height
                
                UIView.animate(withDuration: 0.3) {
                    self.contentTextView.contentInset = inset
                    self.contentTextView.scrollIndicatorInsets = scrollInset
                }
            }).disposed(by: rx.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
}
