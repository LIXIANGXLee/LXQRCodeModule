//
//  QRCodeView.swift
//  QRCODE
//
//  Created by Mac on 2019/11/27.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import LXFitManager

enum LXQRCodeViewType {
    case cancel /// 取消
    case numsOfTap /// 双击
}

protocol LXQRCodeViewDelegate: AnyObject {
    
    /// 用来做放大缩小的手势
    func qrCodeView(_ view: LXQRCodeView, gesture: UIPinchGestureRecognizer)

    /// 点击事件回调
    func qrCodeView(_ view: LXQRCodeView, type: LXQRCodeViewType)
}

class LXQRCodeView: UIView {

    /// 代理
    public weak var delegate: LXQRCodeViewDelegate?
    
    /// 二维码扫描区域 设置
    fileprivate(set) var qrRect: CGRect = CGRect.zero
    
    fileprivate var rectView: UIImageView!
    fileprivate var lineView: UIImageView!
    fileprivate var timer: Timer?
    override init(frame: CGRect) {
        super.init(frame: frame)
         backgroundColor = UIColor.white.withAlphaComponent(0)
         setGesture()
         setNavUI()
         setContentUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}

// MARK: - public 外部调用
extension LXQRCodeView {
    
    /// 设置定时器
   public func setTimer() {
       if #available(iOS 10.0, *) {
           timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
               self.goAuto()
           })
       } else {
           timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(goAuto), userInfo: nil, repeats: true)
       }
   }
   
   ///停止定时器
   public func stopTimer() {
       timer?.invalidate()
       timer = nil
   }
}

// MARK: - private 内部调用
extension LXQRCodeView {
    
    /// 手势捏合
    @objc private func gesturePinch(_ gesture: UIPinchGestureRecognizer) {
        delegate?.qrCodeView(self, gesture: gesture)
    }
    
    /// 手势点击
    @objc private func gestureTap(_ gesture: UITapGestureRecognizer) {
        delegate?.qrCodeView(self, type: .numsOfTap)
    }
    
    /// 点击返回
    @objc private func cancelBtnClick() {
        delegate?.qrCodeView(self, type: .cancel)
    }
    
    /// 定时器 回调
    @objc private func goAuto() {
        self.lineView.frame.origin.y += 1
        if self.lineView.frame.origin.y >= self.rectView.frame.height {
            self.lineView.frame.origin.y = 0
        }
    }
}

// MARK: - private 添加UI
extension LXQRCodeView {
    
    /// 添加手势
    private func setGesture() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(gesturePinch(_:)))
        addGestureRecognizer(pinch)
        let numTap = UITapGestureRecognizer(target: self, action: #selector(gestureTap(_:)))
        numTap.numberOfTapsRequired = 2
        addGestureRecognizer(numTap)
    }
    
    /// 添加导航的view
    private func setNavUI() {
        let bgNavView = UIView(frame: CGRect(x: 0, y: 0, width: LXQrCodeConst.screenW, height: LXQrCodeConst.navbarH))
        bgNavView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(bgNavView)

        let cancelBtn = UIButton(type: UIButton.ButtonType.custom)
        cancelBtn.frame = CGRect(x:LXFit.fitFloat(8), y: LXQrCodeConst.statusbarH, width: LXFit.fitFloat(52), height: 44)
        cancelBtn.setTitle("取消", for: UIControl.State.normal)
        cancelBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15).fitFont
        bgNavView.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: UIControl.Event.touchUpInside)

        let titleL = UILabel(frame: CGRect(x: cancelBtn.frame.maxX, y: LXQrCodeConst.statusbarH, width: LXQrCodeConst.screenW - cancelBtn.frame.maxX * 2, height: 44))
        titleL.text = "二维码"
        titleL.textColor = UIColor.white
        titleL.textAlignment = .center
        titleL.font = UIFont(name: "PingFangSC-Medium", size: 18)?.fitFont
        bgNavView.addSubview(titleL)
        
    }
    
    /// 添加内容
    private func setContentUI() {
               
        rectView = UIImageView(image: UIImage(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "LXQRCode", ofType: "bundle")! + "/lxRectQR.png"))
        rectView.frame.size = CGSize(width: LXFit.fitFloat(258), height: LXFit.fitFloat(258))
        rectView.center = self.center
        rectView.contentMode = .scaleAspectFill
        addSubview(rectView)
        qrRect = rectView.frame
               
        lineView = UIImageView(image: UIImage(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "LXQRCode", ofType: "bundle")! + "/lxLineQR.png"))
        lineView.contentMode = .scaleAspectFill
        lineView.frame = CGRect(x: LXFit.fitFloat(16), y: 0, width: LXFit.fitFloat(226), height: LXFit.fitFloat(2))
        rectView.addSubview(lineView)
        
    }
}
