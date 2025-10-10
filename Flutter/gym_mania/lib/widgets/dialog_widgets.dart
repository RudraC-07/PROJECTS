import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_mania/constants/app_constants.dart';
import 'package:gym_mania/models/exercise.dart';

// Selected Exercise model class for routine management
class SelectedExercise {
  final Exercise exercise;
  int sets;
  int reps;
  int durationInSeconds;
  int restInSeconds;

  SelectedExercise({
    required this.exercise,
    this.sets = 3,
    this.reps = 12,
    this.durationInSeconds = 60,
    this.restInSeconds = 60,
  });

  SelectedExercise copyWith({
    Exercise? exercise,
    int? sets,
    int? reps,
    int? durationInSeconds,
    int? restInSeconds,
  }) {
    return SelectedExercise(
      exercise: exercise ?? this.exercise,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      restInSeconds: restInSeconds ?? this.restInSeconds,
    );
  }
}

// Dialog Widgets for Exercise Selection and Editing
class ExerciseSelectionDialog extends StatefulWidget {
  final List<Exercise> availableExercises;
  final List<Exercise>? selectedExercises;
  final Function(Exercise) onExerciseSelected;

  const ExerciseSelectionDialog({
    Key? key,
    required this.availableExercises,
    this.selectedExercises,
    required this.onExerciseSelected,
  }) : super(key: key);

  @override
  State<ExerciseSelectionDialog> createState() => _ExerciseSelectionDialogState();
}

class _ExerciseSelectionDialogState extends State<ExerciseSelectionDialog> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredExercises = widget.availableExercises
        .where((exercise) =>
            exercise.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Select Exercise',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredExercises.isEmpty
                  ? const Center(
                      child: Text('No exercises found'),
                    )
                  : ListView.builder(
                      itemCount: filteredExercises.length,
                      itemBuilder: (context, index) {
                        final exercise = filteredExercises[index];
                        final isSelected = widget.selectedExercises?.any((e) => e.id == exercise.id) ?? false;
                        return Card(
                          color: isSelected ? Colors.grey[200] : null,
                          child: ListTile(
                            title: Text(exercise.name),
                            subtitle: Text(exercise.description ?? 'No description'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppConstants.getDifficultyColor(exercise.difficulty ?? 'Unknown').withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppConstants.getDifficultyColor(exercise.difficulty ?? 'Unknown').withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                exercise.difficulty ?? 'Unknown',
                                style: TextStyle(
                                  color: AppConstants.getDifficultyColor(exercise.difficulty ?? 'Unknown'),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            onTap: isSelected ? null : () {
                              widget.onExerciseSelected(exercise);
                              Get.back();
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditExerciseDialog extends StatefulWidget {
  final SelectedExercise selectedExercise;
  final Function(SelectedExercise) onExerciseUpdated;

  const EditExerciseDialog({
    Key? key,
    required this.selectedExercise,
    required this.onExerciseUpdated,
  }) : super(key: key);

  @override
  State<EditExerciseDialog> createState() => _EditExerciseDialogState();
}

class _EditExerciseDialogState extends State<EditExerciseDialog> {
  late TextEditingController _setsController;
  late TextEditingController _repsController;
  late TextEditingController _durationController;
  late TextEditingController _restController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _setsController = TextEditingController(text: widget.selectedExercise.sets.toString());
    _repsController = TextEditingController(text: widget.selectedExercise.reps.toString());
    _durationController = TextEditingController(text: widget.selectedExercise.durationInSeconds.toString());
    _restController = TextEditingController(text: widget.selectedExercise.restInSeconds.toString());
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _durationController.dispose();
    _restController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Exercise',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.selectedExercise.exercise.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _setsController,
                      decoration: const InputDecoration(
                        labelText: 'Sets',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _repsController,
                      decoration: const InputDecoration(
                        labelText: 'Reps',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        labelText: 'Duration (sec)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _restController,
                      decoration: const InputDecoration(
                        labelText: 'Rest (sec)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updatedExercise = SelectedExercise(
                          exercise: widget.selectedExercise.exercise,
                          sets: int.parse(_setsController.text),
                          reps: int.parse(_repsController.text),
                          durationInSeconds: int.parse(_durationController.text),
                          restInSeconds: int.parse(_restController.text),
                        );
                        widget.onExerciseUpdated(updatedExercise);
                        Get.back();
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}