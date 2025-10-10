import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_mania/constants/app_constants.dart';
import 'package:gym_mania/controllers/routine_controller.dart';
import 'package:gym_mania/widgets/dialog_widgets.dart';

class AddRoutineScreen extends StatelessWidget {
  final RoutineController controller = Get.put(RoutineController());

  AddRoutineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load exercises when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadExercises();
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        if (controller.isLoading.value && controller.availableExercises.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppConstants.primaryColor,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading exercises...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            // Custom Header Section
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Color(0xFF1A1A1A)],
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 70, 25, 32),
                      child: Column(
                        children: [
                          // Header with back button, centered title, and save button
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Back button
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),

                              // Centered title section
                              Expanded(
                                child: Column(
                                  children: const [
                                    Text(
                                      'Create Routine',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Set up your workout plan',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              // Save button with icon
                              Obx(() => GestureDetector(
                                onTap: controller.isLoading.value ? null : () async {
                                  await controller.createRoutine();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: controller.isLoading.value 
                                        ? Colors.grey[400] 
                                        : AppConstants.primaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (controller.isLoading.value 
                                            ? Colors.grey[400]! 
                                            : AppConstants.primaryColor).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: controller.isLoading.value
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.save_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Curved bottom section
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 24),

                  // Content wrapped in Form
                  Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                      // Routine name
                      TextFormField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          labelText: 'Routine Name*',
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.fitness_center_rounded, color: AppConstants.primaryColor),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Please enter a routine name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Day selection
                      Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedDay.value,
                        decoration: InputDecoration(
                          labelText: 'Day of Week',
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.calendar_today_rounded, color: AppConstants.primaryColor),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        items: controller.daysOfWeek.map((day) {
                          return DropdownMenuItem(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.setSelectedDay(value!);
                        },
                      )),

                      const SizedBox(height: 32),

                      // Exercises section header
                      Row(
                        children: [
                          Icon(
                            Icons.list_alt_rounded,
                            color: Colors.grey[700],
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Obx(() => Text(
                              'Exercises (${controller.selectedExercises.length})',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            )),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Add Exercise button - Full width
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppConstants.primaryColor, AppConstants.primaryColor.withOpacity(0.8)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppConstants.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () => _showExerciseSelectionDialog(context),
                            icon: const Icon(Icons.add_rounded, color: Colors.white),
                            label: const Text(
                              'Add Exercise',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Selected exercises list
                      Obx(() {
                        if (controller.selectedExercises.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.fitness_center_outlined,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No exercises added yet',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap "Add Exercise" to get started',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          children: List.generate(controller.selectedExercises.length, (index) {
                            final selectedEx = controller.selectedExercises[index];
                            return Container(
                              height: 200,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey[200]!),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [AppConstants.primaryColor, AppConstants.primaryColor.withOpacity(0.8)],
                                            ),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                selectedEx.exercise.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              if (selectedEx.exercise.description?.isNotEmpty ?? false)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4),
                                                  child: Text(
                                                    selectedEx.exercise.description!,
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: PopupMenuButton<String>(
                                            onSelected: (value) {
                                              if (value == 'edit') {
                                                _editExercise(context, index);
                                              } else if (value == 'delete') {
                                                controller.removeExercise(index);
                                              }
                                            },
                                            itemBuilder: (context) => const [
                                              PopupMenuItem(
                                                value: 'edit',
                                                child: ListTile(
                                                  leading: Icon(Icons.edit_rounded),
                                                  title: Text('Edit'),
                                                  contentPadding: EdgeInsets.zero,
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 'delete',
                                                child: ListTile(
                                                  leading: Icon(Icons.delete_rounded, color: Colors.red),
                                                  title: Text('Delete', style: TextStyle(color: Colors.red)),
                                                  contentPadding: EdgeInsets.zero,
                                                ),
                                              ),
                                            ],
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Icon(Icons.more_vert_rounded, color: Colors.grey[600]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Container
                                    (
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildParameterChip(
                                                  'Sets: ${selectedEx.sets}',
                                                  Icons.format_list_numbered_rounded,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: _buildParameterChip(
                                                  'Reps: ${selectedEx.reps}',
                                                  Icons.repeat_rounded,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildParameterChip(
                                                  'Duration: ${selectedEx.durationInSeconds}s',
                                                  Icons.timer_rounded,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: _buildParameterChip(
                                                  'Rest: ${selectedEx.restInSeconds}s',
                                                  Icons.pause_circle_rounded,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      }),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showExerciseSelectionDialog(BuildContext context) {
    Get.dialog(
      ExerciseSelectionDialog(
        availableExercises: controller.availableExercises,
        onExerciseSelected: (exercise) {
          controller.addExercise(exercise);
        },
      ),
    );
  }

  void _editExercise(BuildContext context, int index) {
    final selectedEx = controller.selectedExercises[index];
    Get.dialog(
      EditExerciseDialog(
        selectedExercise: selectedEx,
        onExerciseUpdated: (updatedExercise) {
          controller.updateExercise(index, updatedExercise);
        },
      ),
    );
  }

  Widget _buildParameterChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppConstants.primaryColor,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

