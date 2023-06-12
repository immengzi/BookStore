import UIKit

class CartViewController: UIViewController {
    
    var username: String = ""
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
        
        let cartItemsData = DataManager.shared.getCartItems(forUsername: username) // 获取购物车图书项数组
        
        // 转换 [CartItem] 为 [Book]
        cartItems = cartItemsData.map { $0.book }
        
        // 添加tableView到视图层次结构中
        view.addSubview(tableView)
        tableView.frame = view.bounds
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
