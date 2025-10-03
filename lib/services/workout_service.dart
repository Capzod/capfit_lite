import 'dart:convert';
import 'package:http/http.dart' as http;

class WorkoutService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  
  // GET all workouts
  static Future<List<Map<String, dynamic>>> getWorkouts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        return data.take(6).map((item) {
          return {
            'id': item['id'],
            'title': '${_getWorkoutType(item['id'])}: ${item['title'].toString().split(' ').take(3).join(' ')}',
            'duration': '${30 + (item['id'] % 30)} min',
            'calories': '${200 + (item['id'] % 200)} cal',
            'difficulty': _getDifficulty(item['id']),
            'image': _getWorkoutEmoji(item['id']),
            'dueDate': _getDueDate(item['id']),
            'isCompleted': item['id'] % 3 == 0,
            'category': _getCategory(item['id']),
          };
        }).toList();
      } else {
        throw Exception('Failed to load workouts');
      }
    } catch (e) {
      // Fallback to mock data
      return _getMockWorkouts();
    }
  }

  // POST - Add new workout
  static Future<Map<String, dynamic>> addWorkout(Map<String, dynamic> workout) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(workout),
      );
      
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add workout');
      }
    } catch (e) {
      // Simulate success for demo
      return {'id': DateTime.now().millisecondsSinceEpoch, ...workout};
    }
  }

  // PUT - Update workout
  static Future<Map<String, dynamic>> updateWorkout(int id, Map<String, dynamic> updates) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/posts/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updates),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update workout');
      }
    } catch (e) {
      return updates;
    }
  }

  // DELETE - Remove workout
  static Future<bool> deleteWorkout(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/posts/$id'),
      );
      
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete workout');
      }
    } catch (e) {
      return true;
    }
  }

  // Helper methods
  static String _getWorkoutType(int id) {
    List<String> types = ['Strength Training', 'Cardio Session', 'Yoga Flow', 'HIIT Workout', 'Core Focus', 'Flexibility'];
    return types[id % types.length];
  }

  static String _getDifficulty(int id) {
    List<String> difficulties = ['Beginner', 'Intermediate', 'Advanced'];
    return difficulties[id % difficulties.length];
  }

  static String _getWorkoutEmoji(int id) {
    List<String> emojis = ['💪', '🏃', '🧘', '🔥', '⚡', '🌟'];
    return emojis[id % emojis.length];
  }

  static String _getDueDate(int id) {
    List<String> dates = ['Today', 'Tomorrow', 'This Week'];
    return dates[id % dates.length];
  }

  static String _getCategory(int id) {
    List<String> categories = ['Strength', 'Cardio', 'Yoga', 'HIIT', 'Core'];
    return categories[id % categories.length];
  }

  // Fallback mock data
  static List<Map<String, dynamic>> _getMockWorkouts() {
    return [
      {
        'id': 1,
        'title': 'Upper Body Strength',
        'duration': '45 min',
        'calories': '320 cal',
        'difficulty': 'Intermediate',
        'image': '💪',
        'dueDate': 'Today',
        'isCompleted': false,
        'category': 'Strength',
      },
      {
        'id': 2,
        'title': 'Cardio Running',
        'duration': '30 min',
        'calories': '280 cal',
        'difficulty': 'Beginner',
        'image': '🏃',
        'dueDate': 'Tomorrow',
        'isCompleted': false,
        'category': 'Cardio',
      },
    ];
  }
}