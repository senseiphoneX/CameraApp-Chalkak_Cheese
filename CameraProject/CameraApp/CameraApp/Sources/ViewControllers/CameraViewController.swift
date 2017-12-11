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
    
    private var cameraService = CameraService()
    var currentIndexPath: IndexPath?
    var imagePickerSelectedImage: UIImage?
    private let tintColor = UIColor(red: 245.0 / 255.0, green: 166.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0)
    static var viewSize: CGPoint?
    private var lensPositionObserving: NSKeyValueObservation?
    private var temperatureObserving: NSKeyValueObservation?
    private var isoObserving: NSKeyValueObservation?
    
    // MARK: - Initializing
    
    // MARK: - Actions
    
    private func checkFirstLaunch() {
        let isFirstLaunched = UserDefaults.standard.string(forKey: "isFirstLaunched")
        if isFirstLaunched == nil {
            UserDefaults.standard.set("true", forKey: "isFirstLaunched")
            let popUpView: IntroPopUpViewController = UINib(nibName: "IntroPopUpViewController", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! IntroPopUpViewController
            popUpView.frame = self.view.frame
            self.view.addSubview(popUpView)
        }
    }
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied: break
        case .restricted: break
        case .authorized:
            self.readyToUseCamera()
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
        CameraViewController.viewSize = self.cameraView.frame.origin //🔴 main thread르 바꿔주기!
        self.cameraService.setUpCaptureSession()
        self.cameraService.setUpDevice()
        self.cameraService.setUpInputOutput()
        self.cameraService.setUpPreviewLayer(view: self.cameraView)
        self.cameraService.startRunningCaputureSession()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.takePhotoButtonAction), name: Notification.Name(rawValue: "volumeChanged"), object: nil)
        let volView = MPVolumeView(frame: CGRect(x: 0, y: -100, width: 0, height: 0))
        self.view.addSubview(volView)
        isoSliderOutlet.minimumValue = cameraService.currentCamera?.activeFormat.minISO ?? 1.0
        isoSliderOutlet.maximumValue = cameraService.currentCamera?.activeFormat.maxISO ?? 0.0
    }
    func albumButtonPreviewAtCameraView() {
        let photoAsset = AlbumService.fetchResult.object(at: 0)
        let photoSize = CGSize(width: 42.7, height: 42.7)
        AlbumService.imageManager.requestImage(for: photoAsset, targetSize: photoSize, contentMode: .aspectFill, options: nil) { (image, info) -> Void in
            if let img = image {
                let imageView = UIImageView(image: img)
                imageView.frame.size = photoSize
                imageView.contentMode = UIViewContentMode.scaleAspectFill
                imageView.clipsToBounds = true
                self.albumButtonOutlet.addSubview(imageView)
            }
        }
    }
    private func addObservers() {
        lensPositionObserving = self.cameraService.currentCamera?.observe((\.lensPosition), changeHandler: { (observe, change) in
            if CameraService.isAutoLensPosition {
                let newValue = observe.lensPosition
                DispatchQueue.main.async {
                    self.lensPositionSliderOutlet.value = newValue
                }
            }
        })
        temperatureObserving = self.cameraService.currentCamera?.observe((\.deviceWhiteBalanceGains), changeHandler: { (observe, change) in
            if CameraService.isAutoTemperature {
                let newValue = observe.deviceWhiteBalanceGains
                let newTemp = self.cameraService.currentCamera?.temperatureAndTintValues(for: newValue).temperature
                if let tem = newTemp {
                    DispatchQueue.main.async {
                        self.temperatureSliderOutlet.value = tem
                    }
                }
            }
        })
        isoObserving = self.cameraService.currentCamera?.observe((\.iso), changeHandler: { (observe, change) in
            if CameraService.isAutoISO {
                let newValue = observe.iso
                DispatchQueue.main.async {
                    self.isoSliderOutlet.value = newValue
                }
            }
        })
    }
    private func removeObservers() {
        lensPositionObserving = nil
        temperatureObserving = nil
        isoObserving = nil
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
        if let touch = touchPoint {
            print(touch.location(in: self.cameraView))
            if touch.location(in: self.cameraView).x <= self.cameraView.frame.width &&
                touch.location(in: self.cameraView).x > 0 &&
                touch.location(in: self.cameraView).y <= self.cameraView.frame.height &&
                touch.location(in: self.cameraView).y > 0 {
                cameraService.cameraFocusing(focusPoint: foucusPoint)
                //focus marker 뜨게
                self.brightnessFocusMark.frame = CGRect(x: touch.location(in: self.view).x - 25, y: touch.location(in: self.view).y - 78.5, width: 81, height: 81) //touchPoint
                self.focusMark.frame = CGRect(x: touch.location(in: self.view).x - 25, y: touch.location(in: self.view).y - 78.5, width: 81, height: 81) //touchPoint
                self.brightnessFocusMark.isHidden = false
                self.focusMark.isHidden = false
                self.setFocusLabelFrame()
            }
        }
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
        zoonLabel.text = "\(cameraService.cameraZoom(pinch: sender))x"
    }
    
    // MARK: - UI
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var manualModeControlView: UIView!
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
    }
    @IBOutlet weak var timerButtonOutlet: UIButton!
    @IBOutlet weak var timerButtonSecondLabel: UILabel!
    @IBAction func timerButton(_ sender: UIButton) {
        cameraService.timerSetting()
        if CameraService.timer != 0 {
            sender.tintColor = tintColor
            timerButtonSecondLabel.isHidden = false
        } else {
            sender.tintColor = .white
            timerButtonSecondLabel.isHidden = true
        }
        timerLabel.text = "\(CameraService.timer)"
        timerButtonSecondLabel.text = "\(CameraService.timer)"
        print(CameraService.timer)
    }
    @IBAction func manualModeViewButton(_ sender: UIButton) {
        if manualModeControlView.isHidden {
            manualModeControlView.isHidden = false
        } else {
            manualModeControlView.isHidden = true
        }
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
    @IBAction func isoAutoButton(_ sender: UIButton) {
        
        
        if CameraService.isAutoISO {
            CameraService.isAutoISO = false
            sender.setTitle("Manual", for: .normal)
            sender.setTitleColor(.white, for: .normal)
            isoSliderOutlet.isEnabled = true
        } else {
            if let device = cameraService.currentCamera {
                do{
                    try device.lockForConfiguration()
                    device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
                } catch {
                    print(error)
                }
                device.unlockForConfiguration()
            }
            CameraService.isAutoISO = true
            sender.setTitle("Auto", for: .normal)
            sender.setTitleColor(tintColor, for: .normal)
            isoSliderOutlet.isEnabled = false
        }
        
        
        
    }
    @IBAction func temperatureSlider(_ sender: UISlider) {
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
            if let device = cameraService.currentCamera {
                do{
                    try device.lockForConfiguration()
                    device.isWhiteBalanceModeSupported(.autoWhiteBalance)
                    device.whiteBalanceMode = AVCaptureDevice.WhiteBalanceMode.continuousAutoWhiteBalance
                } catch {
                    print(error)
                }
                device.unlockForConfiguration()
            }
            CameraService.isAutoTemperature = true
            sender.setTitle("Auto", for: .normal)
            sender.setTitleColor(tintColor, for: .normal)
            temperatureSliderOutlet.isEnabled = false
        }
    }
    @IBOutlet weak var lensPositionSliderOutlet: UISlider!
    @IBAction func lensPositionSlider(_ sender: UISlider) {
        cameraService.setLensPosition(value: sender.value)
        sender.maximumValue = 1.0
        sender.minimumValue = 0.0
    }
    @IBAction func lensPositionAutoButton(_ sender: UIButton) {
        if CameraService.isAutoLensPosition {
            CameraService.isAutoLensPosition = false
            sender.setTitle("Manual", for: .normal)
            sender.setTitleColor(.white, for: .normal)
            lensPositionSliderOutlet.isEnabled = true
        } else {
            if let device = cameraService.currentCamera {
                do{
                    try device.lockForConfiguration()
                    device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                } catch {
                    print(error)
                }
                device.unlockForConfiguration()
            }
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
        checkFirstLaunch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.addObservers()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.removeObservers()
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
