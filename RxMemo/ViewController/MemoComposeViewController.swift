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
            .toContentInset(of: self.contentTextView)
            .bind(to: contentTextView.rx.contentInset)
            .disposed(by: rx.disposeBag)
        
        keyboardObservable
            .toContentInset(of: self.contentTextView)
            .bind(to: contentTextView.rx.scrollIndicatorInsets)
            .disposed(by: rx.disposeBag)
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


/// Custom 연산자 구현하기
/// next이벤트에 포함된 요소를 원하는 방식으로 처리한 다음에 결과를 방출하는 새로운 옵저버블을 리턴하는 방식으로 구현한다.
extension ObservableType where Element == CGFloat { // CGFloat을 방출하는 Observable 형식에서만 적용된다.
    /// 1. 반복적으로 사용하는 코드를 연산자로 배치하고
    func toContentInset(of textView: UITextView) -> Observable<UIEdgeInsets> {
        return map { height in
            var inset = textView.contentInset
            inset.bottom = height
            return inset
        }
    }
}

/// 2. UI와 관련된 속성을 Binder로 구성하면 코드가 단순해진다.
extension Reactive where Base: UITextView {
    var contentInset: Binder<UIEdgeInsets> {
        return Binder(self.base) { textView, inset in
            textView.contentInset = inset
        }
    }
    
    var scrollIndicatorInsets: Binder<UIEdgeInsets> {
        return Binder(self.base) { textView, inset in
            textView.scrollIndicatorInsets = inset
        }
    }
}
