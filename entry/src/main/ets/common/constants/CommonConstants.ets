export class CommonConstants {
  /**
   * Application Colors (Themed)
   */
  static readonly COLOR_BG = $r('app.color.bg_primary');
  static readonly COLOR_CARD = $r('app.color.card_bg');
  static readonly COLOR_PRIMARY = $r('app.color.text_primary');
  static readonly COLOR_SECONDARY = $r('app.color.text_secondary');
  
  // Hex fallbacks for specific string manipulations if needed
  static readonly COLOR_PRIMARY_HEX = '#333333';
  
  static readonly PAGE_PADDING = 24;
  
  // Page URLs / Keys
  static readonly URL_HOME = 'HomePage';
  static readonly URL_EDITOR = 'MoodEditorPage';
  static readonly URL_TOOLS = 'ToolsPage';
  static readonly URL_STATS = 'StatsPage';
  static readonly URL_SETTINGS = 'SettingsPage';
  static readonly URL_SEARCH = 'pages/SearchPage';
  static readonly URL_WIDGETS = 'pages/WidgetsPage';
}
