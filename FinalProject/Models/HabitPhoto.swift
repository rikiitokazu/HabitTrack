//
//  HabitPhoto.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/30/24.
//

import Foundation
import SwiftData
import FirebaseFirestore
import FirebaseAuth

class HabitPhoto: Identifiable, Encodable {
    @DocumentID var id: String?
    var userId: String
    var habitId: String?
    var dateCreated: Date
    var caption: String
    var frontImageURLString: String
    var backImageURLString: String
    var user: String
    
    init(id: String? = nil, userId: String = Auth.auth().currentUser?.uid ?? "", habitId: String? = nil, dateCreated: Date = Date.now, caption: String = "", frontImageURLString: String = "", backImageURLString: String = "", user: String = Auth.auth().currentUser?.email ?? "") {
        self.userId = userId
        self.habitId = habitId
        self.dateCreated = dateCreated
        self.caption = caption
        self.frontImageURLString = frontImageURLString
        self.backImageURLString = backImageURLString
        self.user = user
    }
}
