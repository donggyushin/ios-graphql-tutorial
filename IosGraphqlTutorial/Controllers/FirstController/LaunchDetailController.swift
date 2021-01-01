//
//  LaunchDetailController.swift
//  IosGraphqlTutorial
//
//  Created by 신동규 on 2021/01/01.
//

import UIKit
import Apollo
import SDWebImage

class LaunchDetailController: UIViewController {
    // MARK: Properties
    var launchId:GraphQLID? {
        didSet {
            guard let launchId = self.launchId else { return }
            self.title = launchId
            fetchLaunch(id: launchId)
        }
    }
    
    var launch:LaunchQuery.Data.Launch? {
        didSet {
            guard let launch = self.launch else { return }
            self.imageView.image = nil
            if let urlString = launch.mission?.missionPatch {
                if let url = URL(string: urlString) {
                    self.imageView.sd_setImage(with: url, completed: nil)
                }
            }
            
            self.siteLabel.text = launch.site
            self.missionNameLabel.text = launch.mission?.name
            self.rocketNameLabel.text = launch.rocket?.name
            if launch.isBooked {
                self.isBookedLabel.text = "Booked"
                self.bookButton.setTitle("Cancel", for: UIControl.State.normal)
            }else {
                self.isBookedLabel.text = "Not Booked"
                self.bookButton.setTitle("Book", for: UIControl.State.normal)
            }
        }
    }
    
    private lazy var imageView:UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        iv.layer.cornerRadius = 50
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()
    
    private lazy var siteLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var missionNameLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var rocketNameLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var isBookedLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var bookButton:UIButton = {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.addTarget(self, action: #selector(buttonTapped), for: UIControl.Event.touchUpInside)
        return bt
    }()

    // MARK: Lifecycles
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
    }
    
    // MARK: Configures
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        view.addSubview(siteLabel)
        siteLabel.translatesAutoresizingMaskIntoConstraints = false
        siteLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        siteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(missionNameLabel)
        missionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        missionNameLabel.topAnchor.constraint(equalTo: siteLabel.bottomAnchor, constant: 10).isActive = true
        missionNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(rocketNameLabel)
        rocketNameLabel.translatesAutoresizingMaskIntoConstraints = false
        rocketNameLabel.topAnchor.constraint(equalTo: missionNameLabel.bottomAnchor, constant: 10).isActive = true
        rocketNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(bookButton)
        bookButton.translatesAutoresizingMaskIntoConstraints = false
        bookButton.topAnchor.constraint(equalTo: rocketNameLabel.bottomAnchor, constant: 40).isActive = true
        bookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    // MARK: APIs
    func fetchLaunch(id:GraphQLID) {
        Network.shared.fetchLaunchDetail(id: id) { (error, launch) in
            if let launch = launch {
                self.launch = launch
            }
        }
    }
    
    // MARK: Selectors
    @objc func buttonTapped() {
        guard let launch = self.launch else { return }
        if self.launch?.isBooked == true {
            // 예약취소하기
            Network.shared.cancelTrip(launchId: launch.id) { (error, success) in
                if success == true {

                    self.launch?.isBooked = false
                }
            }
        }else {
            // 예약하기
            
            Network.shared.bookTrips(launchIds: [launch.id]) { (error, success, message) in
                
                if success == true {

                    self.launch?.isBooked = true
                }
            }
        }
    }

}
