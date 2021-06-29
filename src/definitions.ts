import type { PluginListenerHandle } from '@capacitor/core';

export interface SiriShortcutsPlugin {
  /**
   * Donates the provided action to Siri/Shortcuts
   *
   * @since 1.0.0
   *
   * @param {Options} options Options to specify for the donation
   */
  donate(options: Options): Promise<any>;

  /**
   * Deletes the previous donations with the provided persistent identifiers
   *
   * @since 2.1.0
   *
   * @param {Array.<String>} identifiers Persistent identifiers which should be deleted
   */
  delete(identifiers: string[]): Promise<void>;

  /**
   * Delets all the previously donated activities
   *
   * @since 2.1.0
   */
  deleteAll(): Promise<void>;

  /**
   * Listens to events associated with Siri Shortcuts
   * and notifies the listenerFunc if a Shortcuts has been executed.
   *
   * @since 2.0.1
   *
   * @param eventName Name of the event
   * @param listenerFunc Function to execute when listener gets notified
   */
  addListener(
    eventName: 'appLaunchBySiriShortcuts',
    listenerFunc: (shortcut: Shortcut) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Remove all listeners for this plugin.
   *
   * @since 2.0.1
   */
  removeAllListeners(): Promise<void>;
}

export interface UserInfo {
  /**
   * Anything except persistentIdentifier, because the
   * persistentIdentifier will be added automatically!
   */
  [key: string]: string;
}

export interface Shortcut extends UserInfo {
  persistentIdentifier: Options['persistentIdentifier'];
}

/**
 * 	Options to specify for the donation
 */
export interface Options {
  /**
   * Specify an identifier to uniquely identify the shortcut,
   * in order to be able to remove it
   */
  persistentIdentifier: string;

  /**
   * Specify a title for the shortcut, which is visible to the
   * user as the name of the shortcut
   */
  title: string;

  /**
   * Provide a key-value object that contains information about
   * the shortcut, this will be returned in the getActivatedShortcut
   * method. It is not possible to use the persistentIdentifier key,
   * it is used internally
   */
  userInfo?: UserInfo;

  /**
   * Specify the phrase to give the user some inspiration
   * on what the shortcut to call
   */
  suggestedInvocationPhrase?: string;

  /**
   * This value defaults to true, set this value to make
   * it searchable in Siri
   */
  isEligibleForSearch?: boolean;

  /**
   * This value defaults to true, set this value to set whether
   * the shortcut eligible for prediction
   */
  isEligibleForPrediction?: boolean;
}
