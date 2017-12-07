//
//  CameraViewFilterCollectionViewCell.swift
//  CameraApp
//
//  Created by Eunyeong Kim on 2017. 11. 16..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import UIKit

class CameraViewFilterCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.frame = self.layer.bounds
        self.label.font = UIFont.systemFont(ofSize: 10)
        addSubview(label)
    }
    
    let label:UILabel = {
        let label = UILabel()
        label.text = "filter"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                print("isSelected")
            }
        }
    }

}
