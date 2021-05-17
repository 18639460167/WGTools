//
//  WGBaseTool.swift
//  WGTools
//
//  Created by 窝瓜 on 2021/5/8.
//  基础工具

import Foundation
import UIKit

public let WG_ScreenWidth: CGFloat = UIScreen.main.bounds.width
public let WG_ScreenHeight: CGFloat = UIScreen.main.bounds.height
public let WG_ScreenScale: CGFloat = WG_ScreenWidth/375.0
public let WG_SafeTop: CGFloat = WGAPP.safeAreaInsets.top
public let WG_SafeBottom: CGFloat = WGAPP.safeAreaInsets.bottom

public final class WGAPP {
    // 应用名
    public static var AppName: String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
    // 版本号
    public static var AppVersion: String {Bundle.wg_appVersion}
    public static var AppBuild: String {Bundle.wg_appBuild}
    // 版本号包含构建次数
    public static var AppVersionAndBuild: String {
        let version = AppVersion, build = AppBuild
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
    // 当前语言code
    public static var language: String {Locale.current.languageCode ?? "en"}
    // 旋转方向
    public static var ScreenOrientation: UIInterfaceOrientation {UIApplication.shared.statusBarOrientation}
    
    public static var IsXIphone: Bool {
        if UIApplication.shared.windows.count > 0, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0 > 0 {
            return true
        }
        if UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0 > 0 {
            return true
        }
        return false
    }
    // 安全区域
    public static var safeAreaInsets: UIEdgeInsets {
        if UIApplication.shared.windows.count > 0 {
            return UIApplication.shared.windows.first!.safeAreaInsets
        }
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
}

extension UIColor {
    /// 将十六进制颜色转换为UIColor
    @objc convenience init(hexColor: String, alpha: CGFloat = 1.0) {
        self.init(hexString: hexColor, alpha: alpha)
    }
    
    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16)/255, green: CGFloat((hex & 0x00FF00) >> 8)/255, blue: CGFloat(hex & 0x0000FF)/255, alpha: alpha)
    }
    
    /// 将十六进制颜色转换为 UIColor
    @objc convenience init(hexString: String, alpha:CGFloat = 1.0) {
        var pureHexString = hexString
        if hexString.hasPrefix("#") {
            pureHexString.remove(at: pureHexString.firstIndex(of: "#")!)
        }
        
        // 存储转换后的数值
        var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
        
        // 分别转换进行转换
        Scanner(string: pureHexString[0..<2]).scanHexInt32(&red)
        
        Scanner(string: pureHexString[2..<4]).scanHexInt32(&green)
        
        Scanner(string: pureHexString[4..<6]).scanHexInt32(&blue)
        
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: Int = 255) {
        // 存储转换后的数值
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
    }
    
    //返回随机颜色
    class var uf_randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    /// view背景色, 适配暗黑模式
    class var uf_systemBackground: UIColor {
        get {
            let lightColor = UIColor.white
            let darkColor = UIColor.black
            if #available(iOS 13, *) {
                return UIColor { $0.userInterfaceStyle == .dark ? darkColor : lightColor }
            }
            return lightColor
        }
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: Int = 1) {
        // 存储转换后的数值
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha))
    }
}

extension String {
    var uf_removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    /// String使用下标截取字符串
    /// 例: "示例字符串"[0..<2] 结果是 "示例"
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
}

public extension Bundle {
    static var wg_executable: String {
        Bundle.main.infoDictionary?[kCFBundleExecutableKey as String] as? String ?? "UnKnow"
    }
    
    static var wg_AppId: String{
        Bundle.main.infoDictionary?[kCFBundleIdentifierKey as String] as? String ?? "UnKnow"
    }
    
    static var wg_appVersion:String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "UnKnow"
    }
    
    static var wg_appBuild :String {
        Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? "Unknow"
    }
    
    static func wg_resourceBundle(for anyClass:AnyClass,name:String)->Bundle?{
        let Sfx_frameBundle =  Bundle.init(for: anyClass)
        guard let resourceBundleUrl = Sfx_frameBundle.url(forResource: name, withExtension: "bundle") else {
            return nil
        }
        return  Bundle(url: resourceBundleUrl)
    }
}
