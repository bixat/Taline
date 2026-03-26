// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Eyes Care';

  @override
  String get forceMode => 'Force Mode';

  @override
  String get forceModeSubtitle => 'Prevent window minimization during breaks';

  @override
  String get startupAtLogin => 'Startup at Login';

  @override
  String get startupAtLoginSubtitle =>
      'Launch application automatically at system startup';

  @override
  String get work => 'work';

  @override
  String get breakPeriod => 'break';

  @override
  String get breakTime => 'Break Time';

  @override
  String get ruleTitle => '20-20-20 Rule';

  @override
  String get ruleSubtitle =>
      'Give your eyes a rest by following the 20-20-20 rule';

  @override
  String get ruleEvery20Minutes => 'Every 20 minutes,';

  @override
  String get ruleLookAway =>
      'look away from your screen and focus on something';

  @override
  String get rule20FeetAway => '20 feet away';

  @override
  String get ruleFor => 'for';

  @override
  String get rule20Seconds => '20 seconds.';

  @override
  String get ruleExplanation =>
      'This helps reduce eye strain caused by prolonged screen use.';

  @override
  String get settings => 'Settings';

  @override
  String get editRule => 'Edit Rule';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get minutes => 'Minutes';

  @override
  String get seconds => 'Seconds';

  @override
  String get stayFocused => 'Stay Focused 💪';

  @override
  String get takeAMoment => 'Take a Moment 🌟';

  @override
  String get breakNotification =>
      'Keep your gaze on the screen. Remember, every 20 minutes, take a 20-second break looking at something 20 feet away.';

  @override
  String get workNotification =>
      'Step back from the screen and focus on something 20 feet away for 20 seconds. Your eyes will thank you!';

  @override
  String get poweredBy => 'Powered by bixat.dev team';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';
}
