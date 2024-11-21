//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(
        \.managedObjectContext
    ) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Emoji.name, ascending: true)],
        animation: .default
    ) private var emojiList: FetchedResults<Emoji>
    
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack() {
            Button("Get Emojis") {
                if emojiList.isEmpty {
                    viewModel.loadEmojis(context: viewContext)
                }
            }
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            } else {
                List {
                    ForEach(emojiList) { emoji in
                        Text(emoji.name ?? "")
                    }
                }
                .listStyle(PlainListStyle())
            }
            Spacer()
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
