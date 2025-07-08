import SwiftUI

struct WebContentView: View {
    @StateObject private var viewModel = WebContentViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Chargement...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let url = viewModel.urlToLoad {
                VStack {
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.orange).padding()
                    }
                }
                WebView(url: url)
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text("Erreur")
                        .font(.title)
                        .foregroundColor(.red)
                    Text(error)
                        .multilineTextAlignment(.center)
                    Button("Réessayer") {
                        viewModel.loadContent()
                    }
                    .padding()
                }
                .padding()
            } else {
                EmptyView()
            }
        }
        .onAppear {
            viewModel.loadContent()
        }
    }
}
