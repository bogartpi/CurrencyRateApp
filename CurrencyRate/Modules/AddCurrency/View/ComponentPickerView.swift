
import UIKit

final class CurrencyPickerView: UIView {
    
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ symbol: CurrencySymbolDTO) {
        titleLabel.text = symbol.abbreviation
        descriptionLabel.text = symbol.name
    }
    
}

extension CurrencyPickerView {
    
}
