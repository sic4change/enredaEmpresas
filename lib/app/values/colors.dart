part of values;

class AppColors {
  static const Color primaryColor = Color(0xFF00CCCC);
  //Shades of primary color
  static const Color primary050 = Color(0xFFEDFAF9);
  static const Color primary100 = Color(0xFFA7E4E1);
  static const Color primary200 = Color(0xFF00CCCC);
  static const Color primary300 = Color(0xFF00CCCC);
  static const Color primary400 = Color(0xFF00D0CE);
  static const Color primary500 = Color(0xFF18C5C1);
  static const Color primary600 = Color(0xFF0BCCC6);
  static const Color primary900 = Color(0xFF054D5E);
  static const Color primary060 = Color(0xFFB5F0F0);
  static const Color primary040 = Color(0xFFCCFAF0);
  static const Color primary030 = Color(0xFFDBF1F1);
  static const Color primary020 = Color(0xFFCDDBDF);
  static const Color primary010 = Color(0xFFEEFAFA);

  //accent Colors
  static const Color accentColor = Color(0xFFF7F7F7);
  static const Color accentColor100 = Color(0xFFF2F0F1);

  //Accent colors
  static const Color primaryText1 = Color(0xFF959595);
  static const Color primaryText2 = Color(0xFF717171);

  //black
  static const Color black = Color(0xFF000000);
  static const Color black400 = Color(0xFF212121);
  static const Color black100 = Color(0xFF313131);
  static const Color black200 = Color(0xFF2D2D2D);

  //White
  static const Color white = Color(0xFFFFFFFF);
  static const Color altWhite = Color(0xFFFCFCFC);
  static const Color offWhite = Color(0xFFF3F3F3);
  static const Color darkWhite = Color(0xFFDFDFDF);
  static const Color offWhite200 = Color(0xFFE5E5DB);
  static const Color lightWhite = Color(0xFFF2F2F2);

  //Green
  static const Color greenLight = Color(0xFFA4F5F6);

  //Blue
  static const Color blue050 = Color(0xFF82A6AE);
  static const Color seaBlue = Color(0xFF4E657E);
  static const Color turquoiseBlue = Color(0xFF054D5E);
  static const Color blue300 = Color(0xFF2867F0);
  static const Color blueDarker = Color(0xFF2C5F73);
  static const Color blueViolet = Color(0xFFB5C2EB);
  static const Color blueLight = Color(0xFF5876D2);
  static const Color blueDark = Color(0xFF002185);
  static const Color blueAlt = Color(0xFF5F7ED9);
  static const Color bluePetrol = Color(0xFF054D5E);
  static const Color blueLightInfo = Color(0xFFEDFAF9);

  //Yellow
  static const Color lightYellow = Color(0xFFFFDCB1);
  static const Color yellow = Color(0xFFFFCB77);
  static const Color darkYellow = Color(0xFFF2A241);

  //Pink
  static const Color pink300 = Color(0xFFDC5687);
  static const Color pink600 = Color(0xFFAB1F8C);

  //Grey
  static const Color grey50 = Color(0xFFF2F1F1);
  static const Color grey70 = Color(0xFFEDECEC);
  static const Color grey80 = Color(0xFFFCFCFC);
  static const Color grey100 = Color(0xFFE7E7E7);
  static const Color grey150 = Color(0xFFC6C6C6);
  static const Color grey250 = Color(0xFFBBBBBB);
  static const Color grey300 = Color(0xFFBABABA);
  static const Color grey350 = Color(0xFFADADAD);
  static const Color gre500 = Color(0xff707070);
  static const Color gre600 = Color(0xFF1819454D);
  static const Color greyBlue = Color(0xFFC2D1D5);
  static const Color greyLight = Color(0xFFF4F5FB);
  static const Color greyViolet = Color(0xFF6768AB);
  static const Color greyAlt = Color(0xFF44494B);
  static const Color greyDark = Color(0xFF44494B);
  static const Color greyUltraLight = Color(0xFFD9D9D9);
  static const Color greyTxtAlt = Color(0xFF535A5F);
  static const Color greyLight2 = Color(0xFF181945);
  static const Color greyDark2 = Color(0xFF44494B);
  static const Color greyBorder = Color(0xFFCBCBCB);
  static const Color greyLetter = Color(0xFF4E657E);
  static const Color greyChip = Color(0xFFF5F5F5);
  static const Color greySearch = Color(0xFFEBF1F2);
  static const Color greyDropMenuBorder = Color(0xFFB8B8C5);

  //Violet
  static const Color darkViolet = Color(0xFFA0A5D2);
  static const Color violet = Color(0xFFE3E4F2);
  static const Color lightViolet = Color(0xFFD7DAF7);
  static const Color ultraLightViolet = Color(0xFFD7DAF8);
  static const Color darkGray = Color(0xFF535A5F);
  static const Color lightLilac = Color(0xFFF4F5FB);
  static const Color lilac = Color(0xFFA0A5D2);
  static const Color darkLilac = Color(0xFF6768AB);
  static const Color penLightBlue = Color(0xFF5776D1);
  static const Color penBlue = Color(0xFF002185);
  static const Color chatLightBlue = Color(0xFFE3EAFF);
  static const Color chatDarkBlue = Color(0xFF5876D2);
  static const Color chatDarkGray = Color(0xFF44494B);
  static const Color chatLightGray = Color(0xFFF1F3F4);
  static const Color chatButtonsGray = Color(0xFFA0A0A7);
  static const Color deleteRed = Color(0xFFAC0336);

  //Turquoise
  static const Color turquoise = Color(0xFF00D0CE);
  static const Color lightTurquoise = Color(0xFFB5F0F0);
  static const Color onHoverTurquoise = Color(0xFFEFFDFA);
  static const Color turquoiseAlt = Color(0xFF00CCCC);
  static const Color turquoiseButton = Color(0xFF00D0CE);
  static const Color turquoiseButton2 = Color(0xFF18C5C1);
  static const Color turquoiseUltraLight = Color(0xFFCDDBDF);

  //Red
  static const Color red = Color(0xFFF1291A);
  static const Color red050 = Color(0xFFD32D50);

  //Evaluation gradient

  static const Color redGradient = Color(0xFFE81616);
  static const Color orangeGradient = Color(0xFFFF9100);
  static const Color greenGradient = Color(0xFF24F18F);

  static const Gradient sliderGradient = LinearGradient(
      colors: <Color> [
        AppColors.redGradient,
        AppColors.orangeGradient,
        AppColors.greenGradient,
      ]
  );

}