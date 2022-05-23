import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:whiteboard/datakit/models/cart.dart';

class SubTotalSection extends StatelessWidget {
  final double value;
  final double tax;
  final String currency;
  final double discount;
  final double delivery;
  final List<Tax> appliedTaxes;
  final List<Discount> discounts;
  final bool isHistory;

  SubTotalSection(
      {required this.value,
      required this.currency,
      required this.tax,
      required this.delivery,
      required this.isHistory,
      required this.discount,
      required this.appliedTaxes,
      required this.discounts});

  @override
  Widget build(BuildContext context) {
    return subTotalRow(context, value: value, currency: currency);
  }

  Widget subTotalRow(BuildContext context,
      {required double value, required String currency}) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Subtotal: ',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14),
                ),
                flex: 1,
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(top: 10), child: DottedLine())),
              Expanded(
                child: Text(value.toString() + " " + currency,
                    textAlign: TextAlign.right, style: TextStyle(fontSize: 16)),
                flex: 1,
              ),
            ],
          ),
          tax == 0.0?SizedBox(height: 0,):Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  tax.isNegative || tax == 0.0?'Discount: ':'Delivery fee: ',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(top: 10), child: DottedLine())),
              Expanded(
                child: Text(tax.toStringAsFixed(2) + " " + currency,
                    textAlign: TextAlign.right, style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
          isHistory?Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Delivery fee: ',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(top: 10), child: DottedLine())),
              Expanded(
                child: Text(delivery.toString() + " " + currency,
                    textAlign: TextAlign.right, style: TextStyle(fontSize: 16)),
              ),
            ],
          ):SizedBox(height: 0,),
          appliedTaxes.isEmpty
              ? SizedBox(
                  height: 0,
                )
              : Column(
                  children: appliedTaxes
                      .map((item) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.label,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: DottedLine())),
                              Expanded(
                                child: Text(
                                    item.amount.value.toString() + currency,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ],
                          ))
                      .toList()),
          discounts.isEmpty
              ? SizedBox(
                  height: 0,
                )
              : Column(
                  children: [
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Discounts: ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    discounts.isEmpty
                        ? SizedBox(
                            height: 0,
                          )
                        : Column(
                            children: discounts
                                .map((item) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.label,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Container(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: DottedLine())),
                                        Expanded(
                                          child: Text(
                                              item.amount.value.toString() +
                                                  currency,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(fontSize: 16)),
                                        ),
                                      ],
                                    ))
                                .toList()),
                  ],
                ),
        ],
      ),
    );
  }
}
