export interface SiriShortcutsPlugin {
  donate(options: { persistentIdentifier: string, title: string, userInfo?: UserInfo, suggestedInvocationPhrase?: string, isEligibleForSearch?: boolean, isEligibleForPrediction?: boolean}): Promise<any>;
}

/**
 * Anything except persistentIdentifier, because the persistentIdentifier will be added automatically!
 */
export interface UserInfo {
  string: any
}
