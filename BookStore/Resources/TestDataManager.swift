//
//  TestDataManager.swift
//  BookStore
//
//  Created by Apple on 2023/6/12.
//

import Foundation

class TestDataManager {
    static let shared = TestDataManager()
    
    private let dataManager: DataManager

    private init() {
        dataManager = DataManager.shared
        // 在这里进行测试特定的初始化或设置
    }
    
    // 在这里添加测试特定的方法和属性
    
    func insertTestData() {
        // 在这里调用适当的方法来插入测试数据
        // 例如，调用dataManager中的方法来插入测试图书
//        let book1 = Book(id: 1, name: "Book 1", price: 9.99, type: "Fiction", author: "Author 1", description: "Description 1", coverImagePath: "cover_image_1.jpg")
//        let book2 = Book(id: 2, name: "Book 2", price: 14.99, type: "Non-fiction", author: "Author 2", description: "Description 2", coverImagePath: "cover_image_2.jpg")
//
//        dataManager.insertBook(name: book1.name, price: book1.price, type: book1.type, author: book1.author, description: book1.description, coverImagePath: book1.coverImagePath)
//        dataManager.insertBook(name: book2.name, price: book2.price, type: book2.type, author: book2.author, description: book2.description, coverImagePath: book2.coverImagePath)
    }
}
