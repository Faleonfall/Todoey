import UIKit

extension UIColor {

    // Creates a color from a hex string such as `#5AA7E6`, `5AA7E6`, or `#AARRGGBB`.
    convenience init?(hexString: String) {
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hex.hasPrefix("#") { hex.removeFirst() }

        guard hex.count == 6 || hex.count == 8, let value = UInt64(hex, radix: 16) else {
            return nil
        }

        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        let a: CGFloat
        if hex.count == 8 {
            a = CGFloat((value & 0xFF00_0000) >> 24) / 255
            r = CGFloat((value & 0x00FF_0000) >> 16) / 255
            g = CGFloat((value & 0x0000_FF00) >> 8) / 255
            b = CGFloat(value & 0x0000_00FF) / 255
        } else {
            a = 1
            r = CGFloat((value & 0xFF0000) >> 16) / 255
            g = CGFloat((value & 0x00FF00) >> 8) / 255
            b = CGFloat(value & 0x0000FF) / 255
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }

    // Returns the `#RRGGBB` representation of the color.
    func hexValue() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(
            format: "#%02X%02X%02X",
            Int(round(r * 255)), Int(round(g * 255)), Int(round(b * 255)))
    }

    // A pleasant random color with controlled saturation and brightness.
    static func randomFlat() -> UIColor {
        UIColor(
            hue: CGFloat.random(in: 0...1),
            saturation: .random(in: 0.45...0.7),
            brightness: .random(in: 0.8...0.95),
            alpha: 1)
    }

    // Black or white, whichever reads better on top of this color.
    var contrastingTextColor: UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let luminance = 0.299 * r + 0.587 * g + 0.114 * b
        return luminance > 0.6 ? .black : .white
    }

    // Returns a darker variant by lowering brightness by `percentage` (0...1).
    func darkened(by percentage: CGFloat) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a) else { return self }
        let factor = max(0, min(1, 1 - percentage))
        return UIColor(hue: h, saturation: s, brightness: b * factor, alpha: a)
    }
}
