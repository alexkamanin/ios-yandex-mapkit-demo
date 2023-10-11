import UIKit
import Foundation
import YandexMapsMobile

/**
 * This is a basic example that displays a map and sets camera focus on the target location.
 * You need to specify your API key in the AppDelegate.swift file before working with the map.
 * Note: When working on your projects, remember to request the required permissions.
 */
final class CustomStyleViewController: UIViewController {

    private final let mainView = UICustomStyleView()
    
    override func loadView() {
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.map.mapWindow.map.move(
            with: YMKCameraPosition(
                target: Locations.SaintPetersburg.target,
                zoom: 15,
                azimuth: 0,
                tilt: 0
            )
        )
        
        guard let style = getStyle(resourceName: "CustomMapStyle") else { fatalError("Style was nil") }
        self.mainView.map.mapWindow.map.setMapStyleWithStyle(style)
    }

    private func getStyle(resourceName: String) -> String? {
        if let filepath: String = Bundle.main.path(forResource: resourceName, ofType: "json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                return contents
            } catch {
                NSLog("JsonError: Contents could not be loaded from json file: " + resourceName)
                return nil
            }
        } else {
            NSLog("JsonError: json file not found: " + resourceName)
            return nil
        }
    }
}
