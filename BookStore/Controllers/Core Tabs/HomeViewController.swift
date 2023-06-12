import UIKit
import SQLite3

class HomeViewController: UIViewController {
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.identifier)
        return tableView
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        // 在视图控制器加载时插入测试数据
        TestDataManager.shared.insertTestData()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // 返回图书的类别数量作为分区数
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 获取所有图书
        let books = DataManager.shared.getAllBooksOrderedByType()
        
        // 返回图书的总数
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as! BookTableViewCell
        
        // 获取所有图书
        let books = DataManager.shared.getAllBooksOrderedByType()
        
        // 确保行索引有效
        guard indexPath.row < books.count else {
            return cell
        }
        
        // 获取指定位置的图书
        let book = books[indexPath.row]
        
        // 使用图书信息更新单元格
        cell.configure(with: book)
        
        return cell
    }
}
