import UIKit

final class BookTableViewCell: UITableViewCell {
    static let identifier = "BookTableViewCell"
    
    private let cellWidth: CGFloat = UIScreen.main.bounds.width - 32 // 屏幕宽度减去左右边距
    static var cellHeight: CGFloat = 100 // 设置一个默认的单元格高度
    private var quantity: Int = 0

    
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
    
    private let quantityControl: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("🛒", for: .normal)
        button.setTitleColor(.black, for: .normal)
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
        containerView.addSubview(quantityControl)
        containerView.addSubview(quantityLabel)
        containerView.addSubview(addToCartButton)
        
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
            containerView.heightAnchor.constraint(equalToConstant: BookTableViewCell.cellHeight),
            
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
            
            quantityControl.trailingAnchor.constraint(equalTo: addToCartButton.leadingAnchor, constant: -margin),
            quantityControl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            quantityControl.heightAnchor.constraint(equalToConstant: 30),
            
            quantityLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: quantityControl.leadingAnchor, constant: -margin),
            quantityLabel.centerYAnchor.constraint(equalTo: quantityControl.centerYAnchor),
            
            addToCartButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin),
            addToCartButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            addToCartButton.widthAnchor.constraint(equalToConstant: 30),
            addToCartButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    public func configure(with book: Book) {
        // 使用给定的图书信息配置单元格的内容
        coverImageView.image = UIImage(named: book.coverImage)
        nameLabel.text = book.name
        priceLabel.text = "\(book.price)"+" "+"CNY"
        
        // 计算单元格的高度
        let textHeight = nameLabel.sizeThatFits(CGSize(width: nameLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
        let totalHeight = textHeight + 16 + 8 + 30 // nameLabel的高度 + 上下间距 + priceLabel的上间距 + quantityControl的高度
        BookTableViewCell.cellHeight = max(totalHeight, BookTableViewCell.cellHeight)
        
        // Set initial quantity
                quantity = 0
                updateQuantityLabel()
        
        quantityControl.addTarget(self, action: #selector(quantityControlValueChanged(_:)), for: .valueChanged)
                addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
    }
    
    @objc private func quantityControlValueChanged(_ sender: UIStepper) {
            quantity = Int(sender.value)
            updateQuantityLabel()
        }

        @objc private func addToCartButtonTapped() {
            // Handle add to cart button tap event using 'quantity' value
        }

        private func updateQuantityLabel() {
            quantityLabel.text = "数量: "+"\(quantity)"
            quantityControl.value = Double(quantity)
        }
}
