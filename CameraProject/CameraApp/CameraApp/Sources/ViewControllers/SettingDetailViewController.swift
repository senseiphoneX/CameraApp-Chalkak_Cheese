//
//  SettingDetailViewController.swift
//  CameraApp
//
//  Created by Eunyeong Kim on 2017. 11. 26..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import UIKit

class SettingDetailViewController: UIViewController {

    // MARK: - Properties
    
    static var navigationBarTitle: String?
    
    // MARK: - Initializing
    
    // MARK: - Actions
    
    // MARK: - UI
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBAction func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("😇\(SettingDetailViewController.navigationBarTitle)")
//        navigationBar.title = SettingDetailViewController.navigationBarTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
