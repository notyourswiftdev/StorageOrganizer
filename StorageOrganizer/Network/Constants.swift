//
//  Constants.swift
//  StorageOrganizer
//
//  Created by Aaron Cleveland on 10/2/22.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
