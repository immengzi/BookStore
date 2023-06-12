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
        // 在这里调用适当的方法来测试数据
        // 例如，调用dataManager中的方法来插入测试图书
        
//        let book1 = Book(name: "计算机网络", price: 45, type: "网络", author: "谢希仁", description: "本书分为10章, 比较全面系统地介绍了计算机网络的发展和原理体系结构, 物理层, 数据链路层, 网络层, 运输层, 应用层, 网络安全, 因特网上的音频/视频服务, 无线网络和下一代因特网等内容。", coverImagePath: "book1")
//
//        dataManager.insertBook(name: book1.name, price: book1.price, type: book1.type, author: book1.author, description: book1.description, coverImagePath: book1.coverImagePath)
    }
}
