//
//  AuthService.swift
//  StorageOrganizer
//
//  Created by Aaron Cleveland on 10/2/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
}

class AuthService {
    // creating a static allows us to only get instance once.
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
        print("Debug: Email is \(email), password: \(password)")
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.fullname
        let username = credentials.username
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Debug: Error is \(error.localizedDescription)")
                return
            }
            // uid is what we get back if it successfully gets a user back from the database
            guard let uid = result?.user.uid else { return }
            let values = ["email": email, "username": username, "fullname": fullname]

            // storing the user in firebase database under it's own UID.
            REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
        }
    }
}
