import 'package:dairyfarmapp/util/constents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

void showLoader(BuildContext context) {
  Loader.show(
    context,
    progressIndicator: const CircularProgressIndicator(
      color: primaryColor,
    ),
  );
}

void stopLoader() {
  Loader.hide();
}
