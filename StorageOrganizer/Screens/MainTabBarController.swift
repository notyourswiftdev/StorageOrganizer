//
//  MainTabBarController.swift
//  StorageOrganizer
//
//  Created by Aaron Cleveland on 10/2/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.layer.cornerRadius = 56 / 2
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        logUserOut()
        view.backgroundColor = .white
        authenticateUserAndConfigure()
        fetchUser()
    }
    
    // MARK: - API
    func fetchUser() {
        UserService.shared.fetchUser()
    }
    
    // Checks to see if the user is logged in. If not than we present the login screen to allow them to regist or login.
    func authenticateUserAndConfigure() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            print("Debug: User is not logged int")
        } else {
            configureViewControllers()
            configureUI()
            print("Debug: User is logged in")
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Debug: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    // MARK: - Selectors
    @objc func actionButtonTapped() {
        print(123)
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
    }
    
    func configureViewControllers() {
        let explore = DashboardViewController()
        let nav1 = templateNavigationController(image: UIImage(named: "square.dashed"), rootViewController: explore)
        
        let notifications = NotificationsViewController()
        let nav2  = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notifications)
        
        viewControllers = [nav1, nav2]
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
}
