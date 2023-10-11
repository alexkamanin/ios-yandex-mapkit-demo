import UIKit
import YandexMapsMobile

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.setupMapKit()
        return true
    }
    
    private func setupMapKit() {
        let apiKey = getApiKey()
        YMKMapKit.setApiKey(apiKey)
        
        if let (languageCode, regionCode) = Locale.preferred {
            YMKMapKit.setLocale("\(languageCode)_\(regionCode)")
        } else {
            YMKMapKit.setLocale("en_US")
        }
        
        YMKMapKit.sharedInstance()
    }

    private func getApiKey() -> String {
        guard let infoDictionary = Bundle.main.infoDictionary else { fatalError("Info dictionary was nil") }
        guard let apiKey: String = infoDictionary[Bundle.Keys.YMKApiKey] as? String else { fatalError("Api key was nil") }
        
        if apiKey.isEmpty {
            fatalError("Replace 'YMK_API_KEY' in 'YMKConfig.xcconfig'")
        }
        
        return apiKey
    }
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

private extension Locale {
    
    typealias PreferredLocale = (languageCode: String, regionCode: String)
    
    static var preferred: PreferredLocale? {
        guard let preferredLanguage = self.preferredLanguages.first else {
            return nil
        }
        let locale = Locale(identifier: preferredLanguage)
        
        guard let languageCode = locale.languageCodeValue,
              let regionCode = locale.regionCodeValue
        else {
            return nil
        }
        
        return (languageCode, regionCode)
    }
    
    private var languageCodeValue: String? {
        if #available(iOS 16, *) {
            return self.language.languageCode?.identifier
        } else {
            return self.languageCode
        }
    }
    
    private var regionCodeValue: String? {
        if #available(iOS 16, *) {
            return self.region?.identifier
        } else {
            return self.regionCode
        }
    }
}
