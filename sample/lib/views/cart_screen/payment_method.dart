import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sample/consts/consts.dart';
import 'package:sample/consts/lists.dart';
import 'package:sample/controllers/cart_controller.dart';
import 'package:sample/views/home_screen/home.dart';
import 'package:sample/widgets_common/loading_indicator.dart';
import 'package:sample/widgets_common/our_button.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value
              ? Center(
                  child: loadingIndicator(),
                )
              : ourButton(
                  onPress: () async {
                    await controller.placeMyOrder(
                        orderPaymentMethod:
                            paymentMethods[controller.paymentIndex.value],
                        totalAmount: controller.totalP.value);

                    await controller.clearCart();
                    VxToast.show(context, msg: "Order placed successfully");
                    Get.offAll(Home());
                  },
                  color: redColor,
                  textColor: whiteColor,
                  title: "Place my order",
                ),
        ),
        appBar: AppBar(
          title: "Choose Payment Method"
              .text
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(
            () => Column(
              children: List.generate(paymentMethodsImg.length, (index) {
                return GestureDetector(
                  onTap: () {
                    controller.changePaymentIndex(index);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.paymentIndex.value == index
                              ? Colors.black
                              : Colors.transparent,
                          width: 4,
                        )),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.asset(paymentMethodsImg[index],
                            width: double.infinity,
                            height: 120,
                            colorBlendMode:
                                controller.paymentIndex.value == index
                                    ? BlendMode.darken
                                    : BlendMode.color,
                            color: controller.paymentIndex.value == index
                                ? Colors.black.withOpacity(0.4)
                                : Colors.transparent,
                            fit: BoxFit.cover),
                        controller.paymentIndex.value == index
                            ? Transform.scale(
                                scale: 1.2,
                                child: Checkbox(
                                    activeColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    value: true,
                                    onChanged: (value) {}),
                              )
                            : Container(),
                        Positioned(
                            bottom: 10,
                            right: 10,
                            child: paymentMethods[index]
                                .text
                                .white
                                .fontFamily(semibold)
                                .size(16)
                                .make()),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
