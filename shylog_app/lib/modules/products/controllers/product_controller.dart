import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../data/models/product_model.dart';
import '../../../data/sample_data.dart';

class ProductController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedSort = 'Featured'.obs;
  final RxBool isLoading = false.obs;

  static const String _apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5000/api/v1',
  );

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _apiBaseUrl,
    connectTimeout: const Duration(seconds: 4),
    receiveTimeout: const Duration(seconds: 4),
  ));

  @override
  void onInit() {
    super.onInit();
    // Start with rich sample data instantly
    products.assignAll(SampleData.products);
    if (!const bool.fromEnvironment('flutter.test')) {
      fetchProductsFromApi();
    }
  }

  Future<void> fetchProductsFromApi() async {
    try {
      isLoading.value = true;
      final response = await _dio.get('/products');
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List list = response.data['data'];
        if (list.isNotEmpty) {
          products.assignAll(list.map((e) => ProductModel.fromJson(e)).toList());
        }
      }
    } catch (_) {
      // Gracefully retain initial sample data if backend endpoint is still being seeded
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String cat) {
    selectedCategory.value = cat;
  }

  void updateSearch(String query) {
    searchQuery.value = query.trim().toLowerCase();
  }

  List<ProductModel> get filteredProducts {
    return products.where((p) {
      final matchesCategory = selectedCategory.value == 'All' ||
          p.category.toLowerCase() == selectedCategory.value.toLowerCase();
      final matchesSearch = searchQuery.value.isEmpty ||
          p.name.toLowerCase().contains(searchQuery.value) ||
          p.description.toLowerCase().contains(searchQuery.value);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<ProductModel> get newArrivals =>
      products.where((p) => p.isNewArrival).toList();

  List<ProductModel> get bestSellers =>
      products.where((p) => p.isBestSeller).toList();
}
