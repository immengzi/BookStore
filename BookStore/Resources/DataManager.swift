import SQLite
import Foundation


class DataManager {
    static let shared = DataManager()

    /// DataBase
    private let dbFileName = "Bookstore.sqlite"
    private var db: Connection!
    
    /// User
    private let userTableName = "User"
    private let userTable: Table
    private let userId = Expression<Int>("id")
    private let username = Expression<String>("username")
    private let password = Expression<String>("password")
    
    /// Book
    private let bookTableName = "Book"
    private let bookTable: Table
    private let bookId = Expression<Int>("id")
    
    /// ShoppingCart
    private let shoppingCartTableName = "ShoppingCart"
    private let shoppingCartTable: Table
    private let shoppingCartId = Expression<Int>("id")
    private let shoppingCartUserId = Expression<Int>("user_id")
    private let shoppingCartBookId = Expression<Int>("book_id")
    private let shoppingCartQuantity = Expression<Int>("quantity")
    
    /// Order
    private let orderTableName = "Order"
    private let orderTable: Table
    private let orderId = Expression<Int>("id")
    private let orderUserId = Expression<Int>("user_id")
    private let orderBookId = Expression<Int>("book_id")
    private let orderQuantity = Expression<Int>("quantity")
    private let orderPrice = Expression<Double>("price")

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
        
        /// ShoppingCart Init
        shoppingCartTable = Table(shoppingCartTableName)
        
        /// Order
        orderTable = Table(orderTableName)
        
        createTable()
        
    }

        // MARK: - Private Methods

    private func createTable() {
        /// User
        do {
            try db.run(userTable.create(ifNotExists: true) { table in
                table.column(userId, primaryKey: .autoincrement)
                table.column(username)
                table.column(password)
            })
            print("User建表成功！")
        } catch {
            print("User建表失败: \(error)")
        }
        /// Book
        do {
            try db.run(bookTable.create(ifNotExists: true) { table in
                
            })
            print("Book建表成功!")
          } catch {
            print("Book建表失败: \(error)")
          }
        /// ShoppingCart
        do {
            try db.run(shoppingCartTable.create(ifNotExists: true) { table in
                
            })
            print("ShoppingCart建表成功!")
          } catch {
            print("ShoppingCart建表失败: \(error)")
          }
        /// Order
        do {
            try db.run(orderTable.create(ifNotExists: true) { table in
                
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
            return User(id: Int(rowid), username: username, password: password)
        } catch {
            print("Failed to create user: \(error)")
            return nil
        }
    }
    
    func getUser(username: String, password: String) -> User? {
            let query = userTable.filter(self.username == username && self.password == password)
            do {
                let row = try db.pluck(query)
                guard let id = row?[self.userId], let username = row?[self.username], let password = row?[self.password] else {
                    return nil
                }
                print("有了！")
                return User(id: id, username: username, password: password)
            } catch {
                print("Failed to get user: \(error)")
                return nil
            }
        }
}

struct User {
    let id: Int
    let username: String
    let password: String
}

struct Book {
    let id: Int
    let cover_image: String
    let title: String
    let author: String
    let description: String
    let price: Double
}

struct ShoppingCartItem {
    let book: Book
    let quantity: Int
}

struct OrderItem {
    let book: Book
    let quantity: Int
    let price: Double
}
