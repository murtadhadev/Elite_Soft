import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("انتظر من فضلك..."),
        ],
      ),
    );
  }
}
