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
    var userId: String
    var lastLogin: Date?
    var totalMissed: Int
    var totalAccomplished: Int
    
    init(id: String? = nil, userId: String = (Auth.auth().currentUser?.uid ?? ""), lastLogin: Date? = nil, totalMissed: Int = 0, totalAccomplished: Int = 0) {
        self.userId = userId
        self.lastLogin = lastLogin
        self.totalMissed = totalMissed
        self.totalAccomplished = totalAccomplished
    }
}
