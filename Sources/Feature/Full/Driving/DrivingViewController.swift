import UIKit
import YandexMapsMobile

/**
 * This example shows how to build routes between two points and display them on the map.
 * Note: Routing API calls count towards MapKit daily usage limits.
 */
final class DrivingViewController: UIViewController {

    private final let mainView = UIDrivingView()
    private var drivingSession: YMKDrivingSession?
    
    override func loadView() {
        self.view = self.mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latitude = (Locations.SaintPetersburg.target.latitude + Locations.Moscow.target.latitude) / 2
        let longitude = (Locations.SaintPetersburg.target.longitude + Locations.Moscow.target.longitude) / 2
        let target = YMKPoint(latitude: latitude, longitude: longitude)

        self.mainView.map.mapWindow.map.move(
            with: YMKCameraPosition(
                target: target,
                zoom: 5.5,
                azimuth: 0,
                tilt: 0
            )
        )

        let requestPoints : [YMKRequestPoint] = [
            YMKRequestPoint(
                point: Locations.SaintPetersburg.target, type: .waypoint,
                pointContext: nil, drivingArrivalPointId: nil),
            YMKRequestPoint(
                point: Locations.Moscow.target, type: .waypoint,
                pointContext: nil, drivingArrivalPointId: nil),
            ]

        let responseHandler = {(routesResponse: [YMKDrivingRoute]?, error: Error?) -> Void in
            if let routes = routesResponse {
                self.onRoutesReceived(routes)
            } else {
                self.onRoutesError(error!)
            }
        }

        let drivingRouter = YMKDirections.sharedInstance().createDrivingRouter()
        self.drivingSession = drivingRouter.requestRoutes(
            with: requestPoints,
            drivingOptions: YMKDrivingDrivingOptions(),
            vehicleOptions: YMKDrivingVehicleOptions(),
            routeHandler: responseHandler)
    }

    private func onRoutesReceived(_ routes: [YMKDrivingRoute]) {
        let mapObjects = self.mainView.map.mapWindow.map.mapObjects
        for route in routes {
            mapObjects.addPolyline(with: route.geometry)
        }
    }

    private func onRoutesError(_ error: Error) {
        guard let routingError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as? YRTError else { return }
        
        var errorMessage: String {
            switch routingError {
                case _ where routingError.isKind(of: YRTNetworkError.self):
                    return "Network error"
                case _ where routingError.isKind(of: YRTRemoteError.self):
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
