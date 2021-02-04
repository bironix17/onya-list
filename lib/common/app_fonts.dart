import 'package:flutter/material.dart';

class AppFonts {
  static final _faBrandsFontFamily = 'fa_brands';
  static final _faCommonFontFamily = 'fa_common';
  static const _sfUiDisplayFontFamily = 'sf_ui_display';
  static final _gilroy = 'gilroy';

  static final faBrands = TextStyle(
    fontFamily: _faBrandsFontFamily,
  );

  static final faRegular = TextStyle(
    fontFamily: _faCommonFontFamily,
    fontWeight: FontWeight.w400,
  );

  static final faSolid = TextStyle(
    fontFamily: _faCommonFontFamily,
    fontWeight: FontWeight.w900,
  );

  static final sfUiDisplay = sfUiDisplayRegular;

  static const sfUiDisplayRegular = TextStyle(
    fontFamily: _sfUiDisplayFontFamily,
  );

  static final sfUiDisplayMedium = TextStyle(
    fontFamily: _sfUiDisplayFontFamily,
    fontWeight: FontWeight.w600,
  );

  static const sfUiDisplayBold = TextStyle(
    fontFamily: _sfUiDisplayFontFamily,
    fontWeight: FontWeight.w700,
  );

  static final sfUiDisplaySemiBond = TextStyle(
    fontFamily: _sfUiDisplayFontFamily,
    fontWeight: FontWeight.w800,
  );

  static final gilroy = TextStyle(
    fontFamily: _gilroy,
    fontWeight: FontWeight.w900,
  );
}
