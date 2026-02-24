/// Browsing history list page.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/error_view.dart';
import '../providers/history_provider.dart';
import 'product_webview_page.dart';

/// Displays all recorded browsing history entries, newest first.
class BrowsingHistoryPage extends ConsumerWidget {
  const BrowsingHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncHistory = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browsing History'),
        actions: [
          asyncHistory.maybeWhen(
            data: (entries) => entries.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep_rounded),
                    tooltip: 'Clear history',
                    onPressed: () => _confirmClear(context, ref),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: asyncHistory.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorView(
          message: err.toString().replaceFirst('Exception: ', ''),
          onRetry: () => ref.invalidate(historyProvider),
        ),
        data: (entries) => entries.isEmpty
            ? const _EmptyHistory()
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: entries.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: AppColors.cardBorder,
                  indent: 72,
                ),
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: const Icon(
                        Icons.language_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      entry.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      _formatDate(entry.visitedAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white38,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white24,
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => ProductWebViewPage(
                          url: entry.url,
                          title: entry.title,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceVariant,
        title: const Text('Clear History?'),
        content: const Text(
          'This will permanently delete all browsing history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(historyProvider.notifier).clear();
    }
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.history_rounded,
              size: 64,
              color: AppColors.cardBorder,
            ),
            const SizedBox(height: 12),
            Text(
              'No browsing history yet',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white38),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tap a product to open it in the browser',
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
          ],
        ),
      );
}
