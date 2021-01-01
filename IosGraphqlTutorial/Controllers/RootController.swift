//
//  RootController.swift
//  IosGraphqlTutorial
//
//  Created by 신동규 on 2021/01/01.
//

import UIKit

class RootController: UITabBarController {

    // MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureControllers()
        
        Network.shared.login { (token) in
            if let token = token {
                print("Token:\(token)")
                LocalStorageService.shared.setAuthTokenValue(token: token)
            }
        }
    }
    
    // MARK: Configures
    func configureControllers() {
        
        let firstController = FirstController()
        let firstControllerNavigationController = UINavigationController(rootViewController: firstController)
        
        firstControllerNavigationController.tabBarItem.title = "launches"
        
        viewControllers = [firstControllerNavigationController]
    }

}
