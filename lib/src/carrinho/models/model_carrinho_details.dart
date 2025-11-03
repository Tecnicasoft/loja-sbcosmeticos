import 'package:get/get.dart';

class CarrinhoDetails extends GetxController {
  final RxInt _qtd = 0.obs;

  get qtd => _qtd.value;

  set qtd(value) => _qtd.value = value;

  // @override
  // void onInit() {
  //   super.onInit();
  //   //var qtd = _qtd.value;
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  //   Future.delayed(const Duration(seconds: 5), () {
  //     _qtd.value = 5;
  //   });
  // }
  CarrinhoDetails({int qtd = 0}) {
    _qtd.value = qtd;
  }

  factory CarrinhoDetails.fromJson(Map<dynamic, dynamic> json) {
    return CarrinhoDetails(
      qtd: json['qtd'] as int,
    );
  }
}
