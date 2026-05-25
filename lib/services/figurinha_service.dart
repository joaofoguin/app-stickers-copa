// import 'dart:convert';

// import 'package:http/http.dart' as http;

// import '../models/figurinha.dart';

// class FigurinhaService {
//   static const String baseUrl = 'https://album-checklist-api.vercel.app';

//   Future<List<Figurinha>> listarFigurinhas() async {
//     final url = Uri.parse('$baseUrl/figurinhas');

//     final response = await http.get(url);

//     if (response.statusCode != 200) {
//       throw Exception('Erro ao buscar figurinhas');
//     }

//     final List<dynamic> dados = jsonDecode(response.body);

//     return dados.map((item) {
//       return Figurinha.fromJson(item);
//     }).toList();
//   }
// }

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/figurinha.dart';

class FigurinhaService {
  static const String baseUrl = 'https://album-checklist-api.vercel.app';

  Future<List<Figurinha>> listarFigurinhas() async {
    final url = Uri.parse('$baseUrl/figurinhas');

    print('URL chamada: $url');

    final response = await http.get(url);

    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar figurinhas');
    }

    final List<dynamic> dados = jsonDecode(response.body);

    return dados.map((item) {
      return Figurinha.fromJson(item);
    }).toList();
  }
}