declare module '@capacitor/core' {
  interface PluginRegistry {
    SiriShortcuts: SiriShortcutsPlugin;
  }
}

export interface SiriShortcutsPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
