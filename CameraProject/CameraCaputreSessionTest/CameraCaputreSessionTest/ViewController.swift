//
//  ViewController.swift
//  CameraCaputreSessionTest
//
//  Created by Eunyeong Kim on 2017. 10. 28..
//  Copyright © 2017년 unnnyong. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: - 변수s
    //나중에 struct로 모아서 정리하기 😇
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var cameraPosition:Bool = true //true = back, false = front
    var flash:Bool = true // true = on, false = off
    
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    
    
    // MARK: - 카메라 관련 함수들
    func setUpCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo //AVCaptureSeesion.Preset : image의 quality를 결정.
    }
    
    func setUpDevice() {
        //iOS 10부터는 device를 AVCaptureDevice를 사용.
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
            // DiscoverySession : 함수가 실행되면 맞는 기기를 자동으로 매치해준다.
            // AVCaptureDevice.DeviceType.builtInWideAngleCamera : 일반적으로 사용하는 카메라 타입.
            // AVCaptureDevice.Position.unspecified : 앞카메라, 뒷카메라 중 어떤걸 사용할 것인지 선택.
        let devices = deviceDiscoverySession.devices
        
        //back, front 카메라 어느쪽을 할 것인지 정하기.
        for deviece in devices {
            if cameraPosition, deviece.position == AVCaptureDevice.Position.back {
                backCamera = deviece
                currentCamera = backCamera
            } else if cameraPosition == false, deviece.position == AVCaptureDevice.Position.front {
                frontCamera = deviece
                currentCamera = frontCamera
            }
        }
        
//        currentCamera = backCamera //카메라 처음 실행했을 때 기본값을 backCamera! 나중에 userDefalut로 bool값을 저장해서 유저가 마지막으로 사용한 카메라 설정을 불러와도 좋을듯 함!
    }
    
    func setUpInputOutput() {
        // [camera]-----setupInput-----[captureSession]---setupOutput---[userView]
        //captureSession에 들어오는 값을 설정.
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!) //사용자가 카메라로 사진을 찍으면 사진 data가 여기로 들어온당
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
            captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        } catch  {
            print(error)
        }
    }
    
    func setUpPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaputureSession() {
        captureSession.startRunning()
    }
    
    // MARK: - Custom Functions
    func frontOrBackCamera(){
        captureSession.beginConfiguration()
        let currentInput:AVCaptureInput = captureSession.inputs[0]
        captureSession.removeInput(currentInput)
        
        if cameraPosition {
            cameraPosition = false
        } else {
            cameraPosition = true
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
    
    func delay(delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func flashControl(){
        if flash {
            flash = false
        } else {
            flash = true
        }
    }

    func toggleTorch(){
        if (currentCamera?.hasTorch)!{
            do {
                try currentCamera?.lockForConfiguration()
                currentCamera?.torchMode = .on
            } catch {
                print("no")
            }
        }
        
        delay(delay: 1.0) {
            self.currentCamera?.torchMode = .off
            self.currentCamera?.unlockForConfiguration()
        }
        
        delay(delay: 0.1) {
            let settings = AVCapturePhotoSettings()
            self.photoOutput?.capturePhoto(with: settings, delegate: self)
        }
    }
    
    func exposureSetFromSlider(isoValue:Float){
        
        let cmTime:CMTime = CMTimeMake(10, 1000)
        
        if let device = currentCamera {
            do{
                try device.lockForConfiguration()
                device.setExposureModeCustom(duration: cmTime, iso: isoValue, completionHandler: { (time) in
                    //
                })
            } catch {
                print(error)
            }
        }
        
        print(isoValue)
    }

    // MARK: - Outlet
    @IBAction func TakePhotoButton(_ sender: UIButton) {
        if cameraPosition && flash {
            toggleTorch()
        } else {
            let settings = AVCapturePhotoSettings()
            photoOutput?.capturePhoto(with: settings, delegate: self)
        }
    }
    @IBAction func ExposureSlider(_ sender: UISlider) {
        sender.minimumValue = (currentCamera?.activeFormat.minISO)!
        sender.maximumValue = (currentCamera?.activeFormat.maxISO)!
        exposureSetFromSlider(isoValue: sender.value)
    }
    
    @IBOutlet weak var exposureSliderOutlet: UISlider!
    
    @IBAction func FrontOrBackCamera(_ sender: UIButton) {
        frontOrBackCamera()
    }
    @IBAction func FlashButton(_ sender: UIButton) {
        flashControl()
    }
    @IBOutlet weak var TouchFocusMark: UIView!
    
    
    
    
    // MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImagePreview" {
            let previewVC = segue.destination as! PreviewViewController
            previewVC.image = self.image
        }
    }
    
    // MARK: - Touching Focus
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first
        let cameraViewSize = self.view.bounds.size
        let foucusPoint = CGPoint(x: (touchPoint?.location(in: self.view).y)!/cameraViewSize.height, y: 1.0 - (touchPoint?.location(in: self.view).x)!/cameraViewSize.width)
        
        
        
        if let device = currentCamera {
            do {
                //선택한 포인트의 초점조절
                try device.lockForConfiguration()
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = foucusPoint
                    device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                }
                //선택한 포인트의 밝기조절
                if device.isExposurePointOfInterestSupported {
                    device.exposurePointOfInterest = foucusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
                }
                device.unlockForConfiguration()
                
                //focus marker 뜨게
                TouchFocusMark.frame = CGRect(x: (touchPoint?.location(in: self.view).x)! - 25, y: (touchPoint?.location(in: self.view).y)! - 25, width: 50, height: 50)
                TouchFocusMark.isHidden = false
                
                delay(delay: 1.0, closure: {
                    self.TouchFocusMark.isHidden = true
                })
                
            } catch {
                print("error!!!")
            }
        }
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCaptureSession()
        setUpDevice()
        setUpInputOutput()
        setUpPreviewLayer()
        startRunningCaputureSession()
        
        TouchFocusMark.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "ImagePreview", sender: nil)
        }
    }
}

