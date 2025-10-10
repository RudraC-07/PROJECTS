import 'dart:async';
import 'package:get/get.dart';
import 'package:gym_mania/models/exercise.dart';
import 'package:gym_mania/models/muscle_group.dart';
import 'package:gym_mania/models/category.dart';
import 'package:gym_mania/services/database_service.dart';

class ExerciseController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();

  // Observable variables
  var exercises = <Exercise>[].obs;
  var allExercises = <Exercise>[].obs; // Store all exercises for filtering
  var categories = <Category>[].obs;
  var muscleGroups = <MuscleGroup>[].obs;
  var category = Rxn<Category>();
  var selectedCategoryId = Rxn<int>();
  var instructions = <String>[].obs;
  var tips = <String>[].obs;
  var equipment = <String>[].obs;
  var isLoading = false.obs;
  var exercisesByDifficulty = <String, int>{}.obs;
  var searchQuery = ''.obs;
  var selectedDifficultyFilter = 'All'.obs;
  
  Timer? _searchDebounceTimer;
  
  final List<String> difficultyOptions = [
    'All', 'Beginner', 'Intermediate', 'Advanced'
  ];

  // Get all exercises
  Future<void> getAllExercises() async {
    try {
      isLoading.value = true;
      final fetchedExercises = await _databaseService.getAllExercises();
      allExercises.value = fetchedExercises;
      exercises.value = fetchedExercises;
    } catch (e) {
      Get.snackbar('Error', 'Error loading exercises: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Load categories for tabs
  Future<void> loadCategories() async {
    try {
      final fetchedCategories = await _databaseService.getAllCategories();
      categories.value = fetchedCategories;
    } catch (e) {
      Get.snackbar('Error', 'Error loading categories: $e');
    }
  }

  // Filter by difficulty
  void filterByDifficulty(String difficulty) {
    selectedDifficultyFilter.value = difficulty;
    _applyFilters();
  }

  // Search exercises
  void searchExercises(String query) {
    searchQuery.value = query;
    
    // Cancel previous timer
    _searchDebounceTimer?.cancel();
    
    // Debounce search to avoid too many calls
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }
  
  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      _applyFilters();
      return;
    }

    try {
      final searchResults = await _databaseService.searchExercises(query.trim());
      
      // Apply difficulty filter if selected
      if (selectedDifficultyFilter.value != 'All') {
        exercises.value = searchResults
            .where((exercise) => exercise.difficulty == selectedDifficultyFilter.value)
            .toList();
      } else {
        exercises.value = searchResults;
      }
    } catch (e) {
      Get.snackbar('Error', 'Error searching exercises: $e');
      // Fallback to local filtering
      _applyFilters();
    }
  }

  // Filter by category
  void filterByCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
    _applyFilters();
  }

  // Apply current filters
  void _applyFilters() {
    var filteredExercises = allExercises.toList();

    // Apply difficulty filter
    if (selectedDifficultyFilter.value != 'All') {
      filteredExercises = filteredExercises
          .where((exercise) => exercise.difficulty == selectedDifficultyFilter.value)
          .toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filteredExercises = filteredExercises.where((exercise) {
        return exercise.name.toLowerCase().contains(query) ||
               (exercise.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    exercises.value = filteredExercises;
  }

  // Clear all filters
  void clearFilters() {
    _searchDebounceTimer?.cancel();
    searchQuery.value = '';
    selectedDifficultyFilter.value = 'All';
    exercises.value = allExercises.toList();
  }
  
  @override
  void onClose() {
    _searchDebounceTimer?.cancel();
    super.onClose();
  }

  // Get exercises by difficulty
  Future<void> getExercisesByDifficulty(String difficulty) async {
    try {
      isLoading.value = true;
      final fetchedExercises = await _databaseService.getExercisesByDifficulty(difficulty);
      exercises.value = fetchedExercises;
    } catch (e) {
      Get.snackbar('Error', 'Error loading exercises: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get exercises by category
  Future<void> getExercisesByCategory(int categoryId) async {
    try {
      isLoading.value = true;
      final fetchedExercises = await _databaseService.getExercisesByCategory(categoryId);
      exercises.value = fetchedExercises;
    } catch (e) {
      Get.snackbar('Error', 'Error loading exercises: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get exercises by muscle group
  Future<void> getExercisesByMuscleGroup(int muscleGroupId) async {
    try {
      isLoading.value = true;
      final fetchedExercises = await _databaseService.getExercisesByMuscleGroup(muscleGroupId);
      exercises.value = fetchedExercises;
    } catch (e) {
      Get.snackbar('Error', 'Error loading exercises: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get exercise details
  Future<void> loadExerciseDetails(Exercise exercise) async {
    try {
      isLoading.value = true;

      final fetchedMuscleGroups = await _databaseService.getMuscleGroupsForExercise(exercise.id!);
      final fetchedCategory = await _databaseService.getCategoryById(exercise.categoryId);
      final fetchedInstructions = await _databaseService.getExerciseInstructions(exercise.id!);
      final fetchedTips = await _databaseService.getExerciseTips(exercise.id!);
      final fetchedEquipment = await _databaseService.getExerciseEquipment(exercise.id!);

      muscleGroups.value = fetchedMuscleGroups;
      category.value = fetchedCategory;
      instructions.value = fetchedInstructions;
      tips.value = fetchedTips;
      equipment.value = fetchedEquipment;
    } catch (e) {
      Get.snackbar('Error', 'Error loading exercise data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get exercise count by difficulty
  Future<void> getExerciseCountByDifficulty() async {
    try {
      final difficultyStats = await _databaseService.getExerciseCountByDifficulty();
      exercisesByDifficulty.value = difficultyStats;
    } catch (e) {
      Get.snackbar('Error', 'Error loading difficulty stats: $e');
    }
  }
}
