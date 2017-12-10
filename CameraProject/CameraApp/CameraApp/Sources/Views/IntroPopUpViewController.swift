//
//  IntroPopUpViewController.swift
//  CameraApp
//
//  Created by Eunyeong Kim on 2017. 12. 10..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import UIKit

class IntroPopUpViewController: UIView {
    
    let titleText: String = "더 좋은 찰칵 소리를 내는 팁."
//    let buttonText: String = "당신의 찰칵을 들려주세요!"
    let text : String =
        """
        👆
        화면을 터치한 후, 초점을 드래그해서 원하는 위치의 밝기와 초점을 각각 설정해보세요.

        🕹
        Manual 모드에서 ISO, 렌즈포지션, 색온도를 원하는 스타일에 맞게 커스텀해보세요.

        👨‍🍳👩‍⚕️👮👩‍🌾
        모두와 함께 찰칵의 즐거움을 나누어보세요.
        

        자, 이제 당신의 찰칵을 들려주세요! 📸
        """
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    @IBAction func button(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = titleText
//        button.setTitle(buttonText, for: .normal)
        textView.text = text
    }
}
