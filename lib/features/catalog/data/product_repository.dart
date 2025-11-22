import 'package:dio/dio.dart';                           // Biblioteca Dio: cliente HTTP para requisições
import '../domain/product.dart';                         // Modelo de produto

class ProductRepository {
  final Dio dio;                                         // Instância do cliente HTTP

  ProductRepository()
      : dio = Dio(BaseOptions(baseUrl: 'https://fakestoreapi.com')); // Configura base URL da API FakeStore

  Future<List<Product>> all() async {                    // Método: busca todos os produtos
    final res = await dio.get('/products');              // Requisição GET para /products
    final data = res.data;                               // Dados retornados pela API
    if (data is List) {                                  // Se for lista válida
      return data.map((e) => Product.fromJson(e)).toList(); // Converte cada item para Product
    }
    return [];                                           // Retorna lista vazia se não for lista
  }

  Future<List<Product>> byCategory(String category) async { // Método: busca produtos por categoria
    final res = await dio.get('/products/category/$category'); // GET com categoria
    final data = res.data;
    if (data is List) {
      return data.map((e) => Product.fromJson(e)).toList(); // Converte lista para objetos Product
    }
    return [];
  }

  Future<Product> byId(int id) async {                   // Método: busca produto por ID
    final res = await dio.get('/products/$id');          // GET com ID
    return Product.fromJson(res.data);                   // Converte JSON para Product
  }

  Future<List<String>> categories() async {              // Método: busca lista de categorias
    final res = await dio.get('/products/categories');   // GET para /products/categories
    final raw = res.data;
    if (raw is List) {
      return raw.map((e) {                               // Converte cada item para String
        final str = e.toString();
        return str[0].toUpperCase() + str.substring(1);  // Capitaliza primeira letra
      }).toList();
    }
    return [];
  }
}
