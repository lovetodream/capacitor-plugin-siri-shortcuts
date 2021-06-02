![ios](https://shields.io/badge/iOS-%3E%3D12.0-informational)
![xcode](https://shields.io/badge/Xcode-%3E%3D10.0-informational)
![npm](https://shields.io/npm/dw/capacitor-plugin-siri-shorts)
![GitHub](https://shields.io/github/license/timozacherl/capacitor-plugin-siri-shortcuts)
![npm](https://shields.io/npm/v/capacitor-plugin-siri-shorts)
![capacitor](https://shields.io/badge/Capacitor-%3E%3D3.0.0-informational)

# Capacitor Plugin for Siri Shortcuts

## Setup

The Plugin requires at least iOS 12 and Xcode 10.

```sh
npm i capacitor-plugin-siri-shorts
```

### iOS Project

Add a new Item to `NSUserActivityTypes` inside your `Info.plist` with your Bundle Identifier:

```sh
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
import { SiriShortcuts } from 'capacitor-plugin-siri-shorts';

...

someAction() {
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
    
    SiriShortcuts.addListener('appLaunchBySiriShortcuts', (res) => {
      // do something with the response of the shortcut here
      console.log(res)
    });
  });
}
```

## API Reference

<docgen-index>

* [`donate(...)`](#donate)
* [`addListener(...)`](#addlistener)
* [`removeAllListeners()`](#removealllisteners)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### donate(...)

```typescript
donate(options: Options) => any
```

Donates the provided action to Siri/Shortcuts

| Param         | Type                                        |
| ------------- | ------------------------------------------- |
| **`options`** | <code><a href="#options">Options</a></code> |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'appLaunchBySiriShortcuts', listenerFunc: (shortcut: Shortcut) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listens to events associated with Siri Shortcuts
and notifies the listenerFunc if a Shortcuts has been executed.

| Param              | Type                                                                 | Description                                     |
| ------------------ | -------------------------------------------------------------------- | ----------------------------------------------- |
| **`eventName`**    | <code>"appLaunchBySiriShortcuts"</code>                              | name of the event                               |
| **`listenerFunc`** | <code>(shortcut: <a href="#shortcut">Shortcut</a>) =&gt; void</code> | function to execute when listener gets notified |

**Returns:** <code>any</code>

--------------------


### removeAllListeners()

```typescript
removeAllListeners() => any
```

Remove all listeners for this plugin.

**Returns:** <code>any</code>

--------------------


### Interfaces


#### Options

<a href="#options">Options</a> to specify for the donation

| Prop                            | Type                                          | Description                                                                                                                                                                                                      |
| ------------------------------- | --------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`persistentIdentifier`**      | <code>string</code>                           | Specify an identifier to uniquely identify the shortcut, in order to be able to remove it                                                                                                                        |
| **`title`**                     | <code>string</code>                           | Specify a title for the shortcut, which is visible to the user as the name of the shortcut                                                                                                                       |
| **`userInfo`**                  | <code><a href="#userinfo">UserInfo</a></code> | Provide a key-value object that contains information about the shortcut, this will be returned in the getActivatedShortcut method. It is not possible to use the persistentIdentifier key, it is used internally |
| **`suggestedInvocationPhrase`** | <code>string</code>                           | Specify the phrase to give the user some inspiration on what the shortcut to call                                                                                                                                |
| **`isEligibleForSearch`**       | <code>boolean</code>                          | This value defaults to true, set this value to make it searchable in Siri                                                                                                                                        |
| **`isEligibleForPrediction`**   | <code>boolean</code>                          | This value defaults to true, set this value to set whether the shortcut eligible for prediction                                                                                                                  |


#### UserInfo


#### Shortcut

| Prop                       | Type                |
| -------------------------- | ------------------- |
| **`persistentIdentifier`** | <code>string</code> |


#### PluginListenerHandle

| Prop         | Type                      |
| ------------ | ------------------------- |
| **`remove`** | <code>() =&gt; any</code> |

</docgen-api>
