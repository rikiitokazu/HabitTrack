//
//  UserViewModel.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/28/24.
//

import Foundation
import FirebaseFirestore


@Observable
class UserViewModel {
    
    static func saveUser(user: User) async -> String? {
        let db = Firestore.firestore()
        
        if let id = user.id {
            do {
                try db.collection("users").document(id).setData(from: user)
                print("Data updated successfully")
                return id
            } catch {
                print("Could not update data in 'users' \(error.localizedDescription)")
                return id
            }
            
        } else {
            do {
                let docRef = try db.collection("users").addDocument(from: user)
                print("Data added succesfully")
                return docRef.documentID
            } catch {
                print("Could not create a new spot in 'users' \(error.localizedDescription)")
                return nil
            }
        }
    }
}
