//
//  FriendsTableViewController.swift
//  VKWay
//
//  Created by Евгений Оводков on 05/03/2019.
//  Copyright © 2019 Евгений Оводков. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    
    @IBOutlet var filterCharControll: FilterCharControl!
    @IBOutlet var friendsTableView: UITableView!
    var searchBar: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar                    = UISearchBar(frame: CGRect(x: 0, y: 0, width: 50, height: 60))
        searchBar.placeholder        = "Введите имя"
        searchBar.searchBarStyle     = .minimal
        searchBar.delegate           = self
        friendsTableView.tableHeaderView    = searchBar
        
        filterCharControll.tableView = friendsTableView
        
        friendsTableView.delegate   = self
        friendsTableView.dataSource = self
        
        Friends.current.load(vc: self) {
            self.friendsTableView.reloadData()
        }
        
    }
    
}


extension FriendsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Friends.current.getCharactersFromList().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Friends.current.getElementsBySection(section: section).count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.nameStr, for: indexPath) as! FriendsTableViewCell

        guard let friend = try? Friends.current.getElement(section: indexPath.section, row: indexPath.row) else {
            return cell
        }
        cell.nameField.text = friend.name
        cell.avatar.image   = friend.avatar

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Friends.current.getCharactersFromList()[section].description
    }
    
    
}

extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchBar.resignFirstResponder()

     let vc = storyboard?.instantiateViewController(withIdentifier: "FriendPhotosViewController") as! FriendPhotosViewController
        guard let friend = try? Friends.current.getElement(section: indexPath.section, row: indexPath.row) else {
            return
        }
        
        vc.people = friend
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)

        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard (searchBar.text ?? "").isEmpty else { return }
        guard let visibleIndexPath = friendsTableView.indexPathsForVisibleRows?.first else { return }

        filterCharControll.selectedChar = Friends.current.getCharactersFromList()[visibleIndexPath.section]
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let friend = try? Friends.current.getElement(section: indexPath.section, row: indexPath.row) else { return UISwipeActionsConfiguration(actions: [])}
        
        let photoAction = UIContextualAction(style: .normal, title: "Новости") { (action, view, actionFunc) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArticleViewController") as! ArticleViewController
            vc.id = friend.id
            self.show(vc, sender: self)
            actionFunc(true)
            
        }
        photoAction.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        
        let swipeConfiguration =  UISwipeActionsConfiguration(actions: [photoAction])
        
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let actions:[UITableViewRowAction] = []

        return actions

    }
}


extension FriendsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Friends.current.load(filter: searchText, vc: self) {
            self.friendsTableView.reloadData()
        }

        filterCharControll.alpha = (searchText.isEmpty) ? 1: 0
        filterCharControll.isEnabled    = searchText.isEmpty
    }
    
}

extension FriendsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimatorShow(forPush: false)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimatorForDismiss(forPop: false)
    }
    
}





class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet var avatar: Avatar!
    
}
