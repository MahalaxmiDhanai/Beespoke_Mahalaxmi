/// Riverpod providers for DI: Dio, datasources, repositories, use-cases.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/local/history_local_datasource.dart';
import '../../data/datasources/local/product_local_datasource.dart';
import '../../data/datasources/remote/product_remote_datasource.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/add_history_entry_usecase.dart';
import '../../domain/usecases/dislike_product_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/like_product_usecase.dart';

// ─── Infrastructure ───────────────────────────────────────────────────────────

/// Provides a configured [Dio] instance.
final dioProvider = Provider<Dio>((ref) => createDioClient());

/// Provides the local likes box. Must be opened before [runApp].
final likesBoxProvider = Provider<Box<int>>(
  (ref) => Hive.box<int>('likes_box'),
);

/// Provides the history box. Must be opened before [runApp].
final historyBoxProvider = Provider<Box<Map<String, dynamic>>>(
  (ref) => Hive.box<Map<String, dynamic>>('history_box'),
);

// ─── Datasources ──────────────────────────────────────────────────────────────

final productRemoteDatasourceProvider = Provider<ProductRemoteDatasource>(
  (ref) => ProductRemoteDatasourceImpl(ref.watch(dioProvider)),
);

final productLocalDatasourceProvider = Provider<ProductLocalDatasource>(
  (ref) => ProductLocalDatasourceImpl(ref.watch(likesBoxProvider)),
);

final historyLocalDatasourceProvider = Provider<HistoryLocalDatasource>(
  (ref) => HistoryLocalDatasourceImpl(ref.watch(historyBoxProvider)),
);

// ─── Repositories ─────────────────────────────────────────────────────────────

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(
    remote: ref.watch(productRemoteDatasourceProvider),
    local: ref.watch(productLocalDatasourceProvider),
  ),
);

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepositoryImpl(ref.watch(historyLocalDatasourceProvider)),
);

// ─── Use Cases ────────────────────────────────────────────────────────────────

final getProductsUseCaseProvider = Provider<GetProductsUseCase>(
  (ref) => GetProductsUseCase(ref.watch(productRepositoryProvider)),
);

final likeProductUseCaseProvider = Provider<LikeProductUseCase>(
  (ref) => LikeProductUseCase(ref.watch(productRepositoryProvider)),
);

final dislikeProductUseCaseProvider = Provider<DislikeProductUseCase>(
  (ref) => DislikeProductUseCase(ref.watch(productRepositoryProvider)),
);

final addHistoryEntryUseCaseProvider = Provider<AddHistoryEntryUseCase>(
  (ref) => AddHistoryEntryUseCase(ref.watch(historyRepositoryProvider)),
);

final getHistoryUseCaseProvider = Provider<GetHistoryUseCase>(
  (ref) => GetHistoryUseCase(ref.watch(historyRepositoryProvider)),
);
