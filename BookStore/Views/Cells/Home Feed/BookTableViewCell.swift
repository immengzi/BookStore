import UIKit

final class BookTableViewCell: UITableViewCell {
    static let identifier = "BookTableViewCell"

    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        // 设置封面图标的布局约束
        // ...
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        // 设置书名的布局约束
        // ...
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        // 设置价格的布局约束
        // ...
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 添加子视图到单元格的内容视图
        contentView.addSubview(coverImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置子视图的布局约束
        // ...
    }

    public func configure(with book: Book) {
        // 使用给定的图书信息配置单元格的内容
        coverImageView.image = UIImage(named: book.coverImagePath)
        nameLabel.text = book.name
        priceLabel.text = "\(book.price)"
    }
}
