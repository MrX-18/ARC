import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import 'arc_button.dart';
import 'arc_logo.dart';

class LoadingView extends StatefulWidget {
  final String? message;
  const LoadingView({super.key, this.message});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ArcLogo(
                size: 80,
                showWordmark: false,
                progress: 0.3 + (_controller.value * 0.7),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            widget.message ?? 'INITIALIZING ARC...',
            style: AppTypography.labelUppercaseGold,
          ),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  const ErrorView({
    super.key,
    this.title = 'SOMETHING WENT WRONG.',
    this.message = 'Your setup is safe. Nothing was lost.',
    this.onRetry,
    this.retryLabel = 'TRY AGAIN',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.error.withOpacity(0.4)),
                color: AppColors.surface,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.titleSmall,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.subtitle,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 28),
              ArcButton(
                label: retryLabel,
                onPressed: onRetry,
                showArrow: false,
                height: 48,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  const EmptyView({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.layers_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
                color: AppColors.surface,
              ),
              child: Icon(icon, size: 36, color: AppColors.goldMuted),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.titleSmall,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.subtitle,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 28),
              ArcButton(
                label: actionLabel!,
                onPressed: onAction,
                showArrow: true,
                height: 48,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
