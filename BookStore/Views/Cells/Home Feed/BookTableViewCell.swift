import UIKit

final class BookTableViewCell: UITableViewCell {
    static let identifier = "BookTableViewCell"
    
    var addToCartButtonTappedHandler: (() -> Void)?
    
    private let cellWidth: CGFloat = UIScreen.main.bounds.width - 32 // 屏幕宽度减去左右边距
    static var cellHeight: CGFloat = 100 // 设置一个默认的单元格高度
    public var number: Int = 0
    
    private var book: Book?
    
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
    
    private let numberControl: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    private let numberLabel: UILabel = {
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
        
        contentView.addSubview(containerView)
        containerView.addSubview(coverImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(numberControl)
        containerView.addSubview(numberLabel)
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
            
            numberControl.trailingAnchor.constraint(equalTo: addToCartButton.leadingAnchor, constant: -margin),
            numberControl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            numberControl.heightAnchor.constraint(equalToConstant: 30),
            
            numberLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            numberLabel.trailingAnchor.constraint(equalTo: numberControl.leadingAnchor, constant: -margin),
            numberLabel.centerYAnchor.constraint(equalTo: numberControl.centerYAnchor),
            
            addToCartButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin),
            addToCartButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            addToCartButton.widthAnchor.constraint(equalToConstant: 30),
            addToCartButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    public func configure(with book: Book) {
        self.book = book
        
        coverImageView.image = UIImage(named: book.coverImage)
        nameLabel.text = book.name
        priceLabel.text = "\(book.price)"+" "+"CNY"
        
        let textHeight = nameLabel.sizeThatFits(CGSize(width: nameLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
        let totalHeight = textHeight + 16 + 8 + 30 // nameLabel的高度 + 上下间距 + priceLabel的上间距 + quantityControl的高度
        BookTableViewCell.cellHeight = max(totalHeight, BookTableViewCell.cellHeight)
        
        number = 0
        updateNumberLabel()
        
        numberControl.addTarget(self, action: #selector(quantityControlValueChanged(_:)), for: .valueChanged)
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
    }
    
    @objc private func quantityControlValueChanged(_ sender: UIStepper) {
        number = Int(sender.value)
        updateNumberLabel()
    }
    
    @objc private func addToCartButtonTapped() {
        guard let book = self.book else {
            return // 如果book为nil，则无法执行添加到购物车的操作
        }
        DataManager.shared.addCartItem(bookIsbn: book.isbn, username: UserManager.shared.currentUser!.username, number: number)
        addToCartButtonTappedHandler?()
    }
    
    private func updateNumberLabel() {
        numberLabel.text = "数量: "+"\(number)"
        numberControl.value = Double(number)
    }
}
