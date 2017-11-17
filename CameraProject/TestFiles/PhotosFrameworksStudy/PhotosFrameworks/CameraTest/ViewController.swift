//
//  ViewController.swift
//  CameraTest
//
//  Created by Eunyeong Kim on 2017. 9. 6..
//  Copyright © 2017년 FastCampusTeam1. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var asset:PHAsset?
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBAction func importImageFromAlbum(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func effectToImage(_ sender: UIButton) {
        

        
    }
    
    func applyEffect(){
        
        
        self.asset?.requestContentEditingInput(with: nil, completionHandler: { (contentInput: PHContentEditingInput, _: [AnyHashable : Any]) in
            
            let url = contentInput.fullSizeImageURL
            let orientation = contentInput.fullSizeImageOrientation
            var inputImg = CIImage(contentsOf: url!, options: nil)
            inputImg = inputImg?.applyingOrientation(orientation)
            
            
            let filter = CIFilter(name: "filter1")
            filter?.setDefaults()
            filter?.setValue(inputImg, forKey: kCIInputImageKey)
            let outputImg = filter?.outputImage
            
            
            let context = CIContext()
            let image = context.createCGImage(outputImg!, from: (outputImg?.extent)!)
            let uiImage = UIImage(cgImage: image!)
            
            
            let contentOutput = PHContentEditingOutput(contentEditingInput: contentInput)
            
            let renderedData = UIImageJPEGRepresentation(uiImage, 0.9)
            
            
            
            
            
            
            
            
            } as! (PHContentEditingInput?, [AnyHashable : Any]) -> Void)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

