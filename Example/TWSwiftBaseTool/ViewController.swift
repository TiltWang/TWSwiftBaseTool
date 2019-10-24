//
//  ViewController.swift
//  TWSwiftBaseTool
//
//  Created by wangxufeng092@163.com on 10/17/2019.
//  Copyright (c) 2019 wangxufeng092@163.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let bannerView = TWBannerView.init(frame: view.bounds)
        bannerView.configDirection = TWScrollDirection.down
        bannerView.colorArr = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
        bannerView.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        view.addSubview(bannerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

