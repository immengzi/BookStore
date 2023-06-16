import UIKit

class OrderDetailViewController: UIViewController, UITableViewDelegate {
    
    static let identifier = "orderDetails"
    public var number: Int = 0
    public var orderItem: OrderItem?
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let itemTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "订单详情"
        view.backgroundColor = .white
        itemTableView.dataSource = self
        itemTableView.delegate = self
        itemTableView.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
        addSubviews()
        setupConstraints()
        setValues()
        print("跳转到订单详情页了")
    }
    
    private func setValues() {
        idLabel.text = "订单编号: \(orderItem!.id)"
        // 打印 orderItem 的 itemJSON 数据
        print("itemJSON: \(orderItem?.itemJSON ?? "")")
        
        guard let jsonData = orderItem!.itemJSON.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
              let items = jsonObject as? [[String: Any]] else {
            print("Failed to parse JSON")
            return
        }
        var totalSum = 0

        for item in items {
            if let number = item["number"] as? Int {
                totalSum += number
            }
        }
        numberLabel.text = "图书总数: \(totalSum)"
        priceLabel.text = "订单金额: \(orderItem!.price) CNY"
        timeLabel.text = "订单时间: \(orderItem!.createTime)"
        
        print("itemTableView 数据源数量: \(tableView(itemTableView, numberOfRowsInSection: 0))")
        
        itemTableView.reloadData()
    }
    
    private func addSubviews() {
        view.addSubview(idLabel)
        view.addSubview(numberLabel)
        view.addSubview(priceLabel)
        view.addSubview(timeLabel)
        view.addSubview(itemTableView)
    }
    
    private func setupConstraints() {
        let margin: CGFloat = 20
        
        NSLayoutConstraint.activate([
            idLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
            idLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),

            numberLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 20),
            numberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            priceLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 20),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            timeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            itemTableView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
            itemTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            itemTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
}

extension OrderDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let jsonData = orderItem?.itemJSON.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
              let items = jsonObject as? [[String: Any]] else {
            return 0
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell,
              let jsonData = orderItem?.itemJSON.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
              let items = jsonObject as? [[String: Any]] else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        let isbn = item["isbn"] as! NSNumber
        let number = item["number"] as! NSNumber
        cell.configure(with: String(isbn.intValue), number: number.intValue)
        
        
        return cell
    }
    
}

class ItemCell: UITableViewCell {
    
    private let itemLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(itemLabel)
        contentView.addSubview(numberLabel)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            itemLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            itemLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 16),
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            numberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with isbn: String, number: Int) {
        print("configure: ISBN: \(isbn), 数量: \(number)")
        itemLabel.text = "ISBN: \(isbn)"
        numberLabel.text = "数量: \(number)"
        contentView.backgroundColor = UIColor.clear
    }
}
