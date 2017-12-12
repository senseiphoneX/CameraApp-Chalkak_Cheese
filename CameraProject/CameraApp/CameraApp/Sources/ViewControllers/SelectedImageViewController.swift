//
//  SelectedImageViewController.swift
//  CameraApp
//
//  Created by Eunyeong Kim on 2017. 11. 25..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import UIKit
import Photos

final class SelectedImageViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Touch
    
    @IBAction func swipeToRight(_ sender: UISwipeGestureRecognizer) {
        if let number = AlbumService.numberOfPhotos {
            if AlbumService.selectedImageNumber != number {
                AlbumService.selectedImageNumber = AlbumService.selectedImageNumber! + 1
                if let imageNumber = AlbumService.selectedImageNumber {
                    loadImageView(indexPath: imageNumber)
                }
            }
        }
    }
    @IBAction func swipeToLeft(_ sender: UISwipeGestureRecognizer) {
        if AlbumService.selectedImageNumber != 0 {
            AlbumService.selectedImageNumber = AlbumService.selectedImageNumber! - 1
            if let imageNumber = AlbumService.selectedImageNumber {
                loadImageView(indexPath: imageNumber)
            }
        }
    }
    
    
    // MARK: - Actions
    
    private func loadImageView(indexPath item: Int) {
        let photoAsset = AlbumService.fetchResult.object(at: item)
        let photoSize = CGSize(width: photoAsset.pixelWidth, height: photoAsset.pixelHeight)
        AlbumService.imageManager.requestImage(for: photoAsset, targetSize: photoSize, contentMode: .aspectFill, options: nil) { (image, info) in
            if let img = image {
                self.imageView.image = img
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - UI

    @IBAction func leftBarButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageNumber = AlbumService.selectedImageNumber {
            loadImageView(indexPath: imageNumber)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
