import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations_en.dart';
import 'localizations_kk.dart';
import 'localizations_ru.dart';
import 'localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/localizations.dart';
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
    Locale('kk'),
    Locale('ru'),
    Locale('uz')
  ];

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @auth.
  ///
  /// In en, this message translates to:
  /// **'Auth'**
  String get auth;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @notIdentified.
  ///
  /// In en, this message translates to:
  /// **'Not identified'**
  String get notIdentified;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @identifiedUser.
  ///
  /// In en, this message translates to:
  /// **'Identified user'**
  String get identifiedUser;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @lent.
  ///
  /// In en, this message translates to:
  /// **'Lent'**
  String get lent;

  /// No description provided for @phoneNumer.
  ///
  /// In en, this message translates to:
  /// **'Phone numer'**
  String get phoneNumer;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth date'**
  String get birthDate;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @lenguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get lenguage;

  /// No description provided for @changePhone.
  ///
  /// In en, this message translates to:
  /// **'Change Phone'**
  String get changePhone;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get personalInformation;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @enterRegisteredNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered number to access your profile!'**
  String get enterRegisteredNumber;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @infoNotFound.
  ///
  /// In en, this message translates to:
  /// **'Information not found'**
  String get infoNotFound;

  /// No description provided for @haveRegisteredBefore.
  ///
  /// In en, this message translates to:
  /// **'Have you registered before? '**
  String get haveRegisteredBefore;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Code'**
  String get enterCode;

  /// No description provided for @verificationCodeSentToPhone.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to '**
  String get verificationCodeSentToPhone;

  /// No description provided for @verificationCodeSentToEmail.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to '**
  String get verificationCodeSentToEmail;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Did not receive the code?'**
  String get didNotReceiveCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @legalEntityInfo.
  ///
  /// In en, this message translates to:
  /// **'Legal entity information'**
  String get legalEntityInfo;

  /// No description provided for @individualInfo.
  ///
  /// In en, this message translates to:
  /// **'Individual information'**
  String get individualInfo;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms of use'**
  String get agreeToTerms;

  /// No description provided for @fillInTheInformation.
  ///
  /// In en, this message translates to:
  /// **'Fill in the information'**
  String get fillInTheInformation;

  /// No description provided for @enterSTIR.
  ///
  /// In en, this message translates to:
  /// **'Enter STIR'**
  String get enterSTIR;

  /// No description provided for @enterCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Enter company name'**
  String get enterCompanyName;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @enterYourSurname.
  ///
  /// In en, this message translates to:
  /// **'Enter your surname'**
  String get enterYourSurname;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get enterVerificationCode;

  /// No description provided for @enterPhoneNumberToRegister.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to register!'**
  String get enterPhoneNumberToRegister;

  /// No description provided for @chooseYourIdentity.
  ///
  /// In en, this message translates to:
  /// **'Choose your identity!'**
  String get chooseYourIdentity;

  /// No description provided for @whoAreYouOnPlatform.
  ///
  /// In en, this message translates to:
  /// **'Who are you on the platform?'**
  String get whoAreYouOnPlatform;

  /// No description provided for @legalEntity.
  ///
  /// In en, this message translates to:
  /// **'Legal Entity'**
  String get legalEntity;

  /// No description provided for @individual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get individual;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @goToMain.
  ///
  /// In en, this message translates to:
  /// **'Go to main'**
  String get goToMain;

  /// No description provided for @successful.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get successful;

  /// No description provided for @rateTheApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get rateTheApp;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @photofact.
  ///
  /// In en, this message translates to:
  /// **'Photofact'**
  String get photofact;

  /// No description provided for @deletePhoto.
  ///
  /// In en, this message translates to:
  /// **'Delete photo'**
  String get deletePhoto;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'days left'**
  String get daysLeft;

  /// No description provided for @allQuestions.
  ///
  /// In en, this message translates to:
  /// **'All questions'**
  String get allQuestions;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutUs;

  /// No description provided for @passingScore.
  ///
  /// In en, this message translates to:
  /// **'Passing score'**
  String get passingScore;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get week;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @moon.
  ///
  /// In en, this message translates to:
  /// **'moon'**
  String get moon;

  /// No description provided for @tests.
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get tests;

  /// No description provided for @goToIdentification.
  ///
  /// In en, this message translates to:
  /// **'Go to identification'**
  String get goToIdentification;

  /// No description provided for @scanToLogin.
  ///
  /// In en, this message translates to:
  /// **'Scan to login'**
  String get scanToLogin;

  /// No description provided for @doYouWantToGoOut.
  ///
  /// In en, this message translates to:
  /// **'Do you want to go out?'**
  String get doYouWantToGoOut;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @transportServices.
  ///
  /// In en, this message translates to:
  /// **'Fast, convenient, affordable in all transport services in one app!'**
  String get transportServices;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @whatHappened.
  ///
  /// In en, this message translates to:
  /// **'What happened'**
  String get whatHappened;

  /// No description provided for @main.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get main;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @cargoTransport.
  ///
  /// In en, this message translates to:
  /// **'Cargo Transport'**
  String get cargoTransport;

  /// No description provided for @cancelAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the announcement?'**
  String get cancelAnnouncement;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @loadWeight.
  ///
  /// In en, this message translates to:
  /// **'Load Weight'**
  String get loadWeight;

  /// No description provided for @passengerCount.
  ///
  /// In en, this message translates to:
  /// **'Passenger Count'**
  String get passengerCount;

  /// No description provided for @transportCount.
  ///
  /// In en, this message translates to:
  /// **'Transport Count'**
  String get transportCount;

  /// No description provided for @departureDate.
  ///
  /// In en, this message translates to:
  /// **'Departure Date'**
  String get departureDate;

  /// No description provided for @cargoType.
  ///
  /// In en, this message translates to:
  /// **'Cargo Type'**
  String get cargoType;

  /// No description provided for @cargoImage.
  ///
  /// In en, this message translates to:
  /// **'Cargo Image'**
  String get cargoImage;

  /// No description provided for @cargoLoadingService.
  ///
  /// In en, this message translates to:
  /// **'Cargo Loading Service'**
  String get cargoLoadingService;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @transportType.
  ///
  /// In en, this message translates to:
  /// **'Transport Type'**
  String get transportType;

  /// No description provided for @yourCargoIsOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'Your cargo is already on the way!'**
  String get yourCargoIsOnTheWay;

  /// No description provided for @driverDeliveredCargo.
  ///
  /// In en, this message translates to:
  /// **'The driver delivered your cargo to the destination. Do you confirm?'**
  String get driverDeliveredCargo;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as Read'**
  String get markAsRead;

  /// No description provided for @multipleBoxCapacity.
  ///
  /// In en, this message translates to:
  /// **'Multiple Box Capacity'**
  String get multipleBoxCapacity;

  /// No description provided for @washingMachineEtc.
  ///
  /// In en, this message translates to:
  /// **'Washing Machine, etc.'**
  String get washingMachineEtc;

  /// No description provided for @homeAppliances.
  ///
  /// In en, this message translates to:
  /// **'Home Appliances and Equipment'**
  String get homeAppliances;

  /// No description provided for @largeQuantityGoods.
  ///
  /// In en, this message translates to:
  /// **'Large Quantity Goods'**
  String get largeQuantityGoods;

  /// No description provided for @aboutOrder.
  ///
  /// In en, this message translates to:
  /// **'About Order'**
  String get aboutOrder;

  /// No description provided for @aboutCargo.
  ///
  /// In en, this message translates to:
  /// **'About Cargo'**
  String get aboutCargo;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @cargoVolume.
  ///
  /// In en, this message translates to:
  /// **'Cargo Volume'**
  String get cargoVolume;

  /// No description provided for @cargoCapacity.
  ///
  /// In en, this message translates to:
  /// **'Cargo Capacity'**
  String get cargoCapacity;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// No description provided for @length.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get length;

  /// No description provided for @cargoImages.
  ///
  /// In en, this message translates to:
  /// **'Cargo Images'**
  String get cargoImages;

  /// No description provided for @truckType.
  ///
  /// In en, this message translates to:
  /// **'Truck Type'**
  String get truckType;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @liveTracking.
  ///
  /// In en, this message translates to:
  /// **'Live Tracking'**
  String get liveTracking;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @orderReceived.
  ///
  /// In en, this message translates to:
  /// **'You have received the order!'**
  String get orderReceived;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @alternativeOffer.
  ///
  /// In en, this message translates to:
  /// **'Alternative Offer'**
  String get alternativeOffer;

  /// No description provided for @carBrokeDown.
  ///
  /// In en, this message translates to:
  /// **'Car broke down.'**
  String get carBrokeDown;

  /// No description provided for @ranOutOfFuel.
  ///
  /// In en, this message translates to:
  /// **'Ran out of fuel.'**
  String get ranOutOfFuel;

  /// No description provided for @cargoIssue.
  ///
  /// In en, this message translates to:
  /// **'There is an issue with the cargo.'**
  String get cargoIssue;

  /// No description provided for @trafficAccident.
  ///
  /// In en, this message translates to:
  /// **'There was a traffic accident.'**
  String get trafficAccident;

  /// No description provided for @couldNotFindKitchen.
  ///
  /// In en, this message translates to:
  /// **'Could not find the kitchen.'**
  String get couldNotFindKitchen;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @cancellationReason.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason'**
  String get cancellationReason;

  /// No description provided for @writeCancellationReason.
  ///
  /// In en, this message translates to:
  /// **'Write the reason for cancellation'**
  String get writeCancellationReason;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @tashkentToAndijan.
  ///
  /// In en, this message translates to:
  /// **'Tashkent → Andijan'**
  String get tashkentToAndijan;

  /// No description provided for @furniture.
  ///
  /// In en, this message translates to:
  /// **'Furniture'**
  String get furniture;

  /// No description provided for @dimensions.
  ///
  /// In en, this message translates to:
  /// **'2 х 3 х 2 m²'**
  String get dimensions;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @physical.
  ///
  /// In en, this message translates to:
  /// **'Physical'**
  String get physical;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @stir.
  ///
  /// In en, this message translates to:
  /// **'STIR'**
  String get stir;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @callCenterNumber.
  ///
  /// In en, this message translates to:
  /// **'Call Center Number'**
  String get callCenterNumber;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @yourSurname.
  ///
  /// In en, this message translates to:
  /// **'Your Surname'**
  String get yourSurname;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @telegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get telegram;

  /// No description provided for @supportCenter.
  ///
  /// In en, this message translates to:
  /// **'Support Center'**
  String get supportCenter;

  /// No description provided for @describeProblem.
  ///
  /// In en, this message translates to:
  /// **'Describe the problem'**
  String get describeProblem;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @canICancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Can I cancel the order?'**
  String get canICancelOrder;

  /// No description provided for @howToAcceptOrder.
  ///
  /// In en, this message translates to:
  /// **'How to accept an order?'**
  String get howToAcceptOrder;

  /// No description provided for @whatCanIDo.
  ///
  /// In en, this message translates to:
  /// **'What can I do?'**
  String get whatCanIDo;

  /// No description provided for @yesYouCan.
  ///
  /// In en, this message translates to:
  /// **'Yes, you can. You will be notified when new clients arrive.'**
  String get yesYouCan;

  /// No description provided for @changeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Number'**
  String get changeNumber;

  /// No description provided for @enterNewPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your new phone number!'**
  String get enterNewPhoneNumber;

  /// No description provided for @verificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to '**
  String get verificationCodeSent;

  /// No description provided for @referalCode.
  ///
  /// In en, this message translates to:
  /// **'Referral Code'**
  String get referalCode;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @createOrder.
  ///
  /// In en, this message translates to:
  /// **'Create Order'**
  String get createOrder;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @paymentInfo.
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get paymentInfo;

  /// No description provided for @cargo.
  ///
  /// In en, this message translates to:
  /// **'Cargo'**
  String get cargo;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @nameAndSurname.
  ///
  /// In en, this message translates to:
  /// **'Name and Surname'**
  String get nameAndSurname;

  /// No description provided for @recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// No description provided for @howManyLoaders.
  ///
  /// In en, this message translates to:
  /// **'How Many Loaders'**
  String get howManyLoaders;

  /// No description provided for @loadingService.
  ///
  /// In en, this message translates to:
  /// **'Loading Service'**
  String get loadingService;

  /// No description provided for @notActive.
  ///
  /// In en, this message translates to:
  /// **'Not Active'**
  String get notActive;

  /// No description provided for @paymentType.
  ///
  /// In en, this message translates to:
  /// **'Payment Type'**
  String get paymentType;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @peregonService.
  ///
  /// In en, this message translates to:
  /// **'Peregon Service'**
  String get peregonService;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Cargo Shipping'**
  String get shipping;

  /// No description provided for @fuelDelivery.
  ///
  /// In en, this message translates to:
  /// **'Fuel Delivery'**
  String get fuelDelivery;

  /// No description provided for @passengerTransport.
  ///
  /// In en, this message translates to:
  /// **'Passenger Transport'**
  String get passengerTransport;

  /// No description provided for @carRental.
  ///
  /// In en, this message translates to:
  /// **'Car Rental'**
  String get carRental;

  /// No description provided for @specialTechServices.
  ///
  /// In en, this message translates to:
  /// **'Special Technical Services'**
  String get specialTechServices;

  /// No description provided for @autoRepair.
  ///
  /// In en, this message translates to:
  /// **'Auto Repair'**
  String get autoRepair;

  /// No description provided for @transportTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transport Transfer'**
  String get transportTransfer;

  /// No description provided for @warehouseStorage.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Storage'**
  String get warehouseStorage;

  /// No description provided for @searchTransport.
  ///
  /// In en, this message translates to:
  /// **'Search for the necessary transport'**
  String get searchTransport;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @announcements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements;

  /// No description provided for @searchAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Search for the necessary announcement'**
  String get searchAnnouncement;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @myServices.
  ///
  /// In en, this message translates to:
  /// **'My Services'**
  String get myServices;

  /// No description provided for @transportAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Transport Announcements'**
  String get transportAnnouncements;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @leaveOrderComment.
  ///
  /// In en, this message translates to:
  /// **'Leave a comment about order!'**
  String get leaveOrderComment;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get enterPrice;

  /// No description provided for @queueRegistration.
  ///
  /// In en, this message translates to:
  /// **'Queue Registration'**
  String get queueRegistration;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @contactViaTelegram.
  ///
  /// In en, this message translates to:
  /// **'Contact via Telegram'**
  String get contactViaTelegram;

  /// No description provided for @referralProgram.
  ///
  /// In en, this message translates to:
  /// **'Referral Program'**
  String get referralProgram;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @invitedUsers.
  ///
  /// In en, this message translates to:
  /// **'Invited Users'**
  String get invitedUsers;

  /// No description provided for @totalProfit.
  ///
  /// In en, this message translates to:
  /// **'Total Profit'**
  String get totalProfit;

  /// No description provided for @earnedProfit.
  ///
  /// In en, this message translates to:
  /// **'Earned Profit'**
  String get earnedProfit;

  /// No description provided for @withdrawnProfit.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn Profit'**
  String get withdrawnProfit;

  /// No description provided for @confirm_delete_account.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get confirm_delete_account;

  /// No description provided for @faq_how_it_works_title.
  ///
  /// In en, this message translates to:
  /// **'How does the Carting service work?'**
  String get faq_how_it_works_title;

  /// No description provided for @faq_how_it_works_desc.
  ///
  /// In en, this message translates to:
  /// **'After placing an order, the nearest driver will pick up and deliver your cargo to the specified address.'**
  String get faq_how_it_works_desc;

  /// No description provided for @faq_payment_methods_title.
  ///
  /// In en, this message translates to:
  /// **'What payment methods are available?'**
  String get faq_payment_methods_title;

  /// No description provided for @faq_payment_methods_desc.
  ///
  /// In en, this message translates to:
  /// **'Our service accepts payments in cash, by bank cards, and through payment systems.'**
  String get faq_payment_methods_desc;

  /// No description provided for @faq_pricing_title.
  ///
  /// In en, this message translates to:
  /// **'How are shipping costs calculated?'**
  String get faq_pricing_title;

  /// No description provided for @faq_pricing_desc.
  ///
  /// In en, this message translates to:
  /// **'The cost depends on the distance, weight, and volume of the cargo. The final amount will be displayed at the time of order placement.'**
  String get faq_pricing_desc;

  /// No description provided for @faq_referral_title.
  ///
  /// In en, this message translates to:
  /// **'How much reward can a user get for inviting others?'**
  String get faq_referral_title;

  /// No description provided for @faq_referral_desc.
  ///
  /// In en, this message translates to:
  /// **'If you send your referral link, and a new user registers through it and pays for a service in the app, you will receive 0.15% of the service cost as a reward.'**
  String get faq_referral_desc;

  /// No description provided for @faq_login_title.
  ///
  /// In en, this message translates to:
  /// **'What do you need to log in to the app?'**
  String get faq_login_title;

  /// No description provided for @faq_login_desc.
  ///
  /// In en, this message translates to:
  /// **'Logging into the Carting app is very easy. Simply enter your phone number or email address. A login code will be sent via SMS or email.'**
  String get faq_login_desc;

  /// No description provided for @about_us_title.
  ///
  /// In en, this message translates to:
  /// **'Carting – Your Reliable Transport Partner!'**
  String get about_us_title;

  /// No description provided for @about_us_desc.
  ///
  /// In en, this message translates to:
  /// **'Carting is a modern platform for convenient, fast, and reliable management of freight transportation and logistics services. We ensure secure delivery, easy order processing, and quick onboarding of verified service providers.'**
  String get about_us_desc;

  /// No description provided for @about_us_why_title.
  ///
  /// In en, this message translates to:
  /// **'Why Choose Carting?'**
  String get about_us_why_title;

  /// No description provided for @about_us_why_points.
  ///
  /// In en, this message translates to:
  /// **'✅ Convenient and fast order processing – just a few steps in the app. ✅ Verified professionals – reliable specialists ensure safe delivery. ✅ Transparent pricing – no hidden fees, only fair prices. ✅ 24/7 support – always available to assist you.'**
  String get about_us_why_points;

  /// No description provided for @about_us_slogan.
  ///
  /// In en, this message translates to:
  /// **'Wherever you go – your cargo is in safe hands!'**
  String get about_us_slogan;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language!'**
  String get select_language;

  /// No description provided for @terms_of_use.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get terms_of_use;

  /// No description provided for @agree_to.
  ///
  /// In en, this message translates to:
  /// **' i agree to'**
  String get agree_to;

  /// No description provided for @via_phone.
  ///
  /// In en, this message translates to:
  /// **'Via phone number'**
  String get via_phone;

  /// No description provided for @via_email.
  ///
  /// In en, this message translates to:
  /// **'Via email'**
  String get via_email;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @no_service_ads.
  ///
  /// In en, this message translates to:
  /// **'No service announcements and\ndrivers available'**
  String get no_service_ads;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm_delete_code.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the code?'**
  String get confirm_delete_code;

  /// No description provided for @confirm_save_referral_changes.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to save changes to the referral code description?'**
  String get confirm_save_referral_changes;

  /// No description provided for @send_time.
  ///
  /// In en, this message translates to:
  /// **'Send Time'**
  String get send_time;

  /// No description provided for @enter_info.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter_info;

  /// No description provided for @nothing_found.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get nothing_found;

  /// No description provided for @mapdan.
  ///
  /// In en, this message translates to:
  /// **'From the map'**
  String get mapdan;

  /// No description provided for @workshops.
  ///
  /// In en, this message translates to:
  /// **'Workshops'**
  String get workshops;

  /// No description provided for @masters.
  ///
  /// In en, this message translates to:
  /// **'Masters'**
  String get masters;

  /// No description provided for @special_equipment.
  ///
  /// In en, this message translates to:
  /// **'Special Equipment'**
  String get special_equipment;

  /// No description provided for @select_location.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get select_location;

  /// No description provided for @from_date.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get from_date;

  /// No description provided for @to_date.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get to_date;

  /// No description provided for @household_appliances.
  ///
  /// In en, this message translates to:
  /// **'Household appliances'**
  String get household_appliances;

  /// No description provided for @construction_materials.
  ///
  /// In en, this message translates to:
  /// **'Construction materials'**
  String get construction_materials;

  /// No description provided for @food_products.
  ///
  /// In en, this message translates to:
  /// **'Food products'**
  String get food_products;

  /// No description provided for @agricultural_products.
  ///
  /// In en, this message translates to:
  /// **'Agricultural products'**
  String get agricultural_products;

  /// No description provided for @medical_equipment.
  ///
  /// In en, this message translates to:
  /// **'Medical equipment'**
  String get medical_equipment;

  /// No description provided for @moving_furniture.
  ///
  /// In en, this message translates to:
  /// **'Moving furniture (home/office)'**
  String get moving_furniture;

  /// No description provided for @animal_transportation.
  ///
  /// In en, this message translates to:
  /// **'Animal transportation'**
  String get animal_transportation;

  /// No description provided for @ad_accepted.
  ///
  /// In en, this message translates to:
  /// **'Your ad has been accepted'**
  String get ad_accepted;

  /// No description provided for @driver_will_contact.
  ///
  /// In en, this message translates to:
  /// **'The driver will contact you shortly'**
  String get driver_will_contact;

  /// No description provided for @my_vehicles.
  ///
  /// In en, this message translates to:
  /// **'My vehicles'**
  String get my_vehicles;

  /// No description provided for @connection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connection;

  /// No description provided for @search_ad.
  ///
  /// In en, this message translates to:
  /// **'Search Ad'**
  String get search_ad;

  /// No description provided for @ad_count.
  ///
  /// In en, this message translates to:
  /// **'Number of Ads'**
  String get ad_count;

  /// No description provided for @piece.
  ///
  /// In en, this message translates to:
  /// **'pcs'**
  String get piece;

  /// No description provided for @search_transport.
  ///
  /// In en, this message translates to:
  /// **'Search Transport'**
  String get search_transport;

  /// No description provided for @transport_number.
  ///
  /// In en, this message translates to:
  /// **'Transport Number'**
  String get transport_number;

  /// No description provided for @manufacture_year.
  ///
  /// In en, this message translates to:
  /// **'Year of Manufacture'**
  String get manufacture_year;

  /// No description provided for @tech_passport.
  ///
  /// In en, this message translates to:
  /// **'Technical Passport Series and Number'**
  String get tech_passport;

  /// No description provided for @shipment_date_time.
  ///
  /// In en, this message translates to:
  /// **'Shipment Date and Time'**
  String get shipment_date_time;

  /// No description provided for @payment_type.
  ///
  /// In en, this message translates to:
  /// **'Payment Type'**
  String get payment_type;

  /// No description provided for @price_offer.
  ///
  /// In en, this message translates to:
  /// **'Price Offer'**
  String get price_offer;

  /// No description provided for @continue_info.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_info;

  /// No description provided for @transport_info.
  ///
  /// In en, this message translates to:
  /// **'Transport Information'**
  String get transport_info;

  /// No description provided for @add_transport.
  ///
  /// In en, this message translates to:
  /// **'Add Transport'**
  String get add_transport;

  /// No description provided for @transport_number_plate.
  ///
  /// In en, this message translates to:
  /// **'Transport License Plate'**
  String get transport_number_plate;

  /// No description provided for @your_transports_here.
  ///
  /// In en, this message translates to:
  /// **'Your transports will be here.\nAdd them.'**
  String get your_transports_here;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @maxLoadCapacity.
  ///
  /// In en, this message translates to:
  /// **'Max Load Capacity'**
  String get maxLoadCapacity;

  /// No description provided for @maxPassengerCount.
  ///
  /// In en, this message translates to:
  /// **'Max Passenger Count'**
  String get maxPassengerCount;

  /// No description provided for @maxTransportCount.
  ///
  /// In en, this message translates to:
  /// **'Max Transport Count'**
  String get maxTransportCount;

  /// No description provided for @transportImages.
  ///
  /// In en, this message translates to:
  /// **'Transport Images'**
  String get transportImages;

  /// No description provided for @additionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInfo;

  /// No description provided for @confirm_delete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get confirm_delete;

  /// No description provided for @edit_advertisement.
  ///
  /// In en, this message translates to:
  /// **'Edit Advertisement'**
  String get edit_advertisement;

  /// No description provided for @attach_image.
  ///
  /// In en, this message translates to:
  /// **'Attach Image'**
  String get attach_image;

  /// No description provided for @warehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get warehouse;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @from_in.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get from_in;

  /// No description provided for @to_in.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to_in;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @understood.
  ///
  /// In en, this message translates to:
  /// **'Understood'**
  String get understood;

  /// No description provided for @company_list.
  ///
  /// In en, this message translates to:
  /// **'Company list'**
  String get company_list;

  /// No description provided for @fuel_type.
  ///
  /// In en, this message translates to:
  /// **'Fuel type'**
  String get fuel_type;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @soonClientsMessage.
  ///
  /// In en, this message translates to:
  /// **'Soon, clients in your area of expertise will contact you.'**
  String get soonClientsMessage;

  /// No description provided for @confirmCodePhone.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a confirmation code to {phone}. Please enter the mobile code in the field below.'**
  String confirmCodePhone(Object phone);

  /// No description provided for @confirmCodeEmail.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a confirmation code to {email}. Please enter the email code in the field below.'**
  String confirmCodeEmail(Object email);

  /// No description provided for @offerByPrice.
  ///
  /// In en, this message translates to:
  /// **'Make an offer by price'**
  String get offerByPrice;

  /// No description provided for @pickImage.
  ///
  /// In en, this message translates to:
  /// **'Pick Image'**
  String get pickImage;

  /// No description provided for @fromCamera.
  ///
  /// In en, this message translates to:
  /// **'Take from Camera'**
  String get fromCamera;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get fromGallery;

  /// No description provided for @unit_kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unit_kg;

  /// No description provided for @unit_tn.
  ///
  /// In en, this message translates to:
  /// **'tn'**
  String get unit_tn;

  /// No description provided for @unit_m3.
  ///
  /// In en, this message translates to:
  /// **'m3'**
  String get unit_m3;

  /// No description provided for @sendProposal.
  ///
  /// In en, this message translates to:
  /// **'Send proposal'**
  String get sendProposal;

  /// No description provided for @sendProposalForAd.
  ///
  /// In en, this message translates to:
  /// **'Send proposal for ad'**
  String get sendProposalForAd;

  /// No description provided for @sendProposalForDriver.
  ///
  /// In en, this message translates to:
  /// **'Send proposal for driver'**
  String get sendProposalForDriver;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @postedToday.
  ///
  /// In en, this message translates to:
  /// **'Posted today'**
  String get postedToday;

  /// No description provided for @postedYesterday.
  ///
  /// In en, this message translates to:
  /// **'Posted yesterday'**
  String get postedYesterday;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;
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
      <String>['en', 'kk', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
