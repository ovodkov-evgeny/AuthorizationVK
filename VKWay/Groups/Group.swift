
import Foundation
import UIKit

import RealmSwift


class Group {
    
    var name:String
    var id:Int
    var avatarURL:String
    var avatar:UIImage?
    
    init(id:Int, name:String, avatar:String) {
        self.name       = name
        self.id         = id
        self.avatarURL  = avatar
        self.avatar     = FileSystem.current.getImage(url: avatar)
    }
    
    init(realmObject: GroupRealm) {
        self.id         = realmObject.id
        self.name       = realmObject.name
        self.avatarURL  = realmObject.avatarURL
        if let imageData = realmObject.avatar {
            self.avatar     = UIImage(data: imageData)
        }
        
    }
    
}

class GroupRealm: Object {
    
    @objc dynamic var name:String = ""
    @objc dynamic var id:Int = 0
    @objc dynamic var avatarURL:String = ""
    @objc dynamic var avatar:Data? = nil
    
    convenience init(_ group: Group) {
        self.init()
        self.name       = group.name
        self.id         = group.id
        self.avatarURL  = group.avatarURL
        self.avatar     = group.avatar?.jpegData(compressionQuality: 1)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}

