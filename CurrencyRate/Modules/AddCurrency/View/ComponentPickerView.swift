
import UIKit

final class ComponentPickerView: UIView {
    
    private lazy var mainStackView = makeMainStackView(subViews: [titleLabel, descriptionLabel])
    private lazy var titleLabel = makeTitleLabel()
    private lazy var descriptionLabel = makeDescriptionlabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ symbol: CurrencySymbolDTO) {
        titleLabel.text = symbol.abbreviation
        descriptionLabel.text = symbol.name
    }
    
}

extension ComponentPickerView {
    private func addViews() {
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leftAnchor.constraint(equalTo: leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    private func makeMainStackView(subViews: [UIView]) -> UIStackView {
        let sv = UIStackView(arrangedSubviews: subViews)
        sv.axis = .vertical
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }
    
    private func makeDescriptionlabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
