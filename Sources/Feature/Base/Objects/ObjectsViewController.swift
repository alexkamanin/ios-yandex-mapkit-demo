import UIKit
import YandexMapsMobile

/**
 * This example shows how to add simple objects such as polygons, circles and polylines to the map.
 * It also shows how to display images instead.
 */
final class ObjectsViewController: UIViewController {
    
    private final let mainView = UIObjectsView()
    
    override func loadView() {
        self.view = self.mainView
    }

    private var animationIsActive = true
    private var circleMapObjectTapListener: YMKMapObjectTapListener!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.createMapObjects()
        self.mainView.map.mapWindow.map.move(
            with: YMKCameraPosition(
                target: Locations.Moscow.target,
                zoom: 14.5,
                azimuth: 0,
                tilt: 0
            )
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.animationIsActive = false
    }

    func createMapObjects() {
        self.createAnimatedPlacemarks(points: Locations.Moscow.placemarks)
        self.createDraggablePlacemarks(points: Locations.Moscow.draggablePlacemarks)
        self.createViewPlacemarks(points: Locations.Moscow.viewPlacemarks)
        self.createPolygon(points: Locations.Moscow.placemarks, excludes: Locations.Moscow.excludePlacemarks)
        self.createColoredPolyline(points: Locations.Moscow.coloredPolylinePoints)
        self.createPolyline(points: Locations.Moscow.polylinePoints)
        self.createTappableCircle(point: Locations.Moscow.circlePlacemark)
    }
    
    private func createAnimatedPlacemarks(points: Array<YMKPoint>) {
        let placemarkPath = Bundle.main.path(forResource: "Animations/AnimatedPlacemark", ofType: "png")
        guard let animatedImageProvider = YRTAnimatedImageProviderFactory.fromFile(placemarkPath) as? YRTAnimatedImageProvider else { return }
        
        points.forEach { point in
            let mapObjects = self.mainView.map.mapWindow.map.mapObjects
            let animatedPlacemark = mapObjects.addPlacemark()
            animatedPlacemark.geometry = point
            
            let animation = animatedPlacemark.useAnimation()
            animation.setIconWithImage(animatedImageProvider, style: YMKIconStyle()) {
                animation.play()
            }
        }
    }
    
    private func createDraggablePlacemarks(points: Array<YMKPoint>) {
        guard let icon = UIImage(named: "DPlacemark") else { return }
        
        points.forEach { point in
            let mapObjects = self.mainView.map.mapWindow.map.mapObjects
            let placemark = mapObjects.addPlacemark()
            placemark.geometry = point
            placemark.isDraggable = true
            placemark.setIconWith(icon)
        }
    }
    
    private func createViewPlacemarks(points: Array<YMKPoint>) {
        points.forEach { point in
            let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
            textView.isOpaque = false
            textView.backgroundColor = UIColor.clear.withAlphaComponent(0.0)
            textView.text = "CustomView"
            textView.font = UIFont.boldSystemFont(ofSize: 16)

            guard let viewProvider = YRTViewProvider(uiView: textView) else { return }

            let mapObjects = self.mainView.map.mapWindow.map.mapObjects
            let viewPlacemark = mapObjects.addPlacemark()
            viewPlacemark.geometry = point
            viewPlacemark.setViewWithView(viewProvider)

            func changeTextColor() {
                if !self.animationIsActive {
                    return
                }
                textView.textColor = .random
                viewProvider.snapshot()
                viewPlacemark.setViewWithView(viewProvider)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    changeTextColor()
                }
            }

            changeTextColor()
        }
    }
    
    private func createPolygon(points: Array<YMKPoint>, excludes: Array<YMKPoint> = []) {
        let mapObjects = self.mainView.map.mapWindow.map.mapObjects
        let polygon = mapObjects.addPolygon(
            with: YMKPolygon(
                outerRing: YMKLinearRing(points: points),
                innerRings: [YMKLinearRing(points: excludes)]
            )
        )
        polygon.fillColor = UIColor.blue.withAlphaComponent(0.5)
        polygon.strokeColor = UIColor.blue.withAlphaComponent(0.8)
        polygon.strokeWidth = 1
        polygon.zIndex = 100
    }
    
    private func createPolyline(points: Array<YMKPoint>) {
        let mapObjects = self.mainView.map.mapWindow.map.mapObjects
        let polyline = mapObjects.addPolyline(with: YMKPolyline(points: points))
        polyline.setStrokeColorWith(.random)
        polyline.strokeWidth = 3
        polyline.zIndex = 100
    }
    
    private func createColoredPolyline(points: Array<YMKPoint>) {
        let mapObjects = self.mainView.map.mapWindow.map.mapObjects
        let polyline = mapObjects.addPolyline(with: YMKPolyline(points: points))
        polyline.gradientLength = 250
        polyline.strokeWidth = 10
        polyline.zIndex = 100
        
        let colorIndexes = points.count - 1
    
        for i in 0..<colorIndexes {
            polyline.setPaletteColorWithColorIndex(UInt(i), color: .random)
        }
        
        let numbers = Array(0..<colorIndexes).map(NSNumber.init(value:))
        polyline.setStrokeColorsWithColors(numbers)
    }
    
    private func createTappableCircle(point: YMKPoint) {
        let mapObjects = self.mainView.map.mapWindow.map.mapObjects
        let circle = mapObjects.addCircle(with: YMKCircle(center: point, radius: 100))
        circle.fillColor = UIColor.red.withAlphaComponent(0.5)
        circle.strokeColor = UIColor.red.withAlphaComponent(0.8)
        circle.strokeWidth = 2
        circle.zIndex = 100
        circle.userData = CircleMapObjectUserData(id: 42, description: "Tappable circle");

        // Client code must retain strong reference to the listener.
        circleMapObjectTapListener = CircleMapObjectTapListener(controller: self);
        circle.addTapListener(with: circleMapObjectTapListener);
    }

    private class CircleMapObjectTapListener: NSObject, YMKMapObjectTapListener {
        
        private weak var controller: UIViewController?

        init(controller: UIViewController) {
            self.controller = controller
        }

        func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
            if let circle = mapObject as? YMKCircleMapObject {
                let randomRadius: Float = 100.0 + 50.0 * Float.random(in: 0..<10);
                let curGeometry = circle.geometry;
                circle.geometry = YMKCircle(center: curGeometry.center, radius: randomRadius);

                if let userData = circle.userData as? CircleMapObjectUserData {
                    let message = "Circle with id \(userData.id) and description '\(userData.description)' tapped";
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert);
                    alert.view.backgroundColor = UIColor.darkGray;
                    alert.view.alpha = 0.8;
                    alert.view.layer.cornerRadius = 15;

                    controller?.present(alert, animated: true);
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        alert.dismiss(animated: true);
                    }
                }
            }
            return true;
        }
    }

    private class CircleMapObjectUserData {
        let id: Int32;
        let description: String;
        init(id: Int32, description: String) {
            self.id = id;
            self.description = description;
        }
    }
}

private extension UIColor {
    
    static var random: UIColor {
        UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
