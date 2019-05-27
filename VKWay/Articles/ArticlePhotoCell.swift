//
//  ArticlePhotoCell.swift
//  VKWay
//
//  Created by Евгений Оводков on 18/03/2019.
//  Copyright © 2019 Евгений Оводков. All rights reserved.
//

import UIKit

@IBDesignable class ArticlePhotoCell: UICollectionViewCell {

    
    @IBOutlet var photoFrame: UIView!
    @IBOutlet var photo: UIImageView!
    @IBOutlet var photoCell: UIView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoFrame.layer.shadowColor     = UIColor.black.cgColor
        photoFrame.layer.shadowRadius    = 5
        photoFrame.layer.shadowOpacity   = 0.5
        photoFrame.layer.cornerRadius    = 20
        photoFrame.layer.shadowOffset    = CGSize(width: 0, height: 3)
        photoFrame.layer.shouldRasterize = true
        
        
        photo.layer.cornerRadius  = 20
        photo.layer.masksToBounds = true
        
        let pan = UILongPressGestureRecognizer(target: self, action: #selector(onPan(recognizer:)))
        pan.minimumPressDuration = 0.1
        photoCell.addGestureRecognizer(pan)
        
    }
    
    @objc func onPan(recognizer:  UILongPressGestureRecognizer) {
        
        if recognizer.state == .began {
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],   animations: {
                self.photoCell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.photoFrame.layer.shadowOpacity = 0.3
                self.photoCell.alpha = 0.8
                })
        } else if recognizer.state == .ended {
           
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                    self.photoCell.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.photoFrame.layer.shadowOpacity = 0.5
                    self.photoCell.alpha = 1
                })
            
        }
        
    }
    
}
