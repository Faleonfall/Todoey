import Foundation
import SwiftData

// In-memory container seeded with sample data, used by SwiftUI previews.
@MainActor
enum PreviewSampleData {

    static let container: ModelContainer = {
        let container = try! ModelContainer(
            for: Category.self, Item.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = container.mainContext

        let home = Category(name: "Home", colorHex: "#5AA7E6")
        let work = Category(name: "Work", colorHex: "#E67E5A")
        context.insert(home)
        context.insert(work)

        context.insert(Item(title: "Buy milk", category: home))
        context.insert(Item(title: "Walk the dog", done: true, category: home))
        context.insert(Item(title: "Email the boss", category: work))

        return container
    }()

    // A seeded category for previews that need one (e.g. the item list).
    static var firstCategory: Category {
        let descriptor = FetchDescriptor<Category>(sortBy: [SortDescriptor(\Category.name)])
        return try! container.mainContext.fetch(descriptor).first!
    }
}
