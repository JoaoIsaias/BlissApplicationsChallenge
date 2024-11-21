import SwiftUI
import CoreData

struct MainView: View {
    @Environment(
        \.managedObjectContext
    ) var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Emoji.name, ascending: true)],
        animation: .default
    ) var emojiList: FetchedResults<Emoji>
    
    @StateObject private var viewModel = MainViewModel()
    @State private var randomEmojiURL: String?
    
    var body: some View {
        NavigationStack {
            AsyncImage(url: URL(string: randomEmojiURL ?? ""))
                .frame(width: 100, height: 100)
                .opacity(emojiList.isEmpty ? 0 : 1)
                .padding()
            
            if emojiList.isEmpty {
                Button("Get Emojis") {
                    viewModel.loadEmojis(context: viewContext)
                }
                .padding()
            } else {
                Button("Random Emoji!") {
                    showRandomEmoji()
                }
                .padding()
            }
                        
            NavigationLink(destination: EmojiListView(emojiList: Array(emojiList))) {
                Text("Emoji List")
            }
            .disabled(emojiList.isEmpty)
            .padding()
            
            Spacer()
            
        }
        .padding()
    }
    
    func showRandomEmoji() {
        randomEmojiURL = emojiList.randomElement()?.url
        
    }
}

#Preview {
    MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
