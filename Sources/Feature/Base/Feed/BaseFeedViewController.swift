import UIKit

protocol FeedItemController {
    
    var items: [FeedItem] { get }
    
    func handleItemSelected(_ item: FeedItem)
}

class BaseFeedViewController: UIViewController, FeedItemController {
    
    var items: [FeedItem] {
        get {
            fatalError("\(#function) must be overridden")
        }
    }
    
    private final let mainView = UIFeedView()
    
    override func loadView() {
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MapKit Demo"
        
        self.mainView.table.items = items
        self.mainView.table.clickListener = handleItemSelected
    }
    
    func handleItemSelected(_ item: FeedItem) {
        fatalError("\(#function) must be overridden")
    }
}
