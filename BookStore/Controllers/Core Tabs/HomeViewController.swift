import UIKit
import SQLite3

class HomeViewController: UIViewController {
    
    private var selectedCategory: String = DataManager.shared.getAllBookCategories().first ?? ""
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.identifier)
        return tableView
    }()
    
    private let categorySegmentedControl: UISegmentedControl = {
        let categories = DataManager.shared.getAllBookCategories()
        let categorySegmentedControl = UISegmentedControl(items: categories)
        categorySegmentedControl.addTarget(self, action: #selector(categoryChanged(_:)), for: .valueChanged)
        categorySegmentedControl.selectedSegmentIndex = 0 // 默认选中第一个分类
        return categorySegmentedControl
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // 在视图控制器加载时插入测试数据
        TestDataManager.shared.insertTestData()
        view.addSubview(categorySegmentedControl)
            categorySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                categorySegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                categorySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                categorySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ])
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: categorySegmentedControl.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 处理用户的登录状态
        handleNotAuthenticated()
        tableView.reloadData()
    }
    
    private func handleNotAuthenticated() {
        // check auth status
        if UserManager.shared.currentUser == nil {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
    
    @objc private func categoryChanged(_ segmentedControl: UISegmentedControl) {
        let selectedCategoryIndex = segmentedControl.selectedSegmentIndex
        selectedCategory = segmentedControl.titleForSegment(at: selectedCategoryIndex) ?? ""
        tableView.reloadData()
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // 返回图书的类别数量作为分区数
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let books = DataManager.shared.getBooksOrderedByType(category: selectedCategory)
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let books = DataManager.shared.getBooksOrderedByType(category: selectedCategory)
            guard indexPath.row < books.count else {
                return UITableViewCell()
            }
            let book = books[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as! BookTableViewCell
            // 使用图书信息更新单元格
            cell.configure(with: book)

            return cell
    }
}
