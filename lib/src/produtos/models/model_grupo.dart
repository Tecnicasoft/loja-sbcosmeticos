import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class GrupoModel extends GetxController {
  int id;
  int parentID;
  String descricao;
  String? descricaoDetalhes;

  GrupoModel({
    this.id = 0,
    this.parentID = 0,
    this.descricao = '',
    this.descricaoDetalhes,
  });

  factory GrupoModel.fromJson(Map<String, dynamic> json) {
    return GrupoModel(
      id: json['Id'] as int,
      parentID: json['ParentID'] as int,
      descricao: json['Nome'] as String,
      descricaoDetalhes: json['DescricaoApp'] as String?,
    );
  }
}
