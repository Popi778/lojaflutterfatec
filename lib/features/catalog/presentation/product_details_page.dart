import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../domain/product.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;
  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://fakestoreapi.com'));
  Product? _product;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    setState(() => _loading = true);
    try {
      final res = await _dio.get('/products/${widget.productId}');
      setState(() {
        _product = Product.fromJson(res.data);
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_product == null) return const Scaffold(body: Center(child: Text('Produto não encontrado')));

    return Scaffold(
      appBar: AppBar(title: Text(_product!.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(_product!.image, height: 200),
            const SizedBox(height: 20),
            Text(_product!.description),
            const SizedBox(height: 20),
            Text('Preço: R\$${_product!.price.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Adicionado: ${_product!.title}')),
                );
              },
              child: const Text('Adicionar ao carrinho'),
            ),
          ],
        ),
      ),
    );
  }
}
