import UIKit
import Foundation
import RealmSwift


extension UIView {
    static var nameStr:String {
        get {
            return String(describing: self)
        }
    }
}

extension Array {
    func rand() -> [Element] {
        
        var result:[Element] = []
        
        for i in self {
            let trueFalse = (Int(arc4random_uniform(11)) % 2 == 0)
            if trueFalse {
                result.append(i)
            }
        }
        
        if result.count == 0 {
            if let newElement = randomElement() {
                result.append(newElement)
            }
        }
        
        return result
    }
}

extension UIImage{
    
    convenience init?(url: String) {
        
        guard let url = URL(string: url), let data = try? Data(contentsOf: url) else {
            self.init()
            return
        }
        
        self.init(data: data)
        
    }
    
}


struct Func {
    static func isTrue() -> Bool {
        return arc4random_uniform(2) == UInt32(1)
    }
}


extension Date {
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return -(Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0)
    }
}



func needToUpdateTableData(name: String) -> Bool {
    
    guard let lastUpdate = UserDefaults.standard.object(forKey: name) as? Date else { return true }
    
    guard lastUpdate.seconds(from: Date()) < 3600 else { return true }
    
    return false
    
}




