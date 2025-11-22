import 'package:dio/dio.dart';                           // Biblioteca Dio: cliente HTTP poderoso
import 'package:retrofit/retrofit.dart';                 // Retrofit: gera cliente HTTP baseado em anotações
import '../domain/product.dart';                         // Modelo de produto

part 'api_client.g.dart';                                // Arquivo gerado automaticamente pelo build_runner

@RestApi(baseUrl: 'https://fakestoreapi.com')            // Define base URL da API FakeStore
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient; // Implementação gerada automaticamente

  @GET('/products')                                      // Endpoint: lista todos os produtos
  Future<List<Product>> getProducts();

  @GET('/products/category/{category}')                  // Endpoint: lista produtos por categoria
  Future<List<Product>> getProductsByCategory(@Path('category') String category);

  @GET('/products/categories')                           // Endpoint: lista todas as categorias
  Future<List<String>> getCategories();
}
