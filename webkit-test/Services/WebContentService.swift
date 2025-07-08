import Foundation

class WebContentService {
    private let endpoint = URL(string: "https://souscription-qlf.oney.fr/scoach-merchant-web/#/dispatch/6370b780-f853-4c5f-9d83-98678c237e37")!

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
