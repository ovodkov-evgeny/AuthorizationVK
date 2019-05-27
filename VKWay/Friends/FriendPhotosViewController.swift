//
//  FriendPhotosViewController.swift
//  VKWay
//
//  Created by Евгений Оводков on 07/03/2019.
//  Copyright © 2019 Евгений Оводков. All rights reserved.
//

import UIKit

class FriendPhotosViewController: UIViewController {
    

    @IBOutlet var mainPhoto: UIImageView!
    @IBOutlet weak var secondPhoto: UIImageView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var secondView: UIView!
    
    
    var interactiveAnimator: UIViewPropertyAnimator!
    
    
    var index:Int = 0
    var isSecondPhoto = false
    var direction:Int = 0
    var initialY: CGFloat = 0
    
    
    var photo: UIImageView {
        get{ return (isSecondPhoto) ? secondPhoto: mainPhoto}
    }
    var photoView: UIView {
        get{ return (isSecondPhoto) ? secondView: mainView}
    }
    
    var nextPhoto: UIImageView {
        get{ return (isSecondPhoto) ? mainPhoto: secondPhoto}
    }
    var nextPhotoView: UIView {
        get{ return (isSecondPhoto) ? mainView: secondView}
    }
    
    var photos:[Photo] = []
    var people:People!
    
    
    
    override func viewDidLoad() {
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBarController?.tabBar.isHidden = true
        tabBarController?.hidesBottomBarWhenPushed = true
        tabBarController?.tabBarController?.tabBar.backgroundColor = UIColor.black
        view.backgroundColor = UIColor.black
        
        Photos.current.getUserPhotosVK(people:people) { photoList in
            self.photos.removeAll()
            self.photos = photoList
            guard self.photos.count > 0 else { return }
            let url = self.photos[0].url
            self.mainPhoto.image = FileSystem.current.getImage(url: url)
        }
        
    }
    
    
    @IBAction func onPan(_ recognizer: UIPanGestureRecognizer) {
        
        let location = recognizer.location(in: view)
        
        switch recognizer.state {
        case .began:
            
            let velocity    = recognizer.velocity(in: recognizer.view?.superview)
            direction       = (velocity.x > 0) ? -1: 1 // -1 right 1 left
            initialY        = location.y
            
            setIndex(direction: direction)
            
            let photo   = photos[index]
            if photo.image == nil {
                photo.image = FileSystem.current.getImage(url: photo.url)
            }
            
            nextPhoto.image               = photo.image
            nextPhotoView.frame.origin.x  = view.frame.maxX * CGFloat(direction)
            nextPhotoView.layer.zPosition = 1
            nextPhotoView.transform       = .identity
            photoView.layer.zPosition     = 0
            
            UIView.animate(withDuration: 1, animations: {
                self.photoView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
            
            interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeOut, animations: {
                self.nextPhotoView.frame.origin.x   = 0
                //self.photoView.alpha                = 0
            })
            
            
            interactiveAnimator.startAnimation()
            interactiveAnimator.pauseAnimation()
        
        case .changed:
            
            //guard location.y - initialY == 0 else { return }
            
            if recognizer.translation(in: recognizer.view?.superview).x > 0 {
                interactiveAnimator.fractionComplete = recognizer.translation(in: recognizer.view?.superview).x / 275
            } else {
                interactiveAnimator.fractionComplete = -recognizer.translation(in: recognizer.view?.superview).x / 275
            }
            
        case .ended:
            
            guard location.y - initialY < 100 else {
                interactiveAnimator.stopAnimation(true)
                setIndex(direction: direction, offset: true)
                let photo = photos[index]
                if photo.image == nil {
                    photo.image = FileSystem.current.getImage(url: photo.url)
                }
                nextPhoto.image = photo.image
                self.dismiss(animated: true, completion: nil)

                return
            }
            
            
            if direction < 0 && location.x < view.frame.midX  || direction > 0 && location.x > view.frame.maxX-100{
                
                interactiveAnimator.stopAnimation(true)
                setIndex(direction: direction, offset: true)
            
                UIView.animate(withDuration: 1, animations: {
                    
                    self.nextPhotoView.frame.origin.x   = self.view.frame.maxX * CGFloat(self.direction)
                    self.photoView.transform = .identity
                    
                })
                
            } else {
                interactiveAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                isSecondPhoto       = !isSecondPhoto
            }
        
        default:
            ()
        }
        
        
    }
    
    
    func setIndex(direction: Int, offset: Bool = false) {
        
        if offset {
            index = index + (-direction)
        } else {
            index = index + direction
        }
        
        if index > (photos.count-1) {
            index = 0
        } else if index < 0 {
            index = photos.count-1
        }
        
    }
    
    
    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}






