/// In-app WebView page for viewing product details.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../domain/models/browsing_history_entry.dart';
import '../providers/history_provider.dart';

/// Opens a URL in an in-app WebView and records a browsing history entry.
class ProductWebViewPage extends ConsumerStatefulWidget {
  const ProductWebViewPage({
    super.key,
    required this.url,
    required this.title,
  });

  final String url;
  final String title;

  @override
  ConsumerState<ProductWebViewPage> createState() => _ProductWebViewPageState();
}

class _ProductWebViewPageState extends ConsumerState<ProductWebViewPage> {
  late final WebViewController _controller;
  double _loadingProgress = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) =>
              setState(() => _loadingProgress = progress / 100),
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: _onPageFinished,
          onWebResourceError: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _onPageFinished(String url) async {
    setState(() => _isLoading = false);
    final title = await _controller.getTitle() ?? widget.title;
    await ref.read(historyProvider.notifier).add(
          BrowsingHistoryEntry(
            url: url,
            title: title,
            visitedAt: DateTime.now(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () => _controller.reload(),
              tooltip: 'Reload',
            ),
          ],
          bottom: _isLoading
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(3),
                  child: LinearProgressIndicator(
                    value: _loadingProgress,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                )
              : null,
        ),
        body: WebViewWidget(controller: _controller),
      );
}
