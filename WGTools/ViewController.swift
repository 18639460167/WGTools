//
//  ViewController.swift
//  WGTools
//
//  Created by 窝瓜 on 2021/5/8.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if UIApplication.shared.windows.count > 0 {
            
        }
        
        let values = [1, 2, 3, 4]
        values.forEach { (value) in
            
        }
        
        print("height:\(String(describing: UIApplication.shared.keyWindow?.safeAreaInsets))")
        
        let originImg = UIImage.init(named: "crop_img")
        let crop1Img = originImg?.cropImageWithArea(CGRect.init(x: 200, y: 550, width: 150, height: 80))
        
        let image1 = UIImageView.init(frame: CGRect.init(x: 50, y: 50, width: 150, height: 80))
        image1.image = crop1Img
        self.view.addSubview(image1)
        let image2 = UIImageView.init(frame: CGRect.init(x: 50, y: 250, width: 150, height: 80))
        image2.image = crop1Img
        self.view.addSubview(image2)
        image2.transform = .init(scaleX: 2.0, y: 2.0)
        
        let crop2Img = originImg?.cropImageWithArea(CGRect.init(x: 90, y: 100, width: 60, height: 60))
        let crop3Img = originImg?.cropImageWithArea(CGRect.init(x: 60, y: 180, width: 90, height: 40))
    }


}

