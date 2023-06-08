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
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.text = UserManager.shared.currentUser?.username
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .clear
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        logOutButton.addTarget(self, action: #selector(didTapLogOutButton), for: .touchUpInside)
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // assign frames
        
        logOutButton.frame = CGRect(
            x: 25,
            y: view.height - view.safeAreaInsets.bottom - 80,
            width: view.width - 50,
            height: 52.0
        )
    }
    
    private func addSubviews() {
        view.addSubview(usernameLabel)
        view.addSubview(logOutButton)
//        view.addSubview(produceButton)
//        view.addSubview(developerButton)
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
