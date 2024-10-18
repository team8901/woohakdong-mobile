import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';

class GeneralFunctions {
  static Future<bool?> generalToastMessage(String msg) async {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      fontSize: 14,
      fontAsset: 'assets/fonts/pretendard/Pretendard-SemiBold.otf',
      backgroundColor: const Color(0xFF6C6E75).withOpacity(0.8),
      textColor: const Color(0xFFFCFCFC),
    );
  }
}
