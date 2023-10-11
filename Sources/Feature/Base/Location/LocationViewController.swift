import UIKit
import YandexMapsMobile
import CoreLocation

/**
 * This example shows how to display and customize user location arrow on the map.
 */
final class LocationViewController: UIViewController {
    
    private final let mainView = UILocationView()
    
    private final let locationManager = CLLocationManager()
    
    override func loadView() {
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.trackPanel.isHidden = true
        self.mainView.trackTitle.text = "Tap to track geo location"
        self.mainView.trackButton.addTarget(self, action: #selector(onSwitchTrack), for: .valueChanged)
        
        self.mainView.map.mapWindow.map.isRotateGesturesEnabled = false
        self.mainView.locationLayer.setObjectListenerWith(self)
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    @objc
    private func onSwitchTrack(_ sender: Any) {
        if self.mainView.trackButton.isOn {
            self.locationManager.startUpdatingLocation()
        } else {
            self.locationManager.stopUpdatingLocation()
        }
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let point = YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        self.mainView.trackPanel.isHidden = false
        self.mainView.progressView.isHidden = true
        self.mainView.locationLayer.setVisibleWithOn(true)
        
        self.mainView.map.mapWindow.map.move(
            with: YMKCameraPosition(target: point, zoom: 16, azimuth: 0, tilt: 0),
            animation: YMKAnimation(type: .smooth, duration: 1),
            cameraCallback: nil
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension LocationViewController: YMKUserLocationObjectListener {
    
    func onObjectAdded(with view: YMKUserLocationView) {
        view.accuracyCircle.fillColor = UIColor.red.withAlphaComponent(0.5)

        if let arrowImage = UIImage(named: "APlacemark") {
            view.arrow.setIconWith(arrowImage)
            view.arrow.setIconStyleWith(
                YMKIconStyle(
                    anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                    rotationType: YMKRotationType.rotate.rawValue as NSNumber,
                    zIndex: 1,
                    flat: true,
                    visible: true,
                    scale: 1,
                    tappableArea: nil
                )
            )
        }

        if let pinImage = UIImage(named: "YPlacemark") {
            view.pin.setIconWith(pinImage)
            view.pin.setIconStyleWith(
                YMKIconStyle(
                    anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                    rotationType: YMKRotationType.rotate.rawValue as NSNumber,
                    zIndex: 1,
                    flat: true,
                    visible: true,
                    scale: 1,
                    tappableArea: nil
                )
            )
        }
    }

    func onObjectRemoved(with view: YMKUserLocationView) {}

    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
}
