
import UIKit
import Foundation
import RealmSwift



class Article: Like {
    
    var body:String
    var images:[Photo?] = []
    var author:People
    var date:Date = Date()
    
    var likeCount:Int = 0
    var likeChanged:Bool = false
    
    var commentsCount:Int = 0
    var repostsCount:Int = 0
    
    init(_ body:String,_ author:People ) {
        self.body       = body
        self.author     = author
    }
    
}


class ArticleRealm: Object {
    
    @objc dynamic var body:String = ""
    let images = RealmSwift.List<Data>()
    @objc dynamic var author:PeopleRealm?
    @objc dynamic var date:Date = Date()
    
    @objc dynamic var likeCount:Int = 0
    @objc dynamic var likeChanged:Bool = false
    
    @objc dynamic var commentsCount:Int = 0
    @objc dynamic var repostsCount:Int = 0
    
}

