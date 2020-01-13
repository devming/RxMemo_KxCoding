//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by devming on 2020/01/13.
//  Copyright © 2020 devming. All rights reserved.
//

import RxSwift
import RxCocoa

class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
}
