import SwiftUI

struct AvatarListView: View {
    @Environment(
        \.managedObjectContext
    ) var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.userId, ascending: true)],
        animation: .default
    ) var userList: FetchedResults<User>
    
    @StateObject private var viewModel = AvatarListViewModel()
    
    var body: some View {
        VStack() {
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                    ForEach(userList) { user in
                        Button {
                            viewModel.deleteAvatar(context: viewContext, username: user.login ?? "")
                        } label: {
                            AsyncImage(url: URL(string: user.avatarUrl ?? "")){ result in
                                result.image?
                                    .resizable()
                                    .scaledToFill()
                            }
                            .frame(width: 100, height: 100)
                            .padding()
                        }
                        
                    }
                }
            }
        }
    }
}

#Preview {
    AvatarListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
