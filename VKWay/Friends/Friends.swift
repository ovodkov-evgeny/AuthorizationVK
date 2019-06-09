//
//  VKResponse.swift
//  VKWay
//
//  Created by Евгений Оводков on 06/05/2019.
//  Copyright © 2019 Евгений Оводков. All rights reserved.
//


import Alamofire
import Foundation
import RealmSwift



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
    
    var list:Results<PeopleRealm>?
    
    
    private init() {}
    
    
    
    func load(vc:UIViewController) {
        
        list = try? Realm().objects(PeopleRealm.self)
        
        Session.current.authorization(controller: vc) {
            self.getFriendsVK()
        }
        
    }
    
    
    private func getFriendsVK() {
        
        
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
            
            guard let realm = try? Realm() else { fatalError("realm") }
            realm.beginWrite()
            
            for friend in friendsData.response.items {
                
                let name = friend.first_name+" "+friend.last_name
                
                let objects = realm.objects(PeopleRealm.self).filter("name == '\(name)' && avatarURL == '\(friend.photo_100)'")
                
                if objects.count == 0 {
                    let people = PeopleRealm(friend.id, name, friend.photo_100)
                    realm.add(people, update: true)
                }
                
            }
            
            do {
                try realm.commitWrite()
            } catch {
                fatalError("\(error)")
            }
            
            
        }
    }
    
    
    
    func getCharactersFromList() -> [Character] {
        guard let chars = list?.compactMap({ $0.name.first }) else { return []}
        return Array(Set(chars)).sorted()
    }
    
    func getElementsByChar(char:Character) -> [PeopleRealm] {
        return list?.filter({ $0.name.first ?? Character("") == char}) ?? []
    }
    
    func getElementsBySection(section: Int) -> [PeopleRealm] {
        return getElementsByChar(char: getCharactersFromList()[section])
    }
    
    func getElement(section: Int, row: Int) throws -> PeopleRealm {
        let friendsBySection = getElementsBySection(section: section)
        return friendsBySection[row]
    }
    
    func getSectionByElement(_ element:Int) -> Int {
        let charList    = getCharactersFromList()
        guard let firstChar   = list?.elements[element].name.first else { return 0 }
        return charList.firstIndex(of: firstChar) ?? 0
    }
    
    func elementIndexPath(_ index: Int) -> IndexPath {
        
        var indexPath = IndexPath(row: index, section: 0)
        guard let list = Friends.current.list else { return indexPath }
        
        let sections = Friends.current.getCharactersFromList()
        let element  = list.elements[index]
        
        if let char = element.name.first {
            indexPath.section = sections.firstIndex(of: char) ?? 0
            indexPath.row     = Friends.current.getElementsByChar(char: char).firstIndex(of: element) ?? index
        }
        
        return indexPath
    }
    
    
}

