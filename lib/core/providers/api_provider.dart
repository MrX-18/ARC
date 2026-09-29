import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_client.dart';
import 'auth_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient();
  final currentUser = ref.watch(currentUserProvider);
  client.setAuthToken(currentUser?.token);
  return client;
});
