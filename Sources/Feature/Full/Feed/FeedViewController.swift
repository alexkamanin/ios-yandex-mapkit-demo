import UIKit

final class FeedViewController: BaseFeedViewController {
    
    override var items: [FeedItem] {
        get {
            [
                .About,
                .Clustering,
                .CustomLayer,
                .CustomStyle,
                .Driving,
                .Jams,
                .Location,
                .Map,
                .Objects,
                .Panorama,
                .Search,
                .Selection,
                .Suggest,
                .Theme
            ]
        }
    }
    
    override func handleItemSelected(_ item: FeedItem) {
        var viewController: UIViewController {
            switch item {
                case .About: return AboutViewController()
                case .Clustering: return ClusteringViewController()
                case .CustomLayer: return CustomLayerViewController()
                case .CustomStyle: return CustomStyleViewController()
                case .Driving: return DrivingViewController()
                case .Jams: return JamsViewController()
                case .Location: return LocationViewController()
                case .Map: return MapViewController()
                case .Objects: return ObjectsViewController()
                case .Panorama: return PanoramaViewController()
                case .Search: return SearchViewController()
                case .Selection: return SelectionViewController()
                case .Suggest: return SuggestViewController()
                case .Theme: return ThemeViewController()
            }
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
