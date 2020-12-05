import { WebPlugin } from '@capacitor/core';
import { SiriShortcutsPlugin } from './definitions';

export class SiriShortcutsWeb extends WebPlugin implements SiriShortcutsPlugin {
  constructor() {
    super({
      name: 'SiriShortcuts',
      platforms: ['web'],
    });
  }

  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}

const SiriShortcuts = new SiriShortcutsWeb();

export { SiriShortcuts };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(SiriShortcuts);
