import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/register_page.dart';
import 'features/catalog/presentation/products_page.dart';
import 'features/catalog/presentation/product_details_page.dart';
import 'features/cart/presentation/cart_page.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (ctx, st) => const LoginPage()),
    GoRoute(path: '/register', builder: (ctx, st) => const RegisterPage()),
    GoRoute(path: '/products', builder: (ctx, st) => const ProductsPage()),
    GoRoute(path: '/cart', builder: (ctx, st) => const CartPage()),
    GoRoute(
      path: '/product/:id',
      builder: (ctx, st) {
        final idStr = st.pathParameters['id']!;
        final id = int.tryParse(idStr) ?? 0;
        return ProductDetailsPage(productId: id);
      },
    ),
  ],
);
