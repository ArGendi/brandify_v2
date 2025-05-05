import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:brandify/cubits/best_products/best_products_cubit.dart';
import 'package:brandify/cubits/lowest_products/lowest_products_cubit.dart';
import 'package:brandify/cubits/products/products_cubit.dart';
import 'package:brandify/view/screens/products/product_details.dart';
import 'package:brandify/view/widgets/product_card.dart';

class lowestProductsScreen extends StatefulWidget {
  const lowestProductsScreen({super.key});

  @override
  State<lowestProductsScreen> createState() => _lowestProductsScreenState();
}

class _lowestProductsScreenState extends State<lowestProductsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LowestProductsCubit.get(context).getLowestProducts(
      ProductsCubit.get(context).products
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lowest 10 Products"),
        backgroundColor: Colors.red.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<LowestProductsCubit, LowestProductsState>(
          builder: (context, state) {
            return Visibility(
              visible: LowestProductsCubit.get(context).lowestProducts.isNotEmpty,
              replacement: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      "assets/animations/request.json",
                      width: 300,
                    ),
                    //SizedBox(height: 20,),
                    Text("No sells yet")
                  ],
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 10,),
                itemBuilder: (_, i) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (_) => ProductDetails(
                        product: LowestProductsCubit.get(context).lowestProducts[i]
                      )));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: LowestProductsCubit.get(context).lowestProducts[i].image != null
                              ? FileImage(
                                  File(LowestProductsCubit.get(context).lowestProducts[i].image!),
                                )
                              : AssetImage("assets/images/default.png"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            LowestProductsCubit.get(context).lowestProducts[i].name.toString(),
                            style: TextStyle(),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${LowestProductsCubit.get(context).lowestProducts[i].noOfSells}",
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: LowestProductsCubit.get(context)
                    .lowestProducts
                    .length,
              ),
            );
          },
        ),
      ),
    );
  }
}