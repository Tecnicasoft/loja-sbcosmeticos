import 'dart:convert';

class Pet {
  int id;
  String guid;
  String nome;
  String dataNascimento;
  int idEspecie;
  String sexo;
  int idRaca;
  int idCor;
  int idPorte;
  int idCliente;
  String stringEspecie;
  String stringRaca;
  String stringCor;
  String stringPorte;
  String? foto;

  Pet({
    this.id = 0,
    this.guid = '',
    this.nome = '',
    this.dataNascimento = '',
    this.idEspecie = 0,
    this.sexo = '',
    this.idRaca = 0,
    this.idCor = 0,
    this.idPorte = 0,
    this.idCliente = 0,
    this.stringEspecie = '',
    this.stringRaca = '',
    this.stringCor = '',
    this.stringPorte = '',
    this.foto,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    // Processa o campo Foto que vem como Map da API
    String? fotoProcessada;

    if (json['Foto'] != null) {
      final fotoData = json['Foto'];

      if (fotoData is Map<String, dynamic>) {
        // Se o Map tem exatamente 2 items, provavelmente um é a chave e outro são os dados
        if (fotoData.length == 2) {
          final valores = fotoData.values.toList();

          // Procura por dados binários (lista de números)
          for (int i = 0; i < valores.length; i++) {
            final valor = valores[i];

            if (valor is List && valor.isNotEmpty && valor.first is int) {
              try {
                final bytes = List<int>.from(valor);
                fotoProcessada =
                    'data:image/jpeg;base64,${base64Encode(bytes)}';
                break;
              } catch (e) {
                // Erro silencioso
              }
            }
          }
        }

        // Fallback: procura por chaves comuns
        if (fotoProcessada == null) {
          final chaves = ['Foto', 'foto', 'data', 'bytes', 'buffer', 'image'];
          for (final chave in chaves) {
            if (fotoData.containsKey(chave)) {
              final valor = fotoData[chave];
              if (valor is List) {
                try {
                  final bytes = List<int>.from(valor);
                  fotoProcessada =
                      'data:image/jpeg;base64,${base64Encode(bytes)}';
                  break;
                } catch (e) {
                  // Erro silencioso
                }
              }
            }
          }
        }
      } else if (fotoData is List) {
        try {
          final bytes = List<int>.from(fotoData);
          fotoProcessada = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        } catch (e) {
          // Erro silencioso
        }
      } else if (fotoData is String) {
        fotoProcessada = fotoData;
      }
    }

    return Pet(
      id: json['IdAnimal'] as int? ?? 0,
      guid: json['GUID'] as String? ?? '',
      nome: json['Nome'] as String? ?? '',
      dataNascimento: json['DataNasci'] as String? ?? '',
      idEspecie: json['IdEspecie'] as int? ?? 0,
      sexo: json['Sexo'] as String? ?? '',
      idRaca: json['IdRaca'] as int? ?? 0,
      idCor: json['IdCor'] as int? ?? 0,
      idPorte: json['IdPorte'] as int? ?? 0,
      idCliente: json['Idcliente'] as int? ?? 0,
      stringEspecie: json['Especie'] as String? ?? '',
      stringRaca: json['Raca'] as String? ?? '',
      stringCor: json['Cor'] as String? ?? '',
      stringPorte: json['Porte'] as String? ?? '',
      foto: fotoProcessada,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'guid': guid,
      'nome': nome,
      'DataNasci': dataNascimento,
      'idEspecie': idEspecie,
      'sexo': sexo,
      'idRaca': idRaca,
      'idCor': idCor,
      'idPorte': idPorte,
      'idCliente': idCliente,
      'Especie': stringEspecie,
      'Raca': stringRaca,
      'Cor': stringCor,
      'Porte': stringPorte,
      'Foto': foto,
    };
  }

  Pet copyWith({
    int? id,
    String? guid,
    String? nome,
    String? dataNascimento,
    int? idEspecie,
    String? sexo,
    int? idRaca,
    int? idCor,
    int? idPorte,
    int? idCliente,
  }) {
    return Pet(
      id: id ?? this.id,
      guid: guid ?? this.guid,
      nome: nome ?? this.nome,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      idEspecie: idEspecie ?? this.idEspecie,
      sexo: sexo ?? this.sexo,
      idRaca: idRaca ?? this.idRaca,
      idCor: idCor ?? this.idCor,
      idPorte: idPorte ?? this.idPorte,
      idCliente: idCliente ?? this.idCliente,
    );
  }
}
