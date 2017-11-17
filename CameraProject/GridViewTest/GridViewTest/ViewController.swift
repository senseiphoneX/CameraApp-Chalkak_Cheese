//
//  ViewController.swift
//  GridViewTest
//
//  Created by Eunyeong Kim on 2017. 11. 17..
//  Copyright © 2017년 Eunyeong Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var gridVertical1: UIView{
        let view = UIView()
        view.frame = CGRect(x: 1*(self.view.safeAreaLayoutGuide.layoutFrame.width/3), y: 0, width: 1, height: self.view.frame.height)
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return view
    }
    var gridVertical2: UIView{
        let view = UIView()
        view.frame = CGRect(x: 2*(self.view.safeAreaLayoutGuide.layoutFrame.width/3), y: 0, width: 1, height: self.view.frame.height)
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return view
    }
    var gridHorizon1: UIView{
        let view = UIView()
        view.frame = CGRect(x: 0, y: (self.view.safeAreaLayoutGuide.layoutFrame.height/3), width: self.view.frame.width, height: 1)
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return view
    }
    var gridHorizon2: UIView{
        let view = UIView()
        view.frame = CGRect(x: 0, y: 2*(self.view.safeAreaLayoutGuide.layoutFrame.height/3), width: self.view.frame.width, height: 1)
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return view
    }
    
    var grid:Bool=false //false = off, true = on
    
    @IBAction func gridButton(_ sender: UIButton) {
        self.view.addSubview(gridVertical1)
        self.view.addSubview(gridVertical2)
        self.view.addSubview(gridHorizon1)
        self.view.addSubview(gridHorizon2)
//        if grid {
//            grid = true
//        } else {
//            grid = false
//        }
//        print(grid)
    }
    
}

