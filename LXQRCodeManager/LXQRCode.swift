//
//  LXQRCode.swift
//  LXFitManager
//
//  Created by Mac on 2020/5/5.
//

import UIKit

class LXQRCode {

    /// 二维码识别
    /// - image 图片
    /// - 返回识别到的字符串
    public static func qrCodeString(with image: UIImage) -> String? {
      
        guard let cgImage = image.cgImage  else { return nil }
        let ciContent = CIContext()
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: ciContent, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        let ciImage = CIImage(cgImage: cgImage)
        guard let feature: CIQRCodeFeature = detector?.features(in: ciImage).first as? CIQRCodeFeature else { return nil }
        return feature.messageString
    }
}
