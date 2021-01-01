//
//  ViewController.swift
//  IosGraphqlTutorial
//
//  Created by 신동규 on 2021/01/01.
//

import UIKit

class ViewController: UIViewController {
    
    var launches = [LaunchListQuery.Data.Launch.Launch]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Apollo.shared.fetchLuanchList()
    }


}

