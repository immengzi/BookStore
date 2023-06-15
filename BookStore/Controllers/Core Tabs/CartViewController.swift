import UIKit

class CartViewController: UIViewController {
    
//    var username: String = ""
    private var cartItems: [Book] = [] // 修改为 [Book]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 添加tableView到视图层次结构中
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            let cartItemsData = try DataManager.shared.getCartItems(forUsername: UserManager.shared.currentUser!.username)
            cartItems = cartItemsData.map { $0.book }
            tableView.reloadData()
        } catch {
            print("Error retrieving cart items: \(error)")
        }
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
        let book = cartItems[indexPath.row]
        
        cell.configure(with: book)
        
        return cell
    }
}
