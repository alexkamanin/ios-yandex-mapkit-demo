import UIKit
import Foundation
import YandexMapsMobile
import SnapKit

/**
 * This is a basic example that displays a map and sets camera focus on the target location.
 * You need to specify your API key in the AppDelegate.swift file before working with the map.
 * Note: When working on your projects, remember to request the required permissions.
 */
final class MapViewController: UIViewController {

    private final let mainView = UIMapView()
    
    override func loadView() {
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.map.mapWindow.map.move(
            with: YMKCameraPosition(target: Locations.Moscow.target, zoom: 15, azimuth: 0, tilt: 0),
            animation: YMKAnimation(type: .smooth, duration: 5),
            cameraCallback: nil
        )
    }
}
