declare module '@capacitor/core' {
  interface PluginRegistry {
    SiriShortcuts: SiriShortcutsPlugin;
  }
}

export interface SiriShortcutsPlugin {
  donate(options: { persistentIdentifier: string, title: string, suggestedInvocationPhrase?: string, isEligibleForSearch?: boolean, isEligibleForPrediction?: boolean, userInfo: UserInfo}): Promise<any>;
}

/**
 * Anything except persistentIdentifier, because the persistentIdentifier will be added automatically!
 */
interface UserInfo {
  string: any
}
