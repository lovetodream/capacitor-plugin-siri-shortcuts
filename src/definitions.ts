export interface SiriShortcutsPlugin {
  /**
   * Donates the provided action to Siri/Shortcuts
   * 
   * @since 1.0.0
   * 
   * @param options 
   */
  donate(options: Options): Promise<any>;
}

export interface UserInfo {
  /**
   * Anything except persistentIdentifier, because the 
   * persistentIdentifier will be added automatically!
   */
  string: any
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
  userInfo: UserInfo;

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
