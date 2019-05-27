//
//  Like.swift
//  VKWay
//
//  Created by Cayenne on 14/03/2019.
//  Copyright © 2019 Cayenne. All rights reserved.
//

import UIKit
import Foundation

class LikeControl: UITableViewHeaderFooterView {
    
    
    @IBOutlet weak var heartView: UIView!
    @IBOutlet var heartCount: UILabel!
    @IBOutlet var heartImage: UIImageView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet var commentImage: UIImageView!
    @IBOutlet var commentCount: UILabel!
    @IBOutlet weak var forwardView: UIView!
    @IBOutlet var forwardImage: UIImageView!
    
    @IBOutlet weak var viewsView: UIView!
    @IBOutlet var viewsCount: UILabel!
    
    
    var object: Like?
    
    var likeChanged: Bool = false {
        didSet{
            heartView.alpha = (likeChanged) ? 1: 0.5
            heartImage.tintColor = (likeChanged) ? UIColor.red: UIColor.black
            heartCount.textColor = (likeChanged) ? UIColor.red: UIColor.black
        }
    }
    
    var likeCount:Int = 0 {
        didSet{
            heartCount?.text = "\(likeCount)"
        }
    }
    
    
    override func awakeFromNib() {

        super.awakeFromNib()
        
        let tapOnHeart = UITapGestureRecognizer(target: self, action: #selector(onTap(recognizer:)))
        heartView.addGestureRecognizer(tapOnHeart)
        
        let tapOnComment = UITapGestureRecognizer(target: self, action: #selector(onTapComment(recognizer:)))
        commentView.addGestureRecognizer(tapOnComment)
        
        let tapOnForward = UITapGestureRecognizer(target: self, action: #selector(onTapForward(recognizer:)))
        forwardView.addGestureRecognizer(tapOnForward)
        
        
        
        heartImage.image        = heartImage.image?.withRenderingMode(.alwaysTemplate)
        heartImage.tintColor    = UIColor.black
        
        heartCount.text = "\(likeCount)"
        
        
        commentCount.text       = "\(arc4random_uniform(100))"
        viewsCount.text         = "\(arc4random_uniform(1000))"
        
    }
    
    func setObject(_ object:Like) {
        self.object = object
        likeCount   = object.likeCount
        likeChanged = object.likeChanged
    }


    @objc func onTap(recognizer: UITapGestureRecognizer) {
        
        likeChanged = !likeChanged
        
        if likeChanged {
            likeCount              += 1
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
                self.heartImage.transform = CGAffineTransform(scaleX: 1.3, y:
                    1.3)
            }) { (_) in
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
                    self.heartImage.transform = CGAffineTransform.identity
                })
            }
            
        } else {
            likeCount              -= 1
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
                self.heartImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }) { (_) in
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
                    self.heartImage.transform = CGAffineTransform.identity
                })
            }
            
        }
        
        
        object?.likeChanged = likeChanged
        object?.likeCount   = likeCount
        
    }
    
    @objc func onTapComment(recognizer: UITapGestureRecognizer) {
     
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: [], animations: {
            self.commentImage.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
                self.commentImage.transform = CGAffineTransform.identity
            }) { (_) in
                
            }
        }
        
    }
    
    @objc func onTapForward(recognizer: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: [], animations: {
            self.forwardImage.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
                self.forwardImage.transform = CGAffineTransform.identity
            }) { (_) in
                
            }
        }
        
    }
    
    @objc func onTapWithCancel(recognizer: UITapGestureRecognizer, element: UIImageView) {
        
    }
    
}






protocol Like {
    var likeCount:Int { get set }
    var likeChanged:Bool { get set }
}
