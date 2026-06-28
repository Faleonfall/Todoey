import Testing

@testable import Todoey

struct CategoryPaletteTests {

    @Test func parsesHexComponents() {
        let parsed = CategoryPalette.components("#FF8800")
        #expect(parsed != nil)
        let (r, g, b) = parsed!
        #expect(abs(r - 1.0) < 0.001)
        #expect(abs(g - 136.0 / 255.0) < 0.001)
        #expect(abs(b - 0.0) < 0.001)
    }

    @Test func parsesWithoutLeadingHash() {
        #expect(CategoryPalette.components("00FF00") != nil)
    }

    @Test func rejectsMalformedHex() {
        #expect(CategoryPalette.components("#FFF") == nil)
        #expect(CategoryPalette.components("nothex!") == nil)
    }

    @Test func isLightDetectsBrightAndDark() {
        #expect(CategoryPalette.isLight("#FFFFFF"))
        #expect(!CategoryPalette.isLight("#000000"))
    }

    @Test func darkenLowersEveryChannel() {
        let darker = CategoryPalette.darken("#FFFFFF", byFraction: 0.5)
        let (r, g, b) = CategoryPalette.components(darker)!
        #expect(r < 1.0 && g < 1.0 && b < 1.0)
        #expect(abs(r - 0.5) < 0.01)
    }

    @Test func darkenByZeroKeepsColor() {
        #expect(CategoryPalette.darken("#3366CC", byFraction: 0) == "#3366CC")
    }

    @Test func randomHexIsParseable() {
        let hex = CategoryPalette.randomHex()
        #expect(hex.hasPrefix("#"))
        #expect(hex.count == 7)
        #expect(CategoryPalette.components(hex) != nil)
    }
}
