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

    let cellId = "cellId"
    let trendingCellId = "trendingCellId"
    let subscriptionCellId = "subscriptionCellId"
    let titles = ["Home", "Trending", "Subscription", "Account"]
    
    var videos : [Video]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = true
        let titleLabel = UILabel(frame: CGRect(x: 4, y: 0, width: view.frame.width, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
    
        setupCollectionView()
        setupMenuBar()
        
        setupNavigationIcons()
    }
    
    func setupCollectionView() {
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
        collectionView?.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellId)
        
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        edgesForExtendedLayout = .bottom
        
        collectionView?.isPagingEnabled = true
    }
    
    
    
    lazy var menuBar : MenuBar = {
        let mb = MenuBar()
        mb.menuDelegate = self
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
    
    func scrollToMenuAtIndexPath(indexPath: IndexPath) {
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
        setTitleForIndex(index: indexPath.item)
    }
    
    private func setTitleForIndex(index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  " + titles[index]
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cellIds = [cellId, trendingCellId, subscriptionCellId, cellId]
        let identifier = cellIds[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.barViewLeftAnchor?.constant = scrollView.contentOffset.x / 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        menuBar.collectionView.selectItem(at: IndexPath(item: Int(index), section: 0), animated: true, scrollPosition: [])
        setTitleForIndex(index: Int(index))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
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

extension HomeViewController : MenuSelectDelegate {
    func didSelectMenuAtIndexPath(indexPath: IndexPath) {
        scrollToMenuAtIndexPath(indexPath: indexPath)
    }
}
