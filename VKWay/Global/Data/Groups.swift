
import UIKit
import Alamofire
import Foundation


fileprivate struct GroupElement:Codable{
    var id:Int
    var name:String
    var photo_100:String
}
fileprivate struct GroupsResponse:Codable{
    var count:Int
    var items:[GroupElement]
}
fileprivate struct GroupsData:Codable{
    var response:GroupsResponse
}


class Groups {
    
    static var current = Groups()
    
    var list:[Group] = []
    
    private init() {}
    
    
    func load(vc:UIViewController, complitionHandler: @escaping ()->()) {
        
        //        if Database.session.loadGroups() {
        //            complitionHandler()
        //            return
        //        }
        
        Session.current.authorization(controller: vc) {
            Groups.current.getUserGroupsVK {
                complitionHandler()
            }
        }
        
    }
    
    
    func getUserGroupsVK(filter:String = "", completionHandler: @escaping ()->() ) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.current.token),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "v", value: "5.95")
            
        ]
        
        list.removeAll()
        
        guard let url = urlComponents.url else { return }
        
        AF.request(url).response{ response in
            guard response.data != nil, let data = response.data else { return }
            
            let groupsData = try! JSONDecoder().decode(GroupsData.self
                , from: data)
            
            for groupData in groupsData.response.items {
                
                guard filter.isEmpty || groupData.name.lowercased().contains(filter.lowercased()) else { continue }
                let group = Group(id: groupData.id, name: groupData.name, avatar: groupData.photo_100)
                self.list.append(group)
                
            }
            
            
            completionHandler()
            
        }
        
    }
    
    func searchGroupsVK(filter:String = "",exclude:[Group]=[], completionHandler: @escaping ([Group])->() ) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.search"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.current.token),
            URLQueryItem(name: "v", value: "5.95")
        ]
        
        if !filter.isEmpty {
            urlComponents.queryItems?.append(URLQueryItem(name: "q", value: filter))
        }
        
        var searchList:[Group] = []
        
        guard let url = urlComponents.url else { return }
        
        AF.request(url).response{ response in
            guard response.data != nil, let data = response.data else { return }
            
            let groupsData = try! JSONDecoder().decode(GroupsData.self
                , from: data)
            
            for groupData in groupsData.response.items {
                
                guard exclude.isEmpty || !exclude.contains(where: {$0.id==groupData.id}) else { continue }
                
                let group = Group(id: groupData.id, name: groupData.name, avatar: groupData.photo_100)
                searchList.append(group)
                
            }
            
            completionHandler(searchList)
            
        }
        
    }
    
    
}
