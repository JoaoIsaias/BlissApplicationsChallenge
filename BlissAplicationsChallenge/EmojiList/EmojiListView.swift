import SwiftUI

struct EmojiListView: View {
    @Environment(
        \.managedObjectContext
    ) var viewContext

    @State var emojiList: [Emoji]
    
    @StateObject private var viewModel = EmojiListViewModel()
    
    var body: some View {
        VStack() {
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                    ForEach(emojiList) { emoji in
                        Button {
                            emojiList = emojiList.filter { $0 != emoji }
                        } label: {
                            AsyncImage(url: URL(string: emoji.url ?? ""))
                                .frame(width: 100, height: 100)
                                .padding()
                        }
                        
                    }
                }
            }
            .refreshable {
                emojiList = viewModel.resetEmojisList(context: viewContext) ?? []
            }
        }
    }
}

#Preview {
    EmojiListView(emojiList: [])
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
