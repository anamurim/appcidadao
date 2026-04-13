import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Equatorial App Cidadão'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar'**
  String get signup;

  /// No description provided for @forgotPassword.
  ///
  /// In pt, this message translates to:
  /// **'Esqueceu a senha?'**
  String get forgotPassword;

  /// No description provided for @email.
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar senha'**
  String get confirmPassword;

  /// No description provided for @name.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get name;

  /// No description provided for @home.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get home;

  /// No description provided for @history.
  ///
  /// In pt, this message translates to:
  /// **'Histórico'**
  String get history;

  /// No description provided for @map.
  ///
  /// In pt, this message translates to:
  /// **'Mapa'**
  String get map;

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @report.
  ///
  /// In pt, this message translates to:
  /// **'Reporte'**
  String get report;

  /// No description provided for @submitReport.
  ///
  /// In pt, this message translates to:
  /// **'ENVIAR REPORTE'**
  String get submitReport;

  /// No description provided for @reportRegistered.
  ///
  /// In pt, this message translates to:
  /// **'Solicitação Registrada'**
  String get reportRegistered;

  /// No description provided for @reportRegisteredMessage.
  ///
  /// In pt, this message translates to:
  /// **'Recebemos seu reporte. O prazo para atendimento é de até 72 horas úteis.'**
  String get reportRegisteredMessage;

  /// No description provided for @understood.
  ///
  /// In pt, this message translates to:
  /// **'ENTENDIDO'**
  String get understood;

  /// No description provided for @address.
  ///
  /// In pt, this message translates to:
  /// **'Endereço completo'**
  String get address;

  /// No description provided for @referencePoint.
  ///
  /// In pt, this message translates to:
  /// **'Ponto de Referência'**
  String get referencePoint;

  /// No description provided for @additionalNotes.
  ///
  /// In pt, this message translates to:
  /// **'Observações adicionais'**
  String get additionalNotes;

  /// No description provided for @selectOption.
  ///
  /// In pt, this message translates to:
  /// **'Selecione uma opção'**
  String get selectOption;

  /// No description provided for @requiredField.
  ///
  /// In pt, this message translates to:
  /// **'Este campo é obrigatório'**
  String get requiredField;

  /// No description provided for @enterAddress.
  ///
  /// In pt, this message translates to:
  /// **'Informe o endereço'**
  String get enterAddress;

  /// No description provided for @locationError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao obter localização'**
  String get locationError;

  /// No description provided for @loading.
  ///
  /// In pt, this message translates to:
  /// **'Carregando...'**
  String get loading;

  /// No description provided for @noReports.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum reporte enviado até o momento.'**
  String get noReports;

  /// No description provided for @allTypes.
  ///
  /// In pt, this message translates to:
  /// **'Todos'**
  String get allTypes;

  /// No description provided for @searchReports.
  ///
  /// In pt, this message translates to:
  /// **'Buscar reportes...'**
  String get searchReports;

  /// No description provided for @filterByStatus.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar por status'**
  String get filterByStatus;

  /// No description provided for @pending.
  ///
  /// In pt, this message translates to:
  /// **'Pendente'**
  String get pending;

  /// No description provided for @sent.
  ///
  /// In pt, this message translates to:
  /// **'Enviado'**
  String get sent;

  /// No description provided for @underReview.
  ///
  /// In pt, this message translates to:
  /// **'Em Análise'**
  String get underReview;

  /// No description provided for @resolved.
  ///
  /// In pt, this message translates to:
  /// **'Resolvido'**
  String get resolved;

  /// No description provided for @close.
  ///
  /// In pt, this message translates to:
  /// **'FECHAR'**
  String get close;

  /// No description provided for @back.
  ///
  /// In pt, this message translates to:
  /// **'VOLTAR'**
  String get back;

  /// No description provided for @camera.
  ///
  /// In pt, this message translates to:
  /// **'Câmera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In pt, this message translates to:
  /// **'Galeria'**
  String get gallery;

  /// No description provided for @video.
  ///
  /// In pt, this message translates to:
  /// **'Vídeo'**
  String get video;

  /// No description provided for @media.
  ///
  /// In pt, this message translates to:
  /// **'Mídia (imagens ou vídeos)'**
  String get media;

  /// No description provided for @logout.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get logout;

  /// No description provided for @darkMode.
  ///
  /// In pt, this message translates to:
  /// **'Modo Escuro'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In pt, this message translates to:
  /// **'Modo Claro'**
  String get lightMode;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
