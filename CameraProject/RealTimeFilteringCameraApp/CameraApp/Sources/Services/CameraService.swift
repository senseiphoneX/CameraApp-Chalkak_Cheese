//
//  CameraService.swift
//  CameraApp
//
//  Created by Eunyeong Kim on 2017. 11. 15..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import AVFoundation
import UIKit

class CameraService: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - Properties
    
    //camera load에 사용 properties
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    let photoSettings = AVCapturePhotoSettings()
    //촬영 이후 사용
    var photoOutput: AVCaptureVideoDataOutput?
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
            captureSession.beginConfiguration()
            photoOutput = AVCaptureVideoDataOutput()
            photoOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
            photoOutput?.alwaysDiscardsLateVideoFrames = true
//            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
            captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
            
            let queue = DispatchQueue(label: "filter", qos: .userInteractive, attributes: .concurrent)
            photoOutput?.setSampleBufferDelegate(self, queue: queue)
            
            captureSession.commitConfiguration()
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
//        if CameraService.cameraPosition && CameraService.flash { //🔴
//            if (currentCamera?.hasTorch)!{
//                do {
//                    try currentCamera?.lockForConfiguration()
//                    currentCamera?.torchMode = .on
//                } catch {
//                    print("no")
//                }
//            }
//
//            CameraService.delay(delay: 1.0) {
//                self.currentCamera?.torchMode = .off
//                self.currentCamera?.unlockForConfiguration()
//            }
//
//            CameraService.delay(delay: 0.1) {
//                let settings = AVCapturePhotoSettings()
//                self.photoOutput?.capturePhoto(with: settings, delegate: self)
//            }
//        } else {
//            let settings = AVCapturePhotoSettings()
//            photoOutput?.capturePhoto(with: settings, delegate: self)
//        }
//        print("take a photo")
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
}

extension CameraService {
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        print("♥️♥️♥️real time !!")
        print(sampleBuffer)
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        var outputImage = CIImage(cvPixelBuffer: imageBuffer!)
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(outputImage, forKey: kCIInputImageKey)
        filter?.setValue((50.0), forKey: kCIInputRadiusKey)
        outputImage = (filter?.outputImage)!
     
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        
        DispatchQueue.main.async {
            self.cameraPreviewLayer?.contents = cgImage
        }
        
    }
}

//extension CameraService: AVCapturePhotoCaptureDelegate {
//    // #available ios10
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
//        if let error = error {
//            print(error)
//        }
//        if let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
//            print(UIImage(data: dataImage)?.size as Any)
//            FilterService.filteringImage(image: UIImage(data: dataImage)!, cameraPosition: CameraService.cameraPosition)
//        }
//    }
//    // #available ios11~
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if let imageData = photo.fileDataRepresentation(){
//            FilterService.filteringImage(image: UIImage(data:imageData)!, cameraPosition: CameraService.cameraPosition)
//        }
//    }
//}

