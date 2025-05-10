import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/best_products/best_products_cubit.dart';
import 'package:brandify/cubits/products/products_cubit.dart';
import 'package:brandify/cubits/all_sells/all_sells_cubit.dart';
import 'package:brandify/models/package.dart';
import 'package:brandify/models/sell.dart';
import 'package:brandify/models/product.dart';
import 'package:brandify/view/screens/products/product_details.dart';
import 'package:brandify/view/widgets/loading.dart';
import 'package:brandify/view/widgets/product_card.dart';
import 'package:brandify/view/widgets/custom_text.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BestProductsScreen extends StatefulWidget {
  final DateTimeRange? dateRange;
  const BestProductsScreen({super.key, this.dateRange});

  @override
  State<BestProductsScreen> createState() => _BestProductsScreenState();
}

class _BestProductsScreenState extends State<BestProductsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.dateRange != null){
      context.read<BestProductsCubit>().setRange(context, widget.dateRange!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Best Selling Products"),
        actions: [
          IconButton(
            onPressed: () => _shareBestProducts(context, widget.dateRange!),
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () => _showFilterBottomSheet(context),
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<BestProductsCubit, BestProductsState>(
          builder: (context, state) {
            if(state is BestProductsLoadingState){
              return Loading();
            }
            else {
              return Visibility(
              visible: context.read<BestProductsCubit>().bestProducts.isNotEmpty,
              replacement: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        "assets/animations/request.json",
                        width: 300,
                      ),
                      //SizedBox(height: 20,),
                      Text("No products, Add now")
                    ],
                  ),
              ),
              child: Column(
                children: [
                  // CustomButton(
                  //   onPressed: () => context.read<BestProductsCubit>().selectDateRange(context),
                  //   text: context.read<BestProductsCubit>().selectedDateRange == null
                  //       ? "Select Date Range"
                  //       : "${context.read<BestProductsCubit>().selectedDateRange!.start.toString().split(' ')[0]} to ${context.read<BestProductsCubit>().selectedDateRange!.end.toString().split(' ')[0]}",
                  // ),
                  // const SizedBox(height: 20),
                  // if (context.read<BestProductsCubit>().selectedDateRange !=
                  //         null &&
                  //     context.read<BestProductsCubit>().bestProducts.isEmpty)
                    
                  // else if (context
                  //     .read<BestProductsCubit>()
                  //     .bestProducts
                  //     .isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            context.read<BestProductsCubit>().bestProducts.length,
                        itemBuilder: (context, index) {
                          final productSales = context
                              .read<BestProductsCubit>()
                              .bestProducts[index];
                          return Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: Package.getImageWidget(productSales.product.image),
                              ),
                              title: CustomText(
                                text: productSales.product.name ??
                                    "Unnamed Product",
                                fontWeight: FontWeight.bold,
                              ),
                              subtitle: CustomText(
                                text: "Quantity Sold: ${productSales.quantity}",
                              ),
                              trailing: CustomText(
                                text:
                                    productSales.profit >=0 ? 
                                      "+${productSales.profit} LE"
                                      : "${productSales.profit} LE",
                                color:  productSales.profit >=0 ?
                                   Colors.green : Colors.red,
                                //fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
            }
          },
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(
                text: "Sort Products By",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.sort),
                title: const Text("Sort by Quantity"),
                onTap: () {
                  final cubit = context.read<BestProductsCubit>();
                  cubit.bestProducts.sort((a, b) => b.quantity.compareTo(a.quantity));
                  cubit.emit(BestProductsChangedState());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text("Sort by Profit"),
                onTap: () {
                  final cubit = context.read<BestProductsCubit>();
                  cubit.bestProducts.sort((a, b) => b.profit.compareTo(a.profit));
                  cubit.emit(BestProductsChangedState());
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    );
  }
}

  Future<void> _shareBestProducts(BuildContext context, DateTimeRange dateRange) async {
    final bestProducts = context.read<BestProductsCubit>().bestProducts;
    if (bestProducts.isEmpty) return;

    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Best Selling Products Report', 
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)
            ),
          ),
          pw.Paragraph(text: 'Period: ${dateRange.start.toString().split(' ')[0]} to ${dateRange.end.toString().split(' ')[0]}'),
          pw.SizedBox(height: 20),
          
          pw.Table.fromTextArray(
            context: context,
            headers: ['Product', 'Quantity Sold', 'Total Revenue', 'Profit'],
            data: bestProducts.map((product) => [
              product.product.name ?? 'Unnamed Product',
              product.quantity.toString(),
              '${product.quantity * (product.product.price ?? 0)} LE',
              '${product.profit} LE',
            ]).toList(),
          ),
          
          pw.Footer(
            trailing: pw.Text(
              'Generated by Brandify on ${DateTime.now().toString().split(' ')[0]}',
              style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
            ),
          ),
        ],
      ),
    );

    // Save and share the PDF
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/best_products_report.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Best Products Report',
    );
  }
