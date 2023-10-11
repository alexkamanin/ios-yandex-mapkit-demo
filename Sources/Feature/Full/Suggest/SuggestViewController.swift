import UIKit
import YandexMapsMobile

/**
 * This example shows how to request a suggest for search requests.
 */
final class SuggestViewController: UIViewController {

    private final let mainView = UISuggestView()

    private lazy var searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
    private lazy var suggestSession: YMKSearchSuggestSession = searchManager.createSuggestSession()
    
    override func loadView() {
        self.view = self.mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.searchField.placeholder = "Enter the search text"
        self.mainView.searchField.addTarget(self, action: #selector(queryChanged), for: .editingChanged)
    }

    @objc
    private func queryChanged(_ sender: UITextField) {
        guard let queryText = sender.text else { return }
        
        let suggestHandler = { (response: [YMKSuggestItem]?, error: Error?) -> Void in
            if let response = response {
                self.onSuggestResponse(response)
            } else if let error = error {
                self.onSuggestError(error)
            }
        }

        suggestSession.suggest(
            withText: queryText,
            window: YMKBoundingBox(
                southWest: YMKPoint(latitude: 55.55, longitude: 37.42),
                northEast: YMKPoint(latitude: 55.95, longitude: 37.82)
            ),
            suggestOptions: YMKSuggestOptions(),
            responseHandler: suggestHandler
        )
    }
    
    private func onSuggestResponse(_ items: [YMKSuggestItem]) {
        self.mainView.suggestTable.items = items
    }

    private func onSuggestError(_ error: Error) {
        guard let suggestError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as? YRTError else { return }

        var errorMessage: String {
            switch suggestError {
                case _ where suggestError.isKind(of: YRTNetworkError.self):
                    return "Network error"
                case _ where suggestError.isKind(of: YRTRemoteError.self):
                    return "Remote server error"
                default:
                    return "Unknown error"
            }
        }
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
}
