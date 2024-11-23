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
                .frame(width: 150, height: 150)
                .border(.blue)
                .padding()
            
            if emojiList.isEmpty {
                Button(action: {
                    viewModel.loadEmojis(context: viewContext)
                }) {
                    Text("Get Emojis")
                    .font(.title3)
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            } else {
                Button(action: {
                    showRandomEmoji()
                }) {
                    Text("Random Emoji!")
                    .font(.title3)
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
                        
            NavigationLink(destination: EmojiListView(emojiList: Array(emojiList))) {
                Text("Emoji List")
                .font(.title3)
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(emojiList.isEmpty)
            .padding()
            
            HStack {
                TextField("", text: $searchText)
                    .font(.title3)
                    .frame(width: 200)
                    .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                    .border(.blue)
                
                Button(action: {
                    if !searchText.isEmpty {
                        Task { await showUserAvatar() }
                    }
                }) {
                    Text("Search")
                    .font(.title3)
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            NavigationLink(destination: AvatarListView()) {
                Text("Avatar List")
                .font(.title3)
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            NavigationLink(destination: RepositoriesListView()) {
                Text("Apple Repositories List")
                .font(.title3)
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            Spacer()
            
        }
        .padding(.init(top: 30, leading: 15, bottom: 15, trailing: 15))
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
