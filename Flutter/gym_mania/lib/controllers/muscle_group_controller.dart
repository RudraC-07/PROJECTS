import 'package:get/get.dart';
import 'package:gym_mania/models/muscle_group.dart';
import 'package:gym_mania/services/database_service.dart';

class MuscleGroupController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();

  // Observable variables
  var muscleGroups = <MuscleGroup>[].obs;
  var muscleGroupExerciseCounts = <int, int>{}.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMuscleGroups();
  }

  // Fetch all muscle groups
  Future<void> fetchMuscleGroups() async {
    try {
      isLoading.value = true;
      final fetchedMuscleGroups = await _databaseService.getAllMuscleGroups();
      final Map<int, int> counts = {};

      // Get exercise count for each muscle group
      for (final muscleGroup in fetchedMuscleGroups) {
        final exercises = await _databaseService.getExercisesByMuscleGroup(muscleGroup.id!);
        counts[muscleGroup.id!] = exercises.length;
      }

      muscleGroups.value = fetchedMuscleGroups;
      muscleGroupExerciseCounts.value = counts;
    } catch (e) {
      Get.snackbar('Error', 'Error loading muscle groups: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get exercise count for a muscle group
  int getExerciseCount(int muscleGroupId) {
    return muscleGroupExerciseCounts[muscleGroupId] ?? 0;
  }
}
