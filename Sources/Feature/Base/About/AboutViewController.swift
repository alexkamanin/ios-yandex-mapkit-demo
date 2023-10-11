import UIKit
import YandexMapsMobile

final class AboutViewController : UIViewController {
    
    private final let mainView = UIAboutView()
    
    override func loadView() {
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About"

        self.mainView.icon.image = self.getAppIcon()
        self.mainView.label.text = "MapKit version:\n\n" + YMKMapKit.sharedInstance().version
    }
    
    private func getAppIcon() -> UIImage? {
        
        if let icons = Bundle.main.infoDictionary?[Bundle.Keys.CFBundleIcons] as? [String: Any],
           let primaryIcon = icons[Bundle.Keys.CFBundlePrimaryIcon] as? [String: Any],
           let iconFiles = primaryIcon[Bundle.Keys.CFBundleIconFiles] as? [String],
           let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        
        return nil
    }
}
