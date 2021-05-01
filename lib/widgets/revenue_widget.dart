import 'package:flutter/material.dart';

class RevenueWidget extends StatelessWidget {
  final double revenue;
  final MainAxisAlignment format;

  RevenueWidget(this.revenue, this.format);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: format,
      children: [
        Text(
          revenue >= 0 ? "Revenue: " : "Lost: ",
          style: revenue >= 0
              ? Theme.of(context).textTheme.headline3
              : Theme.of(context).textTheme.headline4,
        ),
        Text(
          revenue >= 0
              ? "+${revenue.toStringAsFixed(0)}"
              : revenue.toStringAsFixed(0),
          style: revenue >= 0
              ? Theme.of(context).textTheme.headline3
              : Theme.of(context).textTheme.headline4,
        )
      ],
    );
  }
}
