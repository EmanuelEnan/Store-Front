import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_utility/features/screens/product/cubit/product_cubit.dart';
import 'package:product_utility/features/screens/product/repository/product_repo.dart';
import 'package:product_utility/features/screens/product/view/product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fake Store',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: BlocProvider(
        create: (_) => ProductCubit(ProductRepo())..fetchProducts(),
        child: const ProductScreen(),
      ),
    );
  }
}
