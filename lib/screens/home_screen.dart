import 'package:flutter/material.dart';
import '../constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentDayIndex = 2;
  final int _steps = 7242;
  final int _calories = 1540;
  final int _activeMinutes = 92;
  final int _heartRate = 72;

  void _onSearchTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Search feature coming soon!'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _onDayTap(int index) {
    setState(() {
      _currentDayIndex = index;
    });
  }

  void _onChallengeTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting Full Body Challenge!'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _onStatTap(int index) {
    List<String> statNames = ['Steps', 'Calories', 'Active Minutes', 'Heart Rate'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing ${statNames[index]} details'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildAppTitle(),
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 28),
                _buildDailyChallenge(),
                const SizedBox(height: 28),
                _buildChallengeCard(),
                const SizedBox(height: 28),
                _buildStatsGrid(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildAppTitle() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 75,
        height: 75,
        child: Image.asset(
          'assets/images/cap_logo.png',
          fit: BoxFit.contain,
        ),
      ),
      const SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'CAPFIT',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'FITNESS REDEFINED',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: _onSearchTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(26),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: AppColors.textSecondary, size: 22),
            SizedBox(width: 12),
            Text(
              'Search workouts...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyChallenge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Challenge',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 111,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) => _buildDayItem(index)),
          ),
        ),
      ],
    );
  }

  Widget _buildDayItem(int index) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final dates = ['1', '2', '3', '4', '5', '6', '7'];
    final isToday = index == _currentDayIndex;

    return GestureDetector(
      onTap: () => _onDayTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 56,
            decoration: BoxDecoration(
              color: isToday ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                dates[index],
                style: TextStyle(
                  color: isToday ? AppColors.background : AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            days[index],
            style: TextStyle(
              color: isToday ? AppColors.primary : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard() {
    return GestureDetector(
      onTap: _onChallengeTap,
      child: Container(
        height: 120,
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: AppColors.primaryGradient,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Full Body Challenge',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Time to Grind champ!',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      {
        'icon': Icons.directions_walk,
        'value': '$_steps',
        'label': 'Steps',
        'subtext': 'Live tracking',
        'color': AppColors.emoji,
      },
      {
        'icon': Icons.local_fire_department,
        'value': '$_calories',
        'label': 'Calories',
        'subtext': 'Kcal burned',
        'color': AppColors.emoji,
      },
      {
        'icon': Icons.timer,
        'value': '$_activeMinutes',
        'label': 'Active Minutes',
        'subtext': 'Live tracking',
        'color': AppColors.emoji,
      },
      {
        'icon': Icons.favorite,
        'value': '$_heartRate',
        'label': 'Heart Rate',
        'subtext': 'BPM - Live',
        'color': AppColors.emoji,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => _buildStatCard(stats[index], index),
    );
  }

  Widget _buildStatCard(Map stat, int index) {
    return GestureDetector(
      onTap: () => _onStatTap(index),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 34,
              decoration: BoxDecoration(
                color: (stat['color'] as Color).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                stat['icon'] as IconData,
                size: 22,
                color: stat['color'] as Color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              stat['value'] as String,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              stat['label'] as String,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 3.5),
            Text(
              stat['subtext'] as String,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}