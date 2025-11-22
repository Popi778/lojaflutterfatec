import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/app_drawer.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  User? get _user => FirebaseAuth.instance.currentUser;

  Future<void> _updateQuantity(String docId, int currentQty, int delta) async {
    if (_user == null) return;
    final cartRef = FirebaseFirestore.instance
        .collection('carts')
        .doc(_user!.uid)
        .collection('items');

    final newQty = currentQty + delta;
    if (newQty <= 0) {
      await cartRef.doc(docId).delete();
    } else {
      await cartRef.doc(docId).update({'quantity': newQty});
    }
  }

  Future<void> _finalizarCompra(List<QueryDocumentSnapshot> items) async {
    if (_user == null) return;

    final total = items.fold<double>(
      0,
      (sum, doc) => sum + (doc['price'] as num) * (doc['quantity'] as num),
    );

    // Cria documento da compra
    final orderRef = await FirebaseFirestore.instance.collection('orders').add({
      'userId': _user!.uid,
      'total': total,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Salva cada item dentro da compra
    for (var doc in items) {
      final unitPrice = doc['price'] as num;
      final qty = doc['quantity'] as num;
      final subTotal = unitPrice * qty;

      await orderRef.collection('items').add({
        'itemId': doc['productId'],
        'title': doc['title'],
        'unitPrice': unitPrice,
        'quantity': qty,
        'subTotal': subTotal,
      });
    }

    // Limpa carrinho
    final cartRef = FirebaseFirestore.instance
        .collection('carts')
        .doc(_user!.uid)
        .collection('items');
    for (var doc in items) {
      await cartRef.doc(doc.id).delete();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compra registrada com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(
        body: Center(child: Text('Faça login para ver o carrinho')),
      );
    }

    final cartRef = FirebaseFirestore.instance
        .collection('carts')
        .doc(_user!.uid)
        .collection('items');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: cartRef.snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data?.docs ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Carrinho vazio'));
          }

          final total = items.fold<double>(
            0,
            (sum, doc) => sum + (doc['price'] as num) * (doc['quantity'] as num),
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (ctx, i) {
                    final doc = items[i];
                    final qty = doc['quantity'] as int;
                    return ListTile(
                      leading: Image.network(doc['image'], width: 50),
                      title: Text(doc['title']),
                      subtitle: Text('Preço unitário: R\$${doc['price']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () =>
                                _updateQuantity(doc.id, qty, -1),
                          ),
                          Text('$qty'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () =>
                                _updateQuantity(doc.id, qty, 1),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () => _finalizarCompra(items),
                  child: Text('Finalizar - Total: R\$${total.toStringAsFixed(2)}'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
