import Foundation

class AuthManager {
    static let shared = AuthManager()

    private let dataManager = DataManager.shared

    private init() {}
    
        // 用户名是否可用
        // 创建账户
        // 插入到数据库中

    public func registerNewUser(username: String, password: String) -> Bool {
        guard dataManager.isUsernameAvailable(username: username) else {
            print("用户名不可用")
            return false
        }

        guard let user = dataManager.createUser(username: username, password: password) else {
            print("创建用户失败")
            return false
        }
        UserManager.shared.currentUser = user
        print("账户注册成功")
        
        return true
    }

    public func loginUser(username: String, password: String) -> Bool {
        let user = DataManager.shared.getUser(username: username, password: password)
        if user != nil {
            // 保存用户名到 UserDefaults
            UserDefaults.standard.set(username, forKey: "username")
            UserManager.shared.currentUser = user
            return true
        } else {
          return false
        }
    }
    
    public func logOut() {
        UserManager.shared.currentUser = nil
        
        UserDefaults.standard.removeObject(forKey: "username")
        
        print("用户退出成功")
    }
}
