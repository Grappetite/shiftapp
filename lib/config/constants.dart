
import 'dart:ui';

const baseUrl = 'https://shift.grappetite.com/api/v1/';
const authorization = "Authorization";

const mainLoginToken = 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZjEyMmU3NmVhM2Y2Yzk4OWI2NjM2Njg0ODBkMGVjM2Q5YzJlM2JjOTQ0NzBkZDZlNDBmNzY1NWJhZTYyMjNiMzUyZWRlODYyZGRlNTUzMjkiLCJpYXQiOjE2NTg0ODI3MzMuNzY4MjU4LCJuYmYiOjE2NTg0ODI3MzMuNzY4MjYzLCJleHAiOjE2OTAwMTg3MzMuNzQ4NzY5LCJzdWIiOiIxNyIsInNjb3BlcyI6W119.j6TSmT_nLijVkuYvbt5-IbeasQmRi9OC6scs-isH6xBHEtDKGCa6ykcHfuWDblpLKrRW_MwmeChuKf1YsY7PSs5fUckoL3XtDOBg-3bdJAtg94qZbgpnPJxrLMznj85XqBp_-enY-dx3lZqg27TZglNTnRB_w9p9KPByst8qCUGtRUog9P-cD8gMuqS0nn3mOMtXIqxYuizZGz6K3HN3z3bv2edJeLpWk2HZoU_O5NbkeIywnYVvYv9ysT0WkOGqgrndt28q_irTM0n0iQjgPhB4nSkXC7NwRYy6e1G5K-B5lqL0i7rgJ-VR4bniKeV61Fe9PvbxaUM4qm3bzupvTLvcCu5Gvm5CA7isw7FMiVmLY-IlPZshLOrin3-MimwYLt2CuyGdwoLxZ1hkxRZJJpU5XGlhoFxrlOsK1RSWnYhs8Yr_xoN5DHL1YStnY25T7cyVSF4_OK0VqgTllbjdv7-B_QRXaEbFvjlHTF1IESrl1f-d-mVA0C9CUHq9WdvUKWEybPJxfPr-GqZ3zlkI6O7PMv0axyHsp44md36ZMPfNCKj4MhEgqajckke6MHp7sM1iZCeiC7PPXdCGM13KrJDm3E7u1IGiW9O1JiZZpT1YXKVPjeLV7nnOtrxjZWKslxzCtAA-h93JCdvnr-3ezsv3i7hyt4aF-datUADBv48';

const tokenKey = "tokenKey";

const kPrimaryColor = Color.fromRGBO(38, 86, 125, 1.0);
const kSecondaryColor = Color(0xFF39d2d4);

const mainBackGroundColor = Color.fromRGBO(38, 86, 125, 1.0);

const whiteBackGroundColor = Color.fromRGBO(255, 255, 255, 1.0);

const lightBlueColor = Color.fromRGBO(94, 193, 220, 0.25);

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