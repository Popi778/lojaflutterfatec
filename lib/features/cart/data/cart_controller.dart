import 'package:flutter_riverpod/flutter_riverpod.dart';   // Biblioteca de gerenciamento de estado (Riverpod)
import '../../catalog/domain/product.dart';                // Modelo de produto usado no carrinho

class CartItem {                                           // Classe que representa um item no carrinho
  final Product product;                                   // Produto associado
  final int quantity;                                      // Quantidade do produto
  CartItem({required this.product, required this.quantity});
}

class CartNotifier extends StateNotifier<List<CartItem>> { // Notificador que gerencia lista de itens do carrinho
  CartNotifier() : super([]);                              // Inicializa carrinho vazio

  void add(Product product) {                              // Método para adicionar produto ao carrinho
    final index = state.indexWhere((e) => e.product.id == product.id); // Procura se produto já existe
    if (index == -1) {                                     // Se não existe → adiciona novo item
      state = [...state, CartItem(product: product, quantity: 1)];
    } else {                                               // Se já existe → incrementa quantidade
      final updated = [...state];
      updated[index] =
          CartItem(product: product, quantity: updated[index].quantity + 1);
      state = updated;
    }
  }

  void changeQty(Product product, int qty) {               // Método para alterar quantidade de um produto
    if (qty <= 0) {                                        // Se quantidade <= 0 → remove produto do carrinho
      state = state.where((e) => e.product.id != product.id).toList();
    } else {                                               // Senão → atualiza quantidade
      final updated = state.map((e) {
        if (e.product.id == product.id) {
          return CartItem(product: product, quantity: qty);
        }
        return e;
      }).toList();
      state = updated;
    }
  }

  void clear() => state = [];                              // Método para limpar carrinho (zera lista)

  double total() =>                                        // Calcula valor total do carrinho
      state.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  List<int> productIds() =>                                // Retorna lista de IDs dos produtos no carrinho
      state.map((e) => e.product.id).toList();
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>( // Provider Riverpod do carrinho
  (ref) => CartNotifier(),
);
