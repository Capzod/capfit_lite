import 'package:flutter/material.dart';
import '../constants/colors.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  String _selectedTimeframe = 'Week';
  int _selectedMetric = 0;

  final List<String> metrics = ['Workouts', 'Calories', 'Minutes', 'Streak'];
  final List<String> timeframes = ['Week', 'Month', 'Year'];

  final Map<String, List<int>> workoutData = {
    'Week': [3, 5, 4, 6, 2, 4, 5],
    'Month': [18, 22, 25, 20, 23, 26, 24, 22, 25, 28, 26, 24, 22, 25, 28, 30, 28, 26, 24, 22, 25, 28, 26, 24, 22, 25, 28, 30, 32, 30],
    'Year': [120, 135, 125, 140, 130, 145, 135, 150, 140, 155, 145, 160],
  };

  final Map<String, List<int>> calorieData = {
    'Week': [320, 450, 380, 520, 280, 410, 490],
    'Month': [3200, 3500, 3800, 3200, 4100, 3900, 4200, 3800, 4500, 4200, 3900, 4100, 3800, 4200, 4500, 4800, 4200, 3900, 4100, 3800, 4200, 4500, 4800, 4200, 3900, 4100, 3800, 4200, 4500, 4800],
    'Year': [12500, 13200, 12800, 13500, 13000, 14200, 13800, 14500, 14000, 15200, 14800, 15500],
  };

  List<int> get _currentData {
    if (_selectedMetric == 0) return workoutData[_selectedTimeframe] ?? [];
    return calorieData[_selectedTimeframe] ?? [];
  }

  String get _currentMetricValue {
    final data = _currentData;
    if (data.isEmpty) return '0';
    if (_selectedMetric == 0) return data.last.toString();
    return data.last.toString();
  }

  String get _metricChange {
    final data = _currentData;
    if (data.length < 2) return '+0%';
    
    final current = data.last;
    final previous = data[data.length - 2];
    final change = ((current - previous) / previous * 100).round();
    
    return change >= 0 ? '+$change%' : '$change%';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Performance',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Timeframe Selector
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: List.generate(timeframes.length, (index) {
                  final isSelected = _selectedTimeframe == timeframes[index];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTimeframe = timeframes[index];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            timeframes[index],
                            style: TextStyle(
                              color: isSelected ? AppColors.background : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // Main Metric Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                gradient: AppColors.primaryGradient,
              ),
              child: Column(
                children: [
                  Text(
                    _selectedMetric == 0 ? 'Workouts Completed' : 'Calories Burned',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentMetricValue,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _metricChange,
                    style: TextStyle(
                      fontSize: 16,
                      color: _metricChange.contains('+') ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Metrics Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildMetricCard('Total Minutes', '1,250', '+8%', Icons.timer, AppColors.primary),
                _buildMetricCard('Active Days', '24', '+12%', Icons.calendar_today, AppColors.success),
                _buildMetricCard('Current Streak', '7 days', 'Keep going!', Icons.bolt, AppColors.warning),
                _buildMetricCard('Avg. Session', '42 min', '+5%', Icons.trending_up, AppColors.primary),
              ],
            ),

            const SizedBox(height: 24),

            // Progress Chart Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progress Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last $_selectedTimeframe',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Bar Chart
                  Container(
                    height: 200,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _buildChartBars(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          color: AppColors.textSecondary.withOpacity(0.3),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: _buildChartLabels(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Achievements
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Achievements',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildAchievementItem(
              'Week Warrior',
              'Complete 5 workouts in a week',
              true,
              Icons.emoji_events,
            ),
            _buildAchievementItem(
              'Early Riser',
              'Workout before 8 AM for 7 days',
              false,
              Icons.brightness_5,
            ),
            _buildAchievementItem(
              'Marathon Runner',
              'Run total of 42 km this month',
              true,
              Icons.directions_run,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String change, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  color: change.contains('+') ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChartBars() {
    final data = _currentData.take(7).toList();
    final maxValue = data.isNotEmpty ? data.reduce((a, b) => a > b ? a : b) : 1;
    
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;
      final height = (value / maxValue) * 150;
      
      return Column(
        children: [
          Container(
            width: 20,
            height: height,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 8),
        ],
      );
    }).toList();
  }

  List<Widget> _buildChartLabels() {
    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return labels.take(7).map((label) {
      return Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: AppColors.textSecondary,
        ),
      );
    }).toList();
  }

  Widget _buildAchievementItem(String title, String description, bool achieved, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: achieved ? AppColors.primary.withOpacity(0.2) : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: achieved ? AppColors.primary : AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: achieved ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            achieved ? Icons.check_circle : Icons.lock,
            color: achieved ? AppColors.success : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}