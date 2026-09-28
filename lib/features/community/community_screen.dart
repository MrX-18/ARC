import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/models.dart';
import '../../core/repositories/arc_repository.dart';
import '../../shared/widgets/arc_card.dart';
import '../../shared/widgets/state_views.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  final ArcRepository _arcRepo = ArcRepository();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddFriendDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('ADD ACCOUNTABILITY FRIEND', style: AppTypography.titleSmall),
        content: TextField(
          controller: controller,
          style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: "Enter friend's ARC username...",
            hintStyle: AppTypography.subtitle,
            filled: true,
            fillColor: AppColors.surfaceElevated,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('CANCEL', style: AppTypography.labelUppercase.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.ctaBackground, foregroundColor: AppColors.ctaText),
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                // In demo, add mock friend
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.surfaceElevated,
                    content: Text('Friend invite sent to $name', style: AppTypography.labelUppercaseGold),
                  ),
                );
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('INVITE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final friends = _arcRepo.friends;
    final groupArcs = _arcRepo.groupArcs;
    final challenges = _arcRepo.challenges;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'COMMUNITY',
          style: AppTypography.brandWordmark.copyWith(fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined, color: AppColors.gold),
            onPressed: () => _showAddFriendDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.gold,
          unselectedLabelColor: AppColors.textTertiary,
          labelStyle: AppTypography.labelUppercase.copyWith(fontSize: 11, fontWeight: FontWeight.w700),
          tabs: const [
            Tab(text: 'FRIENDS'),
            Tab(text: 'GROUP ARCS'),
            Tab(text: 'CHALLENGES'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Friends
          _buildFriendsTab(friends),

          // Tab 2: Group Arcs
          _buildGroupArcsTab(groupArcs),

          // Tab 3: Challenges
          _buildChallengesTab(challenges),
        ],
      ),
    );
  }

  Widget _buildFriendsTab(List<Friend> friends) {
    if (friends.isEmpty) {
      return const EmptyView(
        title: 'NO FRIENDS ADDED',
        message: 'Add friends for quiet accountability without social media clutter.',
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: friends.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final f = friends[idx];

        return ArcCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderGold),
                ),
                child: ClipOval(
                  child: Image.asset(
                    f.avatar,
                    fit: BoxFit.cover,
                    cacheWidth: 100,
                    errorBuilder: (_, __, ___) => const Icon(Icons.person, color: AppColors.gold),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f.name, style: AppTypography.titleSmall.copyWith(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(
                      f.activeArcTitle,
                      style: AppTypography.labelUppercaseGold.copyWith(fontSize: 9, letterSpacing: 1.0),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${f.currentStreak} DAY STREAK',
                    style: AppTypography.labelUppercase.copyWith(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.goldLight),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${f.daysCompleted} days total',
                    style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textTertiary),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGroupArcsTab(List<GroupArc> groupArcs) {
    if (groupArcs.isEmpty) {
      return const EmptyView(
        title: 'NO GROUP ARCS',
        message: 'Team up with friends to walk the exact same Arc chapter together.',
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: groupArcs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, idx) {
        final g = groupArcs[idx];

        return ArcCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderGold),
                    ),
                    child: Text(
                      '${g.durationDays} DAYS · ${g.memberCount} MEMBERS',
                      style: AppTypography.labelUppercaseGold.copyWith(fontSize: 9),
                    ),
                  ),
                  Text(
                    '${(g.groupProgress * 100).round()}% GROUP COMPLETE',
                    style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.textTertiary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                g.title,
                style: AppTypography.titleLarge.copyWith(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: g.groupProgress,
                  minHeight: 6,
                  backgroundColor: AppColors.progressTrack,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Members: ${g.members.join(", ")}',
                style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChallengesTab(List<Challenge> challenges) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: challenges.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, idx) {
        final c = challenges[idx];

        return ArcCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      '${c.durationDays} DAYS · ${c.category}',
                      style: AppTypography.labelUppercase.copyWith(fontSize: 9, color: AppColors.goldLight),
                    ),
                  ),
                  Text(
                    '${c.participantCount} joined',
                    style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textTertiary),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                c.title,
                style: AppTypography.titleSmall.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                c.description,
                style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    c.joined ? 'STATUS: IN PROGRESS' : 'NOT JOINED',
                    style: AppTypography.labelUppercaseGold.copyWith(fontSize: 9),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.joined ? AppColors.surfaceElevated : AppColors.ctaBackground,
                      foregroundColor: c.joined ? AppColors.textPrimary : AppColors.ctaText,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await _arcRepo.toggleChallenge(c.id);
                      setState(() {});
                    },
                    child: Text(
                      c.joined ? 'LEAVE' : 'JOIN CHALLENGE',
                      style: AppTypography.labelUppercase.copyWith(fontSize: 10, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
