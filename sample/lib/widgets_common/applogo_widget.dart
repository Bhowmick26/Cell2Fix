import 'package:sample/consts/consts.dart';

Widget applogoWidget() {
  return Image.asset(icAppLogo)
      .box
      .white
      .size(125, 95)
      .padding(const EdgeInsets.all(8))
      .rounded
      .make();
}
