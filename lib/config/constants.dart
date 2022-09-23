import 'dart:ui';

import 'package:shiftapp/config/BaseConfig.dart';

// const baseUrl = 'https://dev-shift.grappetite.com/api/v1/';
var baseUrl = Environment().config.apiUrl;
// const baseUrl = 'https://takealot.grappetite.com/api/v1/';
//const baseUrl = 'https://shift.grappetite.com/api/v1/';
//https://dev-shift.grappetite.com
const authorization = "Authorization";

const tokenKey = "tokenKey";

const kPrimaryColor = Color.fromRGBO(38, 86, 125, 1.0);
const kSecondaryColor = Color(0xFF39d2d4);

const mainBackGroundColor = Color.fromRGBO(38, 86, 125, 1.0);

const whiteBackGroundColor = Color.fromRGBO(255, 255, 255, 1.0);

const lightBlueColor = Color.fromRGBO(94, 193, 220, 0.25);

const lightGreenColor = Color.fromRGBO(212, 237, 218, 1);

const lightRedColor = Color.fromRGBO(237, 212, 215, 1);

//, ,

//rgba(94, 193, 220, 0.25)

Map<int, Color> primaryMap = {
  50: const Color.fromRGBO(38, 86, 125, 0.1),
  100: const Color.fromRGBO(38, 86, 125, 0.2),
  200: const Color.fromRGBO(38, 86, 125, 0.3),
  300: const Color.fromRGBO(38, 86, 125, 0.4),
  400: const Color.fromRGBO(38, 86, 125, 0.5),
  500: const Color.fromRGBO(38, 86, 125, 0.6),
  600: const Color.fromRGBO(38, 86, 125, 0.7),
  700: const Color.fromRGBO(38, 86, 125, 0.8),
  800: const Color.fromRGBO(38, 86, 125, 0.9),
  900: const Color.fromRGBO(38, 86, 125, 1.0),
};

//38, 86, 125, 1.0
