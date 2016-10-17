//
//  ViewController.swift
//  YoutubeClone
//
//  Created by Ky Nguyen on 10/13/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var videos : [Video]?
    
    
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
        
        fetchVideos()
    }
    
    func fetchVideos() {
        URLSession.shared.dataTask(with: URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")!) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                self.videos = [Video]()
                for dict in json as! [[String: AnyObject]] {
                    let video = Video()
                    video.title = dict["title"] as? String
                    video.thumbnailImageName = dict["thumbnail_image_name"] as? String
                    video.numberOfViews = dict["number_of_views"] as? NSNumber
                    video.channel = Channel()
                    video.channel?.name = dict["channel"]?["name"] as? String
                    video.channel?.profileImageName = dict["channel"]?["profile_image_name"] as? String
                    
                    self.videos?.append(video)
                }
                
                DispatchQueue.main.sync {
                    self.collectionView?.reloadData()
                }
                
            } catch let jsonerror {
                print(jsonerror)
            }
            
        }.resume()
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

    let settingLauncher = SettingLauncher()
    
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
