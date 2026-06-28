import SwiftData
import SwiftUI

@main
struct TodoeyApp: App {
    var body: some Scene {
        WindowGroup {
            CategoryListView()
        }
        .modelContainer(for: [Category.self, Item.self])
    }
}
