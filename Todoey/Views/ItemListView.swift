import SwiftData
import SwiftUI

struct ItemListView: View {
    @Environment(\.modelContext) private var modelContext
    let category: Category

    @State private var searchText = ""
    @State private var showingAddItem = false
    @State private var newItemTitle = ""

    private var displayedItems: [Item] {
        let sorted = category.items.sorted { $0.createdAt < $1.createdAt }
        return ItemSearch.filter(sorted, query: searchText)
    }

    var body: some View {
        List {
            ForEach(Array(displayedItems.enumerated()), id: \.element.id) { index, item in
                let hex = rowHex(at: index)
                ItemRow(item: item, isLight: CategoryPalette.isLight(hex))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color(hex: hex))
                    .contentShape(Rectangle())
                    .onTapGesture { item.done.toggle() }
            }
            .onDelete(perform: deleteItems)
        }
        .listStyle(.plain)
        .overlay {
            if displayedItems.isEmpty {
                ContentUnavailableView(
                    "No Items", systemImage: "checklist",
                    description: Text("Tap + to add a task."))
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: category.colorHex), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(
            CategoryPalette.isLight(category.colorHex) ? .light : .dark, for: .navigationBar
        )
        .searchable(text: $searchText, prompt: "Search items")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddItem = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .alert("Add Task", isPresented: $showingAddItem) {
            TextField("Title", text: $newItemTitle)
            Button("Add", action: addItem)
            Button("Cancel", role: .cancel) { newItemTitle = "" }
        }
    }

    private func rowHex(at index: Int) -> String {
        let count = displayedItems.count
        let t = count > 1 ? Double(index) / Double(count - 1) : 0
        return CategoryPalette.darken(category.colorHex, byFraction: 0.12 + 0.5 * t)
    }

    private func addItem() {
        let title = newItemTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        defer { newItemTitle = "" }
        guard !title.isEmpty else { return }
        let item = Item(title: title, category: category)
        modelContext.insert(item)
    }

    private func deleteItems(at offsets: IndexSet) {
        let items = displayedItems
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}

#Preview {
    NavigationStack {
        ItemListView(category: PreviewSampleData.firstCategory)
    }
    .modelContainer(PreviewSampleData.container)
}
