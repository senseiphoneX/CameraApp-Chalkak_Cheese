//
//  CameraViewController.swift
//  CameraApp
//
//  Created by Eunyeong Kim on 2017. 11. 15..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import MediaPlayer
import Photos
import UIKit

final class CameraViewController: UIViewController {
    
    // MARK: - Properties
    
    var cameraService = CameraService()
    var currentIndexPath: IndexPath?
    var imagePickerSelectedImage: UIImage?
    private let tintColor = UIColor(red: 245.0 / 255.0, green: 166.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0)
    static var viewSize: CGPoint?
    
    // MARK: - Initializing
    
    // MARK: - Actions
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied: break
        case .restricted: break
        case .authorized: self.readyToUseCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.readyToUseCamera()
                }
            })
        }
    }
    private func checkPhotoLibraryPermission() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    AlbumService.loadPhotos()
                    self.albumButtonPreviewAtCameraView()
                }
            })
        case .restricted: break
        case .denied: break
        case .authorized:
            AlbumService.loadPhotos()
            self.albumButtonPreviewAtCameraView()
        }
    }
    private func readyToUseCamera() {
        self.cameraService.setUpCaptureSession()
        self.cameraService.setUpDevice()
        self.cameraService.setUpInputOutput()
        self.cameraService.setUpPreviewLayer(view: self.cameraView)
        self.cameraService.startRunningCaputureSession()
        CameraViewController.viewSize = self.cameraView.frame.origin //🔴 initializer
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.takePhotoButtonAction), name: Notification.Name(rawValue: "volumeChanged"), object: nil)
        let volView = MPVolumeView(frame: CGRect(x: 0, y: -100, width: 0, height: 0))
        self.view.addSubview(volView)
    }
    func albumButtonPreviewAtCameraView() {
        let photoAsset = AlbumService.fetchResult.object(at: 0)
        let photoSize = CGSize(width: 42.7, height: 42.7)
        AlbumService.imageManager.requestImage(for: photoAsset, targetSize: photoSize, contentMode: .aspectFill, options: nil) { (image, info) -> Void in
            if let img = image {
                DispatchQueue.main.async {
                    let imageView = UIImageView(image: img)
                    imageView.frame.size = photoSize
                    imageView.contentMode = UIViewContentMode.scaleAspectFill
                    imageView.clipsToBounds = true
                    self.albumButtonOutlet.addSubview(imageView)
                }
            }
        }
    }
    func timerPhotoLabelControl() {
        self.timerButtonOutlet.isEnabled = false
        timerLabel.text = "\(CameraService.timer)"
        timerLabel.isHidden = false
        for i in 1...CameraService.timer {
            CameraService.delay(delay: Double(i), closure: {
                if i == CameraService.timer {
                    self.timerLabel.isHidden = true
                    self.cameraService.takePhoto()
                    self.timerButtonOutlet.isEnabled = true
                } else {
                    self.timerLabel.text = "\(CameraService.timer - i)"
                }
            })
        }
    }
    func setFocusLabelFrame() {
        if brightnessFocusMark.isHidden == false && focusMark.isHidden == false {
            brightnessFocusMarkLabel.frame = CGRect(x: brightnessFocusMark.frame.origin.x + 12, y: brightnessFocusMark.frame.origin.y + 81 , width: 57, height: 13)
            focusMarkLabel.frame = CGRect(x: focusMark.frame.origin.x + 12, y: focusMark.frame.origin.y - 13, width: 57, height: 13)
            brightnessFocusMarkLabel.isHidden = false
            focusMarkLabel.isHidden = false
        }
    }
    @objc func takePhotoButtonAction() {
        switch CameraService.timer {
        case CameraService.TimerCase.defalt.rawValue :
            cameraService.takePhoto()
        case CameraService.TimerCase.threeSeconds.rawValue :
            timerPhotoLabelControl()
        case CameraService.TimerCase.fiveSeconds.rawValue :
            timerPhotoLabelControl()
        case CameraService.TimerCase.tenSeconds.rawValue :
            timerPhotoLabelControl()
        default:
            print("error")
        }
        AlbumService.loadPhotos()
        self.albumButtonPreviewAtCameraView()
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
        self.brightnessFocusMark.frame = CGRect(x: (touchPoint?.location(in: self.view).x)! - 25, y: (touchPoint?.location(in: self.view).y)! - 25, width: 81, height: 81) //touchPoint
        self.focusMark.frame = CGRect(x: (touchPoint?.location(in: self.view).x)! - 25, y: (touchPoint?.location(in: self.view).y)! - 25, width: 81, height: 81) //touchPoint
        self.brightnessFocusMark.isHidden = false
        self.focusMark.isHidden = false
        self.setFocusLabelFrame()
    }
    @IBAction func focusPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.focusMark) // = touchPoint
        sender.view?.center = CGPoint(x: (sender.view?.center.x)! + translation.x, y: (sender.view?.center.y)! + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.focusMark)
        cameraService.cameraSetFocus(focusPoint: (sender.view?.center)!)
        self.setFocusLabelFrame()
    }
    @IBAction func brightnessFocusPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.brightnessFocusMark) // = touchPoint
        sender.view?.center = CGPoint(x: (sender.view?.center.x)! + translation.x, y: (sender.view?.center.y)! + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.brightnessFocusMark)
        cameraService.cameraSetBrightnessFocus(focusPoint: (sender.view?.center)!)
        self.setFocusLabelFrame()
    }
    @IBAction func cameraZoomGesture(_ sender: UIPinchGestureRecognizer) {
        
//        cameraService.cameraZoom(pinch: sender)
        zoonLabel.text = "\(cameraService.cameraZoom(pinch: sender))x"
    }
    
    // MARK: - UI
    
    @IBOutlet weak var cameraView: UIView!
    @IBAction func flashButton(_ sender: UIButton) {
        if CameraService.flash {
            CameraService.flash = false
            sender.setImage(#imageLiteral(resourceName: "offFlashIcon"), for: .normal)
        } else {
            CameraService.flash = true
            sender.setImage(#imageLiteral(resourceName: "onFlashIcon"), for: .normal)
        }
    }
    @IBAction func gridButton(_ sender: UIButton) {
        if CameraService.grid {
            horizonGrid1.isHidden = true
            horizonGrid2.isHidden = true
            verticalGrid1.isHidden = true
            verticalGrid2.isHidden = true
            CameraService.grid = false
            sender.imageView?.tintColor = .white
        } else {
            horizonGrid1.frame = CGRect(x: 0, y: (self.cameraView.frame.height/3), width: self.cameraView.frame.width, height: 1)
            horizonGrid2.frame = CGRect(x: 0, y: 2*(self.cameraView.frame.height/3), width: self.cameraView.frame.width, height: 1)
            verticalGrid1.frame = CGRect(x: 1*(self.cameraView.frame.width/3), y: 0, width: 1, height: self.cameraView.frame.height)
            verticalGrid2.frame = CGRect(x: 2*(self.cameraView.frame.width/3), y: 0, width: 1, height: self.cameraView.frame.height)
            
            horizonGrid1.isHidden = false
            horizonGrid2.isHidden = false
            verticalGrid1.isHidden = false
            verticalGrid2.isHidden = false
            CameraService.grid = true
            sender.imageView?.tintColor = tintColor
        }
        print(CameraService.grid)
    }
    @IBOutlet weak var timerButtonOutlet: UIButton!
    @IBOutlet weak var timerButtonSecondLabel: UILabel!
    @IBAction func timerButton(_ sender: UIButton) {
        cameraService.timerSetting()
        if CameraService.timer != 0 {
            sender.tintColor = tintColor
            timerButtonSecondLabel.isHidden = false
        } else {
            sender.setTitle("timer", for: .normal)
            sender.tintColor = .white
            timerButtonSecondLabel.isHidden = true
        }
        timerLabel.text = "\(CameraService.timer)"
        timerButtonSecondLabel.text = "\(CameraService.timer)"
        print(CameraService.timer)
    }
    @IBOutlet weak var focusMarkLabel: UILabel!
    @IBOutlet weak var brightnessFocusMarkLabel: UILabel!
    @IBOutlet weak var brightnessFocusMark: UIImageView!
    @IBOutlet weak var focusMark: UIImageView!
    @IBAction func isoSlider(_ sender: UISlider) {
        sender.minimumValue = (cameraService.currentCamera?.activeFormat.minISO)!
        sender.maximumValue = (cameraService.currentCamera?.activeFormat.maxISO)!
        cameraService.exposureSetFromSlider(isoValue: sender.value)
    }
    @IBOutlet weak var isoSliderOutlet: UISlider!
    @IBAction func temperatureSlider(_ sender: UISlider) {
        sender.maximumValue = 8000
        sender.minimumValue = 3000
//        sender.value = 1 🔴
        cameraService.temperatureSetFromSlider(temperatureValue: sender.value)
    }
    @IBOutlet weak var temperatureSliderOutlet: UISlider!
    @IBAction func temperatureAutoButton(_ sender: UIButton) {
        if CameraService.isAutoTemperature {
            CameraService.isAutoTemperature = false
            sender.setTitle("Manual", for: .normal)
            sender.setTitleColor(.white, for: .normal)
            temperatureSliderOutlet.isEnabled = true
        } else {
//            if let device = cameraService.currentCamera {
//                do{
//                    try device.lockForConfiguration()
//                    device.isWhiteBalanceModeSupported(.autoWhiteBalance)
//                    device.isLockingWhiteBalanceWithCustomDeviceGainsSupported = false
//                } catch {
//                    print(error)
//                }
//                device.unlockForConfiguration()
//            }
            CameraService.isAutoTemperature = true
            sender.setTitle("Auto", for: .normal)
            sender.setTitleColor(tintColor, for: .normal)
            temperatureSliderOutlet.isEnabled = false
        }
    }
    // 🚗🚕🚙 🚗🚕🚙 🚗🚕🚙 lens position
    @IBOutlet weak var lensPositionSliderOutlet: UISlider!
    @IBAction func lensPositionSlider(_ sender: UISlider) {
        cameraService.setLensPosition(value: sender.value)
        sender.maximumValue = 1
        sender.minimumValue = 0
    }
    @IBAction func lensPositionAutoButton(_ sender: UIButton) {
        if CameraService.isAutoLensPosition {
            CameraService.isAutoLensPosition = false
            sender.setTitle("Manual", for: .normal)
            sender.setTitleColor(.white, for: .normal)
            lensPositionSliderOutlet.isEnabled = true
        } else {
            //            if let device = cameraService.currentCamera {
            //                do{
            //                    try device.lockForConfiguration()
            //                    device.isWhiteBalanceModeSupported(.autoWhiteBalance)
            //                    device.isLockingWhiteBalanceWithCustomDeviceGainsSupported = false
            //                } catch {
            //                    print(error)
            //                }
            //                device.unlockForConfiguration()
            //            }
            CameraService.isAutoLensPosition = true
            sender.setTitle("Auto", for: .normal)
            sender.setTitleColor(tintColor, for: .normal)
            lensPositionSliderOutlet.isEnabled = false
        }
    }
    
    @IBAction func albumButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "moveToPhotoAlbumViewSegue", sender: nil)
    }
    @IBOutlet weak var albumButtonOutlet: UIButton!
    @IBAction func takePhotoButton(_ sender: UIButton) {
        takePhotoButtonAction()
    }
    @IBAction func frontOrBackCameraButton(_ sender: UIButton) {
        cameraService.frontOrBackCamera()
    }
    @IBOutlet weak var verticalGrid1: UIView!
    @IBOutlet weak var verticalGrid2: UIView!
    @IBOutlet weak var horizonGrid1: UIView!
    @IBOutlet weak var horizonGrid2: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var zoonLabel: UILabel!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission()
        checkPhotoLibraryPermission()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CameraViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "moveToPhotoViewSegue" {
//            let photoAlbumViewController = segue.destination as! PhotoAlbumViewController
//            print("😎\(self.imagePickerSelectedImage!)😎")
//            if let image = self.imagePickerSelectedImage {
//                print("☺️\(image)")
//                photoAlbumViewController.selectedImage = image
//            }
//        }
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        self.imagePickerSelectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
//        picker.dismiss(animated: true) {
//            self.performSegue(withIdentifier: "moveToPhotoViewSegue", sender: nil)
//        }
//    }
}
