import SQLite
import SQLite3
import Foundation

class DataManager {
    static let shared = DataManager()
    
    /// DataBase
    private let dbFileName = "Bookstore.sqlite"
    private var db: Connection!
    
    /// User
    private let userTableName = "user"
    private let userTable: Table
    private let userId = Expression<Int>("id")
    private let username = Expression<String>("username")
    private let password = Expression<String>("password")
    
    /// Book
    private let bookTableName = "book"
    private let bookTable: Table
    private let bookId = Expression<Int>("id")
    private let bookName = Expression<String>("name")
    private let bookPrice = Expression<Double>("price")
    private let bookType = Expression<String>("type")
    private let bookAuthor = Expression<String>("author")
    private let bookDescription = Expression<String>("description")
    private let bookCoverImage = Expression<String>("coverImage")
    private let bookIsbn = Expression<Int>("isbn")
    
    /// Cart
    private let cartTableName = "cart"
    private let cartTable: Table
    private let cartId = Expression<Int>("id")
    private let cartBookIsbn = Expression<Int>("book_isbn")
    private let cartBookNumber = Expression<Int>("number")
    private let cartUserName = Expression<String>("user_name")
    
    /// Order
    private let orderTableName = "order"
    private let orderTable: Table
    private let orderId = Expression<Int>("id")
    private let orderUserName = Expression<String>("user_name")
    private let orderPrice = Expression<Double>("price")
    private let orderItemJSON = Expression<String>("item_json")
    private let orderCreateTime = Expression<Date>("create_time")
    
    // MARK: - Public API
    
    private init() {
        /// DataBase Init
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask,
                 appropriateFor: nil, create: false)
            .appendingPathComponent(dbFileName)
        db = try! Connection(fileURL.path)
        
        /// User Init
        userTable = Table(userTableName)
        
        /// Book Init
        bookTable = Table(bookTableName)
        
        /// Cart Init
        cartTable = Table(cartTableName)
        
        /// Order
        orderTable = Table(orderTableName)
        
        createTable()
        
        //        resetDatabase()
    }
    
    func resetDatabase() {
        // 断开数据库连接
        db = nil
        
        // 删除数据库文件
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask,
                 appropriateFor: nil, create: false)
            .appendingPathComponent(dbFileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("数据库文件删除成功")
        } catch {
            print("数据库文件删除失败: \(error)")
        }
        
        // 重新打开数据库连接
        db = try! Connection(fileURL.path)
    }
    
    // MARK: - Private Methods
    
    private func createTable() {
        /// User
        do {
            try db.run(userTable.create(ifNotExists: true) { table in
                table.column(userId, primaryKey: .autoincrement)
                table.column(username, unique: true)
                table.column(password)
            })
            print("User建表成功！")
        } catch {
            print("User建表失败: \(error)")
        }
        /// Book
        do {
            try db.run(bookTable.create(ifNotExists: true) { table in
                table.column(bookId, primaryKey: .autoincrement)
                table.column(bookName)
                table.column(bookPrice)
                table.column(bookType)
                table.column(bookAuthor)
                table.column(bookDescription)
                table.column(bookIsbn, unique: true)
                table.column(bookCoverImage)
            })
            print("Book建表成功!")
        } catch {
            print("Book建表失败: \(error)")
        }
        /// Cart
        do {
            try db.run(cartTable.create(ifNotExists: true) { table in
                table.column(cartId, primaryKey: .autoincrement)
                table.column(cartBookIsbn)
                table.column(cartBookNumber)
                table.column(cartUserName)
                table.foreignKey(cartBookIsbn, references: bookTable, bookId, delete: .cascade)
                table.foreignKey(cartUserName, references: userTable, username, delete: .cascade)
            })
            print("Cart建表成功!")
        } catch {
            print("Cart建表失败: \(error)")
        }
        /// Order
        do {
            try db.run(orderTable.create(ifNotExists: true) { table in
                table.column(orderId, primaryKey: .autoincrement)
                table.column(orderUserName)
                table.column(orderPrice)
                table.column(orderItemJSON)
                table.column(orderCreateTime)
                table.foreignKey(orderUserName, references: userTable, username, delete: .cascade)
            })
            print("Order建表成功!")
        } catch {
            print("Order建表失败: \(error)")
        }
    }
    
    func isUsernameAvailable(username: String) -> Bool {
        let query = userTable.filter(self.username == username)
        do {
            let count = try db.scalar(query.count)
            return count == 0
        } catch {
            print("Failed to check username availability: \(error)")
            return false
        }
    }
    
    func createUser(username: String, password: String) -> User? {
        let insert = userTable.insert(self.username <- username, self.password <- password)
        do {
            let rowid = try db.run(insert)
            print("User created with rowid: \(rowid)")
            return User(username: username, password: password)
        } catch {
            print("Failed to create user: \(error)")
            return nil
        }
    }
    
    func getUser(username: String, password: String) -> User? {
        let query = userTable.filter(self.username == username && self.password == password)
        do {
            let row = try db.pluck(query)
            guard let username = row?[self.username], let password = row?[self.password] else {
                return nil
            }
            print("DB层成功获取用户信息")
            return User(username: username, password: password)
        } catch {
            print("Failed to get user: \(error)")
            return nil
        }
    }
    
    func deleteUser(username: String) -> Bool {
        let query = userTable.filter(self.username == username)
        let delete = query.delete()
        do {
            try db.run(delete)
            print("User deleted successfully")
            return true
        } catch {
            print("Failed to delete user: \(error)")
            return false
        }
    }
    
    func insertBook(name: String, price: Double, type: String, author: String, description: String, isbn: Int, coverImage: String) -> Bool {
        let insert = bookTable.insert(bookName <- name, bookPrice <- price, bookType <- type, bookAuthor <- author, bookDescription <- description, bookIsbn <- isbn, bookCoverImage <- coverImage)
        do {
            try db.run(insert)
            print("成功插入一本图书！")
            return true
        } catch {
            print("插入图书失败: \(error)")
            return false
        }
    }
    
    func getAllBookCategories() -> [String] {
        let query = bookTable.select(distinct: bookType)
        do {
            let rows = try db.prepare(query)
            return rows.compactMap { row in
                return row[bookType]
            }
        } catch {
            print("Failed to retrieve book categories: \(error)")
            return []
        }
    }
    
    func getBooksOrderedByType(category: String) -> [Book] {
        let query = bookTable.filter(bookType == category).order(bookType.asc)
        do {
            let rows = try db.prepare(query)
            return rows.map { row in
                return Book(
                    name: row[bookName],
                    price: row[bookPrice],
                    type: row[bookType],
                    author: row[bookAuthor],
                    description: row[bookDescription],
                    isbn: row[bookIsbn],
                    coverImage: row[bookCoverImage]
                )
            }
        } catch {
            print("Failed to retrieve books: \(error)")
            return []
        }
    }
    
    func getBooksOrderedByName(ofType type: String) -> [Book] {
        let query = bookTable.filter(bookType == type).order(bookName.asc)
        do {
            let rows = try db.prepare(query)
            return rows.map { row in
                return Book(
                    name: row[bookName],
                    price: row[bookPrice],
                    type: row[bookType],
                    author: row[bookAuthor],
                    description: row[bookDescription],
                    isbn: row[bookIsbn],
                    coverImage: row[bookCoverImage]
                )
            }
        } catch {
            print("Failed to retrieve books: \(error)")
            return []
        }
    }
    
    func searchBooksByName(query: String) -> [Book] {
        let searchQuery = "%" + query + "%"
        let query = bookTable.filter(bookName.like(searchQuery, escape: "\\")).order(bookName.asc)
        do {
            let rows = try db.prepare(query)
            return rows.map { row in
                return Book(
                    name: row[bookName],
                    price: row[bookPrice],
                    type: row[bookType],
                    author: row[bookAuthor],
                    description: row[bookDescription],
                    isbn: row[bookIsbn],
                    coverImage: row[bookCoverImage]
                )
            }
        } catch {
            print("Failed to retrieve books: \(error)")
            return []
        }
    }
    
    func deleteBook(withId id: Int) -> Bool {
        let query = bookTable.filter(bookId == id)
        let delete = query.delete()
        do {
            try db.run(delete)
            print("Book deleted successfully")
            return true
        } catch {
            print("Failed to delete book: \(error)")
            return false
        }
    }
    
    func getCartItems(forUsername username: String) -> [CartItem] {
        let query = cartTable.join(bookTable, on: cartBookIsbn == bookIsbn)
            .filter(cartUserName == username)
        do {
            let rows = try db.prepare(query)
            return rows.map { row in
                let book = Book(
                    name: row[bookName],
                    price: row[bookPrice],
                    type: row[bookType],
                    author: row[bookAuthor],
                    description: row[bookDescription],
                    isbn: row[bookIsbn],
                    coverImage: row[bookCoverImage]
                )
                let number = row[cartBookNumber]
                return CartItem(book: book, number: number)
            }
        } catch {
            print("Failed to retrieve cart items: \(error)")
            return []
        }
    }
    
    func addCartItem(bookIsbn: Int, username: String, number: Int) -> Bool {
        let query = cartTable.filter(cartBookIsbn == bookIsbn && cartUserName == username)
        
        do {
            if let existingCartItem = try db.pluck(query) {
                // 记录已存在，执行更新操作
                let existingNumber = existingCartItem[cartBookNumber]
                let newNumber = existingNumber + number
                let update = query.update(cartBookNumber <- newNumber)
                try db.run(update)
            } else {
                // 记录不存在，执行插入操作
                let insert = cartTable.insert(cartBookIsbn <- bookIsbn, cartUserName <- username, cartBookNumber <- number)
                try db.run(insert)
            }
            
            print("Cart item added successfully")
            return true
        } catch {
            print("Failed to add cart item: \(error)")
            return false
        }
    }
    
    func removeCartItem(bookIsbn: Int, username: String) -> Bool {
        let query = cartTable.filter(cartBookIsbn == bookIsbn && cartUserName == username)
        let delete = query.delete()
        do {
            try db.run(delete)
            print("Cart item removed successfully")
            return true
        } catch {
            print("Failed to remove cart item: \(error)")
            return false
        }
    }
    
    func clearCartItems(forUsername username: String) -> Bool {
        let query = cartTable.filter(cartUserName == username)
        let delete = query.delete()
        do {
            try db.run(delete)
            print("Cart items cleared successfully")
            return true
        } catch {
            print("Failed to clear cart items: \(error)")
            return false
        }
    }
    
    func addOrderItem(username: String, bookJSON: String) -> Bool {
        guard let jsonData = bookJSON.data(using: .utf8),
              let selectedBooks = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] else {
            print("Failed to deserialize selected books")
            return false
        }
        var totalPrice = 0.0
        for book in selectedBooks {
            print("print book")
            guard let isbn = book["isbn"] as? Int else {
                continue
            }
            let query = bookTable.filter(bookIsbn == isbn)
            
            if let result = try? db.pluck(query) {
                let price = result[bookPrice]
                if let quantity = book["number"] as? Double {
                    totalPrice += price * quantity
                }
            }
        }
        let insert = orderTable.insert(orderUserName <- username, orderPrice <- totalPrice, orderItemJSON <- bookJSON, orderCreateTime <- Date())
        do {
            try db.run(insert)
            print("Order placed successfully, and the orderPrice is \(totalPrice)")
            return true
        } catch {
            print("Failed to place order: \(error)")
            return false
        }
    }
    
    func getOrders(forUsername username: String) -> [OrderItem] {
        var orders: [OrderItem] = []
        
        let query = orderTable.filter(orderUserName == username)
        
        do {
            for row in try db.prepare(query) {
                let orderId = row[orderId]
                let username = row[orderUserName]
                let price = row[orderPrice]
                let itemJSON = row[orderItemJSON]
                let createTime = row[orderCreateTime]
                
                let order = OrderItem(id: orderId, username: username, price: Double(price), itemJSON: itemJSON, createTime: createTime)
                orders.append(order)
            }
        } catch {
            print("Failed to fetch orders for username \(username): \(error)")
        }
        
        return orders
    }
}

struct User {
    let username: String
    let password: String
}

struct Book {
    let name: String
    let price: Double
    let type: String
    let author: String
    let description: String
    let isbn: Int
    let coverImage: String
}

struct CartItem {
    let book: Book
    let number: Int
}

struct OrderItem {
    let id: Int
    let username: String
    let price: Double
    let itemJSON: String
    let createTime: Date
}
