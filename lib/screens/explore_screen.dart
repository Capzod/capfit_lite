import 'package:flutter/material.dart';
import '../services/workout_service.dart';
import '../constants/colors.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedCategory = 0;
  final List<String> categories = ['All', 'Strength', 'Cardio', 'Yoga', 'HIIT'];
  
  List<Map<String, dynamic>> _workouts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadWorkoutsFromAPI();
  }

  // Data cleaning methods
  List<Map<String, dynamic>> _cleanWorkoutData(List<Map<String, dynamic>> workouts) {
    return workouts.where((workout) {
      final title = workout['title']?.toString().trim() ?? '';
      final category = workout['category']?.toString().trim() ?? '';
      
      // Filter out garbage data
      return title.isNotEmpty &&
             title.length > 2 &&
             !title.contains('null') &&
             !title.contains('undefined') &&
             !title.contains('test') &&
             !title.contains('example') &&
             category.isNotEmpty;
    }).map((workout) {
      // Clean individual workout data
      return {
        'id': workout['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _cleanTitle(workout['title']),
        'duration': workout['duration']?.toString().replaceAll('null', '25 min') ?? '25 min',
        'calories': workout['calories']?.toString().replaceAll('null', '200 cal') ?? '200 cal',
        'difficulty': workout['difficulty']?.toString().replaceAll('null', 'Intermediate') ?? 'Intermediate',
        'image': workout['image']?.toString().replaceAll('null', '⚡') ?? '⚡',
        'dueDate': workout['dueDate']?.toString().replaceAll('null', 'Today') ?? 'Today',
        'isCompleted': workout['isCompleted'] ?? false,
        'category': _cleanCategory(workout['category']),
      };
    }).toList();
  }

  String _cleanTitle(String? title) {
    if (title == null || title.isEmpty) return 'Workout Session';
    
    final cleanTitle = title
        .replaceAll('null', '')
        .replaceAll('undefined', '')
        .replaceAll('test', '')
        .trim();
    
    return cleanTitle.isEmpty ? 'Workout Session' : cleanTitle;
  }

  String _cleanCategory(String? category) {
    if (category == null || category.isEmpty) return 'General';
    
    final cleanCategory = category
        .replaceAll('null', '')
        .replaceAll('undefined', '')
        .trim();
    
    return cleanCategory.isEmpty ? 'General' : cleanCategory;
  }

  List<Map<String, dynamic>> _getFallbackWorkouts() {
    return [
      {
        'id': '1',
        'title': 'Morning Cardio Blast',
        'duration': '30 min',
        'calories': '250 cal',
        'difficulty': 'Intermediate',
        'image': '🏃‍♂️',
        'dueDate': 'Today',
        'isCompleted': false,
        'category': 'Cardio',
      },
      {
        'id': '2', 
        'title': 'Strength Training',
        'duration': '45 min',
        'calories': '300 cal',
        'difficulty': 'Advanced',
        'image': '💪',
        'dueDate': 'Today',
        'isCompleted': false,
        'category': 'Strength',
      },
      {
        'id': '3',
        'title': 'Yoga Flow',
        'duration': '40 min',
        'calories': '180 cal',
        'difficulty': 'Beginner',
        'image': '🧘‍♀️',
        'dueDate': 'Tomorrow',
        'isCompleted': false,
        'category': 'Yoga',
      },
      {
        'id': '4',
        'title': 'HIIT Challenge',
        'duration': '20 min',
        'calories': '280 cal',
        'difficulty': 'Advanced',
        'image': '⚡',
        'dueDate': 'Today',
        'isCompleted': true,
        'category': 'HIIT',
      },
      {
        'id': '5',
        'title': 'Evening Stretch',
        'duration': '25 min',
        'calories': '120 cal',
        'difficulty': 'Beginner',
        'image': '🌟',
        'dueDate': 'Tomorrow',
        'isCompleted': false,
        'category': 'Yoga',
      },
    ];
  }

  bool _hasBadData(List<Map<String, dynamic>> workouts) {
    return workouts.any((workout) => 
        workout['title']?.toString().contains('null') == true ||
        workout['title']?.toString().contains('undefined') == true);
  }

  Future<void> _loadWorkoutsFromAPI() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final workouts = await WorkoutService.getWorkouts();
      final cleanedWorkouts = _cleanWorkoutData(workouts);
      
      // If still bad data or empty, use fallback
      if (cleanedWorkouts.isEmpty || _hasBadData(cleanedWorkouts)) {
        setState(() {
          _workouts = _getFallbackWorkouts();
          _isLoading = false;
        });
      } else {
        setState(() {
          _workouts = cleanedWorkouts;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _workouts = _getFallbackWorkouts();
        _isLoading = false;
      });
    }
  }

  void _onCompleteWorkout(int index) async {
    final workout = _workouts[index];
    
    try {
      await WorkoutService.updateWorkout(workout['id'], {
        ...workout,
        'isCompleted': true,
      });
      
      setState(() {
        _workouts[index]['isCompleted'] = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${workout['title']} completed! 🎉'),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to complete workout'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _addNewWorkout() async {
    final newWorkout = {
      'title': 'Custom Workout Session',
      'duration': '25 min',
      'calories': '200 cal',
      'difficulty': 'Intermediate',
      'image': '⚡',
      'dueDate': 'Today',
      'isCompleted': false,
      'category': 'Custom',
    };
    
    try {
      final result = await WorkoutService.addWorkout(newWorkout);
      setState(() {
        _workouts.insert(0, result);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New workout added! 🎉'),
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add workout'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _deleteWorkout(int index) async {
    final workout = _workouts[index];
    final workoutTitle = workout['title'];
    
    try {
      final success = await WorkoutService.deleteWorkout(workout['id']);
      if (success) {
        setState(() {
          _workouts.removeAt(index);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$workoutTitle deleted!'),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete workout'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  List<Map<String, dynamic>> get _filteredWorkouts {
    if (_selectedCategory == 0) return _workouts;
    final category = categories[_selectedCategory];
    return _workouts.where((workout) => workout['category'] == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Workouts',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadWorkoutsFromAPI,
            icon: const Icon(Icons.refresh, color: AppColors.primary),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewWorkout,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.background),
      ),
      body: _isLoading 
          ? _buildLoadingState()
          : _errorMessage.isNotEmpty
            ? _buildErrorState()
            : _buildWorkoutList(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Loading workouts...',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadWorkoutsFromAPI,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutList() {
    final filteredWorkouts = _filteredWorkouts;
    
    return Column(
      children: [
        // Categories
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedCategory == index 
                            ? AppColors.primary 
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: _selectedCategory == index 
                              ? AppColors.background 
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Workout Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                '${filteredWorkouts.length} workouts',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Workouts List
        Expanded(
          child: filteredWorkouts.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filteredWorkouts.length,
                  itemBuilder: (context, index) {
                    final workout = filteredWorkouts[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          // Workout Icon
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                workout['image'],
                                style: const TextStyle(fontSize: 24, color: AppColors.emoji),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Workout Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        workout['dueDate'],
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (workout['isCompleted'])
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.success.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          'Completed',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.success,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  workout['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${workout['duration']} • ${workout['calories']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      workout['difficulty'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '• ${workout['category']}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // Action Buttons
                          Column(
                            children: [
                              if (!workout['isCompleted'])
                                IconButton(
                                  onPressed: () => _onCompleteWorkout(index),
                                  icon: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 28),
                                ),
                              if (workout['isCompleted'])
                                const Icon(Icons.check_circle, color: AppColors.success, size: 28),
                              IconButton(
                                onPressed: () => _deleteWorkout(index),
                                icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 22),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.fitness_center, size: 80, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          const Text(
            'No Workouts Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add a workout to get started!',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _addNewWorkout,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
            ),
            child: const Text('Add First Workout'),
          ),
        ],
      ),
    );
  }
}