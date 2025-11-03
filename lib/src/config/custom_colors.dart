import 'package:flutter/material.dart';

abstract class CustomColors {
  static const Map<int, Color> swatch = {
    50: Color.fromRGBO(139, 195, 74, .1),
    100: Color.fromRGBO(139, 195, 74, .2),
    200: Color.fromRGBO(139, 195, 74, .3),
    300: Color.fromRGBO(139, 195, 74, .4),
    400: Color.fromRGBO(139, 195, 74, .5),
    500: Color.fromRGBO(139, 195, 74, .6),
    600: Color.fromRGBO(139, 195, 74, .7),
    700: Color.fromRGBO(139, 195, 74, .8),
    800: Color.fromRGBO(139, 195, 74, .9),
    900: Color.fromRGBO(139, 195, 74, 1),
  };

  static Color customContrastColor = Colors.red.shade900;
  static const MaterialColor customSwatchColor = MaterialColor(
    0xFF8BC34A,
    swatch,
  );
  static const Color colorFundoPrimario = Color.fromRGBO(252, 201, 41, 1);
  static const Color colorFundoShadow = Color.fromRGBO(252, 201, 41, 1);
  static const Color colorTextoPrimario = Color.fromARGB(255, 255, 254, 253);
  static const Color colorTextoNaoSelecionado = Color.fromARGB(255, 0, 0, 0);
  static const Color colorIcons = Color.fromRGBO(91, 71, 60, 1);
  static const Color colorBottonCompra = Color.fromRGBO(91, 71, 60, 1);
  static const Color colorBottonContinuarCompra =
      Color.fromARGB(255, 205, 202, 34);
  static Color colorFundo = const Color.fromARGB(255, 243, 245, 246);
  static Color textoBottao = const Color.fromARGB(255, 97, 97, 97);
  static Color colorFundoObs = const Color.fromARGB(255, 224, 235, 78);
  static Color colorIconUnselect = const Color.fromRGBO(91, 71, 60, 1);

  // static const Color colorFundoPrimario = Color.fromARGB(255, 228, 153, 13);
  // static const Color colorFundoShadow = Color.fromARGB(255, 227, 179, 90);
  // static const Color colorTextoPrimario = Color.fromARGB(255, 255, 254, 253);
  // static const Color colorTextoNaoSelecionado = Color.fromARGB(255, 0, 0, 0);
  // static const Color colorIcons = Color.fromARGB(255, 0, 0, 0);
  // static const Color colorBottonCompra = Color.fromARGB(255, 239, 98, 11);
  // static Color colorFundo = const Color.fromARGB(255, 246, 243, 243);
}

abstract class ConfigApp {
  static String get nomeLoja => "na SB Cosmeticos";
  static String get nomeBancoDados => "sbcosmeticos";
  //static String retornaUrlAPI(String key) => "http://192.168.0.4:3000";
  static String retornaUrlAPI(String key) =>
      "http://lb-tecnicasoft-1224673766.sa-east-1.elb.amazonaws.com:3000";
}
