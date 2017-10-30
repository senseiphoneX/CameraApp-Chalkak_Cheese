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
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    
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
            if deviece.position == AVCaptureDevice.Position.back{
                backCamera = deviece
            } else if deviece.position == AVCaptureDevice.Position.front {
                frontCamera = deviece
            }
        }
        
        currentCamera = backCamera //카메라 처음 실행했을 때 기본값을 backCamera! 나중에 userDefalut로 bool값을 저장해서 유저가 마지막으로 사용한 카메라 설정을 불러와도 좋읏듯 함!
        
        
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
        } catch  {
            print(error)
        }
    }
    
    func setUpPreviewLayer(){
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
    }
    
    func startRunningCaputureSession() {
        captureSession.startRunning()
    }


    
    @IBAction func TakePhotoButton(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImagePreview" {
            let previewVC = segue.destination as! PreviewViewController
            previewVC.image = self.image
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCaptureSession()
        setUpDevice()
        setUpInputOutput()
        setUpPreviewLayer()
        startRunningCaputureSession()
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

