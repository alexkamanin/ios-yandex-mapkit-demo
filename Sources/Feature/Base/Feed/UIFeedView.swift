import UIKit
import SnapKit

final class UIFeedView: UIView {
    
    final let table = UIFeedTableView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupSubviews()
        self.setupConstraints()
    }
    
    private func setupSubviews() {
        self.addSubview(self.table)
    }

    private func setupConstraints() {
        self.table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
