import 'package:flutter/material.dart';

class LoadingDisplayWidget extends StatelessWidget {
  const LoadingDisplayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
