//
//  RegisterViewController.swift
//  StorageOrganizer
//
//  Created by Aaron Cleveland on 10/2/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: fullnameTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullnameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Full Name")
        return tf
    }()
    
    private let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.twitterBlue, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account?", " Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleShowLogin() {
        print("Going back to login screen")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRegistration() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let fullname = fullnameTextField.text else { return }
        
        let credentials = AuthCredentials(email: email,
                                          password: password,
                                          fullname: fullname)
        
        AuthService.shared.registerUser(credentials: credentials) { error, ref in
            if let error = error {
                print("Debug: Error logging in \(error.localizedDescription)")
            }
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
                let tab = window.rootViewController as? MainTabBarController else { return }
            tab.authenticateUserAndConfigure()
            self.dismiss(animated: true, completion: nil)
            print("Debug: Successful log in.")
        }
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .darkGray
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   fullnameContainerView,
                                                   registrationButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingLeft: 32,
                     paddingRight: 32)
        stack.centerY(inView: view)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor,
                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor,
                                     paddingLeft: 40,
                                     paddingRight: 40)
    }
}
