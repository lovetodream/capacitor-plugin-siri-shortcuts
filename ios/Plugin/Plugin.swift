import Foundation
import Intents
import IntentsUI
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@available(iOS 12.0, *)
@objc(SiriShortcuts)
public class SiriShortcuts: CAPPlugin {
    var activity: NSUserActivity?
    //var shortcutPresentedDelegate: ShortcutPresentedDelegate?
    
    public override func load() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onOpenAppByUserActivity(notification:)),
                                               name: NSNotification.Name("appLaunchBySiriShortcuts"), object: nil)
    }
    
    public static func getActivityName() -> String? {
        guard let identifier = Bundle.main.bundleIdentifier else { return nil }
        
        let activityName = identifier + ".shortcut"
        
        return activityName
    }
    
    @objc func donate(_ call: CAPPluginCall) {
        self.activity = self.createUserActivity(from: call, makeActive: true)
        
        call.resolve()
        
    }
    
    /**
     * Create User Activity
     * @param call: Capacitor Call
     */
    private func createUserActivity(from call: CAPPluginCall, makeActive: Bool) -> NSUserActivity? {
        guard let activityName = SiriShortcuts.getActivityName() else {
            call.reject("ActivityName not provided")
            return nil
        }
        
        guard let persistentIdentifier = call.getString("persistentIdentifier") else {
            call.reject("persistentIdentifier not provided")
            return nil
        }
        
        guard let title = call.getString("title") else {
            call.reject("title not provided")
            return nil
        }
        
        let suggestedInvocationPhrase = call.getString("suggestedInvocationPhrase")
        
        var userInfo = call.getObject("userInfo") ?? [:]
        
        let isEligibleForSearch = call.getBool("isEligibleForSearch") ?? true
        let isEligibleForPrediction = call.getBool("isEligibleForPrediction") ?? true
        
        userInfo["persistentIdentifier"] = persistentIdentifier
        
        // Shortcut creation
        let activity = NSUserActivity(activityType: activityName)
        activity.title = title
        activity.suggestedInvocationPhrase = suggestedInvocationPhrase
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(persistentIdentifier)
        activity.isEligibleForSearch = isEligibleForSearch
        activity.isEligibleForPrediction = isEligibleForPrediction
        
        if (makeActive) {
            ActivityDataHolder.setUserInfo(userInfo)
            
            activity.needsSave = true
            
            activity.addUserInfoEntries(from: userInfo)
        } else {
            activity.userInfo = userInfo
        }
        
        self.bridge?.viewController?.userActivity = activity
        
        activity.becomeCurrent()
        
        return activity
    }
}

@available(iOS 12.0, *)
extension SiriShortcuts {
    @objc public func onOpenAppByUserActivity(notification: Notification) {
        debugPrint(notification)
        self.notifyListeners("appLaunchBySiriShortcuts", data: notification.userInfo as? [String : Any] ?? ["something": "happened"], retainUntilConsumed: true)
    }
}

class ActivityDataHolder {
    private static var userInfo: [AnyHashable: Any]?
    
    public static func getUserInfo() -> [AnyHashable: Any]? {
        return self.userInfo
    }
    
    public static func setUserInfo(_ userInfo: [AnyHashable: Any]?) -> Void {
        self.userInfo = userInfo
    }
}
