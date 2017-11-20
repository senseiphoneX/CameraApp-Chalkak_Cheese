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
    
    func flashControl() {
        if CameraService.flash {
            CameraService.flash = false
        } else {
            CameraService.flash = true
        }
    }
    func gridFrame() {
        horizonGrid1.frame = CGRect(x: 0, y: (self.cameraView.frame.height/3), width: self.cameraView.frame.width, height: 1)
        horizonGrid2.frame = CGRect(x: 0, y: 2*(self.cameraView.frame.height/3), width: self.cameraView.frame.width, height: 1)
        verticalGrid1.frame = CGRect(x: 1*(self.cameraView.frame.width/3), y: 0, width: 1, height: self.cameraView.frame.height)
        verticalGrid2.frame = CGRect(x: 2*(self.cameraView.frame.width/3), y: 0, width: 1, height: self.cameraView.frame.height)
    }
    func gridControl() {
        if CameraService.grid {
            horizonGrid1.isHidden = true
            horizonGrid2.isHidden = true
            verticalGrid1.isHidden = true
            verticalGrid2.isHidden = true
            CameraService.grid = false
        } else {
            horizonGrid1.isHidden = false
            horizonGrid2.isHidden = false
            verticalGrid1.isHidden = false
            verticalGrid2.isHidden = false
            CameraService.grid = true
        }
        print(CameraService.grid)
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
        gridControl()
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
    @IBOutlet weak var verticalGrid1: UIView!
    @IBOutlet weak var verticalGrid2: UIView!
    @IBOutlet weak var horizonGrid1: UIView!
    @IBOutlet weak var horizonGrid2: UIView!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        cameraService.setUpCaptureSession()
        cameraService.setUpDevice()
        cameraService.setUpInputOutput()
        cameraService.setUpPreviewLayer(view: self.cameraView)
        cameraService.startRunningCaputureSession()
        
        focusMark.isHidden = true
        selectFilterCollectionView.isHidden = false //🔴
        CameraViewController.viewSize = self.cameraView.frame.origin //🔴 initializer
        gridFrame()
        if CameraService.grid == false {
            verticalGrid1.isHidden = true
            verticalGrid2.isHidden = true
            horizonGrid1.isHidden = true
            horizonGrid2.isHidden = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension CameraViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterSelectingCell", for: indexPath)
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        var label: UILabel {
            let lb = UILabel()
            lb.textColor = .white
            lb.textAlignment = .left
            lb.font = UIFont.systemFont(ofSize: 10)
//            lb.backgroundColor = .red //
            lb.adjustsFontSizeToFitWidth = true
            return lb
        }
        label.text = "\(indexPath.row)"
        label.frame = cell.layer.bounds
        cell.addSubview(label) //라벨이 들어가지않는다.... 왜인지 대체 모르겠음......
        return cell
    }
}

extension CameraViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
