
import Foundation

final class CurrencyListInteractor {
    weak var presenter: CurrencyListInteractorToPresenterProtocol?
    private let remoteService: CurrencyAPI
    private let storeService: CurrencyStoreService
    private let reachabilityService: ReachabilityServiceProtocol
    private let dispatchGroup = DispatchGroup()
    private let dispatchQueue = DispatchQueue(label: "com.currencyapp.downloading")
    private let constants = Constants.CurrencyList.self
    private(set) var currencyPairs: [CurrencyPairDTO] = []
    private(set) var currencySymbols: [CurrencySymbolDTO] = []
    
    private var hasNetworkConnection: Bool {
        return reachabilityService.isConnected
    }
    
    private var emptyStateMessage: Message {
        return Message(title: constants.emptyStateTitle, body: constants.emptyStateMessage)
    }
    
    init(presenter: CurrencyListInteractorToPresenterProtocol,
         remoteService: CurrencyAPI = APIClient(),
         storeService: CurrencyStoreService,
         reachabilityService: ReachabilityServiceProtocol = ReachabilityService.shared) {
        self.presenter = presenter
        self.remoteService = remoteService
        self.storeService = storeService
        self.reachabilityService = reachabilityService
    }
}

// MARK: - Remote

extension CurrencyListInteractor: CurrencyListPresenterToInteractorProtocol {
    
    func getCurrencySymbolsAndRates() {
        presenter?.toggleLoading(true)
        
        getCurrencySymbols()
        
        dispatchGroup.notify(queue: .main) {
            self.getCurrencyRates()
        }
    }
    
    private func getCurrencySymbols() {
        fetchLocalSymbols()
        
        dispatchGroup.enter()
        guard currencySymbols.isEmpty else {
            dispatchGroup.leave()
            return
        }
        
        remoteService.fetchCurrencySymbols { [weak self] response, error in
            guard let self = self else { return }
            defer { self.dispatchGroup.leave() }
            if let response = response {
                self.saveCurrencySymbols(response.symbols)
            }
        }
    }
    
    private func getCurrencyRates() {
        fetchLocalCurrencyPairs()
        
        guard hasNetworkConnection else {
            DispatchQueue.main.async {
                self.presenter?.toggleLoading(false)
                if !self.currencyPairs.isEmpty {
                    self.presenter?.fetchedCurrencyPairs(self.currencyPairs)
                } else {
                    self.presenter?.showEmptyState(self.emptyStateMessage)
                }
            }
            return
        }
        
        dispatchQueue.async(group: dispatchGroup, qos: .userInitiated) { [weak self] in
            guard let self = self else { return }
            self.currencyPairs.forEach { pair in
                self.dispatchGroup.enter()
                self.remoteService.fetchCurrencyRate(base: pair.base, symbols: pair.secondary) { [weak self] response, error in
                    guard let self = self else { return }
                    defer {
                        self.dispatchGroup.leave()
                    }
                    if let response = response,
                       let pair = self.configureCurrencyPairs(localPair: pair, response: response).first,
                       let index = self.currencyPairs.firstIndex(where: { $0.base == pair.base && $0.secondary == pair.secondary }) {
                        self.currencyPairs[index] = pair
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.presenter?.toggleLoading(false)
            if !self.currencyPairs.isEmpty {
                self.currencyPairs = self.currencyPairs.sorted(by: { $0.timestamp < $1.timestamp })
                self.presenter?.fetchedCurrencyPairs(self.currencyPairs)
            } else {
                self.presenter?.showEmptyState(self.emptyStateMessage)
            }
        }
    }
    
    func getCurrencyRateForAddedPair(_ pair: CurrencyPairDTO) {
        remoteService.fetchCurrencyRate(base: pair.base, symbols: pair.secondary) { [weak self] response, error in
            guard let self = self else { return }
            guard let currencyPair = self.configureCurrencyPairs(localPair: pair, response: response).first else {
                return
            }
            self.currencyPairs.insert(currencyPair, at: 0)
            self.presenter?.fetchedAddedCurrencyPair(currencyPair)
            if let error = error {
                self.presenter?.networkErrorThrown(error)
            }
        }
    }
}

// MARK: - Persistence

extension CurrencyListInteractor {
    func fetchLocalSymbols() {
        let localSymbols = storeService.fetchSymbols()
        currencySymbols = convertToSymbolsDTO(localSymbols)
    }
    
    func fetchLocalCurrencyPairs() {
        let localPairs = storeService.fetchPairs()
        currencyPairs = convertToCurrencyPairsDTO(localPairs)
    }
    
    func deleteCurrencyPair(at index: Int) {
        let pair = currencyPairs[index]
        storeService.delete(base: pair.base, secondary: pair.secondary)
        currencyPairs.remove(at: index)
        if currencyPairs.isEmpty {
            presenter?.deleteListRow(at: index)
            presenter?.showEmptyState(emptyStateMessage)
        } else {
            presenter?.deleteListRow(at: index)
        }
    }
    
    private func saveCurrencySymbols(_ symbols: [String: String]) {
        currencySymbols = configureCurrencySymbols(symbols)
        storeService.add(symbols: symbols)
    }
    
    private func convertToSymbolsDTO(_ local: [CurrencySymbol]) -> [CurrencySymbolDTO] {
        var symbols: [CurrencySymbolDTO] = []
        for symbol in local {
            symbols.append(CurrencySymbolDTO(abbreviation: symbol.abbreviation!,
                                             name: symbol.name!))
        }
        return symbols
    }
    
    private func convertToCurrencyPairsDTO(_ local: [CurrencyPair]) -> [CurrencyPairDTO] {
        var pairs: [CurrencyPairDTO] = []
        for pair in local {
            let pair = CurrencyPairDTO(base: pair.base ?? "",
                                       baseDescription: pair.baseName ?? "",
                                       secondary: pair.secondary ?? "",
                                       secondaryDescription: pair.secondaryName ?? "",
                                       rate: "N/A")
            pairs.append(pair)
        }
        return pairs
    }
}

// MARK: DTO Configuration

extension CurrencyListInteractor {
    private func configureCurrencySymbols(_ symbols: [String: String]) -> [CurrencySymbolDTO] {
        var symbolsDTO: [CurrencySymbolDTO] = []
        for symbol in symbols {
            symbolsDTO.append(CurrencySymbolDTO(abbreviation: symbol.key, name: symbol.value))
        }
        return symbolsDTO.sorted(by: { $0.abbreviation < $1.abbreviation })
    }
    
    private func configureCurrencyPairs(localPair: CurrencyPairDTO,
                                        response: CurrencyRateResponse?) -> [CurrencyPairDTO] {
        guard let response = response else {
            return [localPair]
        }

        var pairs: [CurrencyPairDTO] = []
        for rate in response.rates {
            let pair = CurrencyPairDTO(base: localPair.base,
                                       baseDescription: localPair.baseDescription,
                                       secondary: localPair.secondary,
                                       secondaryDescription: localPair.secondaryDescription,
                                       rate: String(format: "%.4f", rate.value),
                                       timestamp: localPair.timestamp)
            pairs.append(pair)
        }
        return pairs
    }
}
