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
public struct LXQrCodeConst {

   ///根据高度来判断是否是带刘海的手机,也可以通过safaAreaInserts来判断
    public static let isIPhoneX    = (LXQrCodeConst.screenH == CGFloat(812) || LXQrCodeConst.screenH == CGFloat(896)) ? true : false
    ///app屏幕宽度
    public static let screenW = CGFloat(UIScreen.main.bounds.width)
    ///app屏幕高度
    public static let screenH = CGFloat(UIScreen.main.bounds.height)
    ///app导航高度
    public static let navbarH = isIPhoneX ? CGFloat(88.0) : CGFloat(64.0)
    ///状态栏高度
    public static let statusbarH = isIPhoneX ? CGFloat(44.0) : CGFloat(20.0)
}
