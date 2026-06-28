import SwiftData
import Testing

@testable import Todoey

@MainActor
struct ModelCrudTests {

    // Returns the container itself so the caller keeps it alive for the whole
    // test. Returning only the context would let the container deallocate and
    // tear down the in-memory store out from under it.
    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: Category.self, Item.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    @Test func insertingCategoryPersists() throws {
        let container = try makeContainer()
        let context = container.mainContext

        context.insert(Category(name: "Home", colorHex: "#3366CC"))

        let categories = try context.fetch(FetchDescriptor<Category>())
        #expect(categories.count == 1)
        #expect(categories.first?.name == "Home")
    }

    @Test func togglingItemFlipsDone() throws {
        let container = try makeContainer()
        let context = container.mainContext

        let item = Item(title: "Task")
        context.insert(item)
        #expect(!item.done)

        item.done.toggle()
        #expect(item.done)
    }

    @Test func deletingCategoryCascadesToItems() throws {
        let container = try makeContainer()
        let context = container.mainContext

        let category = Category(name: "Work", colorHex: "#CC3366")
        let item = Item(title: "Report", category: category)
        context.insert(category)
        context.insert(item)

        context.delete(category)

        let items = try context.fetch(FetchDescriptor<Item>())
        #expect(items.isEmpty)
    }
}
