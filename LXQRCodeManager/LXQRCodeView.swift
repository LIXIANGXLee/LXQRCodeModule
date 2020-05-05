//
//  QRCodeView.swift
//  QRCODE
//
//  Created by Mac on 2019/11/27.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import LXFitManager

public enum LXQRCodeViewType {
    case cancel /// 取消
    case numsOfTap /// 双击
    case album /// 点击相册
    case flashlight///手电筒
}

public protocol LXQRCodeViewDelegate: AnyObject {
    
    /// 用来做放大缩小的手势
    func qrCodeView(_ view: LXQRCodeView, gesture: UIPinchGestureRecognizer)

    /// 点击事件回调
    func qrCodeView(_ view: LXQRCodeView, type: LXQRCodeViewType)
}

public class LXQRCodeView: UIView {

    ///导航属性设置
    public lazy var bgNavView: UIView = {
       let  bgNavView = UIView(frame: CGRect(x: 0, y: 0, width: LXQRCodeConst.screenW, height: LXQRCodeConst.navbarH))
        bgNavView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bgNavView
    }()
    
    ///取消
    public lazy var cancelBtn: UIButton = {
       let cancelBtn = UIButton(type: UIButton.ButtonType.custom)
       cancelBtn.frame = CGRect(x:LXFit.fitFloat(8), y: LXQRCodeConst.statusbarH, width: LXFit.fitFloat(52), height: 44)
       cancelBtn.setTitle("取消", for: UIControl.State.normal)
       cancelBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
       cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15).fitFont
       cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: UIControl.Event.touchUpInside)
        return cancelBtn
    }()
    
     ///标题
    public lazy var titleL: UILabel = {
        let titleL = UILabel(frame: CGRect(x: cancelBtn.frame.maxX, y: LXQRCodeConst.statusbarH, width: LXQRCodeConst.screenW - cancelBtn.frame.maxX * 2, height: 44))
        titleL.text = "二维码"
        titleL.textColor = UIColor.white
        titleL.textAlignment = .center
        titleL.font = UIFont(name: "PingFangSC-Medium", size: 18)?.fitFont
        return titleL
    }()
    
    ///相册按钮
    public lazy var albumBtn: UIButton = {
        let albumBtn = UIButton(type: UIButton.ButtonType.custom)
        albumBtn.frame = CGRect(x:titleL.frame.maxX, y: LXQRCodeConst.statusbarH, width: LXFit.fitFloat(52), height: 44)
        albumBtn.setTitle("相册", for: UIControl.State.normal)
        albumBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        albumBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15).fitFont
        albumBtn.addTarget(self, action: #selector(albumBtnClick), for: UIControl.Event.touchUpInside)
         return albumBtn
    }()
    
    /// 手势
    private lazy var pinch = UIPinchGestureRecognizer(target: self, action: #selector(gesturePinch(_:)))
    private lazy  var numTap: UITapGestureRecognizer = {
       let numTap = UITapGestureRecognizer(target: self, action: #selector(gestureTap(_:)))
        numTap.numberOfTapsRequired = 2
        return numTap
    }()
    
    ///扫描框
    public lazy  var rectView: UIImageView = {
        let rectView = UIImageView(image: UIImage(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "LXQRCode", ofType: "bundle")! + "/lxRectQR.png"))
        rectView.frame.size = CGSize(width: LXFit.fitFloat(258), height: LXFit.fitFloat(258))
        rectView.isUserInteractionEnabled = true
        rectView.center = self.center
        rectView.contentMode = .scaleAspectFill
        addSubview(rectView)
        qrRect = rectView.frame
        return rectView
    }()
    
    /// 扫描的线
    public lazy  var lineView: UIImageView = {
        let lineView = UIImageView(image: UIImage(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "LXQRCode", ofType: "bundle")! + "/lxLineQR.png"))
        lineView.frame = CGRect(x: LXFit.fitFloat(16), y: 0, width: LXFit.fitFloat(226), height: LXFit.fitFloat(2))
        lineView.isUserInteractionEnabled = true

        return lineView
        
    }()
    
    /// 手电筒
    public lazy var flashlightBtn: UIButton = {
        let flashlightBtn = LXQRButton(type: .custom)
        flashlightBtn.frame = CGRect(x: (rectView.frame.width - LXFit.fitFloat(60)) * 0.5, y: rectView.frame.height - LXFit.fitFloat(70), width: LXFit.fitFloat(60), height: LXFit.fitFloat(50))
        flashlightBtn.addTarget(self, action: #selector(flashlightBtnClick(_:)), for:.touchUpInside)
        flashlightBtn.setImage(UIImage(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "LXQRCode", ofType: "bundle")! + "/lxtorchQR.png"), for: UIControl.State.normal)
        flashlightBtn.setImage(UIImage(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "LXQRCode", ofType: "bundle")! + "/lxtorchQRSelected.png"), for: UIControl.State.selected)

        flashlightBtn.setTitle("轻触照亮", for: .normal)
        return flashlightBtn
        
    }()
    
    /// 代理
    public weak var delegate: LXQRCodeViewDelegate?
    
    /// 二维码扫描区域 设置
    fileprivate(set) var qrRect: CGRect = CGRect.zero
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
    
    ///相册点击
    @objc private func albumBtnClick() {
        delegate?.qrCodeView(self, type: .album)
    }
    
    ///手电筒点击
    @objc private func flashlightBtnClick(_ button: UIButton) {
        button.isHidden = false
        button.isSelected = !button.isSelected
            
        delegate?.qrCodeView(self, type: .flashlight)
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
        addGestureRecognizer(pinch)
        addGestureRecognizer(numTap)
    }
    
    /// 添加导航的view
    private func setNavUI() {
        addSubview(bgNavView)
        bgNavView.addSubview(cancelBtn)
        bgNavView.addSubview(titleL)
        bgNavView.addSubview(albumBtn)
    }
    
    /// 添加内容
    private func setContentUI() {
        addSubview(rectView)
        rectView.addSubview(lineView)
        rectView.addSubview(flashlightBtn)
    }
}


class LXQRButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = UIFont.systemFont(ofSize: 9)
        setTitleColor(UIColor.white, for: UIControl.State.normal)
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.textAlignment = .center
        adjustsImageWhenHighlighted = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: contentRect.height * 0.7, width: contentRect.width, height: contentRect.height * 0.3)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: contentRect.height * 0.05, width: contentRect.width, height: contentRect.height * 0.60)
    }
}
