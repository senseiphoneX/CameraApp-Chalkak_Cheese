//
//  AlbumService.swift
//  CameraApp
//
//  Created by Eunyeong Kim on 2017. 11. 15..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import UIKit
import Photos

class AlbumService {
    
    // MARK: - Properties
    
    static var fetchResult: PHFetchResult<PHAsset>!
    static var imageManager = PHCachingImageManager()
    static var selectedImageNumber: Int?
    
    // MARK: - Functions
    
    //Image Picker에서 사진 가져와서 관련 함수들.
    static func loadPhotos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: .image, options: options)
    }
}
