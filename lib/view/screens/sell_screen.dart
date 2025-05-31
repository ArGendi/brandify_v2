import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/sell/sell_cubit.dart';
import 'package:brandify/cubits/sides/sides_cubit.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/main.dart';
import 'package:brandify/models/product.dart';
import 'package:brandify/models/sell_side.dart';
import 'package:brandify/models/side.dart';
import 'package:brandify/view/screens/calculate_percent_screen.dart';
import 'package:brandify/view/widgets/custom_button.dart';
import 'package:brandify/view/widgets/custom_texfield.dart';
import 'package:brandify/view/widgets/quantity_row.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SellScreen extends StatefulWidget {
  final Product product;
  const SellScreen({super.key, required this.product});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    SellCubit.get(context).sides = [
      for (var item in SidesCubit.get(context).sides) 
        if((item.quantity ?? 0) > 0) SellSide(item)
    ];
    if (widget.product.sizes.length == 1) {
      SellCubit.get(context).selectedSize = widget.product.sizes[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sell),
        actions: [
          IconButton(
            onPressed: () {
              navigatorKey.currentState?.push(
                MaterialPageRoute(builder: (_) => const CalculatePercentScreen())
              );
            },
            icon: const Icon(Icons.percent),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: SellCubit.get(context).formKey,
          child: ListView(
            children: [
              CustomTextFormField(
                keyboardType: TextInputType.number,
                text: AppLocalizations.of(context)!.sellPricePerItem,
                onSaved: (value) {
                  if (value!.isNotEmpty)
                    SellCubit.get(context).price = int.parse(value);
                },
                onValidate: (value) {
                  if (value!.isEmpty) {
                    return AppLocalizations.of(context)!.enterPrice;
                  } else
                    return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(AppLocalizations.of(context)!.whereSell),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<SellCubit,SellState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          SellCubit.get(context).setPlace(SellPlace.online);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: SellCubit.get(context).place ==
                                        SellPlace.online ? mainColor : null,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: SellCubit.get(context).place ==
                                        SellPlace.online
                                    ? mainColor
                                    : Colors.grey,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Text(
                              AppLocalizations.of(context)!.online,
                              style: TextStyle(
                                color: SellCubit.get(context).place ==
                                        SellPlace.online
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          SellCubit.get(context).setPlace(SellPlace.store);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: SellCubit.get(context).place ==
                                        SellPlace.store ? mainColor : null,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: SellCubit.get(context).place ==
                                        SellPlace.store
                                    ? Colors.white
                                    : Colors.grey,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Text(
                              AppLocalizations.of(context)!.store,
                              style: TextStyle(
                                color: SellCubit.get(context).place ==
                                        SellPlace.store
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          SellCubit.get(context).setPlace(SellPlace.inEvent);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: SellCubit.get(context).place ==
                                        SellPlace.inEvent ? mainColor : null,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: SellCubit.get(context).place ==
                                        SellPlace.inEvent
                                    ? Colors.white
                                    : Colors.grey,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Text(
                              AppLocalizations.of(context)!.event,
                              style: TextStyle(
                                color: SellCubit.get(context).place ==
                                        SellPlace.inEvent
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          SellCubit.get(context).setPlace(SellPlace.other);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: SellCubit.get(context).place ==
                                        SellPlace.other ? mainColor : null,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: SellCubit.get(context).place ==
                                        SellPlace.other
                                    ? Colors.white
                                    : Colors.grey,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Text(
                              AppLocalizations.of(context)!.other,
                              style: TextStyle(
                                color: SellCubit.get(context).place ==
                                        SellPlace.other
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (widget.product.sizes.length > 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(AppLocalizations.of(context)!.chooseSize),
                    SizedBox(
                      height: 10,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.1),
                      itemBuilder: (_, i) {
                        return GestureDetector(
                          onTap: () {
                            if (widget.product.sizes[i].quantity! > 0)
                              SellCubit.get(context)
                                  .selectSize(widget.product.sizes[i]);
                          },
                          child: BlocBuilder<SellCubit, SellState>(
                            builder: (context, state) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: SellCubit.get(context).selectedSize ==
                                          widget.product.sizes[i]
                                      ? mainColor
                                      : Colors.grey.shade300,
                                ),
                                child: Center(
                                  child: Text(
                                    widget.product.sizes[i].name.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        decoration:
                                            widget.product.sizes[i].quantity ==
                                                    0
                                                ? TextDecoration.lineThrough
                                                : null),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      itemCount: widget.product.sizes.length,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              Text(AppLocalizations.of(context)!.enterQuantity),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<SellCubit, SellState>(
                builder: (context, state) {
                  return QuantityRow(
                    text: SellCubit.get(context).quantity.toString(),
                    onDec: () {
                      SellCubit.get(context).decQuantity(context);
                    },
                    onInc: () {
                      SellCubit.get(context).incQuantity(context);
                    },
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
              if (SellCubit.get(context).sides.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.chooseOrderExpenses),
                    SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<SellCubit, SellState>(
                      builder: (context, state) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return QuantityRow(
                              text:
                                  "(${SellCubit.get(context).sides[i].usedQuantity}) ${SellCubit.get(context).sides[i].side?.name}",
                              onDec: () {
                                SellCubit.get(context).decSideUsedQuantity(i);
                              },
                              onInc: () {
                                SellCubit.get(context).incSideUsedQuantity(i);
                              },
                            );
                          },
                          separatorBuilder: (context, i) => SizedBox(
                            height: 10,
                          ),
                          itemCount: SellCubit.get(context).sides.length,
                        );
                      },
                    ),
                  ],
                ),
              SizedBox(
                height: 15,
              ),
              CustomTextFormField(
                keyboardType: TextInputType.number,
                text: AppLocalizations.of(context)!.otherExpenses,
                onSaved: (value) {
                  if (value!.isNotEmpty)
                    SellCubit.get(context).extra = int.parse(value);
                },
              ),
              SizedBox(
                height: 20,
              ),
              BlocBuilder<SellCubit, SellState>(
                builder: (context, state) {
                  if (state is LoadingSellState) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ),
                    );
                  } else {
                    return CustomButton(
                      text: AppLocalizations.of(context)!.confirm,
                      onPressed: () {
                        SellCubit.get(context).onDone(context, widget.product);
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
