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

                guard let data = data else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: AnyObject]] else { return }

                let videos = json.map({ return Video(dictionary: $0) })
                
                DispatchQueue.main.sync {
                    completion(videos)
                }

            } catch let jsonerror {
                print(jsonerror)
            }
            
            }.resume()
        
    }    
}
