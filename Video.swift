//
//  Video.swift
//  YoutubeClone
//
//  Created by Ky Nguyen on 10/15/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit
class Video: NSObject {
    
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadedDate : NSDate?
    var channel: Channel?
}

class Channel: NSObject {
    
    var name: String?
    var profileImageName: String?
}
