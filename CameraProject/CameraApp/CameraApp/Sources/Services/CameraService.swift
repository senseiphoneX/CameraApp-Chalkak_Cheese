//
//  CameraService.swift
//  CameraApp
//
//  Created by Eunyeong Kim on 2017. 11. 15..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import AVFoundation
import Photos
import UIKit

class CameraService: NSObject {
    
    // MARK: - Properties
    
    var captureSession = AVCaptureSession()
    var currentCamera: AVCaptureDevice?
    private let photoSettings = AVCapturePhotoSettings()
    private var photoOutput: AVCapturePhotoOutput?
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
//    var image: UIImage? //🔴 필터 때 필요. 우선은 놔두기.
    static var cameraPosition: Bool = true
    static var flash: Bool = false
    static var grid: Bool = false
    static var isAutoTemperature: Bool = true
    static var isAutoLensPosition: Bool = true
    static var isAutoISO: Bool = true
    private let minimumZoom: CGFloat = 1.0
    private let maximumZoom: CGFloat = 5.0
    private var lastZoomFactor: CGFloat = 1.0
    static var timer: Int = 0
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
                if let dualCameradevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                    currentCamera = dualCameradevice
                } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                    currentCamera = backCameraDevice
                }
            } else if CameraService.cameraPosition == false, deviece.position == AVCaptureDevice.Position.front {
                if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                    currentCamera = frontCameraDevice
                }
            }
        }
    }
    func setUpInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.isHighResolutionCaptureEnabled = true
            if #available(iOS 10.2, *) {
                if (photoOutput?.isDualCameraFusionSupported)! {
                    
                }
            }
            if let connection = photoOutput?.connection(with: .video) {
                if connection.isVideoStabilizationSupported {
                    connection.preferredVideoStabilizationMode = .auto
                }
            }
//            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
            captureSession.sessionPreset = AVCaptureSession.Preset.photo
        } catch  {
            print(error)
        }
    }
    func setUpPreviewLayer(view:UIView) {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        DispatchQueue.main.async {
            self.cameraPreviewLayer?.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y-57.5, width: view.frame.width, height: view.frame.height)
            view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
        }
    }
    func startRunningCaputureSession() {
        captureSession.startRunning()
    }
    
    // MARK: - Camera Custom Functions
    
    static func delay(delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    func checkFlashModeAndTakePhoto() {
        photoSettings.isHighResolutionPhotoEnabled = true
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
    }
    func changeCameraPosition() {
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
    func exposureSetFromSlider(isoValue: Float) {
        if let device = currentCamera {
            do{
                try device.lockForConfiguration()
                device.setExposureModeCustom(duration: AVCaptureDevice.currentExposureDuration, iso: isoValue, completionHandler: nil)
            } catch {
                print(error)
            }
        }
        currentCamera?.unlockForConfiguration()
    }
    func nomalizedGains(grains: AVCaptureDevice.WhiteBalanceGains) -> AVCaptureDevice.WhiteBalanceGains {
        var g = grains
        g.redGain = max(1.0, g.redGain)
        g.greenGain = max(1.0, g.greenGain)
        g.blueGain = max(1.0, g.blueGain)
        if let device = self.currentCamera {
            g.redGain = min(device.maxWhiteBalanceGain, g.redGain)
            g.greenGain = min(device.maxWhiteBalanceGain, g.greenGain)
            g.blueGain = min(device.maxWhiteBalanceGain, g.blueGain)
        }
        return g
    }
    func setWhiteBalanceGains(gains: AVCaptureDevice.WhiteBalanceGains) {
        if let device = self.currentCamera {
            let normalGains = nomalizedGains(grains: gains)
            do{
                try device.lockForConfiguration()
                device.setWhiteBalanceModeLocked(with: normalGains, completionHandler: nil)
            } catch {
                print(error)
            }
        }
        currentCamera?.unlockForConfiguration()
    }

    func temperatureSetFromSlider(temperatureValue: Float) {
        let currentTint = (self.currentCamera?.temperatureAndTintValues(for: (self.currentCamera?.deviceWhiteBalanceGains)!).tint)!
        let newWhiteBalance = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues.init(temperature: temperatureValue, tint: currentTint)
        let newGains = self.currentCamera?.deviceWhiteBalanceGains(for: newWhiteBalance)
        setWhiteBalanceGains(gains: newGains!)
        self.currentCamera?.isWhiteBalanceModeSupported(AVCaptureDevice.WhiteBalanceMode.locked)
    }
    func setLensPosition(value: Float) {
        if let device = self.currentCamera {
            do{
                try device.lockForConfiguration()
                device.setFocusModeLocked(lensPosition: value, completionHandler: nil)
            } catch {
                print(error)
            }
        }
        currentCamera?.unlockForConfiguration()
    }
    func touchFocusAction(focusPoint: CGPoint) {
        if let device = currentCamera {
            do {
                try device.lockForConfiguration()
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                }
                if device.isExposurePointOfInterestSupported {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
                }
                device.whiteBalanceMode = AVCaptureDevice.WhiteBalanceMode.continuousAutoWhiteBalance
                device.unlockForConfiguration()
            } catch {
                print("error!!!")
            }
        }
    }
    func focusFanGestureAction(focusPoint: CGPoint) {
        if let device = currentCamera {
            do {
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
    func brightenessFocusFanGestureAction(focusPoint: CGPoint) {
        if let device = currentCamera {
            do {
                try device.lockForConfiguration()
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
    func cameraZoomPinchAction(pinch: UIPinchGestureRecognizer) -> Double {
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
        return Double(newScaleFactor).rounded(places: 1)
    }
}

extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error)
        }
        if let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
//            필터 사용할때 사용하기.
//            FilterService.filteringImage(image: UIImage(data: dataImage)!, cameraPosition: CameraService.cameraPosition)
            UIImageWriteToSavedPhotosAlbum(UIImage(data: dataImage)!, nil, nil, nil)
        }
    }
}

extension Double {
    public func rounded(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self*divisor).rounded() / divisor
    }
}

