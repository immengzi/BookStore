import UIKit

final class OrderTableViewCell: UITableViewCell {
    static let identifier = "OrderTableViewCell"
    
    private let cellWidth: CGFloat = UIScreen.main.bounds.width - 32 // 屏幕宽度减去左右边距
    static var cellHeight: CGFloat = 100 // 设置一个默认的单元格高度
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let orderIdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 添加子视图到单元格的内容视图
        contentView.addSubview(containerView)
        containerView.addSubview(orderIdLabel)
        containerView.addSubview(totalNumberLabel)
        containerView.addSubview(totalPriceLabel)
        containerView.addSubview(createTimeLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupConstraints() {
        let margin: CGFloat = 16
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            containerView.heightAnchor.constraint(equalToConstant: OrderTableViewCell.cellHeight),
            
            orderIdLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: margin),
            orderIdLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin),
            orderIdLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            totalNumberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: margin),
            totalNumberLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin),
            totalNumberLabel.topAnchor.constraint(equalTo: orderIdLabel.bottomAnchor, constant: 8),
            
            totalPriceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: margin),
            totalPriceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin),
            totalPriceLabel.topAnchor.constraint(equalTo: totalNumberLabel.bottomAnchor, constant: 8),
            
            createTimeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: margin),
            createTimeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin),
            createTimeLabel.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 8),
            
        ])
    }
    
    public func configure(with orderItem: OrderItem) {
        orderIdLabel.text = "订单编号: \(orderItem.id)"
        totalPriceLabel.text = "总金额: \(orderItem.price) CNY"
        
        guard let jsonData = orderItem.itemJSON.data(using: .utf8),
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
        totalNumberLabel.text = "总数量: \(totalSum)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let createTimeString = dateFormatter.string(from: orderItem.createTime)
        createTimeLabel.text = "订单时间: \(createTimeString)"
    }
}
