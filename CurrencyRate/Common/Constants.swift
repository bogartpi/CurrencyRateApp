
import Foundation

enum Constants {
    enum ScreenName {
        static let currencyList = ""
        static let addCurreency = "1"
    }
    
    enum CurrencyList {
        static let screenTitle = "Курсы валютных пар"
        static let addButtonTitle = "Добавить валютную пару"
        static let emptyStateTitle = "Добавить валютную пару"
        static let emptyStateMessage = "Выберите валютную пару, чтобы\n получить курс"
    }
    
    enum AddCurrency {
        static let screenTitle = "Выберите валютную пару"
        static let addButtonTitle = "Добавить"
        
        enum SelectionError {
            static let sameSymbols = "Вы не можете добавить пару одинаковых валют"
            static let alreadyExists = "Выбранная пара валют уже добавлена"
            static let unknown = "Что-то пошло не так, попробуйте добавить снова"
        }
    }
    
    enum API {
        static let key = "bMMyeFG6U1QHcN7K0UABwB6bPTsHVPN9"
        static let host = "api.apilayer.com"
        static let scheme = "https"
    }
}
