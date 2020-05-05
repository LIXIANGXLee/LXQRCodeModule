# LXQRCodeManager

#### 项目介绍
 **

### 最完美、最轻量级的 二维码扫一扫
** 

#### 安装说明
方式1 ： cocoapods安装库 
        ** pod 'LXQRCodeManager' **
        ** pod install ** 

方式2:   **直接下载压缩包 解压**    **LXQRCodeManager **   

#### 使用说明
 **下载后压缩包 解压   请先 pod install  在运行项目** 
  
  ### 推荐使用继承用法，  也可以直接调用LXQRCodeViewController
```

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<true/>
</plist>

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
    <string>en</string>
    <string>zh_CN</string>
</array>
</plist>

class LXTestViewController: LXQRCodeViewController {
    override func setCallBack(qrCode: String) {
         UIApplication.shared.open(URL(string: qrCode)!, options: [:], completionHandler: nil)
    }
    override func setGoBack() {
        self.dismiss(animated: true, completion: nil)
    }
}

```

