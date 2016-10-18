//
//  VideoCell.swift
//  YoutubeClone
//
//  Created by Ky Nguyen on 10/14/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        
    }
}

final class VideoCell: BaseCell {
    
    var video : Video? {
        didSet {
            titleLabel.text = video?.title
            setupThumbnailImage()
            setupUserProfileImage()
            
            if let channelName = video?.channel?.name, let numberOfViews = video?.numberOfViews, let uploadedDate = video?.uploadedDate {
                let subtitleText = "\(channelName) - \(numberOfViews) views - \(uploadedDate)"
                subtitleTextView.text = subtitleText
            }
            
            // measure title text
            if let title = video?.title {
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
                if estimatedRect.size.height > 20 {
                    titleHeight?.constant = 36
                    subtitleHeight?.constant = 15
                }
                else {
                    titleHeight?.constant = 20
                    subtitleHeight?.constant = 30
                }
            }
 
        }
    }
    
    func setupThumbnailImage() {
        if let thumbnailUrl = video?.thumbnailImageName {

            self.thumbnailImageView.loadImage(with: thumbnailUrl)
        }
    }
    
    func setupUserProfileImage() {
        if let profileUrl = video?.channel?.profileImageName {

            self.userProfileImageView.loadImage(with: profileUrl)
        }
    }
    
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        return view
    }()
    
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 22
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Youtube app from Brain (Lets build that app) - 10 views - 1 years ago"
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = UIColor.lightGray
        textView.isScrollEnabled = false
        return textView
    }()
    
    var titleHeight : NSLayoutConstraint?
    var subtitleHeight : NSLayoutConstraint?
    
    override func setupView() {
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        
        addConstraints(withFormat: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraints(withFormat: "H:|-16-[v0(44)]", views: userProfileImageView)
        
        // vertical constraint for thumbnail image view and separator view
        addConstraints(withFormat: "V:|-16-[v0]-8-[v1(44)]-18-[v2(0.5)]|", views: thumbnailImageView, userProfileImageView, separatorView)
        
        addConstraints(withFormat: "H:|[v0]|", views: separatorView)
        
        // title top constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        
        // title left constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        // title right constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        
        // title height constraint
        titleHeight = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 20)
        addConstraint(titleHeight!)
        
        // subtitle top constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        
        // subtitle left constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        // subtitle right constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1, constant: 0))
        
        //subtitle height constraint
        subtitleHeight = NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        addConstraint(subtitleHeight!)
    }
}


