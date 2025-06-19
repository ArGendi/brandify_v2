import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appSlogan.
  ///
  /// In en, this message translates to:
  /// **'Manage inventory, track sales, and grow your business with ease'**
  String get appSlogan;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @brandName.
  ///
  /// In en, this message translates to:
  /// **'Brand Name'**
  String get brandName;

  /// No description provided for @brandNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Brand name is required'**
  String get brandNameRequired;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @minPassword.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get minPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! It happens. Please enter the email address associated with your account.'**
  String get forgotPasswordDesc;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent! Check your inbox.'**
  String get resetEmailSent;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone'**
  String get enterPhone;

  /// No description provided for @enterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone'**
  String get enterValidPhone;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get createAccount;

  /// No description provided for @packageInfo.
  ///
  /// In en, this message translates to:
  /// **'Package Information'**
  String get packageInfo;

  /// No description provided for @currentPackage.
  ///
  /// In en, this message translates to:
  /// **'Current Package'**
  String get currentPackage;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @basicFeatures.
  ///
  /// In en, this message translates to:
  /// **'Basic offline features'**
  String get basicFeatures;

  /// No description provided for @fullFeatures.
  ///
  /// In en, this message translates to:
  /// **'Full online features with cloud storage'**
  String get fullFeatures;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account'**
  String get deleteAccountDesc;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data will be permanently deleted.'**
  String get deleteConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @changesSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully'**
  String get changesSaved;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save changes'**
  String get saveFailed;

  /// No description provided for @manageAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage your account details'**
  String get manageAccount;

  /// No description provided for @changePackage.
  ///
  /// In en, this message translates to:
  /// **'Change Package'**
  String get changePackage;

  /// No description provided for @upgradePlan.
  ///
  /// In en, this message translates to:
  /// **'Upgrade or change your current plan'**
  String get upgradePlan;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change application language'**
  String get changeLanguage;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @getSupport.
  ///
  /// In en, this message translates to:
  /// **'Get help from our support team'**
  String get getSupport;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @convert.
  ///
  /// In en, this message translates to:
  /// **'Convert'**
  String get convert;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @alreadyOnline.
  ///
  /// In en, this message translates to:
  /// **'You are already in online package ✌️'**
  String get alreadyOnline;

  /// No description provided for @phoneEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get phoneEmpty;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 11 digits'**
  String get phoneInvalid;

  /// No description provided for @passwordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordEmpty;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @startJourney.
  ///
  /// In en, this message translates to:
  /// **'Start Your Business Journey'**
  String get startJourney;

  /// No description provided for @createAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Create your account and unlock powerful business tools'**
  String get createAccountDesc;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Password doesn\'t match'**
  String get passwordMismatch;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @selectPreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Your Preferred Language'**
  String get selectPreferredLanguage;

  /// No description provided for @languageSelectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose the language you\'re most comfortable with'**
  String get languageSelectionDesc;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @welcomeToBrandify.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Brandify'**
  String get welcomeToBrandify;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your business efficiently with our comprehensive suite of tools'**
  String get welcomeDescription;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Let\'s make more money,'**
  String get welcomeBack;

  /// No description provided for @totalSales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get totalSales;

  /// No description provided for @profit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get profit;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @manageInventory.
  ///
  /// In en, this message translates to:
  /// **'Start add your products & manage your inventory'**
  String get manageInventory;

  /// No description provided for @orderExpenses.
  ///
  /// In en, this message translates to:
  /// **'Order Expenses'**
  String get orderExpenses;

  /// No description provided for @addOrderExpense.
  ///
  /// In en, this message translates to:
  /// **'Add New Expense'**
  String get addOrderExpense;

  /// No description provided for @emptyOrderExpensesDesc.
  ///
  /// In en, this message translates to:
  /// **'Add your packaging items such as order bag, order box, stickers, etc..'**
  String get emptyOrderExpensesDesc;

  /// No description provided for @expenseName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get expenseName;

  /// No description provided for @expenseNameHint.
  ///
  /// In en, this message translates to:
  /// **'Ex. Order package'**
  String get expenseNameHint;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterName;

  /// No description provided for @pricePerItem.
  ///
  /// In en, this message translates to:
  /// **'Price per item'**
  String get pricePerItem;

  /// No description provided for @priceHint.
  ///
  /// In en, this message translates to:
  /// **'Ex. 20 (LE)'**
  String get priceHint;

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get enterPrice;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity (required)'**
  String get quantity;

  /// No description provided for @quantityHint.
  ///
  /// In en, this message translates to:
  /// **'Ex. 100 (pieces)'**
  String get quantityHint;

  /// No description provided for @enterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity sold?'**
  String get enterQuantity;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'{amount} LE'**
  String currency(Object amount);

  /// No description provided for @additionalOrderCosts.
  ///
  /// In en, this message translates to:
  /// **'Additional costs in most of your orders'**
  String get additionalOrderCosts;

  /// No description provided for @ads.
  ///
  /// In en, this message translates to:
  /// **'Ad Expenses'**
  String get ads;

  /// No description provided for @manageCampaigns.
  ///
  /// In en, this message translates to:
  /// **'Manage all campaigns to track your costs'**
  String get manageCampaigns;

  /// No description provided for @externalExpenses.
  ///
  /// In en, this message translates to:
  /// **'External Expenses'**
  String get externalExpenses;

  /// No description provided for @otherExpenses.
  ///
  /// In en, this message translates to:
  /// **'All external expenses but related to your business'**
  String get otherExpenses;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @productsTab.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsTab;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @loadingReports.
  ///
  /// In en, this message translates to:
  /// **'Loading Reports...'**
  String get loadingReports;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @sevenDays.
  ///
  /// In en, this message translates to:
  /// **'7 Days'**
  String get sevenDays;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @threeMonths.
  ///
  /// In en, this message translates to:
  /// **'3 Months'**
  String get threeMonths;

  /// No description provided for @customRange.
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get customRange;

  /// No description provided for @selectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Select Start Date'**
  String get selectStartDate;

  /// No description provided for @selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Select End Date'**
  String get selectEndDate;

  /// No description provided for @generateReport.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get generateReport;

  /// No description provided for @productsInventory.
  ///
  /// In en, this message translates to:
  /// **'Products Inventory'**
  String get productsInventory;

  /// No description provided for @noProductsYet.
  ///
  /// In en, this message translates to:
  /// **'No products yet. Add your first product!'**
  String get noProductsYet;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get searchProducts;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @enterProductName.
  ///
  /// In en, this message translates to:
  /// **'Enter product name'**
  String get enterProductName;

  /// No description provided for @productPrice.
  ///
  /// In en, this message translates to:
  /// **'Product Price'**
  String get productPrice;

  /// No description provided for @enterProductPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter product price'**
  String get enterProductPrice;

  /// No description provided for @productCost.
  ///
  /// In en, this message translates to:
  /// **'Product Cost'**
  String get productCost;

  /// No description provided for @enterProductCost.
  ///
  /// In en, this message translates to:
  /// **'Enter product cost'**
  String get enterProductCost;

  /// No description provided for @productQuantity.
  ///
  /// In en, this message translates to:
  /// **'Product Quantity'**
  String get productQuantity;

  /// No description provided for @enterProductQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter product quantity'**
  String get enterProductQuantity;

  /// No description provided for @productBarcode.
  ///
  /// In en, this message translates to:
  /// **'Product Barcode'**
  String get productBarcode;

  /// No description provided for @enterProductBarcode.
  ///
  /// In en, this message translates to:
  /// **'Enter product barcode'**
  String get enterProductBarcode;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcode;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @priceAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} EGP'**
  String priceAmount(Object amount);

  /// No description provided for @productSalesTitle.
  ///
  /// In en, this message translates to:
  /// **'{productName} sales'**
  String productSalesTitle(Object productName);

  /// No description provided for @dateRangeFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter by date range'**
  String get dateRangeFilter;

  /// No description provided for @noSalesInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No sales found for this period'**
  String get noSalesInPeriod;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity: {count}'**
  String quantityLabel(Object count);

  /// No description provided for @sizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Size: {sizeName}'**
  String sizeLabel(Object sizeName);

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @selectedDateRange.
  ///
  /// In en, this message translates to:
  /// **'{startDate} - {endDate}'**
  String selectedDateRange(Object endDate, Object startDate);

  /// No description provided for @clearDateFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear date filter'**
  String get clearDateFilter;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get viewHistory;

  /// No description provided for @itemsInStockCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String itemsInStockCount(Object count);

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total {amount} EGP'**
  String totalAmount(Object amount);

  /// No description provided for @productDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get productDescription;

  /// No description provided for @availableSizes.
  ///
  /// In en, this message translates to:
  /// **'Available Sizes'**
  String get availableSizes;

  /// No description provided for @sellNowButton.
  ///
  /// In en, this message translates to:
  /// **'Sell Now'**
  String get sellNowButton;

  /// No description provided for @refundButton.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get refundButton;

  /// No description provided for @noItemsInStock.
  ///
  /// In en, this message translates to:
  /// **'No items in stock'**
  String get noItemsInStock;

  /// No description provided for @deleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get deleteProduct;

  /// No description provided for @deleteProductConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this product?'**
  String get deleteProductConfirm;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @shopifyPrice.
  ///
  /// In en, this message translates to:
  /// **'Shopify Price*'**
  String get shopifyPrice;

  /// No description provided for @shopifyPriceRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter shopify price'**
  String get shopifyPriceRequired;

  /// No description provided for @addAnotherSize.
  ///
  /// In en, this message translates to:
  /// **'Add another size'**
  String get addAnotherSize;

  /// No description provided for @anotherSize.
  ///
  /// In en, this message translates to:
  /// **'the other size'**
  String get anotherSize;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @editButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButton;

  /// No description provided for @photosButton.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photosButton;

  /// No description provided for @cameraButton.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraButton;

  /// No description provided for @originalPrice.
  ///
  /// In en, this message translates to:
  /// **'Cost Price (required)'**
  String get originalPrice;

  /// No description provided for @priceRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get priceRequired;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get nameRequired;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name (required)'**
  String get nameLabel;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell 🤑'**
  String get sell;

  /// No description provided for @sellPricePerItem.
  ///
  /// In en, this message translates to:
  /// **'Sell price per item'**
  String get sellPricePerItem;

  /// No description provided for @whereSell.
  ///
  /// In en, this message translates to:
  /// **'Where did you sell it?'**
  String get whereSell;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @productSells.
  ///
  /// In en, this message translates to:
  /// **'{productName} sells'**
  String productSells(Object productName);

  /// No description provided for @filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by Date'**
  String get filterByDate;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @clearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get clearFilter;

  /// No description provided for @noSells.
  ///
  /// In en, this message translates to:
  /// **'No sells for this product'**
  String get noSells;

  /// No description provided for @discountCalculator.
  ///
  /// In en, this message translates to:
  /// **'Discount Calculator'**
  String get discountCalculator;

  /// No description provided for @priceAfterDiscount.
  ///
  /// In en, this message translates to:
  /// **'Price After Discount'**
  String get priceAfterDiscount;

  /// No description provided for @originalPriceWithThePrice.
  ///
  /// In en, this message translates to:
  /// **'Original Price: {price} EGP'**
  String originalPriceWithThePrice(Object price);

  /// No description provided for @calculateDiscount.
  ///
  /// In en, this message translates to:
  /// **'Calculate Discount'**
  String get calculateDiscount;

  /// No description provided for @enterPriceAndDiscount.
  ///
  /// In en, this message translates to:
  /// **'Enter product price and discount percentage'**
  String get enterPriceAndDiscount;

  /// No description provided for @discountPercent.
  ///
  /// In en, this message translates to:
  /// **'Discount %'**
  String get discountPercent;

  /// No description provided for @enterPercent.
  ///
  /// In en, this message translates to:
  /// **'Enter percent'**
  String get enterPercent;

  /// No description provided for @calculateDiscountButton.
  ///
  /// In en, this message translates to:
  /// **'Calculate Discount'**
  String get calculateDiscountButton;

  /// No description provided for @chooseSize.
  ///
  /// In en, this message translates to:
  /// **'Which sizes do you sell?'**
  String get chooseSize;

  /// No description provided for @chooseOrderExpenses.
  ///
  /// In en, this message translates to:
  /// **'Did you use any packaging items?'**
  String get chooseOrderExpenses;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @noExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet.'**
  String get noExpensesYet;

  /// No description provided for @noExpensesDesc.
  ///
  /// In en, this message translates to:
  /// **'Add any external expenses that cost your business such as electricity bill, employee wages, meeting expense, etc...'**
  String get noExpensesDesc;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get totalExpenses;

  /// No description provided for @expensesSummary.
  ///
  /// In en, this message translates to:
  /// **'Expenses Summary'**
  String get expensesSummary;

  /// No description provided for @failedToGeneratePdf.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate PDF'**
  String get failedToGeneratePdf;

  /// No description provided for @sortExpenses.
  ///
  /// In en, this message translates to:
  /// **'Sort Expenses'**
  String get sortExpenses;

  /// No description provided for @highestPrice.
  ///
  /// In en, this message translates to:
  /// **'Highest Price'**
  String get highestPrice;

  /// No description provided for @lowestPrice.
  ///
  /// In en, this message translates to:
  /// **'Lowest Price'**
  String get lowestPrice;

  /// No description provided for @advertising.
  ///
  /// In en, this message translates to:
  /// **'Advertising'**
  String get advertising;

  /// No description provided for @noAdsYet.
  ///
  /// In en, this message translates to:
  /// **'No Ads Yet'**
  String get noAdsYet;

  /// No description provided for @noAdsDesc.
  ///
  /// In en, this message translates to:
  /// **'Add the ads you created in social media platforms.'**
  String get noAdsDesc;

  /// No description provided for @newAd.
  ///
  /// In en, this message translates to:
  /// **'New Ad'**
  String get newAd;

  /// No description provided for @deleteAdvertisement.
  ///
  /// In en, this message translates to:
  /// **'Delete Advertisement'**
  String get deleteAdvertisement;

  /// No description provided for @deleteAdConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this ad?'**
  String get deleteAdConfirm;

  /// No description provided for @advertisementDetails.
  ///
  /// In en, this message translates to:
  /// **'Advertisement Details'**
  String get advertisementDetails;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @adCost.
  ///
  /// In en, this message translates to:
  /// **'Ad cost (required)'**
  String get adCost;

  /// No description provided for @enterAdCost.
  ///
  /// In en, this message translates to:
  /// **'Enter ad cost'**
  String get enterAdCost;

  /// No description provided for @yourAdPlatform.
  ///
  /// In en, this message translates to:
  /// **'Your ad platform?'**
  String get yourAdPlatform;

  /// No description provided for @switchPackageConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to switch to {type} package?'**
  String switchPackageConfirm(String type);

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @salesDistribution.
  ///
  /// In en, this message translates to:
  /// **'Sales Distribution'**
  String get salesDistribution;

  /// No description provided for @showHighestProducts.
  ///
  /// In en, this message translates to:
  /// **'Show highest products'**
  String get showHighestProducts;

  /// No description provided for @startSellingToSeeResults.
  ///
  /// In en, this message translates to:
  /// **'Start selling to see results'**
  String get startSellingToSeeResults;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @expenseDetails.
  ///
  /// In en, this message translates to:
  /// **'Expense Details'**
  String get expenseDetails;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @salesReport.
  ///
  /// In en, this message translates to:
  /// **'Sales Report'**
  String get salesReport;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get metric;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @productsSummary.
  ///
  /// In en, this message translates to:
  /// **'Products Summary'**
  String get productsSummary;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @quantitySold.
  ///
  /// In en, this message translates to:
  /// **'Quantity Sold'**
  String get quantitySold;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @generatedByBrandify.
  ///
  /// In en, this message translates to:
  /// **'Generated by Brandify on {date}'**
  String generatedByBrandify(String date);

  /// No description provided for @choosePackage.
  ///
  /// In en, this message translates to:
  /// **'Choose Package'**
  String get choosePackage;

  /// No description provided for @selectYourPackage.
  ///
  /// In en, this message translates to:
  /// **'Select Your Package'**
  String get selectYourPackage;

  /// No description provided for @changePackageLater.
  ///
  /// In en, this message translates to:
  /// **'You can change your package at any time'**
  String get changePackageLater;

  /// No description provided for @offlinePackage.
  ///
  /// In en, this message translates to:
  /// **'Offline Package'**
  String get offlinePackage;

  /// No description provided for @offlinePackageDesc.
  ///
  /// In en, this message translates to:
  /// **'Store data locally on your device'**
  String get offlinePackageDesc;

  /// No description provided for @workWithoutInternet.
  ///
  /// In en, this message translates to:
  /// **'Work without internet'**
  String get workWithoutInternet;

  /// No description provided for @localDataStorage.
  ///
  /// In en, this message translates to:
  /// **'Local data storage'**
  String get localDataStorage;

  /// No description provided for @basicReporting.
  ///
  /// In en, this message translates to:
  /// **'Basic reporting'**
  String get basicReporting;

  /// No description provided for @unlimitedProducts.
  ///
  /// In en, this message translates to:
  /// **'Unlimited products'**
  String get unlimitedProducts;

  /// No description provided for @onlinePackage.
  ///
  /// In en, this message translates to:
  /// **'Online Package'**
  String get onlinePackage;

  /// No description provided for @onlinePackageDesc.
  ///
  /// In en, this message translates to:
  /// **'Cloud storage with advanced features'**
  String get onlinePackageDesc;

  /// No description provided for @cloudDataStorage.
  ///
  /// In en, this message translates to:
  /// **'Cloud data storage'**
  String get cloudDataStorage;

  /// No description provided for @multiDeviceSync.
  ///
  /// In en, this message translates to:
  /// **'Multi-device sync'**
  String get multiDeviceSync;

  /// No description provided for @advancedReporting.
  ///
  /// In en, this message translates to:
  /// **'Advanced reporting'**
  String get advancedReporting;

  /// No description provided for @dataBackup.
  ///
  /// In en, this message translates to:
  /// **'Data backup'**
  String get dataBackup;

  /// No description provided for @shopifyPackage.
  ///
  /// In en, this message translates to:
  /// **'Shopify Package'**
  String get shopifyPackage;

  /// No description provided for @shopifyPackageDesc.
  ///
  /// In en, this message translates to:
  /// **'Full integration with Shopify (Coming Soon)'**
  String get shopifyPackageDesc;

  /// No description provided for @shopifyIntegration.
  ///
  /// In en, this message translates to:
  /// **'Shopify integration'**
  String get shopifyIntegration;

  /// No description provided for @inventorySync.
  ///
  /// In en, this message translates to:
  /// **'Inventory sync'**
  String get inventorySync;

  /// No description provided for @orderManagement.
  ///
  /// In en, this message translates to:
  /// **'Order management'**
  String get orderManagement;

  /// No description provided for @allOnlineFeatures.
  ///
  /// In en, this message translates to:
  /// **'All online features'**
  String get allOnlineFeatures;

  /// No description provided for @confirmPackage.
  ///
  /// In en, this message translates to:
  /// **'Confirm Package'**
  String get confirmPackage;

  /// No description provided for @confirmPackageSelection.
  ///
  /// In en, this message translates to:
  /// **'Do you want to select the {title}?'**
  String confirmPackageSelection(String title);

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'This package will be available soon!'**
  String get comingSoon;

  /// No description provided for @bestSellingProducts.
  ///
  /// In en, this message translates to:
  /// **'Best Selling Products'**
  String get bestSellingProducts;

  /// No description provided for @productsSortedBy.
  ///
  /// In en, this message translates to:
  /// **'Products sorted by {sortBy}'**
  String productsSortedBy(String sortBy);

  /// No description provided for @noProductsAddNow.
  ///
  /// In en, this message translates to:
  /// **'No products, Add now'**
  String get noProductsAddNow;

  /// No description provided for @sortProductsBy.
  ///
  /// In en, this message translates to:
  /// **'Sort Products By'**
  String get sortProductsBy;

  /// No description provided for @sortByQuantity.
  ///
  /// In en, this message translates to:
  /// **'Sort by Quantity'**
  String get sortByQuantity;

  /// No description provided for @sortByProfit.
  ///
  /// In en, this message translates to:
  /// **'Sort By Profit'**
  String get sortByProfit;

  /// No description provided for @bestSellingProductsReport.
  ///
  /// In en, this message translates to:
  /// **'Best Selling Products Report'**
  String get bestSellingProductsReport;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period: {startDate} to {endDate}'**
  String period(String startDate, String endDate);

  /// No description provided for @unnamedProduct.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Product'**
  String get unnamedProduct;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @selectOrders.
  ///
  /// In en, this message translates to:
  /// **'Select Orders'**
  String get selectOrders;

  /// No description provided for @totalProfit.
  ///
  /// In en, this message translates to:
  /// **'Total Profit'**
  String get totalProfit;

  /// No description provided for @ordersFromTo.
  ///
  /// In en, this message translates to:
  /// **'Orders from {startDate} to {endDate}'**
  String ordersFromTo(String startDate, String endDate);

  /// No description provided for @createReceipt.
  ///
  /// In en, this message translates to:
  /// **'Create Receipt'**
  String get createReceipt;

  /// No description provided for @highestProfit.
  ///
  /// In en, this message translates to:
  /// **'Highest Profit'**
  String get highestProfit;

  /// No description provided for @lowestProfit.
  ///
  /// In en, this message translates to:
  /// **'Lowest Profit'**
  String get lowestProfit;

  /// No description provided for @refund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get refund;

  /// No description provided for @ordersReceipt.
  ///
  /// In en, this message translates to:
  /// **'Orders Receipt'**
  String get ordersReceipt;

  /// No description provided for @orderDate.
  ///
  /// In en, this message translates to:
  /// **'Order Date'**
  String get orderDate;

  /// No description provided for @refunded.
  ///
  /// In en, this message translates to:
  /// **'REFUNDED'**
  String get refunded;

  /// No description provided for @totalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get totalOrders;

  /// No description provided for @fromBrandify.
  ///
  /// In en, this message translates to:
  /// **'From {brandName} on {date}'**
  String fromBrandify(String brandName, String date);

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed: {error}'**
  String loginFailed(String error);

  /// No description provided for @failedToLoadUserData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load user data'**
  String get failedToLoadUserData;

  /// No description provided for @errorLoadingUserData.
  ///
  /// In en, this message translates to:
  /// **'Error loading user data: {error}'**
  String errorLoadingUserData(String error);

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error: {error}'**
  String unexpectedError(String error);

  /// No description provided for @invalidStoreConfig.
  ///
  /// In en, this message translates to:
  /// **'Invalid store configuration'**
  String get invalidStoreConfig;

  /// No description provided for @couldNotGetUserData.
  ///
  /// In en, this message translates to:
  /// **'Could not get user data, please login again'**
  String get couldNotGetUserData;

  /// No description provided for @failedToGetUserData.
  ///
  /// In en, this message translates to:
  /// **'Failed to get user data from the internet'**
  String get failedToGetUserData;

  /// No description provided for @errorProcessingExpense.
  ///
  /// In en, this message translates to:
  /// **'Error processing expense data: {error}'**
  String errorProcessingExpense(String error);

  /// No description provided for @successfullyConvertedToOnline.
  ///
  /// In en, this message translates to:
  /// **'Successfully converted to online package'**
  String get successfullyConvertedToOnline;

  /// No description provided for @failedToUploadData.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload data to online storage'**
  String get failedToUploadData;

  /// No description provided for @successfullyConvertedToOffline.
  ///
  /// In en, this message translates to:
  /// **'Successfully converted to offline package'**
  String get successfullyConvertedToOffline;

  /// No description provided for @egp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egp;

  /// No description provided for @numberOfSales.
  ///
  /// In en, this message translates to:
  /// **'Number of sales'**
  String get numberOfSales;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total income'**
  String get totalIncome;

  /// No description provided for @extraExpenses.
  ///
  /// In en, this message translates to:
  /// **'Extra expenses'**
  String get extraExpenses;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noDataToShow.
  ///
  /// In en, this message translates to:
  /// **'No data to show'**
  String get noDataToShow;

  /// No description provided for @boughtByPlace.
  ///
  /// In en, this message translates to:
  /// **'Bought by place'**
  String get boughtByPlace;

  /// No description provided for @totalCostByPlatform.
  ///
  /// In en, this message translates to:
  /// **'Total Costs by Platform'**
  String get totalCostByPlatform;

  /// No description provided for @electricityExample.
  ///
  /// In en, this message translates to:
  /// **'ex: Electricity bill'**
  String get electricityExample;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// No description provided for @soldFor.
  ///
  /// In en, this message translates to:
  /// **'Sold for'**
  String get soldFor;

  /// No description provided for @sideExpensesCost.
  ///
  /// In en, this message translates to:
  /// **'Side expenses cost'**
  String get sideExpensesCost;

  /// No description provided for @sideExpensesAre.
  ///
  /// In en, this message translates to:
  /// **'Side expenses are'**
  String get sideExpensesAre;

  /// No description provided for @refundFailed.
  ///
  /// In en, this message translates to:
  /// **'Can\'t make the refund 😥'**
  String get refundFailed;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @viewYourSalesAndProfit.
  ///
  /// In en, this message translates to:
  /// **'View your total sales and profit'**
  String get viewYourSalesAndProfit;

  /// No description provided for @manageYourInventory.
  ///
  /// In en, this message translates to:
  /// **'Manage your product inventory'**
  String get manageYourInventory;

  /// No description provided for @manageOrderExpenses.
  ///
  /// In en, this message translates to:
  /// **'Track your order-related expenses'**
  String get manageOrderExpenses;

  /// No description provided for @manageYourAdCampaigns.
  ///
  /// In en, this message translates to:
  /// **'Manage your advertising campaigns'**
  String get manageYourAdCampaigns;

  /// No description provided for @manageOtherExpenses.
  ///
  /// In en, this message translates to:
  /// **'Track other business expenses'**
  String get manageOtherExpenses;

  /// No description provided for @statsCardsTutorial.
  ///
  /// In en, this message translates to:
  /// **'Track Your Business Performance'**
  String get statsCardsTutorial;

  /// No description provided for @statsCardsTutorialDesc.
  ///
  /// In en, this message translates to:
  /// **'Monitor your total sales and profit in real-time. Tap to view detailed reports.'**
  String get statsCardsTutorialDesc;

  /// No description provided for @quickActionsTutorial.
  ///
  /// In en, this message translates to:
  /// **'Quick Access to Essential Features'**
  String get quickActionsTutorial;

  /// No description provided for @quickActionsTutorialDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your products, expenses, and advertising campaigns with just one tap.'**
  String get quickActionsTutorialDesc;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @mandatoryFieldsNote.
  ///
  /// In en, this message translates to:
  /// **'Only name, original price & quantity are mandatory'**
  String get mandatoryFieldsNote;

  /// No description provided for @originalPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Cost price is the price you paid to get the product, not selling price'**
  String get originalPriceHint;

  /// No description provided for @pricePaidHint.
  ///
  /// In en, this message translates to:
  /// **'Price you paid for the product'**
  String get pricePaidHint;

  /// No description provided for @packagingStock.
  ///
  /// In en, this message translates to:
  /// **'Packaging Stock'**
  String get packagingStock;

  /// No description provided for @businessExpenses.
  ///
  /// In en, this message translates to:
  /// **'Business Expenses'**
  String get businessExpenses;

  /// No description provided for @enterAdDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the ad you\'ve already posted on social media'**
  String get enterAdDescription;

  /// No description provided for @enterAnyAdditionalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Enter any additional expenses'**
  String get enterAnyAdditionalExpenses;

  /// No description provided for @sellPriceQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is the price you sell the product for?'**
  String get sellPriceQuestion;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @chooseSizeMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose a size'**
  String get chooseSizeMessage;

  /// No description provided for @productOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Product is out of stock'**
  String get productOutOfStock;

  /// No description provided for @notEnoughQuantity.
  ///
  /// In en, this message translates to:
  /// **'Not enough quantity available (Only {quantity} left)'**
  String notEnoughQuantity(int quantity);

  /// No description provided for @failedToUpdateInventory.
  ///
  /// In en, this message translates to:
  /// **'Failed to update inventory'**
  String get failedToUpdateInventory;

  /// No description provided for @chooseSizeFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a size first'**
  String get chooseSizeFirst;

  /// No description provided for @notEnoughQuantityAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not enough quantity available'**
  String get notEnoughQuantityAvailable;

  /// No description provided for @addedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Added successfully'**
  String get addedSuccessfully;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Error occurred'**
  String get errorOccurred;

  /// No description provided for @refundError.
  ///
  /// In en, this message translates to:
  /// **'{error}'**
  String refundError(String error);

  /// No description provided for @tryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Try again later'**
  String get tryAgainLater;

  /// No description provided for @productDeleted.
  ///
  /// In en, this message translates to:
  /// **'Product Deleted'**
  String get productDeleted;

  /// No description provided for @productUpdated.
  ///
  /// In en, this message translates to:
  /// **'Product Updated 🤙'**
  String get productUpdated;

  /// No description provided for @errorUpdatingProduct.
  ///
  /// In en, this message translates to:
  /// **'Error Updating Product 😢'**
  String get errorUpdatingProduct;

  /// No description provided for @doesntExist.
  ///
  /// In en, this message translates to:
  /// **'Doesn\'t exist 🤔'**
  String get doesntExist;

  /// No description provided for @failedToDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account: {error}'**
  String failedToDeleteAccount(String error);

  /// No description provided for @failedToFetchProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch products: {error}'**
  String failedToFetchProducts(String error);

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @connectionTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out'**
  String get connectionTimedOut;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get accessDenied;

  /// No description provided for @selectDateFromAndToFirst.
  ///
  /// In en, this message translates to:
  /// **'Select date from and to first'**
  String get selectDateFromAndToFirst;

  /// No description provided for @failedToSaveTransaction.
  ///
  /// In en, this message translates to:
  /// **'Failed to save transaction'**
  String get failedToSaveTransaction;

  /// No description provided for @unexpectedErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred'**
  String get unexpectedErrorOccurred;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
