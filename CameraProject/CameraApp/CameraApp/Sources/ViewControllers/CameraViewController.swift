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
    static var cameraPosition:Bool = true //true = back, false = front
    var flash:Bool = false // true = on, false = off
    var timer:Int = 0
    enum TimerCase: Int {
        case defalt = 0
        case threeSeconds = 3
        case fiveSeconds = 5
        case tenSeconds = 10
    }
    
    // MARK: - Initializing
    
    // MARK: - Actions
    func flashControl(){
        if flash {
            flash = false
        } else {
            flash = true
        }
    }
    
    // MARK: - UI
    
    @IBOutlet weak var cameraView: UIView!
    @IBAction func flashButton(_ sender: UIButton) {
        flashControl()
    }
    @IBAction func gridButton(_ sender: UIButton) {
    }
    @IBAction func nightModeButton(_ sender: UIButton) {
    }
    @IBAction func timerButton(_ sender: UIButton) {
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
        selectFilterCollectionView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//extension CameraViewController : UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//}

extension CameraViewController : UICollectionViewDelegateFlowLayout {
    
}
