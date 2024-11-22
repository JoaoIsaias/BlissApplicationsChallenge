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
    @State private var imageURL: String?
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
                AsyncImage(url: URL(string: imageURL ?? "")){ result in
                    result.image?
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: 100, height: 100)
                .border(.blue)
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
            
            HStack {
                TextField("", text: $searchText)
                    .border(.black)
                    .padding(.horizontal)
                Button("Search") {
                    if !searchText.isEmpty {
                        Task {
                            await showUserAvatar()
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            
            Spacer()
            
        }
        .padding()
    }
    
    func showRandomEmoji() {
        imageURL = emojiList.randomElement()?.url
    }
    
    func showUserAvatar() async {
        await viewModel.getUserInfo(context: viewContext, username: searchText.lowercased()) { userInfo in
            if userInfo != nil {
                imageURL = userInfo?.avatarUrl
            }
        }
    }
}

#Preview {
    MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
