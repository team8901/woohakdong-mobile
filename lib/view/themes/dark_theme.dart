import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woohakdong/view/themes/spacing.dart';
import 'package:woohakdong/view/themes/text_style.dart';

/// 주요 색상
const Color primary = Color(0xFF3D63DD);
const Color secondaryPrimary = Color(0xFF1D2E61);
const Color red = Color(0xFFE53935);
const Color green = Color(0xFF43A047);

/// 그레이 스케일
const Color black = Color(0xFF111111);
const Color darkGray = Color(0xFF6C6E75);
const Color gray = Color(0xFF797B82);
const Color lightGray = Color(0xFFB2B4B9);
const Color white = Color(0xFFEDEEEF);

final ThemeData darkTheme = ThemeData(
  /// 기본
  brightness: Brightness.dark,
  primaryColor: primary,
  scaffoldBackgroundColor: black,
  applyElevationOverlayColor: false,
  splashColor: darkGray.withOpacity(0.1),
  highlightColor: darkGray.withOpacity(0.1),

  /// 컬러 스키마
  colorScheme: const ColorScheme.dark(
    primary: primary,
    inversePrimary: white,
    secondary: secondaryPrimary,
    surfaceContainer: darkGray,
    onSurface: lightGray,
    inverseSurface: white,
    outline: gray,
    error: red,
    onError: white,
    tertiary: green,
    onTertiary: white,
    surfaceDim: black,
  ),

  /// 텍스트 테마
  textTheme: TextTheme(
    headlineLarge: CustomTextStyle.headerLarge.copyWith(color: white),
    headlineSmall: CustomTextStyle.headerSmall.copyWith(color: white),
    titleLarge: CustomTextStyle.titleLarge.copyWith(color: white),
    titleMedium: CustomTextStyle.titleMedium.copyWith(color: white),
    titleSmall: CustomTextStyle.titleSmall.copyWith(color: white),
    bodyLarge: CustomTextStyle.bodyLarge.copyWith(color: white),
    bodyMedium: CustomTextStyle.bodyMedium.copyWith(color: white),
    bodySmall: CustomTextStyle.bodySmall.copyWith(color: white),
    labelLarge: CustomTextStyle.labelLarge.copyWith(color: white),
  ),

  /// 텍스트 선택 테마
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: white,
    selectionColor: lightGray,
    selectionHandleColor: primary,
  ),

  /// 쿠퍼티노 텍스트 선택 테마
  cupertinoOverrideTheme: const CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: primary,
  ),

  /// 앱바 테마
  appBarTheme: const AppBarTheme(
    backgroundColor: black,
    titleSpacing: defaultPaddingM,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    iconTheme: IconThemeData(color: white),
    actionsIconTheme: IconThemeData(color: white),
  ),

  /// 아이콘 테마
  iconTheme: const IconThemeData(
    color: white,
  ),

  /// 바텀 네비게이션바 테마
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: black,
    elevation: 0,
    selectedItemColor: white,
    unselectedItemColor: lightGray,
    selectedLabelStyle: CustomTextStyle.labelLarge.copyWith(color: white),
    unselectedLabelStyle: CustomTextStyle.labelLarge.copyWith(color: lightGray),
    type: BottomNavigationBarType.fixed,
    enableFeedback: false,
  ),

  /// 서치바 태마
  searchBarTheme: SearchBarThemeData(
    elevation: const WidgetStatePropertyAll(0),
    backgroundColor: const WidgetStatePropertyAll(darkGray),
    surfaceTintColor: const WidgetStatePropertyAll(darkGray),
    side: const WidgetStatePropertyAll(BorderSide.none),
    shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadiusM)),
    )),
    textStyle: WidgetStatePropertyAll(CustomTextStyle.titleSmall.copyWith(color: white)),
    hintStyle: WidgetStatePropertyAll(CustomTextStyle.titleSmall.copyWith(color: lightGray)),
  ),

  /// 스낵바 테마
  snackBarTheme: SnackBarThemeData(
    backgroundColor: darkGray,
    contentTextStyle: CustomTextStyle.bodySmall.copyWith(color: white),
  ),

  /// 팝업 메뉴 버튼 테마
  popupMenuTheme: PopupMenuThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(defaultBorderRadiusM),
    ),
    color: darkGray,
    labelTextStyle: WidgetStateProperty.all(CustomTextStyle.bodySmall.copyWith(color: white)),
    elevation: 1,
    menuPadding: const EdgeInsets.all(defaultPaddingS / 2),
  ),

  /// 다이어로그 테마
  dialogTheme: DialogTheme(
    backgroundColor: darkGray,
    surfaceTintColor: darkGray,
    elevation: 1,
    alignment: Alignment.center,
    insetPadding: const EdgeInsets.symmetric(horizontal: defaultPaddingM * 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(defaultBorderRadiusM),
    ),
  ),
);
