import UIKit
import Foundation
import YandexMapsMobile
import SnapKit

/**
 * This example shows how to add layer traffic on the map.
 */
final class JamsViewController: UIViewController {

    private final let mainView = UIJamsView()
    
    override func loadView() {
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.trafficTitle.text = "Tap to switch traffic"

        self.mainView.trafficButton.addTarget(self, action: #selector(onSwitchTraffic), for: .valueChanged)

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
    private func onSwitchTraffic(_ sender: Any) {
        if self.mainView.trafficButton.isOn {
            self.mainView.trafficLayer.addTrafficListener(withTrafficListener: self)
            self.mainView.trafficLayer.setTrafficVisibleWithOn(true)
            
            self.mainView.jamsTitle.isHidden = false
        } else {
            self.mainView.trafficLayer.removeTrafficListener(withTrafficListener: self)
            self.mainView.trafficLayer.setTrafficVisibleWithOn(false)
            
            self.mainView.jamsTitle.isHidden = true
        }
    }
}

extension JamsViewController: YMKTrafficDelegate {
    
    func onTrafficChanged(with trafficLevel: YMKTrafficLevel?) {
        guard let trafficLevel = trafficLevel else { return }

        let level: String = trafficLevel.level.description
        var color: UIColor {
            switch trafficLevel.color {
                case YMKTrafficColor.red:return UIColor.red
                case YMKTrafficColor.green: return UIColor.green
                case YMKTrafficColor.yellow: return UIColor.yellow
                default: return UIColor.white
            }
        }
        
        self.mainView.jamsTitle.text = level
        self.mainView.jamsTitle.backgroundColor = color
    }

    func onTrafficLoading() {}

    func onTrafficExpired() {}
}
