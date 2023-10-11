import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            fatalError("Expected window scene but was nil")
        }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.rootViewController = UINavigationController(rootViewController: FeedViewController())
        self.window?.makeKeyAndVisible()
    }
}
