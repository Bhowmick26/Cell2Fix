import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sample/consts/consts.dart';
import 'package:sample/consts/lists.dart';
import 'package:sample/controllers/product_controller.dart';
import 'package:sample/views/chat_screen/chat_screen.dart';
import 'package:sample/widgets_common/our_button.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({Key? key, required this.title, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        controller.resetValue();
        return true;
      },
      child: Scaffold(
          backgroundColor: lightGrey,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                controller.resetValue();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
              Obx(
                () => IconButton(
                    onPressed: () {
                      if (controller.isFav.value) {
                        controller.removeFromWishList(data.id, context);
                      } else {
                        controller.addToWishList(data.id, context);
                      }
                    },
                    icon: Icon(
                      Icons.favorite_outlined,
                      color: controller.isFav.value ? redColor : darkFontGrey,
                    )),
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //swiper section
                            VxSwiper.builder(
                                autoPlay: true,
                                height: 400,
                                itemCount: data['p_imgs'].length,
                                aspectRatio: 16 / 9,
                                viewportFraction: 1.0,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    data["p_imgs"][index],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                }),
                            10.heightBox,
                            //title and details
                            title!.text
                                .size(16)
                                .color(darkFontGrey)
                                .fontFamily(semibold)
                                .make(),
                            10.heightBox,
                            VxRating(
                              isSelectable: false,
                              value: double.parse(data['p_rating']),
                              onRatingUpdate: (value) {},
                              normalColor: textfieldGrey,
                              selectionColor: golden,
                              count: 5,
                              maxRating: 5,
                              size: 25,
                            ),
                            10.heightBox,
                            "${data['p_price']}"
                                .numCurrency
                                .text
                                .color(redColor)
                                .fontFamily(bold)
                                .size(18)
                                .make(),

                            10.heightBox,
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    "Seller"
                                        .text
                                        .white
                                        .fontFamily(semibold)
                                        .make(),
                                    5.heightBox,
                                    "${data['p_seller']}"
                                        .text
                                        .fontFamily(semibold)
                                        .size(16)
                                        .make(),
                                  ],
                                )),
                                const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.message_rounded,
                                      color: darkFontGrey),
                                ).onTap(() {
                                  Get.to(
                                    () => const ChatScreen(),
                                    arguments: [
                                      data['p_seller'],
                                      data['vendor_id']
                                    ],
                                  );
                                }),
                              ],
                            )
                                .box
                                .height(60)
                                .padding(
                                    const EdgeInsets.symmetric(horizontal: 16))
                                .color(textfieldGrey)
                                .make(),

                            //color selection
                            20.heightBox,
                            Obx(
                              () => Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: 100,
                                          child: "Color:"
                                              .text
                                              .color(textfieldGrey)
                                              .make()),
                                      Row(
                                        children: List.generate(
                                            3,
                                            (index) => VxBox()
                                                .size(40, 40)
                                                .roundedFull
                                                .color(Vx.randomPrimaryColor)
                                                .margin(
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4))
                                                .make()),
                                      ),
                                    ],
                                  ).box.padding(const EdgeInsets.all(8)).make(),

                                  //quantity row
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: 100,
                                          child: "Quantity:"
                                              .text
                                              .color(textfieldGrey)
                                              .make()),
                                      Obx(
                                        () => Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  controller.decreaseQuantity();
                                                  controller
                                                      .calculateTotalPrice(
                                                          int.parse(
                                                              data['p_price']));
                                                },
                                                icon: const Icon(Icons.remove)),
                                            controller.quantity.value.text
                                                .size(16)
                                                .color(darkFontGrey)
                                                .fontFamily(bold)
                                                .make(),
                                            IconButton(
                                                onPressed: () {
                                                  controller.increaseQuantity(
                                                      int.parse(
                                                          data['p_quantity']));
                                                  controller
                                                      .calculateTotalPrice(
                                                          int.parse(
                                                              data['p_price']));
                                                },
                                                icon: const Icon(Icons.add)),
                                            10.widthBox,
                                            "(${data['p_quantity']} available)"
                                                .text
                                                .color(textfieldGrey)
                                                .make()
                                          ],
                                        ),
                                      ),
                                    ],
                                  ).box.padding(const EdgeInsets.all(8)).make(),

                                  //total Row
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: 100,
                                          child: "Total:"
                                              .text
                                              .color(textfieldGrey)
                                              .make()),
                                      "${controller.totalPrice.value}"
                                          .numCurrency
                                          .text
                                          .color(redColor)
                                          .size(16)
                                          .fontFamily(bold)
                                          .make(),
                                    ],
                                  ).box.padding(const EdgeInsets.all(8)).make(),
                                ],
                              ).box.white.shadowSm.make(),
                            ),

                            //description section

                            10.heightBox,
                            "Description"
                                .text
                                .color(darkFontGrey)
                                .fontFamily(semibold)
                                .make(),
                            10.heightBox,
                            "${data['p_desc']}".text.color(darkFontGrey).make(),

                            //buttons section
                            10.heightBox,

                            ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: List.generate(
                                  itemDetailsButtonsList.length,
                                  (index) => ListTile(
                                        title: itemDetailsButtonsList[index]
                                            .text
                                            .fontFamily(semibold)
                                            .color(darkFontGrey)
                                            .make(),
                                        trailing:
                                            const Icon(Icons.arrow_forward),
                                      )),
                            ),
                            20.heightBox,

                            //products you may like section

                            productsyoumaylike.text
                                .fontFamily(bold)
                                .size(16)
                                .color(darkFontGrey)
                                .make(),
                            10.heightBox,
                            //i copied this widget from homescreen file(featured products)
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                    6,
                                    (index) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              imgP1,
                                              width: 130,
                                              fit: BoxFit.cover,
                                            ),
                                            10.heightBox,
                                            "Laptop 4GB/64GB"
                                                .text
                                                .fontFamily(semibold)
                                                .color(darkFontGrey)
                                                .make(),
                                            10.heightBox,
                                            "\$600"
                                                .text
                                                .color(redColor)
                                                .fontFamily(bold)
                                                .size(16)
                                                .make()
                                          ],
                                        )
                                            .box
                                            .white
                                            .margin(const EdgeInsets.symmetric(
                                                horizontal: 4))
                                            .roundedSM
                                            .padding(const EdgeInsets.all(8))
                                            .make()),
                              ),
                            )
                          ],
                        ),
                      ))),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ourButton(
                    color: redColor,
                    onPress: () {
                      if (controller.quantity.value > 0) {
                        controller.addToCart(
                            context: context,
                            vendorID: data['vendor_id'],
                            img: data['p_imgs'][0],
                            qty: controller.quantity.value,
                            sellername: data['p_seller'],
                            title: data['p_name'],
                            tprice: controller.totalPrice.value);
                        VxToast.show(context, msg: "Added to Cart");
                      } else {
                        VxToast.show(context,
                            msg: "Please select the quantitiy");
                      }
                    },
                    textColor: whiteColor,
                    title: "Add to Cart"),
              ),
            ],
          )),
    );
  }
}
