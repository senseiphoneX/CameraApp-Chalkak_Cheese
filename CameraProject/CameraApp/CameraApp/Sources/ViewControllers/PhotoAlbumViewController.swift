//
//  PhotoAlbumViewController.swift
//  CameraApp
//
//  Created by Eunyeong Kim on 2017. 11. 15..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import UIKit
import Photos

final class PhotoAlbumViewController: UIViewController {

    // MARK: - Properties
    
    fileprivate let cellReuseIdentifier: String = "photoCell"

    // MARK: - Initializing
    
    // MARK: - Actions
    
    // MARK: - UI
    
    @IBAction func leftBarButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AlbumService.loadPhotos()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension PhotoAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AlbumService.fetchResult.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath)
        let photoAsset = AlbumService.fetchResult.object(at: indexPath.item)
        AlbumService.imageManager.requestImage(for: photoAsset, targetSize: cell.frame.size, contentMode: .aspectFill, options: nil) { (image, info) -> Void in
            let imageView = UIImageView(image: image)
            imageView.frame.size = cell.frame.size
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            cell.contentView.addSubview(imageView)
        }
        cell.backgroundColor = .red
        return cell
    }
}
extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.photoCollectionView.frame.width - 20)/3, height: (self.photoCollectionView.frame.width - 20)/3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AlbumService.selectedImageNumber = indexPath.item
        self.performSegue(withIdentifier: "moveToPhotoPreviewSegue", sender: nil)
    }
}

