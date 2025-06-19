import 'package:brandify/models/local/hive_services.dart';
import 'package:brandify/view/screens/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

// Local imports
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/ads/ads_cubit.dart';
import 'package:brandify/cubits/all_sells/all_sells_cubit.dart';
import 'package:brandify/cubits/app_user/app_user_cubit.dart';
import 'package:brandify/cubits/extra_expenses/extra_expenses_cubit.dart';
import 'package:brandify/cubits/products/products_cubit.dart';
import 'package:brandify/cubits/reports/reports_cubit.dart';
import 'package:brandify/cubits/sell/sell_cubit.dart';
import 'package:brandify/cubits/sides/sides_cubit.dart';
import 'package:brandify/main.dart';
import 'package:brandify/models/ad.dart';
import 'package:brandify/models/extra_expense.dart';
import 'package:brandify/models/local/cache.dart';
import 'package:brandify/models/sell.dart';
import 'package:brandify/view/screens/ads/ads_screen.dart';
import 'package:brandify/view/screens/ads/all_ads_screen.dart';
import 'package:brandify/view/screens/best_products_screen.dart';
import 'package:brandify/view/screens/calculate_percent_screen.dart';
import 'package:brandify/view/screens/auth/login_screen.dart';
import 'package:brandify/view/screens/extra_expenses_screen.dart';
import 'package:brandify/view/screens/lowest_products_screen.dart';
import 'package:brandify/view/screens/products/products_screen.dart';
import 'package:brandify/view/screens/reports/reports_screen.dart';
import 'package:brandify/view/screens/sides_screen.dart';
import 'package:brandify/view/screens/tabs/settings_tab.dart';
import 'package:brandify/view/widgets/package_card.dart';
import 'package:brandify/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];
  final GlobalKey productsKey = GlobalKey();
  final GlobalKey expensesKey = GlobalKey();
  final GlobalKey adsKey = GlobalKey();
  final GlobalKey extraExpensesKey = GlobalKey();

  void initializeData() async {
    await context.read<AppUserCubit>().refreshUserData();
    await context.read<ProductsCubit>().getProducts();
    int cost = await context.read<AdsCubit>().getAllAds();
    await context.read<AllSellsCubit>().getSells(
      ads: cost,
      allProducts: context.read<ProductsCubit>().products,
    );
    context.read<SidesCubit>().getAllSides();
    // context.read<AppUserCubit>().calculateTotalAndProfit(
    //   context.read<AllSellsCubit>().sells,
    //   context.read<AdsCubit>().ads,
    //   context.read<ExtraExpensesCubit>().expenses,
    // );
    await context.read<ExtraExpensesCubit>().getAllExpenses();
    initializeReports(
      context.read<AllSellsCubit>().sells,
      context.read<AdsCubit>().ads,
      context.read<ExtraExpensesCubit>().expenses,
    );
  }

  void initializeReports(
    List<Sell> allSells,
    List<Ad> allAds,
    List<ExtraExpense> allExtraExpenses,
  ) {
    ReportsCubit.get(
      context,
    ).setTodayReport(allSells, allAds, allExtraExpenses);
    ReportsCubit.get(context).setWeekReport(allSells, allAds, allExtraExpenses);
    ReportsCubit.get(
      context,
    ).setMonthReport(allSells, allAds, allExtraExpenses);
    ReportsCubit.get(
      context,
    ).setThreeMonthsReport(allSells, allAds, allExtraExpenses);
  }

  @override
  void initState() {
    super.initState();
    initializeData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initTargets();
      _initTutorial();
      showTutorial();
    });
  }

  void _initTargets() {
    targets = [
      TargetFocus(
        identify: "products",
        keyTarget: productsKey,
        alignSkip: Cache.getLanguage() == "ar" ? Alignment.topLeft : Alignment.topRight ,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.products,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.manageInventory,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  void _initTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: AppLocalizations.of(context)!.skip,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        debugPrint("Tutorial finished");
        Cache.setBool("homeTutorialCoach", true);
      },
      onClickTarget: (target) {
        debugPrint('Clicked on ${target.identify}');
      },
      onSkip: () {
        debugPrint("Tutorial skipped");
        Cache.setBool("homeTutorialCoach", true);
        return true;
      },
    );
  }

  void showTutorial() {
    if (mounted) {
      if(!(Cache.getBool("homeTutorialCoach") ?? false)){
        tutorialCoachMark.show(context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          const ProductsScreen(),
          const ReportsScreen(),
          const SettingsTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            // if(index == 1){
            //   ProductsCubit.get(context).getProducts();
            // }
            if (index == 2) {
              initializeReports(
                context.read<AllSellsCubit>().sells,
                context.read<AdsCubit>().ads,
                context.read<ExtraExpensesCubit>().expenses,
              );
            }
            setState(() => _currentIndex = index);
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.grey[400],
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_rounded),
              label: AppLocalizations.of(context)!.productsTab,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: AppLocalizations.of(context)!.reports,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: AppLocalizations.of(context)!.settings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AppUserCubit, AppUserState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.welcomeBack,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            BlocBuilder<AppUserCubit, AppUserState>(
                              builder: (context, state) {
                                return Text(
                                  AppUserCubit.get(context).brandName ??
                                      "Brandify",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // IconButton(
                      //   onPressed: showTutorial,
                      //   icon: const Icon(Icons.help_outline_rounded),
                      // ),
                      AppUserCubit.get(context).brandPhone == "01227701988"
                          ? IconButton(
                            onPressed:
                                () => navigatorKey.currentState?.push(
                                  MaterialPageRoute(
                                    builder: (_) => const DashboardScreen(),
                                  ),
                                ),
                            icon: const Icon(Icons.dashboard),
                          )
                          : IconButton(
                            onPressed:
                                () => navigatorKey.currentState?.push(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const CalculatePercentScreen(),
                                  ),
                                ),
                            icon: const Icon(Icons.percent_rounded),
                          ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 25),

              // Stats Cards
              BlocBuilder<AppUserCubit, AppUserState>(
                builder: (context, state) {
                  if (state is AppUserLoading) {
                    return Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            AppLocalizations.of(context)!.totalSales,
                            '...',
                            Icons.shopping_bag_rounded,
                            Colors.blue,
                            isLoading: true,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildStatCard(
                            AppLocalizations.of(context)!.profit,
                            '...',
                            Icons.trending_up_rounded,
                            Colors.green,
                            isLoading: true,
                          ),
                        ),
                      ],
                    );
                  }

                  final appUserCubit = context.read<AppUserCubit>();
                  return Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            initializeReports(
                              context.read<AllSellsCubit>().sells,
                              context.read<AdsCubit>().ads,
                              context.read<ExtraExpensesCubit>().expenses,
                            );
                            setState(() => _currentIndex = 2);
                          },
                          child: _buildStatCard(
                            AppLocalizations.of(context)!.totalSales,
                            appUserCubit.total.toString(),
                            Icons.shopping_bag_rounded,
                            Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            initializeReports(
                              context.read<AllSellsCubit>().sells,
                              context.read<AdsCubit>().ads,
                              context.read<ExtraExpensesCubit>().expenses,
                            );
                            setState(() => _currentIndex = 2);
                          },
                          child: _buildStatCard(
                            AppLocalizations.of(context)!.profit,
                            appUserCubit.totalProfit.toString(),
                            appUserCubit.totalProfit >= 0
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            appUserCubit.totalProfit >= 0
                                ? Colors.green
                                : Colors.red,
                            subtitle:
                                appUserCubit.total > 0
                                    ? '${((appUserCubit.totalProfit / appUserCubit.total) * 100).toStringAsFixed(1)}%'
                                    : '0%',
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 25),

              // Quick Actions Grid
              Text(
                AppLocalizations.of(context)!.quickActions,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 15),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.3,
                children: [
                  _buildActionCard(
                    AppLocalizations.of(context)!.products,
                    AppLocalizations.of(context)!.manageInventory,
                    Icons.inventory_2_rounded,
                    Colors.purple,
                    () => navigatorKey.currentState?.push(
                      MaterialPageRoute(builder: (_) => const ProductsScreen()),
                    ),
                    key: productsKey
                  ),
                  _buildActionCard(
                    AppLocalizations.of(context)!.packagingStock,
                    AppLocalizations.of(context)!.additionalOrderCosts,
                    Icons.account_balance_wallet_rounded,
                    Colors.orange,
                    () => navigatorKey.currentState?.push(
                      MaterialPageRoute(builder: (_) => const SidesScreen()),
                    ),
                  ),
                  _buildActionCard(
                    AppLocalizations.of(context)!.ads,
                    AppLocalizations.of(context)!.manageCampaigns,
                    Icons.campaign_rounded,
                    Colors.blue,
                    () => navigatorKey.currentState?.push(
                      MaterialPageRoute(builder: (_) => const AllAdsScreen()),
                    ),
                  ),
                  _buildActionCard(
                    AppLocalizations.of(context)!.businessExpenses,
                    AppLocalizations.of(context)!.otherExpenses,
                    Icons.receipt_long_rounded,
                    Colors.teal,
                    () => navigatorKey.currentState?.push(
                      MaterialPageRoute(builder: (_) => ExtraExpensesScreen()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
    bool isLoading = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              if (subtitle != null) ...[
                const SizedBox(width: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 5),
          isLoading
              ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )
              : Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
    {GlobalKey? key,}
  ) {
    // GlobalKey key;
    // switch (key) {
    //   case 'Products':
    //     key = productsKey;
    //     break;
    //   case 'Order Expenses':
    //     key = expensesKey;
    //     break;
    //   case 'Ads':
    //     key = adsKey;
    //     break;
    //   case 'External Expenses':
    //     key = extraExpensesKey;
    //     break;
    //   default:
    //     key = GlobalKey();
    // }

    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return const Placeholder(); // Implement settings screen
  }
}

