//
//  SnackUser.swift
//  Snacktacular
//
//  Created by Brandon Bisbano on 4/18/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class SnackUser {
    var email: String
    var displayName: String
    var photoURL: String
    var userSince: Date
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["email": email, "displayName": displayName, "photoURL": photoURL, "userSince": userSince, "documentID": documentID]
    }
    
    init(email: String, displayName: String, photoURL: String, userSince: Date, documentID: String) {
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.userSince = userSince
        self.documentID = documentID
    }
    
    convenience init(user: User) { // each convenience initializer calls the initializer...
        self.init(email: user.email ?? "", displayName: user.displayName ?? "", photoURL: (user.photoURL != nil ? "\(user.photoURL!)" : ""), userSince: Date(), documentID: user.uid)
    }
    
    func saveIfNewUser() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(documentID)
        userRef.getDocument { (document, error) in
            guard error == nil else {
                print("*** ERROR: Could not access document for user \(userRef.documentID)")
                return
            }
            guard document?.exists == false else {
                print("^^^ The document for user \(self.documentID) already exists. No reason to create it.")
                return
            }
            self.saveData()
        }
        
    }
    
    func saveData() {
        let db = Firestore.firestore()
        let dataToSave: [String: Any] = self.dictionary // takes all of the values we got and creates a dictionary for us. Now we just have to save the data...
        db.collection("users").document(documentID).setData(dataToSave) { error in
            if let error = error {
                print("*** ERROR: \(error.localizedDescription), could not save data for \(self.documentID).")
            }
        } // since we already know what the document is gonna be, so we dont have to addDocuments too so we can just use setData(...)?
    }
}


