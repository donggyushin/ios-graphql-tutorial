//
//  FirstController.swift
//  IosGraphqlTutorial
//
//  Created by 신동규 on 2021/01/01.
//

import UIKit
import Apollo
private let launchCellIdentifier = "launchCellIdentifier"


class FirstController: UIViewController {
    
    // MARK: Properties
    enum ListSection:Int, CaseIterable {
        case launches
        case loading
    }
    
    private var lastConnection: LaunchListQuery.Data.Launch?
    private var activeRequest: Cancellable?
    var loading = true
    
    var launches = [LaunchListQuery.Data.Launch.Launch]() {
        didSet {
            print("Fetch Launches!")
            self.collectionView.reloadData()
        }
    }
    
    private lazy var collectionView:UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.register(LaunchCell.self, forCellWithReuseIdentifier: launchCellIdentifier)
        return cv
    }()

    // MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
        fetchLaunches()
    }
    
    // MARK: Configures
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: APIS
    func fetchLaunches() {
        Network.shared.fetchLuanchList { (error, launches, lastLaunch) in
            if let launches = launches {
                self.launches = launches
                self.loading = false
            }
            if let lastLaunch = lastLaunch {
                self.lastConnection = lastLaunch
            }
        }
        
    }

}





extension FirstController:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ListSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let listSection = ListSection(rawValue: section) else {
            return 0
        }
        
        switch listSection {
        case .launches:
            return self.launches.count
        case .loading:
            if self.lastConnection?.hasMore == false {
                return 0
            }else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: launchCellIdentifier, for: indexPath) as! LaunchCell
        cell.launch = nil
        cell.launch = self.launches[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let launch = self.launches[indexPath.row]
        let launchDetailController = LaunchDetailController()
        launchDetailController.launchId = launch.id
        navigationController?.pushViewController(launchDetailController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if self.lastConnection?.hasMore == true {
            guard let cursor = self.lastConnection?.cursor else { return }
            if indexPath.row == self.launches.count - 1 {
                if self.loading == false {
                    self.loading = true
                    
                    Network.shared.fetchMoreLaunches(cursor: cursor) { (error, launches, lastLaunch) in
                        self.loading = false
                        if let launches = launches {
                            self.launches.append(contentsOf: launches)
                        }
                        if let lastLaunch = lastLaunch {
                            self.lastConnection = lastLaunch
                        }
                    }
                }
            }
        }
    }
    
    
}

extension FirstController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 100)
    }
}
