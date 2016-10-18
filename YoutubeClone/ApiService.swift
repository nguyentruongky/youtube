//
//  ApiService.swift
//  YoutubeClone
//
//  Created by Ky Nguyen on 10/18/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

class ApiService: NSObject {

    static let shared = ApiService()
    
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(completion: @escaping (_ videos: [Video]) -> Void) {
        fetchData(from: "\(baseUrl)/home.json", completion: completion)
    }
    
    func fetchTrendingVideos(completion: @escaping (_ videos: [Video]) -> Void) {
        fetchData(from: "\(baseUrl)/trending.json", completion: completion)
    }
    
    func fetchSubscriptionsVideos(completion: @escaping (_ videos: [Video]) -> Void) {
        
        fetchData(from: "\(baseUrl)/subscriptions.json", completion: completion)
    }
    
    private func fetchData(from url: String, completion: @escaping (_ videos: [Video]) -> Void) {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                var videos = [Video]()
                for dict in json as! [[String: AnyObject]] {
                    let video = Video()
                    video.title = dict["title"] as? String
                    video.thumbnailImageName = dict["thumbnail_image_name"] as? String
                    video.numberOfViews = dict["number_of_views"] as? NSNumber
                    video.channel = Channel()
                    video.channel?.name = dict["channel"]?["name"] as? String
                    video.channel?.profileImageName = dict["channel"]?["profile_image_name"] as? String
                    
                    videos.append(video)
                }
                
                DispatchQueue.main.sync {
                    completion(videos)
                }
                
            } catch let jsonerror {
                print(jsonerror)
            }
            
            }.resume()
        
    }    
}
