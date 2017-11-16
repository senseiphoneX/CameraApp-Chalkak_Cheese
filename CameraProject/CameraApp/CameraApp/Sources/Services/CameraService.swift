//
//  CameraService.swift
//  CameraApp
//
//  Created by Eunyeong Kim on 2017. 11. 15..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import AVFoundation
import UIKit

class CameraService: NSObject {
    
    // MARK: - Properties
    
    //camera load에 사용 properties
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    let photoSettings = AVCapturePhotoSettings()
    //촬영 이후 사용
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    //밑에는 사용하는지 안하는지 머름 ㅠ
    var image: UIImage?

    // MARK: - Camera Core Functions
    
    func setUpCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    func setUpDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        //back, front 카메라 어느쪽을 할 것인지 정하기.
        for deviece in devices {
            if CameraViewController.cameraPosition, deviece.position == AVCaptureDevice.Position.back {
                backCamera = deviece
                currentCamera = backCamera
            } else if CameraViewController.cameraPosition == false, deviece.position == AVCaptureDevice.Position.front {
                frontCamera = deviece
                currentCamera = frontCamera
            }
        }
    }
    func setUpInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
            captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        } catch  {
            print(error)
        }
    }
    func setUpPreviewLayer(view:UIView) {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = view.frame
        view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    func startRunningCaputureSession() {
        captureSession.startRunning()
    }
    
    // MARK: - Camera Custom Functions
    
    static func delay(delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    func takePhoto(cameraPosition:Bool, flash:Bool) {
        if cameraPosition && flash {
            if (currentCamera?.hasTorch)!{
                do {
                    try currentCamera?.lockForConfiguration()
                    currentCamera?.torchMode = .on
                } catch {
                    print("no")
                }
            }
            
            CameraService.delay(delay: 1.0) {
                self.currentCamera?.torchMode = .off
                self.currentCamera?.unlockForConfiguration()
            }
            
            CameraService.delay(delay: 0.1) {
                let settings = AVCapturePhotoSettings()
                self.photoOutput?.capturePhoto(with: settings, delegate: self)
            }
        } else {
            let settings = AVCapturePhotoSettings()
            photoOutput?.capturePhoto(with: settings, delegate: self)
        }
    }
    func frontOrBackCamera(){
        captureSession.beginConfiguration()
        let currentInput:AVCaptureInput = captureSession.inputs[0]
        captureSession.removeInput(currentInput)
        if CameraViewController.cameraPosition {
           CameraViewController.cameraPosition = false
        } else {
            CameraViewController.cameraPosition = true
        }
        setUpDevice()
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: currentCamera!))
        } catch  {
            print(error)
        }
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
    func exposureSetFromSlider(isoValue:Float){
        let cmTime:CMTime = CMTimeMake(10, 1000) //🔴적절한 cmTime 찾기🔴
        if let device = currentCamera {
            do{
                try device.lockForConfiguration()
                device.setExposureModeCustom(duration: cmTime, iso: isoValue, completionHandler: { (time) in
                })
            } catch {
                print(error)
            }
        }
        currentCamera?.unlockForConfiguration()
        print(isoValue)
    }
}

extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?, cameraPosition: Bool, view: UIView) {
        if let imageData = photo.fileDataRepresentation(){
            FilterService.filteringImage(image: UIImage(data: imageData)!, cameraPosition: cameraPosition, view: view)
        }
    }
}
