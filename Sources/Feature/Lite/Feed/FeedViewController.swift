import UIKit

final class FeedViewController: BaseFeedViewController {
    
    override var items: [FeedItem] {
        get {
            [
                .About,
                .Clustering,
                .CustomLayer,
                .CustomStyle,
                .Jams,
                .Location,
                .Map,
                .Objects,
                .Selection,
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
                case .Jams: return JamsViewController()
                case .Location: return LocationViewController()
                case .Map: return MapViewController()
                case .Objects: return ObjectsViewController()
                case .Selection: return SelectionViewController()
                case .Theme: return ThemeViewController()
                default: fatalError("Feature '\(item)' not supported")
            }
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
