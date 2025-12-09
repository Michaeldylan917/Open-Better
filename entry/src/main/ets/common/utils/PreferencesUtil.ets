import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

export class PreferencesUtil {
  private static instance: PreferencesUtil;
  private pref: preferences.Preferences | null = null;
  private readonly PREF_NAME = 'MoodDiaryPrefs';

  private constructor() {}

  public static getInstance(): PreferencesUtil {
    if (!PreferencesUtil.instance) {
      PreferencesUtil.instance = new PreferencesUtil();
    }
    return PreferencesUtil.instance;
  }

  async init(context: common.UIAbilityContext): Promise<void> {
    try {
      this.pref = await preferences.getPreferences(context, this.PREF_NAME);
      console.info('PreferencesUtil', 'Preferences initialized');
    } catch (err) {
      console.error('PreferencesUtil', 'Failed to get preferences. Cause: ' + JSON.stringify(err));
    }
  }

  async putValue(key: string, value: preferences.ValueType): Promise<void> {
    if (!this.pref) {
      console.error('PreferencesUtil', 'Preferences not initialized');
      return;
    }
    try {
      await this.pref.put(key, value);
      await this.pref.flush();
    } catch (err) {
      console.error('PreferencesUtil', 'Failed to put value. Cause: ' + JSON.stringify(err));
    }
  }

  async getValue(key: string, defaultValue: preferences.ValueType): Promise<preferences.ValueType> {
    if (!this.pref) {
      console.error('PreferencesUtil', 'Preferences not initialized');
      return defaultValue;
    }
    try {
      const value = await this.pref.get(key, defaultValue);
      return value;
    } catch (err) {
      console.error('PreferencesUtil', 'Failed to get value. Cause: ' + JSON.stringify(err));
      return defaultValue;
    }
  }
}
