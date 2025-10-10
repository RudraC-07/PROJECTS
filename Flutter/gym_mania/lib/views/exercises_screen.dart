import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_mania/constants/app_constants.dart';
import 'package:gym_mania/controllers/exercise_controller.dart';
import 'package:gym_mania/widgets/custom_widgets.dart';

class ExercisesScreen extends StatefulWidget {
  final String? difficultyFilter;

  const ExercisesScreen({Key? key, this.difficultyFilter}) : super(key: key);

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final ExerciseController controller = Get.put(ExerciseController());
  // Observable variables for search state
  var isSearchExpanded = false.obs;
  late FocusNode searchFocusNode;

  @override
  void initState() {
    super.initState();
    searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Load exercises and categories when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.difficultyFilter != null) {
        controller.getExercisesByDifficulty(widget.difficultyFilter!);
      } else {
        controller.getAllExercises();
      }
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
                  widget.difficultyFilter != null
                      ? 'Loading ${widget.difficultyFilter} exercises...'
                      : 'Loading exercises...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.exercises.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fitness_center_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 24),
                Text(
                  widget.difficultyFilter != null
                      ? 'No ${widget.difficultyFilter} Exercises Found'
                      : 'No Exercises Found',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.difficultyFilter != null
                      ? 'There are no ${widget.difficultyFilter!.toLowerCase()} exercises available.'
                      : 'Please add some exercises to get started.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
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
                      padding: const EdgeInsets.fromLTRB(25,70, 25, 32),
                      child: Column(
                        children: [
                          // Header with back button, centered title, and search/badge
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Back button (no box styling)
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
                                  children: [
                                    Text(
                                      widget.difficultyFilter != null
                                          ? '${widget.difficultyFilter} Exercises'
                                          : 'All Exercises',
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
                                      widget.difficultyFilter != null
                                          ? 'Perfect for your fitness level'
                                          : 'Your complete exercise library',
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

                              // Search icon or difficulty badge (no box styling for search)
                              if (widget.difficultyFilter == null)
                                GestureDetector(
                                  onTap: () {
                                    isSearchExpanded.value = !isSearchExpanded.value;
                                    if (isSearchExpanded.value) {
                                      Future.delayed(const Duration(milliseconds: 100), () {
                                        searchFocusNode.requestFocus();
                                      });
                                    } else {
                                      controller.clearFilters();
                                      searchFocusNode.unfocus();
                                    }
                                  },
                                  child: Icon(
                                    isSearchExpanded.value ? Icons.close : Icons.search,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                )
                              else
                              // Difficulty badge (keeping the styled container for badge)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppConstants.getDifficultyColor(widget.difficultyFilter!),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppConstants.getDifficultyColor(widget.difficultyFilter!).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    widget.difficultyFilter!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
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

                  // Expanded Search Bar (only show when search is expanded)
                  Obx(() => isSearchExpanded.value && widget.difficultyFilter == null
                      ? Column(
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 20),
                    ],
                  )
                      : const SizedBox()),

                  // Difficulty Tabs (only show when not filtering by difficulty)
                  if (widget.difficultyFilter == null) _buildDifficultyTabs(),
                  if (widget.difficultyFilter == null) const SizedBox(height: 20),

                  // Stats Section
                  // if (widget.difficultyFilter == null) _buildStatsSection(),
                  if (widget.difficultyFilter == null) const SizedBox(height: 10),

                  // Exercises Header
                  Row(
                    children: [
                      Icon(
                        Icons.list_alt_rounded,
                        color: Colors.grey[700],
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.difficultyFilter != null
                            ? '${widget.difficultyFilter} Exercises (${controller.exercises.length})'
                            : 'All Exercises (${controller.exercises.length})',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Exercise Cards
                  ...controller.exercises.map((exercise) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ExerciseCard(exercise: exercise),
                  )).toList(),

                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDifficultyTabs() {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.difficultyOptions.map((difficulty) {
            final isSelected = controller.selectedDifficultyFilter.value == difficulty;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ChoiceChip(
                label: Text(difficulty),
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
                onSelected: (_) => controller.filterByDifficulty(difficulty),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomSearchTextField(controller: controller, focusNode: searchFocusNode),
    );
  }
}
