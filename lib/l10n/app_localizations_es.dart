// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Cuidado de Ojos';

  @override
  String get forceMode => 'Modo Forzado';

  @override
  String get forceModeSubtitle =>
      'Evitar minimizar la ventana durante los descansos';

  @override
  String get startupAtLogin => 'Iniciar al Iniciar Sesión';

  @override
  String get startupAtLoginSubtitle =>
      'Iniciar aplicación automáticamente al iniciar el sistema';

  @override
  String get work => 'trabajo';

  @override
  String get breakPeriod => 'descanso';

  @override
  String get breakTime => 'Tiempo de Descanso';

  @override
  String get ruleTitle => 'Regla 20-20-20';

  @override
  String get ruleSubtitle => 'Descansa tus ojos siguiendo la regla 20-20-20';

  @override
  String get ruleEvery20Minutes => 'Cada 20 minutos,';

  @override
  String get ruleLookAway => 'aparta la mirada de la pantalla y enfoca algo';

  @override
  String get rule20FeetAway => 'a 20 pies de distancia';

  @override
  String get ruleFor => 'durante';

  @override
  String get rule20Seconds => '20 segundos.';

  @override
  String get ruleExplanation =>
      'Esto ayuda a reducir la fatiga visual causada por el uso prolongado de la pantalla.';

  @override
  String get settings => 'Configuración';

  @override
  String get editRule => 'Editar Regla';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get minutes => 'Minutos';

  @override
  String get seconds => 'Segundos';

  @override
  String get stayFocused => 'Mantente Concentrado 💪';

  @override
  String get takeAMoment => 'Tómate un Momento 🌟';

  @override
  String get breakNotification =>
      'Mantén tu mirada en la pantalla. Recuerda, cada 20 minutos, toma un descanso de 20 segundos mirando algo a 20 pies de distancia.';

  @override
  String get workNotification =>
      'Aléjate de la pantalla y enfoca algo a 20 pies de distancia durante 20 segundos. ¡Tus ojos te lo agradecerán!';

  @override
  String get poweredBy => 'Desarrollado por el equipo de bixat.dev';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get system => 'Sistema';
}
