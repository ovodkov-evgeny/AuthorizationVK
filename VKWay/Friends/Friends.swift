//
//  VKResponse.swift
//  VKWay
//
//  Created by Евгений Оводков on 06/05/2019.
//  Copyright © 2019 Евгений Оводков. All rights reserved.
//


import Alamofire
import Foundation



fileprivate struct FriendElement:Codable{
    var id:Int
    var first_name:String
    var last_name:String
    var photo_100:String
}
fileprivate struct FriendsResponse:Codable{
    var count:Int
    var items:[FriendElement]
}
fileprivate struct FriendsData:Codable{
    var response:FriendsResponse
}




class Friends {
    
    static let current = Friends()
    
    var list:[People] = []
    
    private init() {}
    
    
    func load(filter:String="", vc:UIViewController, complitionHandler: @escaping ()->()) {
      
        if Database.session.loadFriends(filter) {
            complitionHandler()
            return
        }
        
        Session.current.authorization(controller: vc) {
            self.getFriendsVK(filter: filter, completionHandler: {
                complitionHandler()
            })
        }
        
    }
    
    
    
    
    private func getFriendsVK(filter:String = "", completionHandler: @escaping ()->()) {
        
        list.removeAll()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.current.token),
            URLQueryItem(name: "v", value: "5.95"),
            URLQueryItem(name: "fields", value: "nickname, photo_100")
        ]
        
        guard let url = urlComponents.url else { return }
        
        AF.request(url).response{ response in
            guard response.error==nil, let data = response.data else { return }
            
            guard let friendsData = try? JSONDecoder().decode(FriendsData.self, from: data) else { return }
            
            for friend in friendsData.response.items {
                
                let name = friend.first_name+" "+friend.last_name
                guard filter.isEmpty || name.lowercased().contains(filter.lowercased()) else { continue }
                let people = People(id: friend.id, name: name, avatar: friend.photo_100)
                people.avatar = UIImage(url: people.avatarURL)
                self.list.append(people)
                
            }
            
            self.list.sort(by: {$0.name > $1.name})
            
            Database.session.writeFriends()
            
            completionHandler()
        }
    }
    
    
    
    
    func getCharactersFromList() -> [Character] {
        let chars = list.compactMap({ $0.name.first })
        return Array(Set(chars)).sorted()
    }
    
    func getElementsByChar(char:Character) -> [People] {
        return list.filter({ $0.name.first ?? Character("") == char})
    }
    
    func getElementsBySection(section: Int) -> [People] {
        return getElementsByChar(char: getCharactersFromList()[section])
    }
    
    func getElement(section: Int, row: Int) throws -> People {
        let friendsBySection = getElementsBySection(section: section)
        return friendsBySection[row]
    }

    
}

