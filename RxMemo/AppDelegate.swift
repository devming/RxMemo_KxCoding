//
//  AppDelegate.swift
//  RxMemo
//
//  Created by devming on 2020/01/08.
//  Copyright © 2020 devming. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let storage = MemoryStorage()
        let storage = CoreDataStorage(modelName: "RxMemo")
        let coordinator = SceneCoordinator(window: window!)
        let listViewModel = MemoListViewModel(title: "나의 메모", sceneCoordinator: coordinator, storage: storage)
        /// list Scene
        let listScene = Scene.list(listViewModel)
        
        coordinator.transition(to: listScene, using: .root, animated: false)
        return true
    }


}

