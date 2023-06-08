//
//  currentUser.swift
//  exercise_tabBar
//
//  Created by Apple on 2023/6/8.
//

import Foundation

class UserManager {
    
    static let shared = UserManager()
    
    var currentUser: User?
    
    private init() {}
    
}
