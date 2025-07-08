import Foundation

class WebContentService {
    private let endpoint = URL(string: "")!

    func fetchURL(completion: @escaping (Result<URL, Error>) -> Void) {
        URLSession.shared.dataTask(with: endpoint) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let data = data else {
                return completion(.failure(
                    NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Aucune donnée reçue"])
                ))
            }

            do {
                let content = try JSONDecoder().decode(WebContent.self, from: data)
                if let url = URL(string: content.url) {
                    completion(.success(url))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL invalide"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
