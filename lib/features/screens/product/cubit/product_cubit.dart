import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/product_repo.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo _productRepo;

  ProductCubit(this._productRepo) : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    await _loadProducts();
  }

  Future<void> refreshProducts() async {
    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _productRepo.fetchProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
