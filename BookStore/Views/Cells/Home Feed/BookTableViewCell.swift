import UIKit

final class BookTableViewCell: UITableViewCell {
    static let identifier = "BookTableViewCell"

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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 添加子视图到单元格的内容视图
        contentView.addSubview(coverImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        
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
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            coverImageView.widthAnchor.constraint(equalToConstant: 80),

            nameLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: margin),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            
            priceLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: margin),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin)
        ])
    }

    public func configure(with book: Book) {
        // 使用给定的图书信息配置单元格的内容
        coverImageView.image = UIImage(named: book.coverImage)
        nameLabel.text = book.name
        priceLabel.text = "\(book.price)"
    }
}
