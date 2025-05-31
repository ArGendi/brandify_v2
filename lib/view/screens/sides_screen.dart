import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/sides/sides_cubit.dart';
import 'package:brandify/main.dart';
import 'package:brandify/view/widgets/custom_button.dart';
import 'package:brandify/view/widgets/custom_texfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SidesScreen extends StatefulWidget {
  const SidesScreen({super.key});

  @override
  State<SidesScreen> createState() => _SidesScreenState();
}

class _SidesScreenState extends State<SidesScreen> {
  @override
  void initState() {
    super.initState();
    SidesCubit.get(context).getAllSides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.orderExpenses),
        backgroundColor: mainColor, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<SidesCubit, SidesState>(
          builder: (context, state) {
            print("Overall Sides state: $state");
            if (state is LoadingSidesState) {
              return Center(
                child: CircularProgressIndicator(
                  color: mainColor,
                ),
              );
            } else {
              return Visibility(
                visible: SidesCubit.get(context).sides.isNotEmpty,
                replacement: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.card_giftcard,
                        color: Colors.grey,
                        size: 50,
                      ),
                      // Image.asset(
                      //   "assets/images/empty.png",
                      //   height: 200, 
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        AppLocalizations.of(context)!.emptyOrderExpensesDesc,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // const Text(
                      //   "Any side expenses you use in your orders",
                      //   textAlign: TextAlign.center,
                      // ),
                    ],
                  ),
                ),
                child: ListView.separated(
                  itemBuilder: (context, i) {
                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: mainColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        SidesCubit.get(context)
                                            .sides[i]
                                            .quantity
                                            .toString(),
                                        style: TextStyle(
                                          color: mainColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      SidesCubit.get(context)
                                          .sides[i]
                                          .name
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.priceAmount(SidesCubit.get(context).sides[i].price ?? 0),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 1,
                        ),
                        IconButton(
                          onPressed: () {
                            SidesCubit.get(context).remove(i, context);
                          },
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                          ),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (context, i) => const SizedBox(
                    height: 15,
                  ),
                  itemCount: SidesCubit.get(context).sides.length,
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _addBottomSheet(context);
        },
        label: Text(AppLocalizations.of(context)!.addOrderExpense),
        icon: const Icon(Icons.add),
        backgroundColor: mainColor,
      ),
    );
  }

  Future<void> _addBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Form(
              key: SidesCubit.get(context).formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomTextFormField(
                    text: AppLocalizations.of(context)!.expenseName,
                    hintText: AppLocalizations.of(context)!.expenseNameHint,
                    onSaved: (value) {
                      SidesCubit.get(context).name = value;
                    },
                    onValidate: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!.enterName;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          keyboardType: TextInputType.number,
                          text: AppLocalizations.of(context)!.pricePerItem,
                          hintText: AppLocalizations.of(context)!.priceHint,
                          onSaved: (value) {
                            if (value!.isNotEmpty)
                              SidesCubit.get(context).price = int.parse(value);
                          },
                          onValidate: (value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)!.enterPrice;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextFormField(
                          keyboardType: TextInputType.number,
                          text: AppLocalizations.of(context)!.quantity,
                          hintText: AppLocalizations.of(context)!.quantityHint,
                          onSaved: (value) {
                            if (value!.isNotEmpty)
                              SidesCubit.get(context).quantity = int.parse(value);
                          },
                          onValidate: (value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)!.enterQuantity;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<SidesCubit, SidesState>(
                    builder: (context, state) {
                      print("Sides state: $state");
                      if (state is LoadingOneSideState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return CustomButton(
                          text: AppLocalizations.of(context)!.add,
                          onPressed: () async {
                            bool done = await SidesCubit.get(context).onAddSide(context);
                            if (done) navigatorKey.currentState?.pop();
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
