import UIKit
import Foundation
import YandexMapsMobile
import SnapKit

final class ThemeViewController: UIViewController {

    private final let mainView = UIThemeView()
    
    override func loadView() {
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.themeTitle.text = "Tap to switch theme"

        self.mainView.themeButton.addTarget(self, action: #selector(onSwitchTheme), for: .valueChanged)

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
    private func onSwitchTheme(_ sender: Any) {
        self.mainView.map.mapWindow.map.isNightModeEnabled = self.mainView.themeButton.isOn
    }
}
