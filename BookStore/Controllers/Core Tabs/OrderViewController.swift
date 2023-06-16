import UIKit

class OrderViewController: UIViewController {
    
    private var orderItems: [OrderItem] = []
    let username = UserManager.shared.currentUser?.username
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orderItems = DataManager.shared.getOrders(forUsername: UserManager.shared.currentUser!.username)
        tableView.reloadData()
    }
}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier, for: indexPath) as! OrderTableViewCell
        let orderItem = orderItems[indexPath.row]
        
        cell.configure(with: orderItem)
        
        return cell
    }
}
