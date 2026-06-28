import Testing

@testable import Todoey

struct ItemSearchTests {

    private func items(_ titles: [String]) -> [Item] {
        titles.map { Item(title: $0) }
    }

    @Test func emptyQueryReturnsAll() {
        let all = items(["Buy milk", "Walk dog"])
        #expect(ItemSearch.filter(all, query: "").count == 2)
        #expect(ItemSearch.filter(all, query: "   ").count == 2)
    }

    @Test func matchesCaseInsensitively() {
        let all = items(["Buy milk", "Walk dog"])
        let result = ItemSearch.filter(all, query: "MILK")
        #expect(result.count == 1)
        #expect(result.first?.title == "Buy milk")
    }

    @Test func matchesSubstring() {
        let all = items(["Buy milk", "Milkshake"])
        #expect(ItemSearch.filter(all, query: "milk").count == 2)
    }

    @Test func noMatchReturnsEmpty() {
        let all = items(["Buy milk", "Walk dog"])
        #expect(ItemSearch.filter(all, query: "xyz").isEmpty)
    }
}
