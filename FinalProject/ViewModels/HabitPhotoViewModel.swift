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

   // Call this twice for front and back on the same HabitPhoto model
    static func saveImage(habit:Habit, photo: HabitPhoto, data: Data, display: AVCaptureDevice.Position) async  {
//        guard let id = habit.id else {
//            print("should never have been called without a valid spot.id")
//            return
//        }
        
        let storage = Storage.storage().reference()
        let metadata = StorageMetadata()
        if photo.id == nil {
            photo.id = UUID().uuidString
        }
        let _ = UUID().uuidString
        metadata.contentType = "image/jpeg"
        let path = "\("dummy")/\(UUID().uuidString)"
        
        do {
            let storageref = storage.child(path)
            let _ = try await storageref.putDataAsync(data, metadata: metadata)
            print("returned data")
            
            guard let url = try? await storageref.downloadURL() else {
                print("could not get downloadurl")
                return
            }
            if display == .front {
                photo.frontImageURLString = url.absoluteString
            } else {
                photo.backImageURLString = url.absoluteString
            }
            print(url.absoluteString)
            print("photo image url string")
            
            let db = Firestore.firestore()
            do {
                if let id = photo.id {
                    try db.collection("photos").document(id).setData(from:photo)
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
