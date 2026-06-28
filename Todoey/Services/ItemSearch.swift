import Foundation

enum ItemSearch {

    // Case-insensitive title filter. An empty or whitespace-only query returns all items.
    static func filter(_ items: [Item], query: String) -> [Item] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return items }
        return items.filter { $0.title.localizedCaseInsensitiveContains(trimmed) }
    }
}
