
import UIKit

protocol CurrencyListSectionViewDelegate: AnyObject {
    func addButtonDidTap()
}

final class CurrencyListSectionView: UIView {
    
    weak var delegate: CurrencyListSectionViewDelegate?
    private lazy var plusButton = makePlusButton()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var mainStackView = makeMainStackView(subViews: [plusButton, titleLabel])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    @objc private func addButtonDidTap() {
        delegate?.addButtonDidTap()
    }
}

extension CurrencyListSectionView {
    private func addSubViews() {
        addSubview(mainStackView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            mainStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            mainStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
        ])
    }
    
    private func makePlusButton() -> UIButton {
        let button = UIButton()
        button.setImage(CustomImages.plus, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 20
        return button
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = Constants.CurrencyList.addButtonTitle
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = CustomColors.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeMainStackView(subViews: [UIView]) -> UIStackView {
        let sv = UIStackView(arrangedSubviews: subViews)
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }
}
