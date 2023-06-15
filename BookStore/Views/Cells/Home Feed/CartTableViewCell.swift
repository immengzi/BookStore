import UIKit

final class CartTableViewCell: UITableViewCell {
    static let identifier = "CartTableViewCell"
    
    private let cellWidth: CGFloat = UIScreen.main.bounds.width - 32 // 屏幕宽度减去左右边距
    static var cellHeight: CGFloat = 100 // 设置一个默认的单元格高度
    private var quantity: Int = 0
    
    public var book: Book?
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
//        label.textAlignment = .center
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
    
    public let selectCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 添加子视图到单元格的内容视图
        contentView.addSubview(containerView)
        containerView.addSubview(coverImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(quantityLabel)
        containerView.addSubview(totalPriceLabel)
        containerView.addSubview(selectCheckBox)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
    }
    
    private func setupConstraints() {
        let margin: CGFloat = 16
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            containerView.heightAnchor.constraint(equalToConstant: CartTableViewCell.cellHeight),
            
            coverImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            coverImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            coverImageView.widthAnchor.constraint(equalToConstant: cellWidth / 3),
            
            nameLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: margin),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: margin),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            quantityLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: margin),
            quantityLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin),
            quantityLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            
            totalPriceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            totalPriceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin),
            totalPriceLabel.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: 8),
            
            selectCheckBox.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin),
            selectCheckBox.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            selectCheckBox.widthAnchor.constraint(equalToConstant: 30),
            selectCheckBox.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    public func configure(with cartItem: CartItem) {
        // 使用给定的图书信息配置单元格的内容
        self.book = cartItem.book
        quantity = cartItem.number
        coverImageView.image = UIImage(named: book!.coverImage)
        nameLabel.text = book?.name
        if let price = book?.price {
            priceLabel.text = "\(price)" + " " + "CNY"
        } else {
            priceLabel.text = "N/A"
        }
        
        // 计算单元格的高度
        let textHeight = nameLabel.sizeThatFits(CGSize(width: nameLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
        let totalHeight = textHeight + 16 + 8 + 8 + 30 // nameLabel的高度 + 上下间距 + priceLabel的上间距 + quantityLabel的上间距 + selectCheckBox的高度
        CartTableViewCell.cellHeight = max(totalHeight, CartTableViewCell.cellHeight)
        
        updateQuantityLabel()
        
        selectCheckBox.addTarget(self, action: #selector(selectCheckBoxTapped), for: .touchUpInside)
    }

    @objc private func selectCheckBoxTapped() {
        selectCheckBox.isSelected = !selectCheckBox.isSelected
    }

    private func updateQuantityLabel() {
        guard let book = book else { return }
        
        quantityLabel.text = "数量: " + "\(quantity)"
        let totalPrice = book.price * Double(quantity)
        totalPriceLabel.text = "总价: " + "\(totalPrice)" + " CNY"
    }
}
