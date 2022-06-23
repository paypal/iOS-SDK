import UIKit

extension UIColor {

    /// Creates an UIColor from HEX String in "#482937" format
    ///
    /// - Parameters:
    ///  - hexString: HEX String in "#482937" format
    ///
    /// - Returns: UIColor from HexString
    convenience init(hexString: String) {
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString as String)

        if hexString.hasPrefix("#") {
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        let mask = 0x000000FF
        let redAux = Int(color >> 16) & mask
        let greenAux = Int(color >> 8) & mask
        let blueAux = Int(color) & mask
        let red = CGFloat(redAux) / 255.0
        let green = CGFloat(greenAux) / 255.0
        let blue = CGFloat(blueAux) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
