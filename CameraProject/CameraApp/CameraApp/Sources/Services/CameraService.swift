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
    //카메라 사용 관련 properties
    static var cameraPosition:Bool = true //true = back, false = front
    static var flash:Bool = false // true = on, false = off
    static var grid:Bool = true // true = on, false = off
    static var timer:Int = 0
    enum TimerCase: Int {
        case defalt = 0
        case threeSeconds = 3
        case fiveSeconds = 5
        case tenSeconds = 10
    }

    // MARK: - Camera Core Functions
    
    func setUpCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    func setUpDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        //back, front 카메라 어느쪽을 할 것인지 정하기.
        for deviece in devices {
            if CameraService.cameraPosition, deviece.position == AVCaptureDevice.Position.back {
                backCamera = deviece
                currentCamera = backCamera
            } else if CameraService.cameraPosition == false, deviece.position == AVCaptureDevice.Position.front {
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
//            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
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
    func takePhoto() {
        if CameraService.cameraPosition && CameraService.flash {
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
        print("take a photo")
    }
    func frontOrBackCamera() {
        captureSession.beginConfiguration()
        let currentInput:AVCaptureInput = captureSession.inputs[0]
        captureSession.removeInput(currentInput)
        if CameraService.cameraPosition {
           CameraService.cameraPosition = false
        } else {
            CameraService.cameraPosition = true
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
    func timerSetting() {
        switch CameraService.timer {
        case CameraService.TimerCase.defalt.rawValue :
            CameraService.timer = CameraService.TimerCase.threeSeconds.rawValue
        case CameraService.TimerCase.threeSeconds.rawValue :
            CameraService.timer = CameraService.TimerCase.fiveSeconds.rawValue
        case CameraService.TimerCase.fiveSeconds.rawValue :
            CameraService.timer = CameraService.TimerCase.tenSeconds.rawValue
        case CameraService.TimerCase.tenSeconds.rawValue :
            CameraService.timer = CameraService.TimerCase.defalt.rawValue
        default:
            print("error")
        }
    }
    func exposureSetFromSlider(isoValue:Float) {
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
    func cameraFocusing(focusPoint: CGPoint) {
        if let device = currentCamera {
            do {
                //선택한 포인트의 초점조절
                try device.lockForConfiguration()
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                }
                //선택한 포인트의 밝기조절
                if device.isExposurePointOfInterestSupported {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
                }
                device.unlockForConfiguration()
            } catch {
                print("error!!!")
            }
        }
    }
    func cameraSetFocus(focusPoint: CGPoint) {
        if let device = currentCamera {
            do {
                //선택한 포인트의 초점조절
                try device.lockForConfiguration()
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = AVCaptureDevice.FocusMode.continuousAutoFocus
                }
                device.unlockForConfiguration()
            } catch {
                print("set focus error.")
            }
        }
    }
    func cameraSetBrightnessFocus(focusPoint: CGPoint) {
        if let device = currentCamera {
            do {
                try device.lockForConfiguration()
                //선택한 포인트의 밝기조절
                if device.isExposurePointOfInterestSupported {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
                }
                device.unlockForConfiguration()
            } catch {
                print("set brightness error!")
            }
        }
    }
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 5.0
    var lastZoomFactor: CGFloat = 1.0
    func cameraZoom(pinch: UIPinchGestureRecognizer) {
        func minMaxZoom(factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), (currentCamera?.activeFormat.videoMaxZoomFactor)!)
        }
        func update(scale factor: CGFloat) {
            do {
                try currentCamera?.lockForConfiguration()
                defer {
                    currentCamera?.unlockForConfiguration()
                }
                currentCamera?.videoZoomFactor = factor
            } catch {
                print("error")
            }
        }
        let newScaleFactor = minMaxZoom(factor: pinch.scale * lastZoomFactor)
        switch pinch.state {
        case .began:
            fallthrough
        case .changed:
            update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(factor: newScaleFactor)
            update(scale: lastZoomFactor)
        default:
            break
        }
    }
}

extension CameraService: AVCapturePhotoCaptureDelegate {
    // #available ios10
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error)
        }
        if let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
            print(UIImage(data: dataImage)?.size as Any)
            FilterService.filteringImage(image: UIImage(data: dataImage)!, cameraPosition: CameraService.cameraPosition)
        }
    }
    // #available ios11~
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if let imageData = photo.fileDataRepresentation(){
//            FilterService.filteringImage(image: UIImage(data:imageData)!, cameraPosition: CameraService.cameraPosition)
//        }
//    }
}
