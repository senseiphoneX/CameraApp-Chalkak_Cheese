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
//        let captureDeviceInput =  5분18초!
        
    }
    
    func setUpPreviewLayer(){
        
        
    }
    
    func startRunningCaputureSession() {
        
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

