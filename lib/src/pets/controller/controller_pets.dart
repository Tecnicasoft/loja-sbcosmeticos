import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:petshop_template/src/pets/models/model_cor.dart';
import 'package:petshop_template/src/pets/models/model_especie.dart';
import 'package:petshop_template/src/pets/models/model_pet.dart';
import 'package:petshop_template/src/pets/models/model_porte.dart';
import 'package:petshop_template/src/pets/models/model_raca.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetsController extends GetxController {
  final uri = Util.uri;

  // Obter token de autenticação
  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  // Headers padrão para requisições
  Future<Map<String, String>> _getHeaders() async {
    String token = await _getToken();
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  /// Busca pets por cliente
  Future<List<Pet>> getPetsByCliente(String guidCliente) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();

      http.Client client = http.Client();
      final response = await client.get(
        Uri.parse('$uri/pets/retornaPetsClienteGuid?clienteGuid=$guidCliente'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return _parsePets(response.body);
      } else {
        throw Exception('Erro ao carregar pets: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar pets: $e');
    }
  }

  /// Busca todos os pets (com filtro opcional)
  Future<List<Pet>> getPets({String? filter}) async {
    try {
      var params = {"find": filter ?? ""};
      String body = json.encode(params);

      http.Client client = http.Client();
      final response = await client.post(
        Uri.parse('$uri/pets/buscar'),
        headers: await _getHeaders(),
        body: body,
      );

      if (response.statusCode == 200) {
        return _parsePets(response.body);
      } else {
        throw Exception('Erro ao carregar pets: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar pets: $e');
    }
  }

  /// Salva um novo pet
  Future<bool> salvarPet(Pet pet) async {
    try {
      String body = json.encode(pet.toJson());

      http.Client client = http.Client();
      final response = await client.post(
        Uri.parse('$uri/pets/cadastraPet'),
        headers: await _getHeaders(),
        body: body,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Erro ao salvar pet: $e');
    }
  }

  /// Atualiza um pet existente
  Future<bool> atualizarPet(Pet pet) async {
    try {
      String body = json.encode(pet.toJson());

      http.Client client = http.Client();
      final response = await client.put(
        Uri.parse('$uri/pets/atualizaPet?id=${pet.id}'),
        headers: await _getHeaders(),
        body: body,
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Erro ao atualizar pet: $e');
    }
  }

  /// Envia foto usando Base64 (compatível com ASPxBinaryImage.ContentBytes)

  /// Determina o tipo de arquivo baseado na extensão
  String _obterTipoArquivo(String caminhoImagem) {
    final extensao = caminhoImagem.toLowerCase().split('.').last;
    switch (extensao) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg'; // Padrão
    }
  }

  /// Busca a foto do pet no servidor e retorna a URL ou null
  Future<String?> buscarFotoPet(int idPet) async {
    try {
      http.Client client = http.Client();
      final response = await client.get(
        Uri.parse('$uri/pets/buscarFotoPet?id=$idPet'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['url'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Exclui um pet
  Future<bool> excluirPet(int idPet) async {
    try {
      http.Client client = http.Client();
      final response = await client.delete(
        Uri.parse('$uri/pets/excluir/$idPet'),
        headers: await _getHeaders(),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Erro ao excluir pet: $e');
    }
  }

  /// Busca todas as espécies
  Future<List<Especie>> getEspecies() async {
    try {
      http.Client client = http.Client();
      final response = await client.get(
        Uri.parse('$uri/pets/retornaEspeciesPets'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return _parseEspecies(response.body);
      } else {
        throw Exception('Erro ao carregar espécies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar espécies: $e');
    }
  }

  /// Busca todas as raças
  Future<List<Raca>> getRacas() async {
    try {
      http.Client client = http.Client();
      final response = await client.get(
        Uri.parse('$uri/pets/retornaRacasPets'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return _parseRacas(response.body);
      } else {
        throw Exception('Erro ao carregar raças: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar raças: $e');
    }
  }

  /// Busca todas as cores
  Future<List<Cor>> getCores() async {
    try {
      http.Client client = http.Client();
      final response = await client.get(
        Uri.parse('$uri/pets/retornaCorPets'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return _parseCores(response.body);
      } else {
        throw Exception('Erro ao carregar cores: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar cores: $e');
    }
  }

  /// Busca todos os portes
  Future<List<Porte>> getPortes() async {
    try {
      http.Client client = http.Client();
      final response = await client.get(
        Uri.parse('$uri/pets/retornaPortePets'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return _parsePortes(response.body);
      } else {
        throw Exception('Erro ao carregar portes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar portes: $e');
    }
  }

  // ==================== MÉTODOS DE PARSE ====================

  List<Pet> _parsePets(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Pet>((json) => Pet.fromJson(json)).toList();
  }

  List<Especie> _parseEspecies(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Especie>((json) => Especie.fromJson(json)).toList();
  }

  List<Raca> _parseRacas(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Raca>((json) => Raca.fromJson(json)).toList();
  }

  List<Cor> _parseCores(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Cor>((json) => Cor.fromJson(json)).toList();
  }

  List<Porte> _parsePortes(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Porte>((json) => Porte.fromJson(json)).toList();
  }

  Future<Map<String, String>> _getHeadersMultipart() async {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await _getToken()}',
    };
  }

  Future<bool> enviarFotoPet(int idPet, String caminhoImagen) async {
    try {
      final file = File(caminhoImagen);

      // Lê os bytes do arquivo (equivalente ao byte[] do C#)
      final bytes = await file.readAsBytes();

      // Cria uma requisição multipart para enviar os bytes puros
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$uri/pets/salvaFotoPets'),
      );

      // Adiciona os headers de autenticação
      final headers = await _getHeadersMultipart();
      request.headers.addAll(headers);

      // Adiciona os campos
      request.fields['IdAnimal'] = idPet.toString();

      // Adiciona o arquivo como bytes[] (equivalente ao C#)
      request.files.add(http.MultipartFile.fromBytes(
        'foto', // Nome do campo que o C# vai receber
        bytes, // Array de bytes direto
        filename: 'pet_${idPet}_${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: MediaType.parse(_obterTipoArquivo(caminhoImagen)),
      ));

      // Envia a requisição
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Erro ao enviar foto: $e');
    }
  }

  Future<bool> removerFotoPet(int idPet) async {
    try {
      http.Client client = http.Client();
      final response = await client.delete(
        Uri.parse('$uri/pets/removerFotoPet?IdAnimal=$idPet'),
        headers: await _getHeaders(),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Erro ao remover foto do pet: $e');
    }
  }
}
