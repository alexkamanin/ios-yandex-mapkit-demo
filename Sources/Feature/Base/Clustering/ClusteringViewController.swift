import UIKit
import YandexMapsMobile
import SnapKit

/**
 * This example shows how to add a collection of clusterized placemarks to the map.
 */
final class ClusteringViewController: UIViewController {
    
    private var imageProvider = UIImage(named: "DPlacemark")!
    private let FONT_SIZE: CGFloat = 15
    private let MARGIN_SIZE: CGFloat = 3
    private let STROKE_SIZE: CGFloat = 3

    private final let mainView = UIClusteringView()
    
    override func loadView() {
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.map.mapWindow.map.move(
            with: YMKCameraPosition(
                target: Locations.Moscow.target,
                zoom: 7,
                azimuth: 0,
                tilt: 0
            )
        )

        // Note that application must retain strong references to both
        // cluster listener and cluster tap listener
        let collection = self.mainView.map.mapWindow.map.mapObjects.addClusterizedPlacemarkCollection(with: self)
        collection.addPlacemarks(with: Locations.Moscow.clusters, image: self.imageProvider, style: YMKIconStyle())

        // Placemarks won't be displayed until this method is called. It must be also called
        // to force clusters update after collection change
        collection.clusterPlacemarks(withClusterRadius: 60, minZoom: 15)
    }
}

extension ClusteringViewController: YMKClusterListener {
    
    func onClusterAdded(with cluster: YMKCluster) {
        // We setup cluster appearance and tap handler in this method
        cluster.appearance.setIconWith(clusterImage(cluster.size))
        cluster.addClusterTapListener(with: self)
    }
    
    private func clusterImage(_ clusterSize: UInt) -> UIImage {
        let scale = UIScreen.main.scale
        let text = (clusterSize as NSNumber).stringValue
        let font = UIFont.systemFont(ofSize: FONT_SIZE * scale)
        let size = text.size(withAttributes: [NSAttributedString.Key.font: font])
        let textRadius = sqrt(size.height * size.height + size.width * size.width) / 2
        let internalRadius = textRadius + MARGIN_SIZE * scale
        let externalRadius = internalRadius + STROKE_SIZE * scale
        let iconSize = CGSize(width: externalRadius * 2, height: externalRadius * 2)

        UIGraphicsBeginImageContext(iconSize)
        let ctx = UIGraphicsGetCurrentContext()!

        ctx.setFillColor(UIColor.red.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: .zero,
            size: CGSize(width: 2 * externalRadius, height: 2 * externalRadius)));

        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: CGPoint(x: externalRadius - internalRadius, y: externalRadius - internalRadius),
            size: CGSize(width: 2 * internalRadius, height: 2 * internalRadius)));

        (text as NSString).draw(
            in: CGRect(
                origin: CGPoint(x: externalRadius - size.width / 2, y: externalRadius - size.height / 2),
                size: size),
            withAttributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.black])
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
}

extension ClusteringViewController: YMKClusterTapListener {
    
    func onClusterTap(with cluster: YMKCluster) -> Bool {
        let title = "Tap"
        let message = String(format: "Tapped cluster with %u items", cluster.size)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)

        // We return true to notify map that the tap was handled and shouldn't be
        // propagated further.
        return true
    }
}
