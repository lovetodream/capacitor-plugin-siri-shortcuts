import { WebPlugin } from '@capacitor/core';
import { SiriShortcutsPlugin, UserInfo } from './definitions';

export class SiriShortcutsWeb extends WebPlugin implements SiriShortcutsPlugin {
  constructor() {
    super({
      name: 'SiriShortcuts',
      platforms: ['web'],
    });
  }
  async donate(options: { persistentIdentifier: string; title: string; userInfo?: UserInfo | undefined; suggestedInvocationPhrase?: string | undefined; isEligibleForSearch?: boolean | undefined; isEligibleForPrediction?: boolean | undefined; }): Promise<any> {
    return options
  }
}

const SiriShortcuts = new SiriShortcutsWeb();

export { SiriShortcuts };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(SiriShortcuts);
