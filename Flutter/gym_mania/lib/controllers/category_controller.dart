import 'package:get/get.dart';
import 'package:gym_mania/models/category.dart';
import 'package:gym_mania/services/database_service.dart';

class CategoryController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();

  // Observable variables
  var categories = <Category>[].obs;
  var categoryExerciseCounts = <int, int>{}.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // Fetch all categories
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final fetchedCategories = await _databaseService.getAllCategories();
      final Map<int, int> counts = {};

      // Get exercise count for each category
      for (final category in fetchedCategories) {
        final exercises = await _databaseService.getExercisesByCategory(category.id!);
        counts[category.id!] = exercises.length;
      }

      categories.value = fetchedCategories;
      categoryExerciseCounts.value = counts;
    } catch (e) {
      Get.snackbar('Error', 'Error loading categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get exercise count for a category
  int getExerciseCount(int categoryId) {
    return categoryExerciseCounts[categoryId] ?? 0;
  }
}
