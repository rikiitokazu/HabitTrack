//
//  CameraViewModel.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/29/24.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI


@Observable
class CameraViewModel: NSObject {
    
    enum PhotoCaptureState {
        case notStarted
        case processing
        case finished(Data)
    }
    
    var session = AVCaptureSession()
    var preview = AVCaptureVideoPreviewLayer()
    var output = AVCapturePhotoOutput()
    
    var photoData: Data? {
        if case .finished(let data) = photoCaptureState {
            return data
        }
        return nil
    }
    
    var hasPhoto: Bool {
        photoData != nil
    }
    
    private(set) var photoCaptureState: PhotoCaptureState = .notStarted
    
    func requestAcccessAndSetup(position: AVCaptureDevice.Position) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { didAllowAccess in
                self.setup(position: position)
            }
        case .authorized:
            self.setup(position: position)
        // more cases
        default:
           print("other status")
            
        }
    }
    
    private func setup(position: AVCaptureDevice.Position) {
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        do {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else {
                return
            }
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input) else { return }
            session.addInput(input)
            
            guard session.canAddOutput(output) else { return }
            session.addOutput(output)
            
            session.commitConfiguration()

            
            Task(priority: .background) {
                self.session.startRunning()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func takePhoto() {
        guard case .notStarted = photoCaptureState else { return }
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        withAnimation {
            self.photoCaptureState = .processing
        }
    }
    
    func retakePhoto() {
        Task(priority: .background) {
            self.session.startRunning()
            await MainActor.run {
                self.photoCaptureState = .notStarted
            }
        }
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error {
            print(error.localizedDescription)
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        Task(priority: .background) {
            self.session.stopRunning()
            await MainActor.run {
                withAnimation {
                    self.photoCaptureState = .finished(imageData)
                }
            }
        }
    }
}
