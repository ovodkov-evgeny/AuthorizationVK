
import UIKit
import Alamofire
import Foundation


fileprivate struct ArticlesElementProperty:Codable{
    var count:Int
}


fileprivate struct PhotoElementURL:Codable{
    var type:String
    var url:String
    var width:Int
    var height:Int
}

fileprivate struct LinkElement:Codable{
    var title:String
    var photo:PhotoElement?
}
fileprivate struct PhotoElement:Codable{
    var id:Int
    var album_id:Int
    var sizes:[PhotoElementURL]
}
fileprivate struct ArticlesElementAttachments:Codable{
    var type:String
    var photo:PhotoElement?
    var link:LinkElement?
}

fileprivate struct ArticlesElement:Codable{
    var id:Int
    var from_id:Int
    var owner_id:Int
    var date:Int
    var text:String
    var attachments:[ArticlesElementAttachments]?
    var copy_history:[ArticlesElement]?
    var comments:ArticlesElementProperty?
    var likes:ArticlesElementProperty?
    var reposts:ArticlesElementProperty?
    var views:ArticlesElementProperty?
}
fileprivate struct ArticlesResponse:Codable{
    var count:Int
    var items:[ArticlesElement]
}
fileprivate struct ArticlesData:Codable{
    var response:ArticlesResponse
}


class Articles {
    
    static var current = Articles()
    
    var list:[Article] = []
    
    private init() {}
    
    
    func load(id:Int, vc:UIViewController, complitionHandler: @escaping ()->()) {
        
        if Database.session.loadArticles() {
            complitionHandler()
            return
        }
        
        Session.current.authorization(controller: vc) {
            self.getArticlesVK(id: id, completionHandler: {
                complitionHandler()
            })
        }
        
    }

    
    func getArticlesVK(id:Int, completionHandler: @escaping ()->() ) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/wall.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: Session.current.token),
            URLQueryItem(name: "owner_id", value: "\(id)"),
            //URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "v", value: "5.95")
            
        ]
        
        list.removeAll()
        
        guard let url = urlComponents.url else { return }
        
        AF.request(url).response{ response in
            guard response.data != nil, let data = response.data else { return }
            
            let articlesData = try! JSONDecoder().decode(ArticlesData.self
                , from: data)
//            guard let articlesData = try? JSONDecoder().decode(ArticlesData.self
//                , from: data) else { return }

            
            for articleData in articlesData.response.items {
                
                if let repostList = articleData.copy_history {
                    for repost in repostList {
                        self.appendArticle(articleElement: repost)
                    }
                } else {
                    self.appendArticle(articleElement: articleData)
                }
                
            }
            
            completionHandler()
            
        }
        
    }
    
    
    
    private func appendArticle(articleElement:ArticlesElement) {
        
        let author  = People(id: articleElement.from_id)
        let article = Article(articleElement.text, author)
        
        article.likeCount       = articleElement.likes?.count ?? 0
        article.repostsCount    = articleElement.reposts?.count ?? 0
        article.commentsCount   = articleElement.comments?.count ?? 0
        
        self.appendImages(articleData: articleElement, article: article)
        
        self.list.append(article)

    }
 
    private func appendImages(articleData:ArticlesElement, article:Article) {
      
        guard let attachments = articleData.attachments else { return }
        
        //images
        for element in attachments where element.type == "photo" {
            guard let list = element.photo else { continue }
            
            var maxSize=0
            var char=""
            for photo in list.sizes {
                let size = photo.width+photo.height
                if size>maxSize {
                    maxSize = size
                    char    = photo.type
                }
            }
            
            guard let photoUrl = list.sizes.first(where: {$0.type==char})?.url else { continue }
            article.images.append(Photo(url: photoUrl))
        }
        
        //link
        for element in attachments where element.type == "link" {
            guard let link = element.link else { continue }
            
            let title = link.title
            
            var maxSize=0
            var char=""
            if let photoLinks = link.photo?.sizes {
                for photo in photoLinks {
                    let size = photo.width+photo.height
                    if size>maxSize {
                        maxSize = size
                        char    = photo.type
                    }
                }
                guard let photoUrl = photoLinks.first(where: {$0.type==char})?.url else { continue }
                article.body = title
                article.images.append(Photo(url: photoUrl))
            }
            
        }
        
    }
    
    
}
