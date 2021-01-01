//
//  LaunchCell.swift
//  IosGraphqlTutorial
//
//  Created by 신동규 on 2021/01/01.
//

import UIKit
import SDWebImage

class LaunchCell: UICollectionViewCell {
    // MARK: Properties
    var launch:LaunchListQuery.Data.Launch.Launch? {
        didSet {
            
            guard let launch = self.launch else { return }
            titleLabel.text = launch.site
            missionNameLabel.text = launch.mission?.name
            self.imageView.image = nil 
            if let imageUrlString = launch.mission?.missionPatch {
                if let url = URL(string: imageUrlString) {
                    self.imageView.sd_setImage(with: url, completed: nil)
                }
            }
            
        }
    }
    
    private lazy var imageView:UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()
    
    lazy var titleLabel:UILabel = {
       let label = UILabel()
        return label
    }()
    
    private lazy var missionNameLabel:UILabel = {
        let label = UILabel()
         return label
    }()
    
    
    // MARK: Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configures
    func configureUI() {
        backgroundColor = .systemBackground
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 4).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 11).isActive = true
        
        
        addSubview(missionNameLabel)
        missionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        missionNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        missionNameLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
         
    }
}
