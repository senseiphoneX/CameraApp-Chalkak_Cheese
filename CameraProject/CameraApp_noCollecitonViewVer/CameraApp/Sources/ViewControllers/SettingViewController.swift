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
    }
    @IBOutlet weak var settingTableView: UITableView!
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    


}

extension SettingViewController : UITableViewDelegate {
    
}

//extension SettingViewController : UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return 1
//    }
//
//
//}
