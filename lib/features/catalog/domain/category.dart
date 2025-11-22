import 'package:freezed_annotation/freezed_annotation.dart'; // Biblioteca Freezed: gera código imutável e utilitários

part 'category.freezed.dart';                               // Arquivo gerado automaticamente pelo build_runner (implementações extras)
part 'category.g.dart';                                     // Arquivo gerado para suporte a serialização JSON

@freezed                                                   // Anotação que indica que a classe será processada pelo Freezed
class Category with _$Category {                            // Classe Category com mixin gerado pelo Freezed
  const factory Category({                                  // Construtor imutável da classe
    required String name,                                   // Campo obrigatório: nome da categoria
  }) = _Category;                                           // Implementação concreta gerada automaticamente

  factory Category.fromJson(Map<String, dynamic> json) =>   // Método fábrica para criar Category a partir de JSON
      _$CategoryFromJson(json);                             // Função gerada automaticamente para parsing
}
