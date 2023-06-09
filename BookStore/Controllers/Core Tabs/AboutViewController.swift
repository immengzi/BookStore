//
//  AboutViewController.swift
//  exercise_tabBar
//
//  Created by Apple on 2023/6/7.
//

import UIKit

class AboutViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius : CGFloat = 9.0
    }
    
    private let logOutButton : UIButton = {
        let button = UIButton()
        button.setTitle("注销", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.text = UserManager.shared.currentUser?.username
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        view.backgroundColor = .systemBackground
        logOutButton.addTarget(self, action: #selector(didTapLogOutButton), for: .touchUpInside)
    }
    
    func addSubviews() {
        addLabel()
        addButton()
    }
    
    func addLabel() {
        usernameLabel.text = "欢迎您：" + UserManager.shared.currentUser!.username
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false // 禁用自动布局

        // 添加label组件到视图中
        view.addSubview(usernameLabel)

        // 设置label组件的位置和尺寸
        NSLayoutConstraint.activate([
//            usernameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor), // 垂直居中
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 水平居中
            usernameLabel.widthAnchor.constraint(equalToConstant: 200),
            usernameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func addButton() {
        logOutButton.translatesAutoresizingMaskIntoConstraints = false // 禁用自动布局

        // 添加button组件到视图中
        view.addSubview(logOutButton)

        // 设置button组件的位置和尺寸
        NSLayoutConstraint.activate([
            logOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            logOutButton.heightAnchor.constraint(equalToConstant: 52.0)
        ])
    }
    
    @objc private func didTapLogOutButton() {
        let actionSheet = UIAlertController(title: "注销", message: "确定要注销吗？", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "注销", style: .destructive, handler: {
            (action) in
            AuthManager.shared.logOut()
                if UserManager.shared.currentUser == nil {
                    let loginVC = LoginViewController()
                    loginVC.modalPresentationStyle = .fullScreen
                    self.present(loginVC, animated: true) {
                        self.navigationController?.popToRootViewController(animated: false)
                        self.tabBarController?.selectedIndex = 0
                    }
                }
                else {
                    fatalError("无法注销用户登录")
                }
        }))
        
        present(actionSheet, animated: true)
    }

}
