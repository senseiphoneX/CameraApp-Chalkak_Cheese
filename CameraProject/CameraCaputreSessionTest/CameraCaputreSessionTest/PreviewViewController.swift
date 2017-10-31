//
//  PreviewViewController.swift
//  CameraCaputreSessionTest
//
//  Created by Eunyeong Kim on 2017. 10. 30..
//  Copyright © 2017년 unnnyong. All rights reserved.
//

import UIKit


class PreviewViewController: UIViewController  {

    // MARK: - 변수들
    var image: UIImage!
    var filter: CIFilter?
    
    // MARK: - funtions
    func filteringImage(image:UIImage) {
        
        let ciImage = CIImage(image: image)
        
        filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue((20.0), forKey: kCIInputRadiusKey)
        
        let outputImage = filter?.outputImage
        
        //아래에있는 3가지는 나중에 struct로 빼버리기
        let rect = CGRect(origin: self.imageView.frame.origin, size: self.image.size)
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(outputImage!, from: rect)
        ////////////////////////////////////
        
        let filteredUIImage = UIImage(cgImage: cgImage!, scale: self.image.scale, orientation: .right)
//        let filteredUIImage = UIImage(cgImage: cgImage!)
        
        imageView.image = filteredUIImage
        
        print("가우시안!!!!!ㅌ")
    }
    

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
        filteringImage(image: self.image)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



