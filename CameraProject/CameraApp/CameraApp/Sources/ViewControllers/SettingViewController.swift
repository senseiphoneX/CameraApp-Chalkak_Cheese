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
            performSegue(withIdentifier: "moveToDetailViewSegue", sender: nil)
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
        return 3
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
            createSegueCell.textLabel?.text = "사용된 오픈소스"
            createSegueCell.textLabel?.textColor = .white
            return createSegueCell
        } else if indexPath.section == 1 {
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath)
            switchCell.textLabel?.text = "자동 저장" //구현안됨.🔴
            switchCell.selectionStyle = .none
            switchCell.textLabel?.textColor = .white
            return switchCell
        } else {
            let noticeCell: NoticeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "noticeCell", for: indexPath) as! NoticeTableViewCell
            noticeCell.selectionStyle = .none
            noticeCell.noticeLabel.text = """
            카메라 앱을 다운받아 주셔서 감사합니당 😀
            버그나 문의사항이 있으시면 언제든지 메일 주세용!
            hello.
            this
            is
            my
            camera
            application.
            thank
            you
            for
            your
            download.
            """
            return noticeCell
        }
    }
}

