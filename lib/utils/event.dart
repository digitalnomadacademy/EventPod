import 'package:eventpod/utils/logger.dart';

typedef EventListener<T> = Future<void> Function(T payload);

abstract class BaseSubscription {
  void removeListener();
}

class EventSubscription<T> extends BaseSubscription {
  EventSubscription(this.event, this.listener);

  final EventBus<T> event;
  final EventListener<T> listener;

  @override
  void removeListener() {
    event.removeListener(listener);
  }
}

abstract class EventBus<T> {
  final List<EventListener<T>> listeners = [];

  EventSubscription<T> listen(EventListener<T> listener) {
    listeners.add(listener);

    return EventSubscription<T>(this, listener);
  }

  void removeListener(EventListener<T> listener) {
    listeners.remove(listener);
  }

  void removeAll() {
    listeners.clear();
  }

  Future<void> dispatch(T payload, {bool eagerError = false}) async {
    try {
      logger.t('executing ${listeners.length} listeners on $runtimeType'
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
