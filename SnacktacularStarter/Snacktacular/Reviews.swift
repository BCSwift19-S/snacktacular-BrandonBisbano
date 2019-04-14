//
//  Reviews.swift
//  Snacktacular
//
//  Created by Brandon Bisbano on 4/14/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray: [Review] = [] // can do this either way
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(spot: Spot, completed: @escaping () -> ()) {
        guard spot.documentID != "" else {
            return
        } // prevents us from loading data without a spot or doc id. pasted in
        db.collection("spots").document(spot.documentID).collection("review").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: Adding the snapshot listener \(error!.localizedDescription).")
                return completed()
            }
            self.reviewArray = []
            // There are querySnapshot!.documents.count documents in the spots snapshot.
            for document in querySnapshot!.documents {
                let review = Review(dictionary: document.data())
                review.documentID = document.documentID
                self.reviewArray.append(review)
            }
            completed()
        }
    }
}

