//
//  SceneDelegate.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {return}
        window = UIWindow(windowScene: windowScene)
        let memoHomeVC = MemoHomeViewController()
        let navigationController = UINavigationController(rootViewController: memoHomeVC)
        window?.rootViewController = navigationController
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
    }
}

