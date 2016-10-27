//
//  SettingCell.swift
//  YoutubeClone
//
//  Created by Ky Nguyen on 10/17/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

final class SettingCell: BaseCell {

    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    var iconImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = UIViewContentMode.scaleAspectFill
        return iv
    }()
    
    var setting : Setting? {
        didSet {
            nameLabel.text = setting?.name.rawValue
            if let imageName = setting?.imageName {
                iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = UIColor.darkGray
            }
        }
    }
    
    override func setupView() {
        super.setupView()
        
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        addConstraints(withFormat: "H:|-8-[v0(24)]-8-[v1]|", views: iconImageView, nameLabel)
        addConstraints(withFormat: "V:|[v0]|", views: nameLabel)
        addConstraints(withFormat: "V:[v0(24)]", views: iconImageView)
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted  ? UIColor.darkGray : UIColor.white
            nameLabel.textColor = isHighlighted  ? UIColor.white : UIColor.black
            iconImageView.tintColor = isHighlighted  ? UIColor.white : UIColor.darkGray
        }
    }
}
