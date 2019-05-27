//
//  getPhotos.swift
//  VKWay
//
//  Created by Евгений Оводков on 06/05/2019.
//  Copyright © 2019 Евгений Оводков. All rights reserved.
//

import Alamofire
import Foundation


fileprivate struct PhotoElementURL:Codable{
    var type:String
    var url:String
    var width:Int
    var height:Int
}

fileprivate struct PhotoElement:Codable{
    var id:Int
    var album_id:Int
    var sizes:[PhotoElementURL]
}

fileprivate struct PhotoResponse:Codable{
    var count:Int
    var items:[PhotoElement]
}

fileprivate struct PhotoData:Codable{
    var response:PhotoResponse
}


class Photos {
    
    static var current = Photos()
    
    private init() {}
    
    func getUserPhotosVK(people:People, completionHandler:@escaping ([Photo])->()) {
   
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/photos.getAll"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.current.token),
            URLQueryItem(name: "v", value: "5.95"),
            URLQueryItem(name: "owner_id", value: "\(people.id)")
        ]
        
        
        guard let url = urlComponents.url else { return }
        
        AF.request(url).response{ response in
            
            guard response.data != nil, let data = response.data else { return }
            
            let photosData = try! JSONDecoder().decode(PhotoData.self
                , from: data)
            
            var list:[Photo] = []
            
            for photoAlbum in photosData.response.items {
                
                var maxSize=0
                var char=""
                for photo in photoAlbum.sizes {
                    let size = photo.width+photo.height
                    if size>maxSize {
                        maxSize = size
                        char    = photo.type
                    }
                }
                
                guard let photoUrl = photoAlbum.sizes.first(where: {$0.type==char})?.url else { continue }
                
                let photo = Photo(url: photoUrl)
                list.append(photo)
                
            }
            
            completionHandler(list)

        }
        
    }

}


