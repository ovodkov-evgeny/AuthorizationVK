//
//  Database.swift
//  VKWay
//
//  Created by Евгений Оводков on 5/20/19.
//  Copyright © 2019 Евгений Оводков. All rights reserved.
//

import RealmSwift


class Database{
    
    static var session = Database()    
    
    private init() {}
    
    
    func writeFriends() {
        
        let list = List<PeopleRealm>()
        
        for friend in Friends.current.list {
            let people = PeopleRealm(friend)
            list.append(people)
        }
        
        do {
            let realm = try Realm()
            
            print(realm.configuration.fileURL!)
            
            realm.beginWrite()
            
            realm.add(list)
            
            try realm.commitWrite()
            
            UserDefaults.standard.setValue(Date(), forKey: "FriendsLastUpdate")
            UserDefaults.standard.synchronize()
            
        } catch {
            print(error)
        }

    }
    
    func loadFriends(_ filter:String="") -> Bool {

        guard actualData(key: "FriendsLastUpdate") else { return false }
        
        do {
            let realm = try Realm()
            let friends = realm.objects(PeopleRealm.self)
            if friends.count > 0 {
                Friends.current.list.removeAll()
                for friend in friends {
                    let people = People(realmObject: friend)
                    Friends.current.list.append(people)
                }
                
                print("friends read from Realm ... sucess")
                print(realm.configuration.fileURL!)
                
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
    
    
    
    func loadArticles(_ id:Int=0) -> Bool {

        guard actualData(key: "ArticlesLastUpdate") else { return false }
        
        //soon
        return false
        
    }
    
    
    
    func loadGroups() -> Bool {

        guard actualData(key: "GroupsLastUpdate") else { return false }
        
        do {
            let realm = try Realm()
            let groupsRealm = realm.objects(GroupRealm.self)
            
            if groupsRealm.count > 0 {
                Groups.current.list.removeAll()
                for groupRealm in groupsRealm {
                    let group = Group(realmObject: groupRealm)
                    Groups.current.list.append(group)
                }
                
                print("groups read from Realm ... sucess")
                print(realm.configuration.fileURL!)
                
                return true
            }
        } catch {
            print(error)
        }
        return false
        
    }
    
    
    func writeGroups() {
        
        let list = List<GroupRealm>()
        
        for group in Groups.current.list {
            let groupRealm = GroupRealm(group)
            list.append(groupRealm)
        }
        
        do {
            let realm = try Realm()
            
            print(realm.configuration.fileURL!)
            
            realm.beginWrite()
            
            realm.add(list)
            
            try realm.commitWrite()
            
            UserDefaults.standard.setValue(Date(), forKey: "GroupsLastUpdate")
            UserDefaults.standard.synchronize()
            
        } catch {
            print(error)
        }
        
    }
    
    
    func actualData(key:String) -> Bool {
        
        guard let date = UserDefaults.standard.value(forKey: key) as? Date  else { return false }
        let secondsFromLastUpdate = date.seconds(from: Date())
        
        if secondsFromLastUpdate < 3600 {
            return true
        } else {
            print("data is out of date... need to update from VK")
            return false
        }
        
    }
        
}
