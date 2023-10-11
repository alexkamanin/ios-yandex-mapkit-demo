import UIKit

final class UIFeedTableView: UITableView {

    var items: [FeedItem] = [] {
        didSet {
            reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }

    var clickListener: ((FeedItem) -> Void)?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero, style: .plain)

        dataSource = self
        delegate = self

        register(UIFeedTableViewCell.self, forCellReuseIdentifier: "\(UIFeedTableViewCell.self)")
    }
    
    deinit {
        self.clickListener = nil
    }
}

extension UIFeedTableView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellValue = items[indexPath.item]
        guard let cellView = dequeueReusableCell(
            withIdentifier: "\(UIFeedTableViewCell.self)",
            for: indexPath
        ) as? UIFeedTableViewCell else {
            fatalError("is not supported")
        }
        cellView.setData(cellValue)
        return cellView
    }
}

extension UIFeedTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellValue = items[indexPath.row]
        self.clickListener?(cellValue)
        self.deselectRow(at: indexPath, animated: false)
    }
}
