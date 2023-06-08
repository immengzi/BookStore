import UIKit
import SQLite3

class HomeViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 处理用户的登录状态
        handleNotAuthenticated()
    }
    
    private func handleNotAuthenticated() {
        // check auth status
        if UserManager.shared.currentUser == nil {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
    
}
