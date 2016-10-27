//
//  SettingLauncher.swift
//  YoutubeClone
//
//  Created by Ky Nguyen on 10/17/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName : String {
    
    case Cancel = "Cancel"
    case Settings = "Settings"
    case Term = "Term & Privacy"
    case Feedback = "Send Feedback"
    case Help = "Help"
    case SwitchAccount = "Switch Account"
}

class SettingLauncher : NSObject {
    
    var blackView = UIView()
    var delegate : SettingDelegate?
    
    let collectionView : UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellId = "cellId"
    let cellHeight : CGFloat = 50
    let dismissAnimationDuration : Double = 0.5
    
    let settings = [
        Setting(name: .Settings, imageName: "setting"),
        Setting(name: .Term, imageName: "privacy"),
        Setting(name: .Feedback, imageName: "feedback"),
        Setting(name: .Help, imageName: "help"),
        Setting(name: .SwitchAccount, imageName: "account"),
        Setting(name: .Cancel, imageName: "cancel"),
    ]
    
    func showSetting() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.frame = window.frame
            blackView.alpha = 0
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            collectionView.isScrollEnabled = false
            let collectionViewHeight: CGFloat = CGFloat(settings.count) * cellHeight
            let y = window.frame.height - collectionViewHeight
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: collectionViewHeight)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
                
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: collectionViewHeight)
                
                }, completion: nil)
        }
    }
    
    func handleDismiss() {
        UIView.animate(withDuration: dismissAnimationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
            }, completion: nil)
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
}

extension SettingLauncher: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        let settingItem = settings[indexPath.row]
        cell.setting = settingItem
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = settings[indexPath.row]
        handleDismiss()
        perform(#selector(handleSettingSelected), with: setting, afterDelay: dismissAnimationDuration)
    }
    
    func handleSettingSelected(setting: Setting) {
        guard setting.name != .Cancel else { return }
        delegate?.didSelectSettingMenu(setting: setting)
    }
}


