//
//  ViewController.swift
//  YoutubeClone
//
//  Created by Ky Nguyen on 10/13/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var videos : [Video] = {
        
        var keenChannel = Channel()
        keenChannel.name = "This is the best channel"
        keenChannel.profileImageName = "swift-banner"
        
        var blankSpaceVideo = Video()
        blankSpaceVideo.title = "Ky Nguyen is following Lets build that app from Youtube to make a Youtube application"
        blankSpaceVideo.thumbnailImageName = "swift-banner"
        blankSpaceVideo.channel = keenChannel
        blankSpaceVideo.numberOfViews = 12023123
        blankSpaceVideo.uploadedDate = NSDate()
        
        return [blankSpaceVideo]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = true
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")

        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        edgesForExtendedLayout = .bottom
        
        setupMenuBar()
        
        setupNavigationIcons()
    }
    let menuBar : MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraints(withFormat: "H:|[v0]|", views: menuBar)
        view.addConstraints(withFormat: "V:|[v0(50)]", views: menuBar)
    }
    
    func setupNavigationIcons() {
        let search = UIBarButtonItem(image: UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(handleSearch))
        let menu = UIBarButtonItem(image: UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(handleMenu))
        search.tintColor = UIColor.white
        menu.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [menu, search]
    }
    
    func handleSearch() {
        
    }
    
    func handleMenu() {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        cell.video = videos[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 32) * 9 / 16
        return CGSize(width: view.frame.width, height: height + 84)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
