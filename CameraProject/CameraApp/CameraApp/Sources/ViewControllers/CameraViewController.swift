//
//  CameraViewController.swift
//  CameraApp
//
//  Created by Eunyeong Kim on 2017. 11. 15..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import UIKit

final class CameraViewController: UIViewController {
    
    // MARK: - Properties
    
    var cameraService = CameraService()
    static var viewSize: CGPoint?
    
    // MARK: - Initializing
    
    // MARK: - Actions
    
    func flashControl(){
        if CameraService.flash {
            CameraService.flash = false
        } else {
            CameraService.flash = true
        }
    }
    
    // MARK: - Touch event
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first
        let cameraViewSize = self.cameraView.bounds.size
        let foucusPoint = CGPoint(x: (touchPoint?.location(in: self.view).y)!/cameraViewSize.height, y: 1.0 - (touchPoint?.location(in: self.view).x)!/cameraViewSize.width)
        //초점, 밝기잡을려고 화면 터치하면 slider 위치가 새로 맞춰진 ISO에 맞춰지게 조정.
        self.isoSliderOutlet.value = (cameraService.currentCamera?.iso)!
        cameraService.cameraFocusing(focusPoint: foucusPoint)
        //focus marker 뜨게
        focusMark.frame = CGRect(x: (touchPoint?.location(in: self.view).x)! - 25, y: (touchPoint?.location(in: self.view).y)! - 25, width: 50, height: 50) //touchPoint
        focusMark.isHidden = false
        CameraService.delay(delay: 1.0, closure: {
            self.focusMark.isHidden = true
        })
    }
    
    // MARK: - UI
    
    @IBOutlet weak var cameraView: UIView!
    @IBAction func flashButton(_ sender: UIButton) {
        flashControl()
        print(CameraService.flash)
    }
    @IBAction func gridButton(_ sender: UIButton) {
        cameraView.backgroundColor = .red //🔴
    }
    @IBAction func nightModeButton(_ sender: UIButton) {
        //🔴
    }
    @IBAction func timerButton(_ sender: UIButton) {
        cameraService.timerSetting()
        sender.titleLabel?.text = "\(CameraService.timer)초"
        print(CameraService.timer)
    }
    @IBOutlet weak var focusMark: UIView!
    @IBAction func isoSlider(_ sender: UISlider) {
        sender.minimumValue = (cameraService.currentCamera?.activeFormat.minISO)!
        sender.maximumValue = (cameraService.currentCamera?.activeFormat.maxISO)!
        cameraService.exposureSetFromSlider(isoValue: sender.value)
    }
    @IBOutlet weak var isoSliderOutlet: UISlider!
    @IBAction func albumButton(_ sender: UIButton) {
    }
    @IBAction func takePhotoButton(_ sender: UIButton) {
        switch CameraService.timer {
        case CameraService.TimerCase.defalt.rawValue :
            cameraService.takePhoto()
        case CameraService.TimerCase.threeSeconds.rawValue :
            CameraService.delay(delay: 3, closure: {
                self.cameraService.takePhoto()
            })
        case CameraService.TimerCase.fiveSeconds.rawValue :
            CameraService.delay(delay: 5, closure: {
                self.cameraService.takePhoto()
            })
        case CameraService.TimerCase.tenSeconds.rawValue :
            print(CameraService.timer)
            CameraService.delay(delay: 10, closure: {
                self.cameraService.takePhoto()
            })
        default:
            print("error")
        }
    }
    @IBAction func frontOrBackCameraButton(_ sender: UIButton) {
        cameraService.frontOrBackCamera()
    }
    @IBOutlet weak var selectFilterCollectionView: UICollectionView!
    
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        cameraService.setUpCaptureSession()
        cameraService.setUpDevice()
        cameraService.setUpInputOutput()
        cameraService.setUpPreviewLayer(view: self.cameraView)
        cameraService.startRunningCaputureSession()
        
        focusMark.isHidden = true
        selectFilterCollectionView.isHidden = true //🔴
        CameraViewController.viewSize = self.view.frame.origin //🔴 initializer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension CameraViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterSelectingCell", for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
}

extension CameraViewController : UICollectionViewDelegateFlowLayout {
    
}
