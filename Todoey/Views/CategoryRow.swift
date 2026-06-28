import SwiftUI

struct CategoryRow: View {
    let category: Category

    var body: some View {
        Text(category.name)
            .font(.title3)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(CategoryPalette.isLight(category.colorHex) ? .black : .white)
    }
}

#Preview {
    List {
        CategoryRow(category: Category(name: "Home", colorHex: "#5AA7E6"))
            .listRowBackground(Color(hex: "#5AA7E6"))
    }
}
