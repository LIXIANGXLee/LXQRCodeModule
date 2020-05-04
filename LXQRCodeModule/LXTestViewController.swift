//
//  LXTestViewController.swift
//  LXQRCodeModule
//
//  Created by Mac on 2020/5/4.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXQRCodeManager

class LXTestViewController: LXQRCodeViewController {

 
    override func setCallBack(qrCode: String) {
        
        print("===\(qrCode)")
         UIApplication.shared.open(URL(string: qrCode)!, options: [:], completionHandler: nil)
    }
    
    
    override func setGoBack() {
        self.dismiss(animated: true, completion: nil)
    }
    

}
