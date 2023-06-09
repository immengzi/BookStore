//
//  BookTableViewController.swift
//  BookStore
//
//  Created by Apple on 2023/6/9.
//

import UIKit

final class BookTableViewCell: UITableViewCell {
    
    static let identifier = "BookTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
        
    }
}
