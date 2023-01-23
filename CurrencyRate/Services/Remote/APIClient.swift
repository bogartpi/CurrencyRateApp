
import Foundation

typealias ParsedCompletion<T: Decodable> = (T?, NetworkError?) -> Void

enum NetworkError: Error {
    case badUrl
    case badRequest
    case networkUnavailable
    case timeOut
    case failedToParse
    case unauthenticated
    case unknown
}

final class APIClient {
    
    func makeAPIRequest<T: Decodable>(_ request: CurrencyAPIClient, completion: @escaping ParsedCompletion<T>) {
        URLSession.shared.dataTask(with: request.configureUrlRequest()) { res in
            DispatchQueue.main.async {
                self.parseDictionaryObject(res, completion: completion)
            }
        }.resume()
    }
    
    func parseDictionaryObject<T: Decodable>(_ response: Result<Data, NSError>,
                                             completion: @escaping ParsedCompletion<T>) {
        switch response {
        case .success(let data):
            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                completion(value, nil)
            } catch {
                completion(nil, .failedToParse)
            }
        case .failure(let error):
            switch error.code {
            case 401, 403:
                completion(nil, .unauthenticated)
            case 400:
                completion(nil, .badRequest)
            default:
                completion(nil, .unknown)
            }
        }
    }
}

extension URLSession {
    func dataTask(with urlRequest: URLRequest,
                  handler: @escaping (Result<Data, NSError>) -> Void) -> URLSessionDataTask {
        dataTask(with: urlRequest) { data, _, error in
            if let error = error as? NSError {
                handler(.failure(error))
            } else {
                handler(.success(data ?? Data()))
            }
        }
    }
}
