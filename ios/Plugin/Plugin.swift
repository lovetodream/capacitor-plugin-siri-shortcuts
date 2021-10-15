import Foundation
import Intents
import IntentsUI
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(SiriShortcuts)
public class SiriShortcuts: CAPPlugin {
    var activity: NSUserActivity?
    var currentCall: CAPPluginCall?
    
    public override func load() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onOpenAppByUserActivity(notification:)),
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
    
    @objc func present(_ call: CAPPluginCall) {
        self.activity = self.createUserActivity(from: call, makeActive: true)
        
        if let userActivity = self.activity  {
            let shortcut = INShortcut(userActivity: userActivity)
            let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            self.currentCall = call
            DispatchQueue.main.async {
                viewController.modalPresentationStyle = .formSheet
                viewController.delegate = self
                self.bridge?.viewController?.present(viewController, animated: true, completion: nil)
            }
            return
        }
        
        call.reject("No activity provided")
    }
    
    @objc func delete(_ call: CAPPluginCall) {
        guard let identifiers = call.getArray("identifiers", String.self) else {
            call.reject("No identifiers provided")
            return
        }
        
        DispatchQueue.main.async {
            NSUserActivity.deleteSavedUserActivities(withPersistentIdentifiers: identifiers) {
                call.resolve()
            }
        }
    }
    
    @objc func deleteAll(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            NSUserActivity.deleteAllSavedUserActivities {
                call.resolve()
            }
        }
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
        
        DispatchQueue.main.async {
            self.bridge?.viewController?.userActivity = activity
        }
        
        activity.becomeCurrent()
        
        return activity
    }
}

extension SiriShortcuts: INUIAddVoiceShortcutViewControllerDelegate {
    public func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        self.bridge?.viewController?.dismiss(animated: true, completion: {
            if error == nil {
                self.currentCall?.resolve()
            } else {
                self.currentCall?.reject(error!.localizedDescription)
            }
            self.currentCall = nil
        })
    }
    
    public func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        self.bridge?.viewController?.dismiss(animated: true, completion: {
            self.currentCall?.reject("Adding voice shortcut cancelled by user")
            self.currentCall = nil
        })
    }
}

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
