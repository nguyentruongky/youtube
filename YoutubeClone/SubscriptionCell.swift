//
//  SubscriptionCell.swift
//  YoutubeClone
//
//  Created by Ky Nguyen on 10/19/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {

    override func fetchVideos() {
        ApiService.shared.fetchSubscriptionsVideos { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }

}
