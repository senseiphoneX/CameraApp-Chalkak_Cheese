//
//  SettingViewController.swift
//  CameraApp
//
//  Created by Eunyeong Kim on 2017. 11. 15..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import UIKit

final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Initializing
    
    // MARK: - Actions
    
    // MARK: - UI
    
    @IBAction func leftBarButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var settingTableView: UITableView!
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingTableView.register(UINib.init(nibName: "NoticeTableViewCell", bundle: nil), forCellReuseIdentifier: "noticeCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SettingViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "createSegueCell", for: indexPath)
//            SettingDetailViewController.navigationBarTitle = "\(cell.textLabel?.text)"
//            print(cell.textLabel?.text)
            if indexPath.row == 0 {
//                let url = NSURL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=고유아이디")
                let url = NSURL(string: "http://www.naver.com") //🔴
                UIApplication.shared.open(url! as URL, options: [:], completionHandler: { (true) in
                })
            }else if indexPath.row == 1 {
                performSegue(withIdentifier: "moveToDetailViewSegue", sender: nil)
            }
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension SettingViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let createSegueCell = tableView.dequeueReusableCell(withIdentifier: "createSegueCell", for: indexPath)
            createSegueCell.textLabel?.textColor = .white
            if indexPath.row == 0 {
                createSegueCell.textLabel?.text = "App Store에서 리뷰하기"
            }
            return createSegueCell
//        } else if indexPath.section == 1 {
//            let switchCell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath)
//            switchCell.textLabel?.text = "" //구현안됨.🔴
//            switchCell.selectionStyle = .none
//            switchCell.textLabel?.textColor = .white
//            return switchCell
        } else {
            let noticeCell: NoticeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "noticeCell", for: indexPath) as! NoticeTableViewCell
            noticeCell.selectionStyle = .none
            noticeCell.noticeLabel.text = """
            안녕하세요!
            먼저, 카메라 앱을 다운받아주셔서 진심으로 감사드립니다. 💛
            가을즈음에 카메라 앱을 만들 결심을 하고 공부와 코딩을 하다보니 롱패딩의 계절이 다가왔네요.
            사진을 찍는 걸 좋아해서 기본카메라와 사진 퀄리티는 비슷하지만 아쉬웠던 기능들을 추가한 어플리케이션입니다.
            
            ✨ 카메라 앱 사용 팁
            - 밝기와 초점을 각각 조절해서 멋진 사진을 촬영해보세요! 
            추후 이미지 에디터의 기능을 추가할 예정입니다.
            빠른 업데이트를 기다리신다면 리뷰 작성을 부탁드립니다.📝
            리뷰에 원하는 기능이나 아쉬운 부분을 작성해 주신다면 꼭! 반영하도록 하겠습니다!
            여러분의 리뷰는 저에게 힘이 됩니다! 😇
            곧 기능을 가득 추가한 업데이트로 다시 찾아뵙겠습니다. 👋🏻
            """
            return noticeCell
        }
    }
}

