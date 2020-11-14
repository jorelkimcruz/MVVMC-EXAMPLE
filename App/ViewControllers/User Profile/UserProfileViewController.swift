//
//  UserProfileViewController.swift
//  App
//
//  Created by MAC HOME on 11/12/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import Foundation
import UIKit
import Network
protocol UserProfileViewControllerListener: class {
  func userDidUpdate(user: User)
}
class UserProfileViewController: UIViewController, Storyboarded {
    weak var delegate: UserProfileViewControllerListener?
    var user: User!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var blogUrl: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var profileViewModel: ProfileViewModel!
    let connectivityMonitor = NWPathMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 0.5
        self.profileViewModel.delegate = self
        
        // Get data on first load
        getData(withState: connectivityMonitor.state())
        
        // Get data when connectivity changes
        self.connectivityMonitor.stateDidChange { [weak self] (state) in
            guard let `self` = self else {
                return
            }
            self.getData(withState: state)
        }
        
    }
    
    @IBAction func saveProfileButtonTapped(_ sender: Any) {
        profileViewModel.updateNotes(notes: textView.text)
    }
    
    private func getData(withState state: ConnectionState) {
        DispatchQueue.global(qos: .background).async {
            if state == .isActive {
                self.profileViewModel.requestProfile()
            } else {
                self.profileViewModel.getUserProfileFromPersistence()
            }
        }
    }
    
    
}

extension UserProfileViewController: ProfileViewModelDelegate {
    func userDidUpdate(user: User) {
        
        DispatchQueue.main.async {
            self.delegate?.userDidUpdate(user: user)
            self.followersLabel.text = "Followers: \(user.followers)"
            self.followingLabel.text = "Following: \(user.following)"
            if let name = user.name,
                let company = user.company,
                let blog = user.blog,
                let notes = user.note {
                self.name.text = "Name: \(name)"
                self.company.text = "Company: \(blog)"
                self.blogUrl.text = "Blog: \(company)"
                self.textView.text = notes
            }
            
            if let avatar = user.avatarURL {
                self.avatarImageView.downloadAndCache(url: avatar) { [weak self] (image) in
                    guard let `self` = self else {
                        return
                    }
                    self.avatarImageView.image = image
                }
            }
            
        }
    }
    
    func userDataDidChange() {
        self.profileViewModel.syncUsersProfileToPersistence(data: self.profileViewModel.profileData)
    }
    
}
