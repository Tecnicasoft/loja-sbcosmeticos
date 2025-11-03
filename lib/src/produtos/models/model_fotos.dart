import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FotoModel extends GetxController {
  String foto;

  FotoModel({
    this.foto = '',
  });

  factory FotoModel.fromJson(Map<String, dynamic> json) {
    return FotoModel(
      foto: json['foto'] as String,
    );
  }
}
