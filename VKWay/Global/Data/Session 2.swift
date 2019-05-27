//
//  Session.swift
//  VKWay
//
//  Created by Cayenne on 25/04/2019.
//  Copyright © 2019 Cayenne. All rights reserved.
//

import Foundation

class Session {
    
    let token:String
    let id:Int
    
    static let current = Session()
    
    private init() {
        token = "hi"
        id    = 123
    }
    
    
    func getFriends() {
        
    //https://api.vk.com/method/friends.get?user_id=222437235&access_token=a440259e05f1690f16f8ce02d0066c0cd98628a7e312368caba644b2769d2b444cafac3c276f01ea36e21&v=V
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.current.token),
            URLQueryItem(name: "v", value: "5.95")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        let urlConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: urlConfiguration)
        let task    = session.dataTask(with: request) { data, response, error in
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) else { return }
            guard let jsonA = json as? [String:Any] else { return }
            print(jsonA)
            
            
            
        }
        task.resume()
        
    }

    
}
