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
    
    // MARK: - Initializing
    
    // MARK: - Actions
    
    // MARK: - UI
    
    @IBAction func flashButton(_ sender: UIButton) {
    }
    @IBAction func gridButton(_ sender: UIButton) {
    }
    @IBAction func nightModeButton(_ sender: UIButton) {
    }
    @IBAction func timerButton(_ sender: UIButton) {
    }
    @IBOutlet weak var focusMark: UIView!
    @IBAction func isoSlider(_ sender: UISlider) {
    }
    @IBOutlet weak var isoSliderOutlet: UISlider!
    @IBAction func albumButton(_ sender: UIButton) {
    }
    @IBAction func takePhotoButton(_ sender: UIButton) {
    }
    @IBAction func frontOrBackCameraButton(_ sender: UIButton) {
    }
    @IBOutlet weak var selectFilterCollectionView: UICollectionView!
    
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
