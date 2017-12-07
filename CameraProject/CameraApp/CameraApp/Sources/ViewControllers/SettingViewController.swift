//
//  SettingViewController.swift
//  CameraApp
//
//  Created by Eunyeong Kim on 2017. 11. 15..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import MessageUI
import StoreKit
import UIKit

final class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - Properties
    
    // MARK: - Initializing
    
    // MARK: - Actions
    
    func saveToUserDefaultViewRunTimes() {
        let runs = countViewRunTimes() + 1
        UserDefaults.standard.setValue(runs, forKey: "runTimes")
        UserDefaults.standard.synchronize()
        if runs == 2 {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        }
    }
    func countViewRunTimes() -> Int {
        let savedRunTimes = UserDefaults.standard.value(forKey: "runTimes")
        var runTimes = 0
        if savedRunTimes != nil {
            runTimes = savedRunTimes as! Int
        }
        return runTimes
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UI
    
    @IBAction func leftBarButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var settingTableView: UITableView!
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingTableView.register(UINib.init(nibName: "NoticeTableViewCell", bundle: nil), forCellReuseIdentifier: "noticeCell")
        self.saveToUserDefaultViewRunTimes()
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
            switch indexPath.row {
            case 0:
                let url = NSURL(string: "http://www.naver.com") //🔴
//                let url = NSURL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=고유아이디")
                UIApplication.shared.open(url! as URL, options: [:], completionHandler: { (true) in
                })
            case 1:
                // 메일보내기 넣기.
                let composeVC = MFMailComposeViewController()
                let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
                let messageBody = """
                ..
                Device model: \(UIDevice.current.model)
                System version: \(UIDevice.current.systemVersion)
                Application version: \(appVersion ?? "0.0")
                """
                composeVC.mailComposeDelegate = self
                composeVC.setToRecipients(["k01090652272@gmail.com"])
                composeVC.setSubject("[Camera app] Feedback")
                composeVC.setMessageBody(messageBody, isHTML: false)
                self.present(composeVC, animated: true, completion: nil)
                print("mail")
            case 2:
                performSegue(withIdentifier: "moveToDetailViewSegue", sender: nil)
            default: break
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
            return 2
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
            switch indexPath.row {
            case 0:
                createSegueCell.textLabel?.text = "App Store에서 리뷰하기"
            case 1:
                createSegueCell.textLabel?.text = "개발자에게 메일보내기"
            default: break
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

