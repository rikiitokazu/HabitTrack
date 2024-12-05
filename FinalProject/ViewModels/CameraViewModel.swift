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
    
    enum PhotoCaptureFrontState {
        case frontNotStarted
        case frontProcessing
        case frontFinished(Data)
    }
    enum PhotoCaptureBackState {
        case backNotStarted
        case backProcessing
        case backFinished(Data)
    }
    
    var session = AVCaptureMultiCamSession()
    var frontOutput = AVCapturePhotoOutput()
    var backOutput = AVCapturePhotoOutput()
    
    var frontData: Data? {
        if case .frontFinished(let data) = photoCaptureFrontState {
            return data
        }
        return nil
    }
    
    var backData: Data? {
        if case .backFinished(let data) = photoCaptureBackState {
            return data
        }
        return nil
    }
    
    var hasPhoto: Bool {
        frontData != nil
    }
    
    private(set) var photoCaptureFrontState: PhotoCaptureFrontState = .frontNotStarted
    private(set) var photoCaptureBackState: PhotoCaptureBackState = .backNotStarted
    
    private var finalFrontData: Data?
    private var finalBackData: Data?
    
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
        
        do {
            guard let deviceFront = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
                return
            }
            let frontInput = try AVCaptureDeviceInput(device: deviceFront)
            guard session.canAddInput(frontInput) else { return }
            session.addInput(frontInput)
            
            guard session.canAddOutput(frontOutput) else { return }
            session.addOutput(frontOutput)
            
            guard let deviceBack = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                return
            }
            let backInput = try AVCaptureDeviceInput(device: deviceBack)
            guard session.canAddInput(backInput) else { return }
            session.addInput(backInput)
            
            guard session.canAddOutput(backOutput) else { return }
            session.addOutput(backOutput)
            
            session.commitConfiguration()
            
            
            Task(priority: .background) {
                self.session.startRunning()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func takePhoto() {
        guard case .frontNotStarted = photoCaptureFrontState else { return }
        guard case .backNotStarted = photoCaptureBackState else { return }
        frontOutput.capturePhoto(with: AVCapturePhotoSettings(),  delegate: self)
        backOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        
        withAnimation {
            self.photoCaptureFrontState = .frontProcessing
            self.photoCaptureBackState = .backProcessing
        }
    }
    
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate{

    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error {
            print(error.localizedDescription)
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("error here")
            return
        }
        
        // the photoOutput functions runs twice before the Task is ran
        // I believe the frontData is passed in first as it is the first device. 
        if finalFrontData == nil {
            finalFrontData = imageData
        } else {
            finalBackData = imageData
        }
        
        
        Task(priority: .background) {
            self.session.stopRunning()
            await MainActor.run {
                withAnimation {
                    self.photoCaptureFrontState = .frontFinished(finalFrontData!)
                    self.photoCaptureBackState = .backFinished(finalBackData!)

                }
            }
        }
    }
    
}
