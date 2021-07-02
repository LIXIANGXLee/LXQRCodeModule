//
//  LXApp.swift
//  LXFoundationManager
//
//  Created by Mac on 2020/4/22.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - LXAPP 常用的全局变量

/// 定义一下app经常用到的全局常量
public struct LXQRCodeConst {

    ///app屏幕宽度
    public static let screenW = CGFloat(UIScreen.main.bounds.width)
    ///app屏幕高度
    public static let screenH = CGFloat(UIScreen.main.bounds.height)
    ///app导航高度
    public static let navbarH = statusBarHeight + 44
    ///状态栏高度
    public static let statusbarH = statusBarHeight
    
    /// 获取状态栏高度
    private static var statusBarHeight: CGFloat {
        var statusH: CGFloat = UIApplication.shared.statusBarFrame.height
        if statusH == 0, #available(iOS 13.0, *) {
            statusH = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        
        if  statusH == 0, #available(iOS 11.0, *)  {
            statusH = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        }
        
        return statusH
    }

}
