# Capacitor Plugin for Siri Shortcuts

## Setup

The Plugin requires at least iOS 12 and Xcode 10.

```
npm i capacitor-plugin-siri-shortcuts
```

### iOS Project

Add a new Item to `NSUserActivityTypes` inside your `Info.plist` with your Bundle Identifier:
```
$(PRODUCT_BUNDLE_IDENTIFIER).shortcut
```

Extend the `application:continueuserActivity,restorationHandler` function inside your `AppDelegate.swift` with the following line:
```swift
NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "appLaunchBySiriShortcuts"), object: userActivity, userInfo: userActivity.userInfo))
```
**Put this line before the return statement!**

The function should look similar to that:
```swift
func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "appLaunchBySiriShortcuts"), object: userActivity, userInfo: userActivity.userInfo))
    return CAPBridge.handleContinueActivity(userActivity, restorationHandler)
}
```

## Example Usage

Basic example of the donate function:
```ts
import { Plugins } from '@capacitor/core';

...

someAction() {
  const { SiriShortcuts } = Plugins;

  SiriShortcuts.donate({
    persistentIdentifier: "someIdentifier",
    title: "A descriptive title"
  })
}
```

It's recommended to add a Listener into the `initializeApp()` function inside `app.component.ts`.
```ts
initializeApp() {
  this.platform.ready().then(() => {
    
    ...
    
    Plugins.SiriShortcuts.addListener('appLaunchBySiriShortcuts', (res) => {
      // do something with the response of the shortcut here
      console.log(res)
    });
  });
}
```

## API Reference

[donate(options): Promise&lt;any&gt;](#donate)  
Donate shortcut to Siri/Shortcuts (silently)

## donate
Donate shortcut to Siri/Shortcuts (silently)

**Returns:** Promise

| Param | Type | Description |
| --- | --- | --- |
| options | <code>object</code> | Options to specify for the donation |
| options.persistentIdentifier | <code>string</code> | Specify an identifier to uniquely identify the shortcut, in order to be able to remove it |
| options.title | <code>string</code> | Specify a title for the shortcut, which is visible to the user as the name of the shortcut |
| options.userInfo | <code>object?</code> | Provide a key-value object that contains information about the shortcut, this will be returned in the getActivatedShortcut method. It is not possible to use the persistentIdentifier key, it is used internally |
| options.suggestedInvocationPhrase | <code>string?</code> | Specify the phrase to give the user some inspiration on what the shortcut to call |
| options.isEligibleForSearch | <code>boolean?</code> | This value defaults to true, set this value to make it searchable in Siri |
| options.isEligibleForPrediction | <code>boolean?</code> | This value defaults to true, set this value to set whether the shortcut eligible for prediction |
