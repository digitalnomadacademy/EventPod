import 'package:riverflow/utils/logger.dart';

typedef EventListener1<T> = void Function(T payload);
typedef EventListener0 = void Function();
typedef AsyncEventListener1<T> = Future<void> Function(T payload);
typedef AsyncEventListener0 = Future<void> Function();

abstract class BaseSubscription {
  void removeListener();
}

class AsyncEventSubscription1<T> extends BaseSubscription {
  AsyncEventSubscription1(this.Event, this.listener);

  final AsyncEventBus1<T> Event;
  final AsyncEventListener1<T> listener;

  @override
  void removeListener() {
    Event.removeListener(listener);
  }
}

abstract class AsyncEventBus1<T> {
  final List<AsyncEventListener1<T>> listeners = [];

  AsyncEventSubscription1<T> listen(AsyncEventListener1<T> listener) {
    listeners.add(listener);

    return AsyncEventSubscription1<T>(this, listener);
  }

  void removeListener(EventListener1<T> listener) {
    listeners.remove(listener);
  }

  void removeAll() {
    listeners.clear();
  }

  Future<void> dispatch(T payload, {bool eagerError = false}) async {
    try {
      logger.v('executing ${listeners.length} listeners on $runtimeType'
          ' with payload \n $payload');
      await Future.wait(listeners.map((listener) => listener(payload)));
    } catch (e) {
      logger.e('listener failed for $runtimeType with \n $e '
          '\n with payload $payload');
      if (eagerError) {
        throw Exception();
      }
    }
  }
}
