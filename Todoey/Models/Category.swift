import Foundation
import SwiftData

@Model
final class Category {
    var name: String
    var colorHex: String
    @Relationship(deleteRule: .cascade, inverse: \Item.category)
    var items: [Item] = []

    init(name: String, colorHex: String) {
        self.name = name
        self.colorHex = colorHex
    }
}
