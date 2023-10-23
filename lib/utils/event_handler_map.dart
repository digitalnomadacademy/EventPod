import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eventpod/utils/actor.dart';

import 'event_handler.dart';
import 'event.dart';

final eventHandlerMapProvider = Provider((ProviderRef ref) {
  return EventHandlerMap(ref.container);
});

class EventHandlerMap extends BaseActor {
  final List<EventEventHandlerMapping> mappings = [];

  EventHandlerMap(ProviderContainer providerContainer)
      : super(providerContainer);

  void mapAsync1<C extends EventHandler<T>, T>(
      Provider<EventBus<T>> eventProvider,
      C Function(ProviderContainer providerContainer) eventHandlerFactory) {
    var event = providerContainer.read(eventProvider);

    var subscription = event.listen(
        (payload) => eventHandlerFactory(providerContainer).execute(payload));
    mappings.add(EventEventHandlerMapping(
        subscription: subscription,
        eventType: event.runtimeType,
        eventHandlerType: C));
  }

  @override
  void dispose() {
    super.dispose();
    for (var mapping in mappings) {
      mapping.subscription.removeListener();
    }
    mappings.clear();
  }
}

class EventEventHandlerMapping {
  final BaseSubscription subscription;
  final Type eventType;
  final Type eventHandlerType;

  EventEventHandlerMapping(
      {required this.subscription,
      required this.eventType,
      required this.eventHandlerType});
}
