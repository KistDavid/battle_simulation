import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battle_simulation/src/common/repositories/hive_repository.dart';

final hiveRepositoryProvider = Provider((ref) {
  return HiveRepository();
});
