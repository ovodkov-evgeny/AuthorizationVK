//
//  GroupViewController.swift
//  VKWay
//
//  Created by Cayenne on 31/03/2019.
//  Copyright © 2019 Cayenne. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let group = User.cacheGroup else { return }
        
        title   = group.name
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
