
import UIKit

final class AddCurrencyViewController: UIViewController {
    
    var presenter: AddCurrencyViewToPresenterProtocol?
    private var symbols: [CurrencySymbolDTO] = []
    private let constants = Constants.AddCurrency.self
    
    private lazy var addCurrencyView = makeAddCurrencyView()
    
    override func loadView() {
        super.loadView()
        addViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
    }
}

extension AddCurrencyViewController {
    private func addViews() {
        view.addSubview(addCurrencyView)
        
        NSLayoutConstraint.activate([
            addCurrencyView.topAnchor.constraint(equalTo: view.topAnchor),
            addCurrencyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addCurrencyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            addCurrencyView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func makeAddCurrencyView() -> AddCurrencyView {
        let view = AddCurrencyView()
        view.backgroundColor = .white
        view.pickerView.dataSource = self
        view.pickerView.delegate = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

extension AddCurrencyViewController: AddCurrencyViewDelegate {
    func addButtonTapped() {
        let baseSymbol = symbols[addCurrencyView.pickerViewSelectedRowIndex(for: 0)]
        let secondarySymbol = symbols[addCurrencyView.pickerViewSelectedRowIndex(for: 1)]
        presenter?.saveButtonTapped(selectedPair: [baseSymbol, secondarySymbol])
    }
}

extension AddCurrencyViewController: AddCurrencyPresenterToViewProtocol {
    func setPicketView(with data: [CurrencySymbolDTO]) {
        symbols = data
    }
    
    func showSelectionCurrencyError(_ text: String) {
        addCurrencyView.toggleError(text)
    }
}

extension AddCurrencyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return symbols.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = ComponentPickerView()
        view.configure(symbols[row])
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return symbols[row].abbreviation
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        addCurrencyView.toggleError()
    }
}
