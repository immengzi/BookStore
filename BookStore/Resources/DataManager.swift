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
        createTable()
        
        /// Book Init
        
    }

        // MARK: - Private Methods

    private func createTable() {
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
    let isbn: String
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
