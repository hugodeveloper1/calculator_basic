import 'package:flutter/material.dart';
import 'keyboard_widget.dart';

class DisplayWidget extends StatelessWidget {
  const DisplayWidget({super.key, required this.operation, this.result = ''});

  final String result;
  final String operation;

  String get resultText {
    if (result.isNotEmpty) {
      return result;
    } else {
      return operation;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return SizedBox(
          width: width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (result.isNotEmpty)
                  Flexible(
                    child: FittedBox(
                      alignment: Alignment.centerRight,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        operation,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 25,
                          color: secondaryGray,
                        ),
                      ),
                    ),
                  ),
                Flexible(
                  child: FittedBox(
                    alignment: Alignment.centerRight,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      resultText,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
