# 💪 CapFit - Fitness App

A complete Flutter fitness application with REST API integration, built for modern mobile fitness tracking.

![CapFit App](https://img.shields.io/badge/Flutter-3.16-blue) ![License](https://img.shields.io/badge/License-MIT-green)

## 🚀 Features

- **4 Professional Screens**: Home, Explore, Performance, Profile
- **REST API Integration**: Full CRUD operations with HTTP package
- **Real-time Data**: Live workout tracking and statistics
- **Professional UI/UX**: Material Design with perfect spacing
- **State Management**: Efficient widget rebuilding
- **Error Handling**: Network failure graceful degradation

## 📱 Screens

| Home | Explore | Performance | Profile |
|------|---------|-------------|---------|
| Dashboard with live stats | API-powered workouts | Charts & metrics | User settings |

## 🛠️ Tech Stack

- **Flutter 3.16** - Cross-platform framework
- **Dart** - Programming language
- **HTTP Package** - REST API integration
- **Material Design** - UI components
- **JSONPlaceholder API** - Demo backend

## 🔧 API Integration

```dart
// Example API call
Future<List<Workout>> getWorkouts() async {
  final response = await http.get(Uri.parse('$baseUrl/workouts'));
  return parseWorkouts(response.body);
}
