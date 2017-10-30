//
//  PreviewViewController.swift
//  CameraCaputreSessionTest
//
//  Created by Eunyeong Kim on 2017. 10. 30..
//  Copyright © 2017년 unnnyong. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    // MARK: - 변수들
    var image: UIImage!


    // MARK: - Outlet
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func SaveButton(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = self.image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
