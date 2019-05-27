
import UIKit
import Foundation

class Article: Like {
    
    static var list:[Article] = []
    
    var body:String
    var images:[UIImage?] = []
    var autor:People
    var date:Date = Date()
    
    var likeCount:Int
    var likeChanged:Bool = false
    
    init(_ body:String, _ images:String="") {
        self.body       = body
        
        self.autor      = People.list.randomElement()!
        self.likeCount  = Int(arc4random_uniform(1000))
        
        for imageName in images.components(separatedBy: ",") where !imageName.isEmpty {
            self.images.append(UIImage(named: imageName))
        }
        
    }
    
    static func getNews() {
        
        guard Article.list.count == 0 else { return }
        
        Article.list.append(Article(
            """
            Какие IT-тренды перешли в 2019 год и на что стоит обращать внимание, чтобы быть впереди планеты всей?
            Наталья Копылова рассмотрела в статье: http://amp.gs/4x3m
            """, "1,4,7,10"))
        
        Article.list.append(Article(
            """
            Как делать себя лучше каждый день?

            Вы замечательны таким, какой вы есть, но каждый хочет делать себя лучше. Это хорошо!
            """, "9,6,5"))
            
        Article.list.append(Article(
            """
            Что нужно знать о кошках перед покупкой?
            
            1. Готовы ли вы к такой ответственности?
            Каждый день вам придется убираться за ней, кормить. Её нельзя будет надолго оставить одну
            """, "2,3"))
        
        Article.list.append(Article(
            """
            Яхууу, сегодня классный день!!!
            """))
        
        Article.list.append(Article(
            """
            День 530
            Человек, жизнь которого поместится в один чемодан
            |Время прочтения 3 минуты|

            Из России можно уехать, но Россия из тебя не уедет!
            ""","8,4,5"))
    
    }

}


