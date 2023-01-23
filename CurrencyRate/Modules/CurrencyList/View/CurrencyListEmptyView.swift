
import UIKit

protocol CurrencyListEmptyViewDelegate: AnyObject {
    func addButtonDidTap()
}

final class CurrencyListEmptyView: UIView {
    
    weak var delegate: CurrencyListEmptyViewDelegate?
    private lazy var iconImageView = makeIconImageView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var bodyLabel = makeBodyLabel()
    private lazy var mainStackView = makeMainStackView(subViews: [iconImageView, titleLabel, bodyLabel])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addButtonTapped() {
        delegate?.addButtonDidTap()
    }
    
    func configure(_ message: Message) {
        titleLabel.text = message.title
        bodyLabel.text = message.body
    }
    
    func animate() {
        [iconImageView, titleLabel, bodyLabel].forEach({ $0.alpha = 0 })
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseInOut) {
            [self.iconImageView, self.titleLabel, self.bodyLabel].forEach({ $0.alpha = 1 })
        }
    }
}

extension CurrencyListEmptyView {
    private func addSubViews() {
        addSubview(mainStackView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func makeIconImageView() -> UIImageView {
        let iv = UIImageView(image: CustomImages.plus)
        iv.tintColor = CustomColors.primary
        iv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addButtonTapped)))
        return iv
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = CustomColors.primary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeBodyLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 2
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeMainStackView(subViews: [UIView]) -> UIStackView {
        let sv = UIStackView(arrangedSubviews: subViews)
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 15
        return sv
    }
}
