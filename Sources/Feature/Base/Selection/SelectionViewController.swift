import UIKit
import Foundation
import YandexMapsMobile

/**
 * This example shows how to activate selection.
 */
final class SelectionViewController: UIViewController {

    private final let mainView = UISelectionView()
    
    override func loadView() {
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.map.mapWindow.map.move(
            with: YMKCameraPosition(
                target: Locations.Moscow.target,
                zoom: 15,
                azimuth: 0,
                tilt: 0
            )
        )

        self.mainView.map.mapWindow.map.addTapListener(with: self)
        self.mainView.map.mapWindow.map.addInputListener(with: self)
    }
}

extension SelectionViewController: YMKLayersGeoObjectTapListener {
    
    func onObjectTap(with: YMKGeoObjectTapEvent) -> Bool {
        let event = with
        let metadata = event.geoObject.metadataContainer.getItemOf(YMKGeoObjectSelectionMetadata.self)
        if let selectionMetadata = metadata as? YMKGeoObjectSelectionMetadata {
            self.mainView.map.mapWindow.map.selectGeoObject(withSelectionMetaData: selectionMetadata)
            return true
        }
        return false
    }
}

extension SelectionViewController: YMKMapInputListener {
    
    func onMapTap(with map: YMKMap, point: YMKPoint) {
        self.mainView.map.mapWindow.map.deselectGeoObject()
    }

    func onMapLongTap(with map: YMKMap, point: YMKPoint) {}
}
