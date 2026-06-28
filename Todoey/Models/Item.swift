import Foundation
import SwiftData

@Model
final class Item {
    var title: String
    var done: Bool
    var createdAt: Date
    var category: Category?

    init(title: String, done: Bool = false, createdAt: Date = .now, category: Category? = nil) {
        self.title = title
        self.done = done
        self.createdAt = createdAt
        self.category = category
    }
}
