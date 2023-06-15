import UIKit

class CartViewController: UIViewController {
    
    private var cartItems: [CartItem] = [] // 修改为 [CartItem]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
        return tableView
    }()
    
    struct Constants {
        static let cornerRadius : CGFloat = 9.0
    }
    
    private let payButton: UIButton = {
        let button = UIButton()
        button.setTitle("支付", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = Constants.cornerRadius
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            payButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            payButton.heightAnchor.constraint(equalToConstant: 52.0)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        view.addSubview(payButton)
        setupConstraints()
        view.bringSubviewToFront(payButton)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartItems = DataManager.shared.getCartItems(forUsername: UserManager.shared.currentUser!.username)
        tableView.reloadData()
    }
    
    
    @objc private func payButtonTapped() {
        let alertController = UIAlertController(title: "确认支付", message: "是否要将所选书本添加到订单中？", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: { _ in
            self.addSelectedBooksToOrder()
        }))
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func addSelectedBooksToOrder() {
        // 遍历所有的单元格
        for cell in tableView.visibleCells {
            guard let cartCell = cell as? CartTableViewCell else { continue }
            
            if cartCell.selectCheckBox.isSelected {
                // 将书本添加到订单中的逻辑
                // ...
            }
        }
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
        let cartItem = cartItems[indexPath.row]
        
        cell.configure(with: cartItem)
        
        return cell
    }
}
