//
//  HabitPhotoViewModel.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/30/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import SwiftUI
import AVFoundation

@Observable
class HabitPhotoViewModel {

    static func saveImage(habit:Habit, habitPhoto: HabitPhoto, frontData: Data, backData: Data) async  {
        guard let _ = habit.id else {
            print("should never have been called without a valid habit.id")
            return
        }
        

        let storage = Storage.storage().reference()
        let metadata = StorageMetadata()
        if habitPhoto.id == nil {
            habitPhoto.id = UUID().uuidString
        }
        let _ = UUID().uuidString
        metadata.contentType = "image/jpeg"
        
        do {
            let storagerefFront = storage.child("\(habit.userId)/\(UUID().uuidString)")
            let _ = try await storagerefFront.putDataAsync(frontData, metadata: metadata)
            
            guard let urlFront = try? await storagerefFront.downloadURL() else {
                print("could not get downloadurl for front data")
                return
            }
            habitPhoto.frontImageURLString = urlFront.absoluteString
            
            
            let storagerefBack = storage.child("\("dummy")/\(UUID().uuidString)")
            let _ = try await storagerefBack.putDataAsync(backData, metadata: metadata)
            
            guard let urlBack = try? await storagerefBack.downloadURL() else {
                print("could not get downloadurl for back data")
                return
            }
            habitPhoto.backImageURLString = urlBack.absoluteString
            
            
            let db = Firestore.firestore()
            do {
                if let id = habitPhoto.id {
                    try db.collection("photos").document(id).setData(from:habitPhoto)
                } else {
                    print("--- failed to unwrap photo.id")
                    return
                }
                
            } catch {
                print("ERROR could not upload photo in url")
            }
        } catch {
            print("error saving photo to storage \(error.localizedDescription)")
        }
    }
    
    
    static func saveProfilePic(user: User, data: Data) async  {
        
        guard let id = user.id else {
            print("should never have been called without a valid user.id")
            return
        }
        

        let storage = Storage.storage().reference()
        let metadata = StorageMetadata()
        let _ = UUID().uuidString
        metadata.contentType = "image/jpeg"
        
        do {
            let storageRef = storage.child("\(id)/\(UUID().uuidString)")
            let _ = try await storageRef.putDataAsync(data, metadata: metadata)
            
            guard let url = try? await storageRef.downloadURL() else {
                print("could not get downloadurl for data")
                return
            }
            user.profilePic = url.absoluteString
            
            
            let db = Firestore.firestore()
            do {
                if let id = user.id {
                    try db.collection("users").document(id).setData(from:user)
                } else {
                    print("--- failed to unwrap photo.id")
                    return
                }
                
            } catch {
                print("ERROR could not upload photo in url")
            }
        } catch {
            print("error saving photo to storage \(error.localizedDescription)")
        }
    }
}
