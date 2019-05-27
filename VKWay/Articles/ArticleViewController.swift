//
//  ArticlesCollectionViewController.swift
//  VKWay
//
//  Created by Евгений Оводков on 10/03/2019.
//  Copyright © 2019 Евгений Оводков. All rights reserved.
//

import UIKit


class ArticleViewController: UIViewController {

    let imageView       = UIImageView(image: UIImage(named: "myPhoto"))
    var avatarShadow: UIView!
    var id:Int = Session.current.id
    
    
    @IBOutlet var articleTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMyAvatar()
        
        articleTableView.registerNib(forClass: ArticleCell.self)
        articleTableView.registerNib(forHeaderFooterClass: LikeControl.self)
        
        articleTableView.dataSource = self
        articleTableView.delegate   = self
     

        Articles.current.list.removeAll()
        articleTableView.reloadData()
        
        Session.current.authorization(controller: self) {
            Articles.current.getArticlesVK(id: self.id, completionHandler: {
                self.articleTableView.reloadData()
            })
        }
        
    }
    
}

extension ArticleViewController: UITableViewDataSource, UITableViewDelegate {
    
   func numberOfSections(in tableView: UITableView) -> Int {
       return Articles.current.list.count
   }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: LikeControl.nameStr) as! LikeControl
        footer.setObject(Articles.current.list[section])
        
        return footer
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = articleTableView.dequeueReusableCell(forClass: ArticleCell.self, for: indexPath)
        
        cell.article        = Articles.current.list[indexPath.section]
        cell.collectionTag  = indexPath.section
        
        
        return cell
        
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
    
}



private struct Const {
    /// Image height/width for Large NavBar state
    static let ImageSizeForLargeState: CGFloat = 50
    /// Margin from right anchor of safe area to right anchor of Image
    static let ImageRightMargin: CGFloat = 16
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ImageBottomMarginForLargeState: CGFloat = 12
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ImageBottomMarginForSmallState: CGFloat = 6
    /// Image height/width for Small NavBar state
    static let ImageSizeForSmallState: CGFloat = 32
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}


extension ArticleViewController {
    
    func setMyAvatar() {
        
        avatarShadow = UIView()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Новости"
        
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(avatarShadow)
        
        avatarShadow.bounds              = imageView.bounds
        avatarShadow.layer.cornerRadius  = Const.ImageSizeForLargeState / 2
        avatarShadow.clipsToBounds       = false
        avatarShadow.layer.shouldRasterize   = true
        avatarShadow.layer.shadowColor       = UIColor.black.cgColor
        avatarShadow.layer.shadowRadius      = 2
        avatarShadow.layer.shadowOpacity     = 1
        avatarShadow.layer.shadowOffset      = CGSize.zero
        
        avatarShadow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarShadow.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            avatarShadow.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            avatarShadow.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            avatarShadow.widthAnchor.constraint(equalTo: avatarShadow.heightAnchor)
            ])
        
        avatarShadow.addSubview(imageView)
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])

        let tapOnAvatar = UITapGestureRecognizer(target: self, action: #selector(onTapOnAvatar(recognizer:)))
        avatarShadow.addGestureRecognizer(tapOnAvatar)
        
        
    }
    
    @objc func onTapOnAvatar(recognizer: UITapGestureRecognizer) {
    
        let alert = LoadingScreen.getLoadingScreen()
        present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
}
