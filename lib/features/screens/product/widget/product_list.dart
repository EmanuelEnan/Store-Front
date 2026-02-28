import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_utility/features/screens/product/cubit/product_cubit.dart';
import 'package:product_utility/features/screens/product/model/product_model.dart';

class ProductList extends StatefulWidget {
  const ProductList({
    super.key,
    required this.products,
    required this.category,
  });

  final List<ProductModel> products;
  final String category;

  @override
  State<ProductList> createState() => ProductListState();
}

class ProductListState extends State<ProductList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _onRefresh(BuildContext context) async {
    await context.read<ProductCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.products.isEmpty) {
      return const Center(child: Text('No products found.'));
    }

    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      child: GridView.builder(
        key: PageStorageKey<String>(widget.category),
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final p = widget.products[index];
          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Image.network(
                        p.image,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.broken_image, size: 48),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    p.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    p.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    '\$${p.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F51B5),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
