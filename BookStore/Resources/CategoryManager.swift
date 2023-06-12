//
//  CategoryManager.swift
//  BookStore
//
//  Created by Apple on 2023/6/12.
//

import Foundation

class CategoryManager {
    
    static let shared = CategoryManager()

    var currentCategory: String = ""

    private init() {}
}
