
import UIKit

protocol AddCurrencyViewDelegate: AnyObject {
    func addButtonTapped()
}

final class AddCurrencyView: UIView {
    
    weak var delegate: AddCurrencyViewDelegate?
    private lazy var titleLabel = makeTitleLabel()
    private(set) lazy var pickerView = makePickerView()
    private lazy var errorLabel = makeErrorLabel()
    private lazy var addButton = makeAddButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addButtonTapped() {
        delegate?.addButtonTapped()
    }
    
    func pickerViewSelectedRowIndex(for component: Int) -> Int {
        pickerView.selectedRow(inComponent: component)
    }
    
    func toggleError(_ text: String? = nil) {
        if let text = text {
            errorLabel.text = text
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
                self.errorLabel.alpha = 1
            }
        } else {
            errorLabel.alpha = 0
        }
    }
}

extension AddCurrencyView {
    private func addViews() {
        addSubview(titleLabel)
        addSubview(pickerView)
        addSubview(errorLabel)
        addSubview(addButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            pickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            pickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 180),
            
            addButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            addButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            errorLabel.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20),
            errorLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            errorLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
        ])
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = Constants.AddCurrency.screenTitle
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makePickerView() -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }
    
    private func makeErrorLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }
    
    private func makeAddButton() -> UIButton {
        let button = UIButton()
        button.setTitle(Constants.AddCurrency.addButtonTitle, for: .normal)
        button.backgroundColor = CustomColors.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }
}
