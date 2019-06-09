//
//  Database.swift
//  VKWay
//
//  Created by Евгений Оводков on 5/20/19.
//  Copyright © 2019 Евгений Оводков. All rights reserved.
//

import RealmSwift


class Database{
    
    var friendsList:Results<PeopleRealm>?
    var groupsList:Results<GroupRealm>?
    
    
    
    
    static var session = Database()
    
    private init() {}
    
    
    
}
