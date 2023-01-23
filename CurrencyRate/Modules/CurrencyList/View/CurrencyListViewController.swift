
import UIKit

protocol CurrencyListViewControllerProtocol: AnyObject {
    func setScreenTitle(_ title: String)
}

final class CurrencyListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
}

extension CurrencyListViewController: 
