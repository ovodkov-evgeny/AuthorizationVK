//
//  FileSystem.swift
//  VKWay
//
//  Created by Cayenne on 11/05/2019.
//  Copyright © 2019 Cayenne. All rights reserved.
//

import Foundation
import UIKit

class FileSystem{
    
    static var current = FileSystem()
    private init() {}
    
    
    func getImage(url: String) -> UIImage? {
        
        var localStorage = false
        if !FileSystem.current.fileExists(url: url) {
            localStorage = FileSystem.current.writeToFile(url: url)
        }
        
        if localStorage {
            return FileSystem.current.readFromFile(url: url)
        } else {
            return UIImage(url: url)
        }

    }
    
    private func filePath(url: String) -> URL? {
        
        guard let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { return nil }
        
        //почему-то hash value от url после перезагрузки постоянно менялось, поэтому использовал base64
        let base64Hash = url.data(using: .utf8)?.base64EncodedString() ?? ""

        return dir.appendingPathComponent("\(base64Hash)")
        
    }
    
    private func writeToFile(url: String) -> Bool {
        
        guard let path = filePath(url: url) else { return false }
        
        guard let fileUrl = URL(string: url) else { return false }
        guard let data = try? Data(contentsOf: fileUrl) else { return false }
        
        do {
            try data.write(to: path)
        } catch {
            return false
        }
        return true
        
    }
    
    private func readFromFile(url: String) -> UIImage? {
        
        guard fileExists(url: url) else { return nil }
        guard let fileName = filePath(url: url) else { return nil }
        
        guard let data = try? Data(contentsOf: fileName), let image = UIImage(data: data) else { return nil }
        return image
        
    }
    
    private func fileExists(url: String) -> Bool {
        guard let fileName = filePath(url: url) else { return false }
        return FileManager.default.fileExists(atPath: fileName.path)
    }
    
}
