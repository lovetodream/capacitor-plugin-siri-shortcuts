import { registerPlugin } from '@capacitor/core';

import type { SiriShortcutsPlugin } from './definitions';

const SiriShortcuts = registerPlugin<SiriShortcutsPlugin>('SiriShortcuts');

export * from './definitions';
export { SiriShortcuts };
