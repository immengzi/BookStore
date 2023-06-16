//
//  BookdetailViewController.swift
//  exercise_tabBar
//
//  Created by Apple on 2023/6/7.
//

import UIKit

class BookdetailViewController: UIViewController {
    
    static let identifier = "bookDetails"
    public var book: Book?
    public var number: Int = 0
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let isbnLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
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
        label.font = UIFont.systemFont(ofSize: 20)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "图书详情"
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
        setValues()
        updateNumberLabel()
        numberControl.addTarget(self, action: #selector(quantityControlValueChanged(_:)), for: .valueChanged)
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        print("跳转到图书详情页了")
    }
    
    private func setValues() {
        coverImageView.image = UIImage(named: book!.coverImage)
        nameLabel.text = book?.name
        priceLabel.text = "\(book!.price) CNY"
        authorLabel.text = "\(book!.author) 著"
        descriptionLabel.text = book?.description
        isbnLabel.text = "ISBN: \(book!.isbn)"
    }
    
    private func addSubviews() {
        view.addSubview(coverImageView)
        view.addSubview(nameLabel)
        view.addSubview(priceLabel)
        view.addSubview(authorLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(isbnLabel)
        view.addSubview(numberLabel)
        view.addSubview(numberControl)
        view.addSubview(addToCartButton)
    }
    
    private func updateNumberLabel() {
        numberLabel.text = "数量: "+"\(number)"
        numberControl.value = Double(number)
    }
    
    @objc private func quantityControlValueChanged(_ sender: UIStepper) {
        number = Int(sender.value)
        updateNumberLabel()
    }
    
    @objc private func addToCartButtonTapped() {
        guard let book = self.book else {
            return
        }
        DataManager.shared.addCartItem(bookIsbn: book.isbn, username: UserManager.shared.currentUser!.username, number: number)
        if number == 0 {
            let alertController = UIAlertController(title: "提示", message: "您选择图书的数量为0", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "好的", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "成功", message: "图书已添加到购物车", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "好的", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        number = 0
        updateNumberLabel()
    }
    
    private func setupConstraints() {
        let margin: CGFloat = 20
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
            coverImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coverImageView.widthAnchor.constraint(equalToConstant: 200),
            coverImageView.heightAnchor.constraint(equalToConstant: 300),
            
            nameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            isbnLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 50),
            isbnLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            authorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: margin),
            authorLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: isbnLabel.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: margin),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: isbnLabel.trailingAnchor),
            
            priceLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margin),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            numberLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margin),
            numberLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: margin),

            numberControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            numberControl.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: margin),
            
            addToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margin),
            addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
        ])
    }
    
}
