/// API and app-wide constants.
library;

/// Base URL for the FakeStore REST API.
const String kBaseUrl = 'https://fakestoreapi.com';

/// HTTP connection timeout.
const Duration kConnectTimeout = Duration(seconds: 15);

/// HTTP receive timeout.
const Duration kReceiveTimeout = Duration(seconds: 15);

/// Hive box names.
const String kLikesBoxName = 'likes_box';
const String kHistoryBoxName = 'history_box';

/// Hive type adapter IDs.
const int kHistoryEntryTypeId = 0;

/// FakeStore API paths.
const String kProductsPath = '/products';
