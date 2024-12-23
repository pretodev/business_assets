import 'dart:async';

Future<void> setup(List<SetupTask> tasks) async {
  for (final task in tasks) {
    await task.prepare();
  }
}

abstract interface class SetupTask {
  FutureOr<void> prepare();
}
