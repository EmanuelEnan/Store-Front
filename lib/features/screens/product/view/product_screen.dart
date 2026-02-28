import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_utility/features/screens/product/cubit/product_cubit.dart';
import 'package:product_utility/features/screens/product/cubit/product_state.dart';
import 'package:product_utility/features/screens/product/model/product_model.dart';
import 'package:product_utility/features/screens/product/widget/product_list.dart';
import 'package:product_utility/features/screens/product/widget/sticky_tab_bar.dart';

const _kCategories = [
  'all',
  "men's clothing",
  "women's clothing",
  'jewelery',
  'electronics',
];

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _kCategories.length, vsync: this);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<ProductModel> _filtered(List<ProductModel> all, String category) {
    final byCategory = category == 'all'
        ? all
        : all.where((p) => p.category == category).toList();
    if (_searchQuery.isEmpty) return byCategory;
    return byCategory
        .where((p) => p.title.toLowerCase().contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ProductCubit>().fetchProducts(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is ProductLoaded) {
            return NestedScrollView(
              headerSliverBuilder: (context, _) => [
                SliverAppBar(
                  expandedHeight: 160,
                  floating: false,
                  pinned: true,
                  snap: false,
                  title: const Text(
                    'ZaviSoft',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF3F51B5), Color(0xFF7986CB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Store Front',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _searchController,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              hintText: 'Search products…',
                              hintStyle: const TextStyle(color: Colors.white60),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white70,
                              ),
                              filled: true,
                              fillColor: Colors.white24,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverPersistentHeader(
                  pinned: true,
                  delegate: StickyTabBar(
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      indicatorColor: const Color(0xFF3F51B5),
                      labelColor: const Color(0xFF3F51B5),
                      unselectedLabelColor: Colors.grey,
                      tabs: _kCategories
                          .map(
                            (c) =>
                                Tab(text: c[0].toUpperCase() + c.substring(1)),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],

              body: TabBarView(
                controller: _tabController,
                children: _kCategories.map((category) {
                  return ProductList(
                    products: _filtered(state.products, category),
                    category: category,
                  );
                }).toList(),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
