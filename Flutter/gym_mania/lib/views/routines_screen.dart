import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_mania/constants/app_constants.dart';
import 'package:gym_mania/controllers/routine_controller.dart';
import 'package:gym_mania/models/routine.dart';
import 'package:gym_mania/views/add_routine_screen.dart';
import 'package:gym_mania/views/routine_detail_screen.dart';
import 'package:gym_mania/views/edit_routine_screen.dart';

class RoutinesScreen extends StatelessWidget {
  final RoutineController controller = Get.put(RoutineController());

  RoutinesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load routines when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadRoutines();
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        if (controller.isLoading.value) {
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
                  'Loading routines...',
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
            // Welcome Header Section
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
                          // Header with back button, centered title, and add button
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

                              SizedBox(width: 5,),
                              // Centered title section
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'My Routines',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Plan and organize your weekly workouts',
                                      style: const TextStyle(
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

                              

                              // Add button
                              GestureDetector(
                                onTap: () async {
                                  final result = await Get.to(() => AddRoutineScreen());
                                  if (result == true) {
                                    controller.loadRoutines();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppConstants.primaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppConstants.primaryColor.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
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
                  const SizedBox(height: 8),

                  // Filter chips
                  Container(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: controller.filterOptions.map((filter) {
                          final isSelected = controller.selectedFilter.value == filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ChoiceChip(
                              label: Text(filter),
                              selected: isSelected,
                              selectedColor: AppConstants.primaryColor,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppConstants.primaryColor
                                      : Colors.grey[300]!,
                                ),
                              ),
                              showCheckmark: true,
                              checkmarkColor: Colors.white,
                              onSelected: (_) => controller.setFilter(filter),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Routines Header
                  Row(
                    children: [
                      Icon(
                        Icons.event_note_rounded,
                        color: Colors.grey[700],
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Obx(() => Text(
                        controller.selectedFilter.value == 'All'
                            ? 'All Routines (${controller.routines.length})'
                            : '${controller.selectedFilter.value} Routines (${controller.getFilteredRoutines().length})',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      )),
                    ],
                  ),

                  const SizedBox(height: 16),
                ]),
              ),
            ),

            // Routines Content
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              sliver: SliverToBoxAdapter(
                child: _buildRoutinesList(),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildRoutinesList() {
    return Obx(() {
      if (controller.selectedFilter.value == 'All') {
        return _buildGroupedRoutines();
      } else {
        return _buildFilteredRoutines();
      }
    });
  }

  Widget _buildGroupedRoutines() {
    return Obx(() {
      if (controller.routinesByDay.isEmpty) {
        return _buildEmptyState();
      }

      final sortedDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      List<Widget> dayWidgets = [];

      for (final day in sortedDays) {
        final dayRoutines = controller.routinesByDay[day] ?? [];
        if (dayRoutines.isEmpty) continue;

        dayWidgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      _getDayIcon(day),
                      color: AppConstants.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      day,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${dayRoutines.length}',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Routines for this day
              ...dayRoutines.map((routine) => _buildRoutineCard(routine)),
              const SizedBox(height: 8),
            ],
          ),
        );
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: dayWidgets,
      );
    });
  }

  Widget _buildFilteredRoutines() {
    return Obx(() {
      final filteredRoutines = controller.getFilteredRoutines();
      if (filteredRoutines.isEmpty) {
        return _buildEmptyState();
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...filteredRoutines.map((routine) => _buildRoutineCard(routine)),
          const SizedBox(height: 32),
        ],
      );
    });
  }

  Widget _buildRoutineCard(Routine routine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () async {
          final result = await Get.to(() => RoutineDetailScreen(routine: routine));
          if (result == true) {
            controller.loadRoutines();
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 22, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 64,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppConstants.primaryColor, AppConstants.primaryColor.withOpacity(0.8)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.event_note_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routine.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              _getDayIcon(routine.dayOfWeek),
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              routine.dayOfWeek,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        final result = await Get.to(() => EditRoutineScreen(routine: routine));
                        if (result == true) {
                          controller.loadRoutines();
                        }
                      } else if (value == 'delete') {
                        _deleteRoutine(routine);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 18),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Tighten bottom spacing when content is minimal
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteRoutine(Routine routine) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Routine'),
        content: Text('Are you sure you want to delete "${routine.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await controller.deleteRoutine(routine);
      if (success) {
        controller.loadRoutines();
      }
    }
  }

  Widget _buildEmptyState() {
    return Obx(() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              controller.selectedFilter.value == 'All'
                  ? 'No routines created yet'
                  : 'No routines for ${controller.selectedFilter.value}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create your first workout routine to get started',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Get.to(() => AddRoutineScreen());
                if (result == true) {
                  controller.loadRoutines();
                }
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Create Routine',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
    ));
  }

  IconData _getDayIcon(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return Icons.work_outline;
      case 'tuesday':
        return Icons.fitness_center;
      case 'wednesday':
        return Icons.local_fire_department;
      case 'thursday':
        return Icons.sports_gymnastics;
      case 'friday':
        return Icons.weekend;
      case 'saturday':
        return Icons.sports_handball;
      case 'sunday':
        return Icons.self_improvement;
      default:
        return Icons.today;
    }
  }
}
