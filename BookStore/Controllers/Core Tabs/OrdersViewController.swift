import UIKit

class OrdersViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let username = UserManager.shared.currentUser?.username
        let orders = DataManager.shared.getOrders(forUsername: username!)
        print(orders)
    }
    
    
}
