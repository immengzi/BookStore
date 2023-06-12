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
        
//        let book1 = Book(name: "计算机网络", price: 45, type: "网络", author: "谢希仁", description: "本书分为10章, 比较全面系统地介绍了计算机网络的发展和原理体系结构, 物理层, 数据链路层, 网络层, 运输层, 应用层, 网络安全, 因特网上的音频/视频服务, 无线网络和下一代因特网等内容。", isbn: 9787121302954, coverImage: "book1")
//
//        dataManager.insertBook(name: book1.name, price: book1.price, type: book1.type, author: book1.author, description: book1.description, isbn: book1.isbn, coverImage: book1.coverImage)
        
//        let book2 = Book(name: "操作系统", price: 91.3, type: "系统", author: "亚伯拉罕·西尔伯沙茨（Abraham Silberschatz）", description: "本书是面向操作系统导论课程的经典书籍，从第1版至今被国内外众多高校选作教材。全书共六部分，不仅详细讲解了进程管理、内存管理、存储管理、保护与安全等概念，而且涵盖重要的理论结果和案例研究，并且给出了供读者深入学习的推荐读物。这一版新增了多核系统和移动计算的内容，每一章都融入了新的技术进展，并且更新了习题和编程项目。本书既适合高等院校计算机相关专业的学生学习，也是专业技术人员的有益参考。", isbn: 9787111604365, coverImage: "book2")
//
//        dataManager.insertBook(name: book2.name, price: book2.price, type: book2.type, author: book2.author, description: book2.description, isbn: book2.isbn, coverImage: book2.coverImage)
    }
}
