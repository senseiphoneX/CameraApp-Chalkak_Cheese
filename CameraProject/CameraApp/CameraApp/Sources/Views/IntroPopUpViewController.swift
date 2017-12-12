//
//  IntroPopUpViewController.swift
//  CameraApp
//
//  Created by Eunyeong Kim on 2017. 12. 10..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import UIKit

class IntroPopUpViewController: UIView {
    
    // MARK: - Properties
    
    private var viewPage: Int?
    private var device: UIDevice?
    private let titleText: String = "더 좋은 찰칵 소리를 내는 팁."
    private let text : String =
        """
        👆
        화면을 터치한 후, 초점을 드래그해서 원하는 위치의 밝기와 초점을 각각 설정해보세요.

        🕹
        Manual 모드에서 ISO, 렌즈포지션, 색온도를 원하는 스타일에 맞게 커스텀해보세요.

        👨‍🍳👩‍⚕️👮👩‍🌾
        모두와 함께 찰칵의 즐거움을 나누어보세요.
        """

    // MARK: - UI
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    @IBAction func button(_ sender: UIButton) {
        if let page = self.viewPage {
            switch page {
            case 0:
                imageView.isHidden = false
                titleLabel.isHidden = true
                textView.isHidden = true
                if DeviceType.iPhone678 {
                    imageView.image = #imageLiteral(resourceName: "intro_iPhone8")
                }else if DeviceType.iPhone678p {
                    imageView.image = #imageLiteral(resourceName: "intro_iPhone8Plus")
                } else if DeviceType.iPhoneX {
                    imageView.image = #imageLiteral(resourceName: "intro_iPhoneX")
                } else {
                    imageView.image = #imageLiteral(resourceName: "intro_iPhoneSE")
                }
                self.viewPage! += 1
            case 1:
                if DeviceType.iPhone678 {
                    imageView.image = #imageLiteral(resourceName: "intro2_iPhone8")
                }else if DeviceType.iPhone678p {
                    imageView.image = #imageLiteral(resourceName: "intro2_iPhone8Plus")
                } else if DeviceType.iPhoneX {
                    imageView.image = #imageLiteral(resourceName: "intro2_iPhoneX")
                } else {
                    imageView.image = #imageLiteral(resourceName: "intro2_iPhoneSE")
                }
                self.viewPage! += 1
            case 2:
                if DeviceType.iPhone678 {
                    imageView.image = #imageLiteral(resourceName: "intro3_iPhone8")
                }else if DeviceType.iPhone678p {
                    imageView.image = #imageLiteral(resourceName: "intro3_iPhone8Plus")
                } else if DeviceType.iPhoneX {
                    imageView.image = #imageLiteral(resourceName: "intro3_iPhoneX")
                } else {
                    imageView.image = #imageLiteral(resourceName: "intro3_iPhoneSE")
                }
                self.viewPage! += 1
            case 3:
                imageView.isHidden = true
                titleLabel.text = "자, 이제 당신의 찰칵을 들려주세요! 📸"
                titleLabel.isHidden = false
                self.viewPage! += 1
            case 4:
                self.removeFromSuperview()
            default:
                break
            }
        }
    }
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = titleText
        textView.text = text
        self.viewPage = 0
    }
}

struct ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
    static let frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
}

struct DeviceType {
    static let iPhone5orSE = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 568.0
    static let iPhone678 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 667.0
    static let iPhone678p = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 736.0
    static let iPhoneX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 812.0
}
