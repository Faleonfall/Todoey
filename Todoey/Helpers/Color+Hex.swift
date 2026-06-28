import SwiftUI

extension Color {

    // Builds a Color from a "#RRGGBB" hex string, falling back to gray when unparseable.
    init(hex: String) {
        guard let (r, g, b) = CategoryPalette.components(hex) else {
            self = .gray
            return
        }
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }
}
