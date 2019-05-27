//
//  ArticleCell.swift
//  VKWay
//
//  Created by Евгений Оводков on 17/03/2019.
//  Copyright © 2019 Евгений Оводков. All rights reserved.
//

import UIKit



class ArticleCell: UITableViewCell {
    
    
    @IBOutlet weak var avatar: Avatar!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var constraintHeight: NSLayoutConstraint!
    
    var date:Date = Date() {
        didSet{
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = "dd MMMM yyyy hh:MM"
            
            dateLabel.text = dateFormatter.string(from: date)
        }
    }
    
    var article: Article? {
        didSet{
            setArticle()
        }
    }
    
    var collectionTag: Int? {
        didSet{
            collectionView.tag = collectionTag!
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        collectionView.registerNib(forClass: ArticlePhotoCell.self)
        collectionView.dataSource   = self
        collectionView.delegate     = self
        collectionView.reloadData()
        
    }
    
    func setArticle() {
        
        if let article = article {
            avatar.image       = FileSystem.current.getImage(url: article.author.avatarURL)
            autor.text         = article.author.name
            date               = Date()
            body.text          = article.body
            
            if article.images.count == 0 {
                constraintHeight.constant  = 0
            } else {
                constraintHeight.constant = 200
            }
            
        }
    
    }
    
    
}


extension ArticleCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return article?.images.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(forClass: ArticlePhotoCell.self, for: indexPath)
        
        if collectionView.tag == collectionTag! {
        
        guard let images = article?.images, images.count >= indexPath.row,  let photo = images[indexPath.row] else
        {
            return cell
        }
        
        cell.photo.image = FileSystem.current.getImage(url: photo.url)
        }
        return cell
    }
    
}

extension ArticleCell: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
     
        
        
    }
}

