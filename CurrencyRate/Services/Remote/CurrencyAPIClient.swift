
import Foundation

enum CurrencyAPIClient {
    
    case rates(base: String, symbols: String)
    case symbols
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.API.scheme
        components.host = Constants.API.host
        components.path = path
        switch self {
        case .rates(let base, let symbols):
            components.queryItems = [
                URLQueryItem(name: "symbols", value: symbols),
                URLQueryItem(name: "base", value: base)
            ]
        default:
            break
        }
        return components.url
    }
    
    var path: String {
        switch self {
        case .rates:
            return "/exchangerates_data/latest"
        case .symbols:
            return "/exchangerates_data/symbols"
        }
    }
    
    var method: String {
        switch self {
        case .symbols, .rates:
            return "GET"
        }
    }
}

extension CurrencyAPIClient {
    func configureUrlRequest() -> URLRequest {
        guard let url = url else {
            fatalError("Couldn't configure url")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue(Constants.API.key, forHTTPHeaderField: "apikey")
        return urlRequest
    }
}
