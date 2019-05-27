

import UIKit


class LoadingScreen: UIView {
    
    
    @IBOutlet var state0: UIImageView!
    @IBOutlet var state50: UIImageView!
    @IBOutlet var state100: UIImageView!
    
    
    override func awakeFromNib() {
      
        super.awakeFromNib()
        
        backgroundColor = UIColor.white.withAlphaComponent(0)
        
        state0.image = state0.image?.withRenderingMode(.alwaysTemplate)
        state50.image = state50.image?.withRenderingMode(.alwaysTemplate)
        state100.image = state100.image?.withRenderingMode(.alwaysTemplate)
        
        state0.layer.cornerRadius   = 5
        state0.layer.masksToBounds  = true
        state0.layer.borderColor    = UIColor.gray.cgColor
        state0.layer.borderWidth    = 1
        
        state50.layer.cornerRadius   = 5
        state50.layer.masksToBounds  = true
        state50.layer.borderColor    = UIColor.gray.cgColor
        state50.layer.borderWidth    = 1
        
        state100.layer.cornerRadius   = 5
        state100.layer.masksToBounds  = true
        state100.layer.borderColor    = UIColor.gray.cgColor
        state100.layer.borderWidth    = 1
        
    }
    
    func startLoading() {
    
        
//        UIView.animateKeyframes(withDuration: 5, delay: 0, options: [], animations: {
//
//            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 1/5, animations: {
//                self.state0.backgroundColor = UIColor.green
//            })
//
//            UIView.addKeyframe(withRelativeStartTime: 2/5, relativeDuration: 1/5, animations: {
//                self.state50.backgroundColor = UIColor.green
//            })
//
//            UIView.addKeyframe(withRelativeStartTime: 3/5, relativeDuration: 1/5, animations: {
//                self.state100.backgroundColor = UIColor.green
//            })
//
//
//            }) { (_) in
//
//        }
        
//        let animation = CABasicAnimation(keyPath: "layer.shadowRadius")
//        animation.fromValue = state0.layer.shadowRadius
//        animation.toValue = state0.layer.shadowRadius + 10
//        animation.duration = 0.5
//        layer.add(animation, forKey: nil)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.state0.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                self.state0.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                self.state0.layer.borderWidth = 0
                self.state50.alpha = 1
                self.state100.alpha = 1
            }, completion: { (_) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.state50.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                    self.state100.alpha = 1
                    self.state50.layer.borderWidth = 0
                }, completion: { (_) in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.state100.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                        self.state100.layer.borderWidth = 0
                    })
                })
            })
        }
        
        
    }
    
}


extension LoadingScreen {
    
    static func getLoadingScreen() -> UIAlertController{
        
        let alert = UIAlertController(title: nil, message: "Загрузка данных ...", preferredStyle: .alert)
        alert.view.frame    = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let loadingView = UINib(nibName: "LoadingScreen", bundle: nil).instantiate(withOwner: nil, options: nil).first as! LoadingScreen
        
        loadingView.frame =  CGRect(x: 110, y: 50, width: 40, height: 20)
        alert.view.addSubview(loadingView)
        
        loadingView.startLoading()
        
        return alert
        
    }
    
}
