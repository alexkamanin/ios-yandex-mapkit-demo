import UIKit
import YandexMapsMobile

final class UISuggestTableView: UITableView {

    var items: [YMKSuggestItem] = [] {
        didSet {
            reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero, style: .plain)

        dataSource = self
        delegate = self

        register(UISuggestTableViewCell.self, forCellReuseIdentifier: "\(UISuggestTableViewCell.self)")
    }
}

extension UISuggestTableView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellValue = items[indexPath.item]
        guard let cellView = dequeueReusableCell(
            withIdentifier: "\(UISuggestTableViewCell.self)",
            for: indexPath
        ) as? UISuggestTableViewCell else {
            fatalError("is not supported")
        }
        cellView.setData(cellValue)
        return cellView
    }
}

extension UISuggestTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.deselectRow(at: indexPath, animated: false)
    }
}
