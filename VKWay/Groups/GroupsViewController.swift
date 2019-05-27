

import UIKit

class GroupsViewController: UIViewController {
    
    @IBOutlet var groupsTableView: UITableView!
    var searchBar: UISearchBar!
    var interactiveTransition: InteractiveTransition?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsTableView.delegate   = self
        groupsTableView.dataSource = self
    
        searchBar                    = UISearchBar(frame: CGRect(x: 0, y: 0, width: 50, height: 60))
        searchBar.placeholder        = "Введите группы"
        searchBar.searchBarStyle     = .minimal
        searchBar.delegate           = self
        groupsTableView.tableHeaderView = searchBar
        
        groupsTableView.tableFooterView = UIView()
        
        navigationController?.delegate = self
        
        
        Groups.current.load(vc: self) {
            self.groupsTableView.reloadData()
        }
                
    }
    
    
    @IBAction func addNewGroup(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "FindGroupViewController") as! FindGroupViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}


extension GroupsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Groups.current.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupsTableView.dequeueReusableCell(withIdentifier: GroupsTableViewCell.nameStr, for: indexPath) as! GroupsTableViewCell
        let group = Groups.current.list[indexPath.row]
        cell.nameField.text = group.name
        cell.avatar.image   = group.avatar
        
        
        return cell
    }
    
}

extension GroupsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchBar.resignFirstResponder()
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаляем город из массива
            Groups.current.list.remove(at: indexPath.row)
            // И удаляем строку из таблицы
            groupsTableView.deleteRows(at: [indexPath], with: .fade)
        }

    }
    
}


class GroupsTableViewCell: UITableViewCell {
    
    @IBOutlet var nameField: UILabel!
    @IBOutlet var avatar: UIImageView!
    
}




extension GroupsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Groups.current.getUserGroupsVK(filter: searchText) {
            self.groupsTableView.reloadData()
        }
    }
    
}

extension GroupsViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition!.hasStarted ? interactiveTransition!: nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            
            interactiveTransition = InteractiveTransition()
            interactiveTransition?.viewController   = toVC
            
            return TransitionAnimatorShow(forPush: true)
            
        default:
            groupsTableView.reloadData()
            return TransitionAnimatorForDismiss(forPop: true)
            
        }
    }

}








