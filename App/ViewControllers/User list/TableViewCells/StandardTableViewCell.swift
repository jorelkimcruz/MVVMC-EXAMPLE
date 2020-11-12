//
//  UserTableViewCell.swift
//  App
//
//  Created by MAC HOME on 11/5/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//


import UIKit

class StandardTableViewCell: UITableViewCell, ConfigurableCell {
    
    lazy var avatarImageView: UIImageView = {
        // UIIMageView Settings
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var usernameLabel: UILabel = {
        // Set label settings
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.isOpaque = true
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var detailsLabel: UILabel = {
        // Set label settings
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.isOpaque = true
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        // Set StackView Settings
        let stackView = UIStackView()
        stackView.isOpaque = true
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var horizontalStackView: UIStackView = {
        // Set StackView Settings
        let stackView = UIStackView()
        stackView.isOpaque = true
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var noteImageView: UIImageView = {
        // UIIMageView Settings
        let imageView = UIImageView()
        imageView.isOpaque = true
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "NoteIcon")!
        return imageView
    }()
    
    //MARK: CONFIGURE
    func configure(data user: User, inverted: Bool) {
        guard let avatar = user.avatarURL, let login = user.login, let detail = user.url else {
            return
        }
        // Remove image on deque
        self.avatarImageView.image = nil
        avatarImageView.downloadAndCache(url: avatar) { (image) in
            self.avatarImageView.image = image
        }
        usernameLabel.text = login
        detailsLabel.text = detail.absoluteString
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // MARK: ContentView
        // Adds bordered effect for each cells contentView
        contentView.isOpaque = true
        backgroundColor = .clear
        
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        // add corner radius on `contentView`
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
        // MARK: Add ui to contentView
        contentView.addSubview(avatarImageView)
        contentView.addSubview(horizontalStackView)
        labelStackView.addArrangedSubview(usernameLabel)
        labelStackView.addArrangedSubview(detailsLabel)
        horizontalStackView.addArrangedSubview(labelStackView)
        horizontalStackView.addArrangedSubview(noteImageView)
        // MARK: Activate custom constraints
        NSLayoutConstraint.activate([
            // Avatar
            avatarImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            
            // label stackView
            //            labelStackView.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 8),
            //            labelStackView.heightAnchor.constraint(equalTo: avatarImageView.heightAnchor, constant: 0),
            
            // Horizontal stackView
            horizontalStackView.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 8),
            horizontalStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4),
            horizontalStackView.heightAnchor.constraint(equalTo: avatarImageView.heightAnchor, constant: 8)
            
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //MARK: set the values for top,left,bottom,right padding creates space for each view cell
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
