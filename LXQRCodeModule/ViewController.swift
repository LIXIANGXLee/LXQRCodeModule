//
//  ViewController.swift
//  LXQRCodeModule
//
//  Created by Mac on 2020/5/4.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXQRCodeManager

class ViewController: UIViewController {
    
    
    let qrCode = LXTestViewController(true)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        qrCode.modalPresentationStyle = .fullScreen
       
//        self.navigationController?.pushViewController(qrCode, animated: true)
        
        UIApplication.shared.delegate?.window??.rootViewController?.present(qrCode, animated: true, completion: nil)
    }

}

