import SwiftUI

struct EmojiListView: View {
    @Environment(
        \.managedObjectContext
    ) var viewContext

    let emojiList: [Emoji]
    
    @StateObject private var viewModel = EmojiListViewModel()
    
    var body: some View {
        VStack() {
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                    ForEach(emojiList) {emoji in
                        AsyncImage(url: URL(string: emoji.url ?? ""))
                            .frame(width: 100, height: 100)
                            .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    EmojiListView(emojiList: [])
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
