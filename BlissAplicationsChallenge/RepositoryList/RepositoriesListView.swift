import SwiftUI

struct RepositoriesListView: View {
    @StateObject private var viewModel = RepositoriesListViewModel()
    @State private var screenHeight: CGFloat = 0
    private let itemHeight: CGFloat = 50
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                LazyVStack {
                    ForEach(viewModel.repositories.indices, id: \.self) { index in
                        Text(viewModel.repositories[index])
                            .frame(height: itemHeight)
                            .onAppear {
                                if index == viewModel.repositories.count - 1 {
                                    viewModel.loadRepositories()
                                }
                            }
                    }
                }


                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
        }
        .background(
            GeometryReader { geometry in
                Color.clear
                .onAppear {
                    screenHeight = geometry.size.height
                }
            }
        )
        .onAppear {
            viewModel.loadRepositories()
        }

        .onChange(of: viewModel.repositories) {
            let itemsSize = viewModel.repositories.count * Int(itemHeight)
            if !viewModel.isLoading && itemsSize < Int(screenHeight) {
                viewModel.loadRepositories()
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    AvatarListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
