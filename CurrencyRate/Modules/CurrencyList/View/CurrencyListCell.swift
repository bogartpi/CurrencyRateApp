
import UIKit

final class CurrencyListCell: UITableViewCell {
    
    static let cellId = "currencyListCell"
    
    private lazy var baseLabel = makeCurrencySymbolLabel()
    private lazy var baseDescriptionLabel = makeCurrencyDescriptionLabel()
    private lazy var symbolLabel = makeCurrencySymbolLabel(alignment: .right)
    private lazy var symbolDescriptionLabel = makeCurrencyDescriptionLabel(alignment: .right)
    private lazy var rateLabel = makeRateLabel()
    private lazy var symbolsStackView = makeSymbolsStackView()
    private lazy var descriptionStackView = makeDescriptionStackView()
    private lazy var mainStackView = makeMainStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(pair: CurrencyPairDTO) {
        baseLabel.text = String(format: "1 %@", pair.base)
        baseDescriptionLabel.text = pair.baseDescription
        symbolLabel.text = pair.secondary
        symbolDescriptionLabel.text = pair.secondaryDescription
        if let rate = pair.rate {
            rateLabel.attributedText = attributedStringWithDifferentSize(text: rate)
        } else {
            rateLabel.attributedText = attributedStringWithDifferentSize(text: "N/A")
        }
    }
    
    private func attributedStringWithDifferentSize(text: String, size: CGFloat = 16) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        if text.count < 2 {
            return attributedString
        }
        let range = NSRange(location: text.count - 2, length: 2)
        attributedString.addAttribute(NSAttributedString.Key.font,value: UIFont.systemFont(ofSize: size) , range: range)
        return attributedString
    }
}

extension CurrencyListCell {
    private func addSubViews() {
        addSubview(mainStackView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            mainStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            mainStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
    
    private func makeSymbolsStackView() -> UIStackView {
        let sv = UIStackView(arrangedSubviews: [baseLabel, rateLabel, symbolLabel])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }
    
    private func makeDescriptionStackView() -> UIStackView {
        let sv = UIStackView(arrangedSubviews: [baseDescriptionLabel, symbolDescriptionLabel])
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        sv.alignment = .top
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }
    
    private func makeMainStackView() -> UIStackView {
        let sv = UIStackView(arrangedSubviews: [symbolsStackView, descriptionStackView])
        sv.axis = .vertical
        sv.distribution = .equalCentering
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }
    
    private func makeCurrencySymbolLabel(alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.textAlignment = alignment
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeCurrencyDescriptionLabel(alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.textAlignment = alignment
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }
    
    private func makeRateLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = CustomColors.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
