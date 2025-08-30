import 'package:flutter/material.dart';

class ItemButton extends StatelessWidget {
  const ItemButton({super.key, this.value = '', this.onTap, this.color});

  final String value;
  final VoidCallback? onTap;
  final Color? color;

  Color get background {
    return color ?? Color(0xFF2E2F38);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: Colors.black12,
        color: background,
        surfaceTintColor: background,
        child: Center(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
