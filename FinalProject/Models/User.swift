//
//  User.swift
//  FinalProject
//
//  Created by Riki Itokazu on 12/2/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class User: Identifiable, Codable {
    
    @DocumentID var id: String?
    var email: String
    var name: String
    var userId: String
    var lastLogin: Date
    var totalMissed: Int
    var totalAccomplished: Int
    var profilePic: String?
    
    init(id: String? = nil, email: String = "", name: String = "", userId: String = (Auth.auth().currentUser?.uid ?? ""), lastLogin: Date = Date.now, totalMissed: Int = 0, totalAccomplished: Int = 0, profilePic: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.userId = userId
        self.lastLogin = lastLogin
        self.totalMissed = totalMissed
        self.totalAccomplished = totalAccomplished
        self.profilePic = profilePic
    }
}
