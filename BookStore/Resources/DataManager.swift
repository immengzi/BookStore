import SQLite
import Foundation

class DataManager {
    static let shared = DataManager()

    /// DataBase
    private let dbFileName = "Bookstore.sqlite"
    private var db: Connection!

    /// User
    private let userTableName = "user"
    private let userTable: Table
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
    private let bookCoverImagePath = Expression<String>("coverimage_path")

    /// Cart
    private let cartTableName = "cart"
    private let cartTable: Table
    private let cartId = Expression<Int>("id")
    private let cartBookId = Expression<Int>("book_id")
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
    }

    // MARK: - Private Methods

    private func createTable() {
        /// User
        do {
            try db.run(userTable.create(ifNotExists: true) { table in
                table.column(username, primaryKey: true)
                table.column(password)
            })
            print("User建表成功！")
        } catch {
            print("User建表失败: \(error)")
        }
        /// Book
        do {
            try db.run(bookTable.create(ifNotExists: true) { table in
                table.column(bookId, primaryKey: true)
                table.column(bookName)
                table.column(bookPrice)
                table.column(bookType)
                table.column(bookAuthor)
                table.column(bookDescription)
                table.column(bookCoverImagePath)
            })
            print("Book建表成功!")
        } catch {
            print("Book建表失败: \(error)")
        }
        /// Cart
        do {
            try db.run(cartTable.create(ifNotExists: true) { table in
                table.column(cartId, primaryKey: true)
                table.column(cartBookId)
                table.column(cartUserName)
                table.foreignKey(cartBookId, references: bookTable, bookId, delete: .cascade)
                table.foreignKey(cartUserName, references: userTable, username, delete: .cascade)
            })
            print("Cart建表成功!")
        } catch {
            print("Cart建表失败: \(error)")
        }
        /// Order
        do {
            try db.run(orderTable.create(ifNotExists: true) { table in
                table.column(orderId, primaryKey: true)
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
}

struct User {
    let username: String
    let password: String
}

struct Book {
    let id: Int
    let name: String
    let price: Double
    let type: String
    let author: String
    let description: String
    let coverImagePath: String
}

struct CartItem {
    let book: Book
    let quantity: Int
}

struct OrderItem {
    let book: Book
    let quantity: Int
    let price: Double
}
