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
            containerView.heightAnchor.constraint(equalToConstant: OrderTableViewCell.cellHeight)
        ])
    }
    
    public func configure(with orderItem: OrderItem) {
//        let username = UserManager.shared.currentUser?.username
//        let item_json = orderItem.itemJSON
        totalPriceLabel.text = "\(orderItem.price)"
        createTimeLabel.text = "\(orderItem.createTime)"
        
    }
}
