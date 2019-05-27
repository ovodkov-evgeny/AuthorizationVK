

import UIKit

class FindGroupViewController: UIViewController {
    
    @IBOutlet var groupsTableView: UITableView!
    
    var groups:[Group] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupsTableView.delegate    = self
        groupsTableView.dataSource  = self
        
        Session.current.authorization(controller: self) {
            Groups.current.searchGroupsVK(filter: "GeekBrains", exclude: Groups.current.list, completionHandler: { (groups) in
                self.groups = groups
                self.groupsTableView.reloadData()
            })
        }
            
        
    }
    
}


extension FindGroupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupsTableView.dequeueReusableCell(withIdentifier: FindGroupTableViewCell.nameStr, for: indexPath) as! FindGroupTableViewCell
        
        let group = groups[indexPath.row]
        cell.nameField.text = group.name
        cell.avatar.image   = group.avatar
        
        
        return cell
    }
    
}

extension FindGroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let group = groups[indexPath.row]
        Groups.current.list.append(group)
        navigationController?.popViewController(animated: true)
        
    }
    
}

class FindGroupTableViewCell: UITableViewCell {
    
    @IBOutlet var nameField: UILabel!
    @IBOutlet var avatar: UIImageView!
    
}
