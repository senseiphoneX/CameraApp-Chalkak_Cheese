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
    var cameraPosition: Bool?
    
    // MARK: - funtions
    func filteringImage(image:UIImage) {
        
        let ciImage = CIImage(image: image)
        
        filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue((10.0), forKey: kCIInputRadiusKey)
        
        let outputImage = filter?.outputImage
        
        
        //아래에있는 3가지는 나중에 struct로 빼버리기
        let rect = CGRect(x: self.imageView.frame.origin.x, y: self.imageView.frame.origin.y, width: image.size.height, height: image.size.width)
        print(self.imageView.frame.size)
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(outputImage!, from: rect)
        ////////////////////////////////////
        
        if cameraPosition! {
            imageView.image = UIImage(cgImage: cgImage!, scale: 1.0, orientation: .right)
        } else {
            imageView.image = UIImage(cgImage: cgImage!, scale: 1.0, orientation: .leftMirrored).imageFlippedForRightToLeftLayoutDirection()
        }
        
        print("가우시안!!!!!ㅌ")
    }


    // MARK: - Outlet
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func SaveButton(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        filteringImage(image: self.image)
//        imageView.image = self.image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
