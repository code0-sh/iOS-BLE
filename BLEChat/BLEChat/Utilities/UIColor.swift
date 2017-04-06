import UIKit

extension UIColor {
    /// RGBをUIColorに変換する
    ///
    /// - Parameters:
    ///   - red: 赤
    ///   - green: 緑
    ///   - blue: 青
    ///   - alpha: 不透明度
    /// - Returns: UIColor
    class func rgb(red: Double,
                   green: Double,
                   blue: Double,
                   alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0,
                       green: CGFloat(green) / 255.0,
                       blue: CGFloat(blue) / 255.0,
                       alpha: alpha)
    }
    /// RSSIをUIColorに変換する
    ///
    /// - Parameter distance: RSSI
    /// - Returns: UIColor
    class func hsl(distance: Int) -> UIColor {
        let max: Double = 255
        let min: Double = 0
        var r: Double = min
        var g: Double = min
        var b: Double = min
        /// RSSIをHSVのHに変換する式
        func convert() -> Double {
            return 3.43 * Double(-distance) - 102.86
        }
        let hsl_h = convert()
        if hsl_h < 60 {
            r = max
            g = (hsl_h / 60) * max
            b = min
        } else if hsl_h < 120 {
            r = max * 2 - (max / 60) * hsl_h
            g = max
            b = min
        } else if hsl_h < 180 {
            r = min
            g = max
            b = -max * 2 + (max / 60) * hsl_h
        } else if hsl_h < 240 {
            r = min
            g = max * 4 - (max / 60) * hsl_h
            b = max
        }
        return rgb(red: r, green: g, blue: b, alpha: 1)
    }
}
