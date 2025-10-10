import 'package:get/get.dart';
import 'package:gym_mania/models/exercise.dart';
import 'package:gym_mania/services/database_service.dart';

class DashboardController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();

  // Observable variables
  var totalExercises = 0.obs;
  var totalCategories = 0.obs;
  var exercisesByDifficulty = <String, int>{}.obs;
  var recentExercises = <Exercise>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  // Load all dashboard data
  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      final exercises = await _databaseService.getAllExercises();
      final categories = await _databaseService.getAllCategories();
      final difficultyStats = await _databaseService.getExerciseCountByDifficulty();

      totalExercises.value = exercises.length;
      totalCategories.value = categories.length;
      exercisesByDifficulty.value = difficultyStats;
      recentExercises.value = exercises.take(5).toList();
    } catch (e) {
      Get.snackbar('Error', 'Error loading data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh dashboard data
  Future<void> refreshData() async {
    await loadDashboardData();
  }
}
