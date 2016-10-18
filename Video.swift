//
//  Video.swift
//  YoutubeClone
//
//  Created by Ky Nguyen on 10/15/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

class SafeJsonObject : NSObject {
    override func setValue(_ value: Any?, forKey key: String) {
        
        let selectorName = capitalFirstCharacter(of: key)
        let selector = NSSelectorFromString("set\(selectorName):")
        let response = self.responds(to: selector)
        
        guard response else { return }
        
        super.setValue(value, forKey: key)
    }
    
    func capitalFirstCharacter(of string: String) -> String {
        let first = String(string.characters.prefix(1)).capitalized
        let other = String(string.characters.dropFirst())
        return "\(first)\(other)"
    }
}

class Video: SafeJsonObject {
    
    var thumbnail_image_name: String?
    var title: String?
    var number_of_views: NSNumber?
    var duration: NSNumber?
    var uploaded_date : NSDate?
    var channel: Channel?
    
    override func setValue(_ value: Any?, forKey key: String) {

        if key == "channel" {
            channel = Channel()
            channel!.setValuesForKeys(value as! [String: AnyObject])
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
    
    
}

class Channel: NSObject {
    
    var name: String?
    var profile_image_name: String?
}
