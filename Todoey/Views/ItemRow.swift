import SwiftUI

struct ItemRow: View {
    let item: Item
    let isLight: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.done ? "checkmark.circle.fill" : "circle")
                .font(.title3)
            Text(item.title)
                .strikethrough(item.done)
            Spacer()
        }
        .padding(.vertical, 14)
        .foregroundStyle(isLight ? .black : .white)
        .opacity(item.done ? 0.55 : 1)
    }
}

#Preview {
    List {
        ItemRow(item: Item(title: "Buy milk"), isLight: true)
        ItemRow(item: Item(title: "Walk the dog", done: true), isLight: true)
    }
}
