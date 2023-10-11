import UIKit
import YandexMapsMobile

/**
 * This example shows how to find a panorama that is nearest to a given point and display it
 * in the PanoramaView object. User is not limited to viewing the panorama found and can
 * use arrows to navigate.
 * Note: Nearest panorama search API calls count towards MapKit daily usage limits.
 */
final class PanoramaViewController: UIViewController {
    
    private final let mainView = UIPanoramaView()
    
    private final let panoramaService = YMKPlaces.sharedInstance().createPanoramaService()
    private var panoramaSession: YMKPanoramaServiceSearchSession?
    
    private var currentPanoramaId: String?
    private var historicalPanoramas: [YMKHistoricalPanorama]?
    
    override func loadView() {
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.yearButton.isHidden = true
        self.mainView.clickListener = { panorama in
            self.currentPanoramaId = panorama.panoramaId
            self.mainView.panoView.player.openPanorama(withPanoramaId: panorama.panoramaId)
        }
        self.mainView.panoView.player.addPanoramaChangeListener(withPanoramaChangeListener: self)

        let responseHandler = { (panoramaId: String?, error: Error?) -> Void in
            if let panoramaId = panoramaId {
                self.onPanoramaFound(panoramaId)
            } else if let error = error {
                self.onPanoramaSearchError(error)
            }
        }

        self.panoramaSession = panoramaService.findNearest(
            withPosition: Locations.Moscow.target,
            searchHandler: responseHandler
        )
    }

    private func onPanoramaFound(_ panoramaId: String) {
        self.currentPanoramaId = panoramaId
        
        self.mainView.panoView.player.openPanorama(withPanoramaId: panoramaId)
        self.mainView.panoView.player.enableMove()
        self.mainView.panoView.player.enableRotation()
        self.mainView.panoView.player.enableZoom()
        self.mainView.panoView.player.enableMarkers()
        self.mainView.panoView.player.enableCompanies()
        self.mainView.panoView.player.enableLoadingWheel()
    }

    private func onPanoramaSearchError(_ error: Error) {
        guard let panoramaSearchError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as? YRTError else { return }
        
        var errorMessage: String {
            switch panoramaSearchError {
                case _ where panoramaSearchError.isKind(of: YRTNetworkError.self):
                    return "Network error"
                case _ where panoramaSearchError.isKind(of: YRTRemoteError.self):
                    return "Remote server error"
                case _ where panoramaSearchError.isKind(of: YMKPanoramaNotFoundError.self):
                    return "Not found"
                default:
                    return "Unknown error"
            }
        }

        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    deinit {
        self.panoramaSession?.cancel()
    }
}

extension PanoramaViewController: YMKPanoramaChangeDelegate {
    
    func onPanoramaChanged(with player: YMKPanoramaPlayer) {
        self.historicalPanoramas = self.historicalPanoramas ?? player.historicalPanoramas()
        
        let items = self.historicalPanoramas?
            .map(convertToItems)
            .sorted(by: sortItems)
        
        self.mainView.items = items
     
        if let selectedItem = items?.first(where: { $0.selected }) {
            self.mainView.yearButton.setTitle(selectedItem.panorama.name, for: .normal)
        }
        
        self.mainView.yearButton.isHidden = self.historicalPanoramas == nil
    }
    
    private func convertToItems(_ panorama: YMKHistoricalPanorama) -> PanaromaItem {
        let selected = panorama.panoramaId == self.currentPanoramaId
        return PanaromaItem(panorama: panorama, selected: selected)
    }
    
    private func sortItems(lhs: PanaromaItem, rhs: PanaromaItem) -> Bool {
        guard let lhsYear = Int(lhs.panorama.name),
              let rhsYear = Int(rhs.panorama.name)
        else {
            return false
        }
        
        return lhsYear > rhsYear
    }
}
