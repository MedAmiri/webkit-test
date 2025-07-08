import Foundation
import Combine

class WebContentViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var urlToLoad: URL? = nil
    @Published var errorMessage: String? = nil

    private let service = WebContentService()
    private let fallbackURL = URL(string:"https://souscription-qlf.oney.fr/scoach-merchant-web/#/dispatch/c9a5c18e-3269-4af2-ae26-8e470b2ab1f3")!
    func loadContent() {
        isLoading = true
        errorMessage = nil

        service.fetchURL { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let url):
                    self?.urlToLoad = url
                case .failure:
                    self?.errorMessage = "Impossible de charger depuis l'API. Ce sera plutôt un mauvais jour..."
                    self?.urlToLoad = self?.fallbackURL
                }
            }
        }
    }
}
