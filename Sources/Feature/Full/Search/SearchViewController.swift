import UIKit
import YandexMapsMobile

/**
 * This example shows how to add and interact with a layer that displays search results on the map.
 * Note: search API calls count towards MapKit daily usage limits.
 */
final class SearchViewController: UIViewController {
    
    private final let mainView = UISearchView()
    private final let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
    private var searchSession: YMKSearchSession?
    
    private var queryText: String = ""
    
    override func loadView() {
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.searchField.placeholder = "Enter the search text"
        self.mainView.searchField.addTarget(self, action: #selector(queryChanged), for: .editingChanged)
        self.mainView.map.mapWindow.map.addCameraListener(with: self)
        
        self.mainView.map.mapWindow.map.move(
            with: YMKCameraPosition(
                target: Locations.SaintPetersburg.target,
                zoom: 14,
                azimuth: 0,
                tilt: 0
            )
        )
    }
    
    @objc
    private func queryChanged(_ sender: UITextField) {
        guard let queryText = sender.text else { return }
        self.queryText = queryText
        
        if self.queryText.isEmpty {
            self.mainView.map.mapWindow.map.mapObjects.clear()
        } else {
            self.processSearch()
        }
    }
    
    private func processSearch() {
        let responseHandler = { (response: YMKSearchResponse?, error: Error?) -> Void in
            if let response = response {
                self.onSearchResponse(response)
            } else if let error = error {
                self.onSearchError(error)
            }
        }

        searchSession = searchManager.submit(
            withText: self.queryText,
            geometry: YMKVisibleRegionUtils.toPolygon(with: self.mainView.map.mapWindow.map.visibleRegion),
            searchOptions: YMKSearchOptions(),
            responseHandler: responseHandler
        )
    }
    
    private func onSearchResponse(_ response: YMKSearchResponse) {
        let mapObjects = self.mainView.map.mapWindow.map.mapObjects
        mapObjects.clear()

        for searchResult in response.collection.children {
            if let point = searchResult.obj?.geometry.first?.point {
                mapObjects.addPlacemark() {
                    $0.geometry = point
                    $0.setIconWith(UIImage(named: "RPlacemark")!)
                }
            }
        }
    }

    private func onSearchError(_ error: Error) {
        let searchError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if searchError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if searchError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }

        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}

extension SearchViewController: YMKMapCameraListener {
    
    func onCameraPositionChanged(
        with map: YMKMap,
        cameraPosition: YMKCameraPosition,
        cameraUpdateReason: YMKCameraUpdateReason,
        finished: Bool
    ) {
        if finished && !self.queryText.isEmpty {
            self.processSearch()
        }
    }
}
