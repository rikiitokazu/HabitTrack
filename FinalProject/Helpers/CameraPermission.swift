//
//  CameraPermission.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/29/24.
//

import UIKit
import AVFoundation

enum CameraPermission {
    enum CameraError: Error, LocalizedError {
        case unauthorized
        case unavailable
        
        var errorDescription: String? {
            switch self {
            case .unauthorized:
                return NSLocalizedString("You have not authorized camera use", comment: "")
            case .unavailable:
                return NSLocalizedString("A camera is not available for this device", comment: "")
            }
        }
        
        var recoverySuggestion: String? {
            switch self {
            case .unauthorized:
                return "Open Settings > Privacy and Security > Camera and turn on for this app"
            case .unavailable:
                return "Use the photo album instead"
            }
        }
        
        static func checkPermissions() -> CameraError? {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                switch authStatus {
                case .notDetermined:
                   return nil
                case .restricted:
                   return nil
                case .denied: 
                    return .unauthorized
                case .authorized:
                    return nil
                @unknown default:
                    return nil
                }
            } else {
                return .unavailable
            }
        }
    }
}
