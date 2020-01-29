//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by devming on 2020/01/13.
//  Copyright © 2020 devming. All rights reserved.
//

/**
 Step 15. MemoDetailViewModel 구현
 -
 */
import Foundation
import RxSwift
import RxCocoa
import Action

class MemoDetailViewModel: CommonViewModel {
    /// 이전 scene에서 전달된 메모
    let memo: Memo
    
    private var formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "Ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
    
    /// BehaviorSubject를 쓰는 이유
    /// - 메모를 편집한 다음에 다시 보기화면으로 오면 편집한 내용이 반영되어야 한다.
    /// - 이렇게 되면 새로운 문자열 배열을 방출해야한다.
    /// - 일반 옵저버블로하면 불가능하기 때문.
    var contents: BehaviorSubject<[String]>
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.memo = memo
        contents = BehaviorSubject<[String]>(value: [memo.content, formatter.string(from: memo.insertDate)])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
