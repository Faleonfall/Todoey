import SwiftData
import SwiftUI

struct CategoryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Category.name) private var categories: [Category]

    @State private var showingAddCategory = false
    @State private var newCategoryName = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(categories) { category in
                    NavigationLink {
                        ItemListView(category: category)
                    } label: {
                        CategoryRow(category: category)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color(hex: category.colorHex))
                }
                .onDelete(perform: deleteCategories)
            }
            .listStyle(.plain)
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddCategory = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .overlay {
                if categories.isEmpty {
                    ContentUnavailableView(
                        "No Categories", systemImage: "tray",
                        description: Text("Tap + to add your first category."))
                }
            }
            .alert("Add Category", isPresented: $showingAddCategory) {
                TextField("Name", text: $newCategoryName)
                Button("Add", action: addCategory)
                Button("Cancel", role: .cancel) { newCategoryName = "" }
            }
        }
    }

    private func addCategory() {
        let name = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        defer { newCategoryName = "" }
        guard !name.isEmpty else { return }
        modelContext.insert(Category(name: name, colorHex: CategoryPalette.randomHex()))
    }

    private func deleteCategories(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(categories[index])
        }
    }
}

#Preview {
    CategoryListView()
        .modelContainer(PreviewSampleData.container)
}
