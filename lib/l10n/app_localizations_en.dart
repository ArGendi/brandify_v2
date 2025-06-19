// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appSlogan => 'Manage inventory, track sales, and grow your business with ease';

  @override
  String get settings => 'Settings';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get brandName => 'Brand Name';

  @override
  String get brandNameRequired => 'Brand name is required';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get invalidPhone => 'Invalid phone number';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get minPassword => 'Minimum 8 characters';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgotPasswordDesc => 'Don\'t worry! It happens. Please enter the email address associated with your account.';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetEmailSent => 'Password reset email sent! Check your inbox.';

  @override
  String get enterPhone => 'Please enter your phone';

  @override
  String get enterValidPhone => 'Please enter a valid phone';

  @override
  String get login => 'Login';

  @override
  String get createAccount => 'Create new account';

  @override
  String get packageInfo => 'Package Information';

  @override
  String get currentPackage => 'Current Package';

  @override
  String get features => 'Features';

  @override
  String get basicFeatures => 'Basic offline features';

  @override
  String get fullFeatures => 'Full online features with cloud storage';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountDesc => 'Permanently delete your account';

  @override
  String get deleteConfirmTitle => 'Delete Account';

  @override
  String get deleteConfirmMessage => 'This action cannot be undone. All your data will be permanently deleted.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get changesSaved => 'Changes saved successfully';

  @override
  String get saveFailed => 'Failed to save changes';

  @override
  String get manageAccount => 'Manage your account details';

  @override
  String get changePackage => 'Change Package';

  @override
  String get upgradePlan => 'Upgrade or change your current plan';

  @override
  String get language => 'Language';

  @override
  String get changeLanguage => 'Change application language';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get getSupport => 'Get help from our support team';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get convert => 'Convert';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get alreadyOnline => 'You are already in online package ✌️';

  @override
  String get phoneEmpty => 'Please enter your phone number';

  @override
  String get phoneInvalid => 'Phone number must be 11 digits';

  @override
  String get passwordEmpty => 'Please enter your password';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get register => 'Register';

  @override
  String get startJourney => 'Start Your Business Journey';

  @override
  String get createAccountDesc => 'Create your account and unlock powerful business tools';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordMismatch => 'Password doesn\'t match';

  @override
  String get registerNow => 'Register Now';

  @override
  String get selectPreferredLanguage => 'Select Your Preferred Language';

  @override
  String get languageSelectionDesc => 'Choose the language you\'re most comfortable with';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get continueText => 'Continue';

  @override
  String get welcomeToBrandify => 'Welcome to Brandify';

  @override
  String get welcomeDescription => 'Manage your business efficiently with our comprehensive suite of tools';

  @override
  String get getStarted => 'Get Started';

  @override
  String get welcomeBack => 'Let\'s make more money,';

  @override
  String get totalSales => 'Total Sales';

  @override
  String get profit => 'Profit';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get products => 'Products';

  @override
  String get manageInventory => 'Start add your products & manage your inventory';

  @override
  String get orderExpenses => 'Order Expenses';

  @override
  String get addOrderExpense => 'Add New Expense';

  @override
  String get emptyOrderExpensesDesc => 'Add your packaging items such as order bag, order box, stickers, etc..';

  @override
  String get expenseName => 'Name';

  @override
  String get expenseNameHint => 'Ex. Order package';

  @override
  String get enterName => 'Enter name';

  @override
  String get pricePerItem => 'Price per item';

  @override
  String get priceHint => 'Ex. 20 (LE)';

  @override
  String get enterPrice => 'Enter price';

  @override
  String get quantity => 'Quantity (required)';

  @override
  String get quantityHint => 'Ex. 100 (pieces)';

  @override
  String get enterQuantity => 'Quantity sold?';

  @override
  String get add => 'Add';

  @override
  String currency(Object amount) {
    return '$amount LE';
  }

  @override
  String get additionalOrderCosts => 'Additional costs in most of your orders';

  @override
  String get ads => 'Ad Expenses';

  @override
  String get manageCampaigns => 'Manage all campaigns to track your costs';

  @override
  String get externalExpenses => 'External Expenses';

  @override
  String get otherExpenses => 'All external expenses but related to your business';

  @override
  String get home => 'Home';

  @override
  String get productsTab => 'Products';

  @override
  String get reports => 'Reports';

  @override
  String get loadingReports => 'Loading Reports...';

  @override
  String get today => 'Today';

  @override
  String get sevenDays => '7 Days';

  @override
  String get thisMonth => 'This Month';

  @override
  String get threeMonths => '3 Months';

  @override
  String get customRange => 'Custom Range';

  @override
  String get selectStartDate => 'Select Start Date';

  @override
  String get selectEndDate => 'Select End Date';

  @override
  String get generateReport => 'Generate Report';

  @override
  String get productsInventory => 'Products Inventory';

  @override
  String get noProductsYet => 'No products yet. Add your first product!';

  @override
  String get searchProducts => 'Search products...';

  @override
  String get addProduct => 'Add Product';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get productName => 'Product Name';

  @override
  String get enterProductName => 'Enter product name';

  @override
  String get productPrice => 'Product Price';

  @override
  String get enterProductPrice => 'Enter product price';

  @override
  String get productCost => 'Product Cost';

  @override
  String get enterProductCost => 'Enter product cost';

  @override
  String get productQuantity => 'Product Quantity';

  @override
  String get enterProductQuantity => 'Enter product quantity';

  @override
  String get productBarcode => 'Product Barcode';

  @override
  String get enterProductBarcode => 'Enter product barcode';

  @override
  String get scanBarcode => 'Scan Barcode';

  @override
  String get save => 'Save';

  @override
  String get update => 'Update';

  @override
  String get productDetails => 'Product Details';

  @override
  String get price => 'Price';

  @override
  String get cost => 'Cost';

  @override
  String get barcode => 'Barcode';

  @override
  String get inStock => 'In Stock';

  @override
  String get outOfStock => 'Out of Stock';

  @override
  String priceAmount(Object amount) {
    return '$amount EGP';
  }

  @override
  String productSalesTitle(Object productName) {
    return '$productName sales';
  }

  @override
  String get dateRangeFilter => 'Filter by date range';

  @override
  String get noSalesInPeriod => 'No sales found for this period';

  @override
  String quantityLabel(Object count) {
    return 'Quantity: $count';
  }

  @override
  String sizeLabel(Object sizeName) {
    return 'Size: $sizeName';
  }

  @override
  String get size => 'Size';

  @override
  String selectedDateRange(Object endDate, Object startDate) {
    return '$startDate - $endDate';
  }

  @override
  String get clearDateFilter => 'Clear date filter';

  @override
  String get viewHistory => 'History';

  @override
  String itemsInStockCount(Object count) {
    return '$count items';
  }

  @override
  String totalAmount(Object amount) {
    return 'Total $amount EGP';
  }

  @override
  String get productDescription => 'Description';

  @override
  String get availableSizes => 'Available Sizes';

  @override
  String get sellNowButton => 'Sell Now';

  @override
  String get refundButton => 'Refund';

  @override
  String get noItemsInStock => 'No items in stock';

  @override
  String get deleteProduct => 'Delete Product';

  @override
  String get deleteProductConfirm => 'Are you sure you want to delete this product?';

  @override
  String get deleteAction => 'Delete';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get shopifyPrice => 'Shopify Price*';

  @override
  String get shopifyPriceRequired => 'Enter shopify price';

  @override
  String get addAnotherSize => 'Add another size';

  @override
  String get anotherSize => 'the other size';

  @override
  String get addButton => 'Add';

  @override
  String get editButton => 'Edit';

  @override
  String get photosButton => 'Photos';

  @override
  String get cameraButton => 'Camera';

  @override
  String get originalPrice => 'Cost Price (required)';

  @override
  String get priceRequired => 'Enter price';

  @override
  String get nameRequired => 'Enter name';

  @override
  String get nameLabel => 'Name (required)';

  @override
  String get sell => 'Sell 🤑';

  @override
  String get sellPricePerItem => 'Sell price per item';

  @override
  String get whereSell => 'Where did you sell it?';

  @override
  String get online => 'Online';

  @override
  String get store => 'Store';

  @override
  String get event => 'Event';

  @override
  String get other => 'Other';

  @override
  String productSells(Object productName) {
    return '$productName sells';
  }

  @override
  String get filterByDate => 'Filter by Date';

  @override
  String get thisWeek => 'This Week';

  @override
  String get clearFilter => 'Clear Filter';

  @override
  String get noSells => 'No sells for this product';

  @override
  String get discountCalculator => 'Discount Calculator';

  @override
  String get priceAfterDiscount => 'Price After Discount';

  @override
  String originalPriceWithThePrice(Object price) {
    return 'Original Price: $price EGP';
  }

  @override
  String get calculateDiscount => 'Calculate Discount';

  @override
  String get enterPriceAndDiscount => 'Enter product price and discount percentage';

  @override
  String get discountPercent => 'Discount %';

  @override
  String get enterPercent => 'Enter percent';

  @override
  String get calculateDiscountButton => 'Calculate Discount';

  @override
  String get chooseSize => 'Which sizes do you sell?';

  @override
  String get chooseOrderExpenses => 'Did you use any packaging items?';

  @override
  String get confirm => 'Confirm';

  @override
  String get noExpensesYet => 'No expenses yet.';

  @override
  String get noExpensesDesc => 'Add any external expenses that cost your business such as electricity bill, employee wages, meeting expense, etc...';

  @override
  String get amount => 'Amount';

  @override
  String get date => 'Date';

  @override
  String get close => 'Close';

  @override
  String get from => 'From';

  @override
  String get to => 'to';

  @override
  String get totalExpenses => 'Total Expenses';

  @override
  String get expensesSummary => 'Expenses Summary';

  @override
  String get failedToGeneratePdf => 'Failed to generate PDF';

  @override
  String get sortExpenses => 'Sort Expenses';

  @override
  String get highestPrice => 'Highest Price';

  @override
  String get lowestPrice => 'Lowest Price';

  @override
  String get advertising => 'Advertising';

  @override
  String get noAdsYet => 'No Ads Yet';

  @override
  String get noAdsDesc => 'Add the ads you created in social media platforms.';

  @override
  String get newAd => 'New Ad';

  @override
  String get deleteAdvertisement => 'Delete Advertisement';

  @override
  String get deleteAdConfirm => 'Are you sure you want to delete this ad?';

  @override
  String get advertisementDetails => 'Advertisement Details';

  @override
  String get platform => 'Platform';

  @override
  String get notAvailable => 'N/A';

  @override
  String get adCost => 'Ad cost (required)';

  @override
  String get enterAdCost => 'Enter ad cost';

  @override
  String get yourAdPlatform => 'Your ad platform?';

  @override
  String switchPackageConfirm(String type) {
    return 'Are you sure you want to switch to $type package?';
  }

  @override
  String get report => 'Report';

  @override
  String get salesDistribution => 'Sales Distribution';

  @override
  String get showHighestProducts => 'Show highest products';

  @override
  String get startSellingToSeeResults => 'Start selling to see results';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get expenseDetails => 'Expense Details';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get salesReport => 'Sales Report';

  @override
  String get summary => 'Summary';

  @override
  String get metric => 'Metric';

  @override
  String get value => 'Value';

  @override
  String get productsSummary => 'Products Summary';

  @override
  String get product => 'Product';

  @override
  String get quantitySold => 'Quantity Sold';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String generatedByBrandify(String date) {
    return 'Generated by Brandify on $date';
  }

  @override
  String get choosePackage => 'Choose Package';

  @override
  String get selectYourPackage => 'Select Your Package';

  @override
  String get changePackageLater => 'You can change your package at any time';

  @override
  String get offlinePackage => 'Offline Package';

  @override
  String get offlinePackageDesc => 'Store data locally on your device';

  @override
  String get workWithoutInternet => 'Work without internet';

  @override
  String get localDataStorage => 'Local data storage';

  @override
  String get basicReporting => 'Basic reporting';

  @override
  String get unlimitedProducts => 'Unlimited products';

  @override
  String get onlinePackage => 'Online Package';

  @override
  String get onlinePackageDesc => 'Cloud storage with advanced features';

  @override
  String get cloudDataStorage => 'Cloud data storage';

  @override
  String get multiDeviceSync => 'Multi-device sync';

  @override
  String get advancedReporting => 'Advanced reporting';

  @override
  String get dataBackup => 'Data backup';

  @override
  String get shopifyPackage => 'Shopify Package';

  @override
  String get shopifyPackageDesc => 'Full integration with Shopify (Coming Soon)';

  @override
  String get shopifyIntegration => 'Shopify integration';

  @override
  String get inventorySync => 'Inventory sync';

  @override
  String get orderManagement => 'Order management';

  @override
  String get allOnlineFeatures => 'All online features';

  @override
  String get confirmPackage => 'Confirm Package';

  @override
  String confirmPackageSelection(String title) {
    return 'Do you want to select the $title?';
  }

  @override
  String get comingSoon => 'This package will be available soon!';

  @override
  String get bestSellingProducts => 'Best Selling Products';

  @override
  String productsSortedBy(String sortBy) {
    return 'Products sorted by $sortBy';
  }

  @override
  String get noProductsAddNow => 'No products, Add now';

  @override
  String get sortProductsBy => 'Sort Products By';

  @override
  String get sortByQuantity => 'Sort by Quantity';

  @override
  String get sortByProfit => 'Sort By Profit';

  @override
  String get bestSellingProductsReport => 'Best Selling Products Report';

  @override
  String period(String startDate, String endDate) {
    return 'Period: $startDate to $endDate';
  }

  @override
  String get unnamedProduct => 'Unnamed Product';

  @override
  String get orders => 'Orders';

  @override
  String get selectOrders => 'Select Orders';

  @override
  String get totalProfit => 'Total Profit';

  @override
  String ordersFromTo(String startDate, String endDate) {
    return 'Orders from $startDate to $endDate';
  }

  @override
  String get createReceipt => 'Create Receipt';

  @override
  String get highestProfit => 'Highest Profit';

  @override
  String get lowestProfit => 'Lowest Profit';

  @override
  String get refund => 'Refund';

  @override
  String get ordersReceipt => 'Orders Receipt';

  @override
  String get orderDate => 'Order Date';

  @override
  String get refunded => 'REFUNDED';

  @override
  String get totalOrders => 'Total Orders';

  @override
  String fromBrandify(String brandName, String date) {
    return 'From $brandName on $date';
  }

  @override
  String loginFailed(String error) {
    return 'Login failed: $error';
  }

  @override
  String get failedToLoadUserData => 'Failed to load user data';

  @override
  String errorLoadingUserData(String error) {
    return 'Error loading user data: $error';
  }

  @override
  String unexpectedError(String error) {
    return 'Unexpected error: $error';
  }

  @override
  String get invalidStoreConfig => 'Invalid store configuration';

  @override
  String get couldNotGetUserData => 'Could not get user data, please login again';

  @override
  String get failedToGetUserData => 'Failed to get user data from the internet';

  @override
  String errorProcessingExpense(String error) {
    return 'Error processing expense data: $error';
  }

  @override
  String get successfullyConvertedToOnline => 'Successfully converted to online package';

  @override
  String get failedToUploadData => 'Failed to upload data to online storage';

  @override
  String get successfullyConvertedToOffline => 'Successfully converted to offline package';

  @override
  String get egp => 'EGP';

  @override
  String get numberOfSales => 'Number of sales';

  @override
  String get totalIncome => 'Total income';

  @override
  String get extraExpenses => 'Extra expenses';

  @override
  String get viewAll => 'View All';

  @override
  String get noDataToShow => 'No data to show';

  @override
  String get boughtByPlace => 'Bought by place';

  @override
  String get totalCostByPlatform => 'Total Costs by Platform';

  @override
  String get electricityExample => 'ex: Electricity bill';

  @override
  String get name => 'Name';

  @override
  String get place => 'Place';

  @override
  String get soldFor => 'Sold for';

  @override
  String get sideExpensesCost => 'Side expenses cost';

  @override
  String get sideExpensesAre => 'Side expenses are';

  @override
  String get refundFailed => 'Can\'t make the refund 😥';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get viewYourSalesAndProfit => 'View your total sales and profit';

  @override
  String get manageYourInventory => 'Manage your product inventory';

  @override
  String get manageOrderExpenses => 'Track your order-related expenses';

  @override
  String get manageYourAdCampaigns => 'Manage your advertising campaigns';

  @override
  String get manageOtherExpenses => 'Track other business expenses';

  @override
  String get statsCardsTutorial => 'Track Your Business Performance';

  @override
  String get statsCardsTutorialDesc => 'Monitor your total sales and profit in real-time. Tap to view detailed reports.';

  @override
  String get quickActionsTutorial => 'Quick Access to Essential Features';

  @override
  String get quickActionsTutorialDesc => 'Manage your products, expenses, and advertising campaigns with just one tap.';

  @override
  String get skip => 'Skip';

  @override
  String get mandatoryFieldsNote => 'Only name, original price & quantity are mandatory';

  @override
  String get originalPriceHint => 'Cost price is the price you paid to get the product, not selling price';

  @override
  String get pricePaidHint => 'Price you paid for the product';

  @override
  String get packagingStock => 'Packaging Stock';

  @override
  String get businessExpenses => 'Business Expenses';

  @override
  String get enterAdDescription => 'Enter the ad you\'ve already posted on social media';

  @override
  String get enterAnyAdditionalExpenses => 'Enter any additional expenses';

  @override
  String get sellPriceQuestion => 'What is the price you sell the product for?';

  @override
  String get done => 'Done';

  @override
  String get chooseSizeMessage => 'Choose a size';

  @override
  String get productOutOfStock => 'Product is out of stock';

  @override
  String notEnoughQuantity(int quantity) {
    return 'Not enough quantity available (Only $quantity left)';
  }

  @override
  String get failedToUpdateInventory => 'Failed to update inventory';

  @override
  String get chooseSizeFirst => 'Choose a size first';

  @override
  String get notEnoughQuantityAvailable => 'Not enough quantity available';

  @override
  String get addedSuccessfully => 'Added successfully';

  @override
  String get errorOccurred => 'Error occurred';

  @override
  String refundError(String error) {
    return '$error';
  }

  @override
  String get tryAgainLater => 'Try again later';

  @override
  String get productDeleted => 'Product Deleted';

  @override
  String get productUpdated => 'Product Updated 🤙';

  @override
  String get errorUpdatingProduct => 'Error Updating Product 😢';

  @override
  String get doesntExist => 'Doesn\'t exist 🤔';

  @override
  String failedToDeleteAccount(String error) {
    return 'Failed to delete account: $error';
  }

  @override
  String failedToFetchProducts(String error) {
    return 'Failed to fetch products: $error';
  }

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get connectionTimedOut => 'Connection timed out';

  @override
  String get accessDenied => 'Access denied';

  @override
  String get selectDateFromAndToFirst => 'Select date from and to first';

  @override
  String get failedToSaveTransaction => 'Failed to save transaction';

  @override
  String get unexpectedErrorOccurred => 'Unexpected error occurred';
}
