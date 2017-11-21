//
//  FilterService.swift
//  CameraApp
//
//  Created by Eunyeong Kim on 2017. 11. 16..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import AVFoundation
import UIKit

class FilterService {
    
    //filter 적용 함수.
    static func filteringImage(image:UIImage, cameraPosition:Bool) {
        
        let ciImage = CIImage(image: image)
        
        //filter는 real time으로 바꾸면서 어떠케할지 고민해봅시다. 지금은 필터링되서 뷰 안보여주고 바로 앨범에 저장됨. //🔴
        var filter: CIFilter?

        filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue((0.0), forKey: kCIInputRadiusKey)
        
        let outputImage = filter?.outputImage
        
        //아래에있는 3가지는 나중에 struct로 빼버리기
        let rect = CGRect(x: (CameraViewController.viewSize?.x)!, y: (CameraViewController.viewSize?.y)!, width: image.size.height, height: image.size.width)
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(outputImage!, from: rect)
        
        if cameraPosition {
            UIImageWriteToSavedPhotosAlbum(UIImage(cgImage: cgImage!, scale: 1.0, orientation: .right), nil, nil, nil)
        } else {
            UIImageWriteToSavedPhotosAlbum(UIImage(cgImage: cgImage!, scale: 1.0, orientation: .leftMirrored).imageFlippedForRightToLeftLayoutDirection(), nil, nil, nil)
        }
    }
}
