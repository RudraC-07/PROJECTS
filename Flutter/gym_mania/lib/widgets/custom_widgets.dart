import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_mania/constants/app_constants.dart';
import 'package:gym_mania/models/exercise.dart';
import 'package:gym_mania/controllers/exercise_controller.dart';
import 'package:gym_mania/views/exercise_detail_screen.dart';
import 'package:gym_mania/views/exercises_screen.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;

  const CustomCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: AppConstants.spacingS),
      child: Material(
        color: color ?? AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppConstants.spacingM),
            child: child,
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final Widget? trailing;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppConstants.primaryColor;
    
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 28,
                color: cardColor,
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            value,
            style: AppConstants.headingLarge.copyWith(
              color: cardColor,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXS),
          Text(
            title,
            style: AppConstants.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: cardColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback? onTap;
  final bool showCategory;

  const ExerciseCard({
    Key? key,
    required this.exercise,
    this.onTap,
    this.showCategory = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap ?? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseDetailScreen(exercise: exercise),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppConstants.primaryGradient,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppConstants.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: AppConstants.headingSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (exercise.description != null)
                  Text(
                    exercise.description!,
                    style: AppConstants.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: AppConstants.spacingXS),
                Row(
                  children: [
                    if (exercise.difficulty != null) ...[
                      DifficultyChip(difficulty: exercise.difficulty!),
                      const SizedBox(width: AppConstants.spacingS),
                    ],
                    if (showCategory) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingS,
                          vertical: AppConstants.spacingXS,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppConstants.radiusS),
                        ),
                        child: Text(
                          'Category ${exercise.categoryId}',
                          style: AppConstants.bodySmall.copyWith(
                            color: AppConstants.accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppConstants.textSecondary,
          ),
        ],
      ),
    );
  }
}

class DifficultyChip extends StatelessWidget {
  final String difficulty;

  const DifficultyChip({Key? key, required this.difficulty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = AppConstants.getDifficultyColor(difficulty);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingS,
        vertical: AppConstants.spacingXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: AppConstants.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String name;
  final int exerciseCount;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const CategoryCard({
    Key? key,
    required this.name,
    required this.exerciseCount,
    required this.icon,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.12),
              color.withOpacity(0.06),
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingS),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: AppConstants.headingSmall.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[900],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppConstants.spacingXS),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingS,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withOpacity(0.18),
                          color.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.28)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.list_alt_rounded, size: 14, color: color),
                        const SizedBox(width: 6),
                        Text(
                          '$exerciseCount exercises',
                          style: AppConstants.bodySmall.copyWith(
                            color: color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MuscleGroupCard extends StatelessWidget {
  final String name;
  final int exerciseCount;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const MuscleGroupCard({
    Key? key,
    required this.name,
    required this.exerciseCount,
    required this.icon,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.12),
              color.withOpacity(0.06),
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingS),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: AppConstants.headingSmall.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[900],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppConstants.spacingXS),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingS,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withOpacity(0.18),
                          color.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.28)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fitness_center_rounded, size: 14, color: color),
                        const SizedBox(width: 6),
                        Text(
                          '$exerciseCount exercises',
                          style: AppConstants.bodySmall.copyWith(
                            color: color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const SearchBar({
    Key? key,
    required this.controller,
    this.hintText = 'Search exercises...',
    this.onChanged,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppConstants.bodyMedium,
          prefixIcon: const Icon(
            Icons.search,
            color: AppConstants.textSecondary,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppConstants.textSecondary,
                  ),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingM,
            vertical: AppConstants.spacingM,
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? action;

  const EmptyState({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppConstants.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: AppConstants.spacingL),
            Text(
              title,
              style: AppConstants.headingMedium.copyWith(
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              subtitle,
              style: AppConstants.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: AppConstants.spacingL),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

// Modern Stat Card Widget
class ModernStatCard extends StatelessWidget {
  final String title, value, subtitle;
  final IconData icon;
  final Color color;

  const ModernStatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// Modern Action Card Widget
class ModernActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Gradient gradient;
  final VoidCallback onTap;

  const ModernActionCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Difficulty Analysis Card Widget
class DifficultyAnalysisCard extends StatelessWidget {
  final Map<String, int> exercisesByDifficulty;

  const DifficultyAnalysisCard({
    Key? key,
    required this.exercisesByDifficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = exercisesByDifficulty.values.fold<int>(0, (a, b) => a + b);
    final orderedKeys = ['Beginner', 'Intermediate', 'Advanced'];
    final keys = [
      ...orderedKeys.where((k) => exercisesByDifficulty.keys.contains(k)),
      ...exercisesByDifficulty.keys.where((k) => !orderedKeys.contains(k)),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          ...keys.map((key) {
            final count = exercisesByDifficulty[key] ?? 0;
            final color = AppConstants.getDifficultyColor(key);
            final percent = total > 0 ? count / total : 0.0;

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            key,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: percent,
                      minHeight: 8,
                      backgroundColor: color.withOpacity(0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: keys.map((key) {
                final color = AppConstants.getDifficultyColor(key);
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ActionChip(
                    label: Text(
                      key,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: color.withOpacity(0.1),
                    labelStyle: TextStyle(color: color),
                    side: BorderSide(color: color.withOpacity(0.3)),
                    onPressed: () {
                      Get.to(() => ExercisesScreen(difficultyFilter: key));
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Modern Category Card Widget
class ModernCategoryCard extends StatelessWidget {
  final String name;
  final int exerciseCount;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback? onTap;

  const ModernCategoryCard({
    Key? key,
    required this.name,
    required this.exerciseCount,
    required this.icon,
    required this.gradient,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon and Arrow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: Colors.white, size: 24),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Category Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.fitness_center_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$exerciseCount exercises',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// Custom SearchTextField Widget
class CustomSearchTextField extends StatefulWidget {
  final ExerciseController controller;
  final FocusNode focusNode;

  const CustomSearchTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
  }) : super(key: key);

  @override
  CustomSearchTextFieldState createState() => CustomSearchTextFieldState();
}

class CustomSearchTextFieldState extends State<CustomSearchTextField> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();

    // Listen to search query changes to update text field
    ever(widget.controller.searchQuery, (String query) {
      if (_textController.text != query) {
        _textController.text = query;
        _textController.selection = TextSelection.collapsed(offset: query.length);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      focusNode: widget.focusNode,
      onChanged: (value) {
        widget.controller.searchExercises(value);
      },
      decoration: InputDecoration(
        hintText: 'Search exercises by name, category, or muscle group...',
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 16,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: AppConstants.primaryColor,
          size: 24,
        ),
        suffixIcon: Obx(() => widget.controller.searchQuery.value.isNotEmpty
            ? IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.grey[600],
          ),
          onPressed: () {
            _textController.clear();
            widget.controller.clearFilters();
          },
        )
            : const SizedBox()),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }
}

// Modern Empty State Card Widget
class ModernEmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;

  const ModernEmptyStateCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

// Modern Muscle Group Card Widget
class ModernMuscleGroupCard extends StatelessWidget {
  final String name;
  final int exerciseCount;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback? onTap;

  const ModernMuscleGroupCard({
    Key? key,
    required this.name,
    required this.exerciseCount,
    required this.icon,
    required this.gradient,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon and Arrow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: Colors.white, size: 24),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Muscle Group Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.fitness_center_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$exerciseCount exercises',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
