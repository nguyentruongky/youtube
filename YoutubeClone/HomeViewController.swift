//
//  ViewController.swift
//  YoutubeClone
//
//  Created by Ky Nguyen on 10/13/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

protocol SettingDelegate {
    func didSelectSettingMenu(setting: Setting)
}

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var videos : [Video]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = true
        let titleLabel = UILabel(frame: CGRect(x: 4, y: 0, width: view.frame.width, height: view.frame.height))
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
        
        fetchVideos()
    }
    
    func fetchVideos() {
        ApiService.shared.fetchVideos { (videos) in
            self.videos = videos
            self.collectionView?.reloadData()
        }
    }
    
    let menuBar : MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupMenuBar() {
        
        navigationController?.hidesBarsOnSwipe = true
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        view.addSubview(redView)
        view.addConstraints(withFormat: "H:|[v0]|", views: redView)
        view.addConstraints(withFormat: "V:[v0(50)]", views: redView)

        view.addSubview(menuBar)
        view.addConstraints(withFormat: "H:|[v0]|", views: menuBar)
        view.addConstraints(withFormat: "V:[v0(50)]", views: menuBar)
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
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

    lazy var settingLauncher : SettingLauncher = {
        let launcher = SettingLauncher()
        launcher.delegate = self
        return launcher
    }()
    
    func handleMenu() {
        
        settingLauncher.showSetting()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        cell.video = videos?[indexPath.row]
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

extension HomeViewController : SettingDelegate {
    func didSelectSettingMenu(setting: Setting) {
        let newViewController = UIViewController()
        newViewController.title = setting.name.rawValue
        newViewController.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white
        ]
        navigationController?.pushViewController(newViewController, animated: true)
    }
}
