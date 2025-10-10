import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gym_mania/models/routine.dart';
import 'package:gym_mania/models/routine_exercise.dart';
import 'package:gym_mania/models/exercise.dart';
import 'package:gym_mania/services/database_service.dart';
import 'package:gym_mania/views/dashboard_screen.dart';
import 'package:gym_mania/widgets/dialog_widgets.dart';

class RoutineController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();

  // Observable variables
  var routines = <Routine>[].obs;
  var routinesByDay = <String, List<Routine>>{}.obs;
  var routineExercises = <Map<String, dynamic>>[].obs;
  var availableExercises = <Exercise>[].obs;
  var selectedExercises = <SelectedExercise>[].obs;
  var isLoading = false.obs;
  var selectedFilter = 'All'.obs;
  var selectedDay = 'Monday'.obs;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  final List<String> daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday'
  ];

  final List<String> filterOptions = [
    'All', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday'
  ];

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  // Load all routines
  Future<void> loadRoutines() async {
    try {
      isLoading.value = true;
      final fetchedRoutines = await _databaseService.getAllRoutines();
      routines.value = fetchedRoutines;
      organizeRoutinesByDay();
    } catch (e) {
      Get.snackbar('Error', 'Error loading routines: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Organize routines by day
  void organizeRoutinesByDay() {
    routinesByDay.clear();
    for (final routine in routines) {
      if (!routinesByDay.containsKey(routine.dayOfWeek)) {
        routinesByDay[routine.dayOfWeek] = [];
      }
      routinesByDay[routine.dayOfWeek]!.add(routine);
    }
    routinesByDay.refresh();
  }

  // Get filtered routines
  List<Routine> getFilteredRoutines() {
    if (selectedFilter.value == 'All') {
      return routines.toList();
    }
    return routinesByDay[selectedFilter.value] ?? [];
  }

  // Load routine exercises with details
  Future<void> loadRoutineExercises(int routineId) async {
    try {
      isLoading.value = true;
      final exercises = await _databaseService.getRoutineExercisesWithDetails(routineId);
      routineExercises.value = exercises;
    } catch (e) {
      Get.snackbar('Error', 'Error loading routine exercises: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Load available exercises
  Future<void> loadExercises() async {
    try {
      isLoading.value = true;
      final exercises = await _databaseService.getAllExercises();
      availableExercises.value = exercises;
    } catch (e) {
      Get.snackbar('Error', 'Error loading exercises: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Create routine
  Future<bool> createRoutine() async {
    if (!formKey.currentState!.validate() || selectedExercises.isEmpty) {
      Get.snackbar('Error', 'Please add at least one exercise');
      return false;
    }

    try {
      isLoading.value = true;

      // Create routine
      final routine = Routine(
        name: nameController.text.trim(),
        dayOfWeek: selectedDay.value,
      );
      final routineId = await _databaseService.createRoutine(routine);

      // Add exercises to routine
      for (int i = 0; i < selectedExercises.length; i++) {
        final selectedEx = selectedExercises[i];
        final routineExercise = RoutineExercise(
          routineId: routineId,
          exerciseId: selectedEx.exercise.id!,
          sets: selectedEx.sets,
          reps: selectedEx.reps,
          duration: selectedEx.durationInSeconds,
          restTime: selectedEx.restInSeconds,
          orderIndex: i,
        );
        await _databaseService.addExerciseToRoutine(routineExercise);
      }

      Get.snackbar('Success', 'Routine saved successfully!');
      resetForm();

      // Navigate to Dashboard screen after saving
      Get.offAll(() => DashboardScreen());

      return true;
    } catch (e) {
      Get.snackbar('Error', 'Error saving routine: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update routine
  Future<bool> updateRoutine(Routine routine, List<RoutineExercise> originalRoutineExercises) async {
    if (!formKey.currentState!.validate() || selectedExercises.isEmpty) {
      Get.snackbar('Error', 'Please add at least one exercise');
      return false;
    }

    try {
      isLoading.value = true;

      // Update routine basic info
      final updatedRoutine = routine.copyWith(
        name: nameController.text.trim(),
        dayOfWeek: selectedDay.value,
      );
      await _databaseService.updateRoutine(updatedRoutine);

      // Remove all existing routine exercises (idempotent cleanup)
      await _databaseService.removeAllExercisesForRoutine(routine.id!);

      // Add new exercises to routine
      for (int i = 0; i < selectedExercises.length; i++) {
        final selectedEx = selectedExercises[i];
        final routineExercise = RoutineExercise(
          routineId: routine.id!,
          exerciseId: selectedEx.exercise.id!,
          sets: selectedEx.sets,
          reps: selectedEx.reps,
          duration: selectedEx.durationInSeconds,
          restTime: selectedEx.restInSeconds,
          orderIndex: i,
        );
        await _databaseService.addExerciseToRoutine(routineExercise);
      }

      Get.snackbar('Success', 'Routine updated successfully!');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Error updating routine: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete routine
  Future<bool> deleteRoutine(Routine routine) async {
    try {
      await _databaseService.deleteRoutine(routine.id!);
      routines.remove(routine);
      organizeRoutinesByDay();
      Get.snackbar('Success', 'Routine deleted successfully');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Error deleting routine: $e');
      return false;
    }
  }

  // Add this method to your RoutineController
  void refreshRoutines() async {
    await loadRoutines();
    update(); // This forces all GetBuilder widgets to rebuild
    routines.refresh(); // This forces all Obx widgets to rebuild
  }

  // Add exercise to selected exercises
  void addExercise(Exercise exercise) {
    selectedExercises.add(SelectedExercise(exercise: exercise));
  }

  // Remove exercise from selected exercises
  void removeExercise(int index) {
    selectedExercises.removeAt(index);
  }

  // Update exercise parameters
  void updateExercise(int index, SelectedExercise updatedExercise) {
    selectedExercises[index] = updatedExercise;
  }

  // Set filter
  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  // Set selected day
  void setSelectedDay(String day) {
    selectedDay.value = day;
  }

  // Reset form
  void resetForm() {
    nameController.clear();
    selectedDay.value = 'Monday';
    selectedExercises.clear();
  }

  // Initialize for editing
  void initializeForEdit(Routine routine, List<SelectedExercise> exercises) {
    nameController.text = routine.name;
    selectedDay.value = routine.dayOfWeek;
    selectedExercises.value = exercises;
  }
}

