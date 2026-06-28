import Foundation

// Pure color math over "#RRGGBB" hex strings. No UI dependency so it stays testable.
enum CategoryPalette {

    // A pleasant random color with controlled saturation and brightness.
    static func randomHex() -> String {
        let (r, g, b) = rgb(
            hue: Double.random(in: 0...1),
            saturation: Double.random(in: 0.45...0.7),
            brightness: Double.random(in: 0.8...0.95)
        )
        return hexString(r: r, g: g, b: b)
    }

    // Darkens a hex color by lowering each channel toward black by `fraction` (0...1).
    static func darken(_ hex: String, byFraction fraction: Double) -> String {
        guard let (r, g, b) = components(hex) else { return hex }
        let factor = max(0, min(1, 1 - fraction))
        return hexString(r: r * factor, g: g * factor, b: b * factor)
    }

    // True when black text reads better than white on this color.
    static func isLight(_ hex: String) -> Bool {
        guard let (r, g, b) = components(hex) else { return true }
        let luminance = 0.299 * r + 0.587 * g + 0.114 * b
        return luminance > 0.6
    }

    // MARK: - Hex parsing and formatting

    // Parses "#RRGGBB" or "RRGGBB" into channels in 0...1.
    static func components(_ hex: String) -> (Double, Double, Double)? {
        var string = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if string.hasPrefix("#") { string.removeFirst() }
        guard string.count == 6, let value = UInt32(string, radix: 16) else { return nil }
        let r = Double((value & 0xFF0000) >> 16) / 255
        let g = Double((value & 0x00FF00) >> 8) / 255
        let b = Double(value & 0x0000FF) / 255
        return (r, g, b)
    }

    private static func hexString(r: Double, g: Double, b: Double) -> String {
        String(
            format: "#%02X%02X%02X",
            Int((r * 255).rounded()), Int((g * 255).rounded()), Int((b * 255).rounded())
        )
    }

    private static func rgb(
        hue: Double, saturation: Double, brightness: Double
    ) -> (Double, Double, Double) {
        guard saturation > 0 else { return (brightness, brightness, brightness) }
        let h = (hue.truncatingRemainder(dividingBy: 1) * 6)
        let sector = Int(h)
        let f = h - Double(sector)
        let p = brightness * (1 - saturation)
        let q = brightness * (1 - saturation * f)
        let t = brightness * (1 - saturation * (1 - f))
        switch sector % 6 {
        case 0: return (brightness, t, p)
        case 1: return (q, brightness, p)
        case 2: return (p, brightness, t)
        case 3: return (p, q, brightness)
        case 4: return (t, p, brightness)
        default: return (brightness, p, q)
        }
    }
}
