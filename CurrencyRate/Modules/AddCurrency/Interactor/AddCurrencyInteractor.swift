
import Foundation

enum CurrencySelectionError: Error {
    case sameSymbols
    case alreadyExists
    case unableToValidate
}

final class AddCurrencyInteractor: AddCurrencyPresenterToInteractorProtocol {

    weak var presenter: AddCurrencyInteractorToPresenterProtocol?
    private let storeService: CurrencyStoreService
    private let selectionError = Constants.AddCurrency.SelectionError.self
    
    init(presenter: AddCurrencyInteractorToPresenterProtocol, storeService: CurrencyStoreService) {
        self.presenter = presenter
        self.storeService = storeService
    }
    
    var symbols: [CurrencySymbolDTO] = []
    
    var selectedCurrencySymbolPair: [CurrencySymbolDTO] = [] {
        didSet {
            guard selectedCurrencySymbolPair.count == 2 else {
                return
            }
            saveCurrencyPair(selectedCurrencySymbolPair)
        }
    }
    
    private func saveCurrencyPair(_ symbols: [CurrencySymbolDTO]) {
        let currencyPair = CurrencyPairDTO(base: symbols[0].abbreviation,
                                           baseDescription: symbols[0].name,
                                           secondary: symbols[1].abbreviation,
                                           secondaryDescription: symbols[1].name,
                                           rate: nil)
        do {
            try validateSelectedPair(pair: currencyPair)
            storeService.add(base: currencyPair.base,
                             baseName: currencyPair.baseDescription,
                             secondary: currencyPair.secondary,
                             secondaryName: currencyPair.secondaryDescription)
            presenter?.addedCurrencyPair(currencyPair)
        } catch CurrencySelectionError.sameSymbols {
            presenter?.failedToSaveCurrencyPair(selectionError.sameSymbols)
        } catch CurrencySelectionError.alreadyExists {
            presenter?.failedToSaveCurrencyPair(selectionError.alreadyExists)
        } catch {
            presenter?.failedToSaveCurrencyPair(selectionError.unknown)
        }
    }
    
    private func validateSelectedPair(pair: CurrencyPairDTO) throws {
        guard pair.base != pair.secondary else {
            throw CurrencySelectionError.sameSymbols
        }
        let duplicatePair = storeService.fetchPairs().first { localPair in
            return localPair.base == pair.base && localPair.secondary == pair.secondary
        }
        guard duplicatePair == nil else {
            throw CurrencySelectionError.alreadyExists
        }
    }
    
}
