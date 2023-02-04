import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverflow/utils/actor.dart';

import 'event_handler.dart';
import 'event.dart';

final eventHandlerMapProvider = Provider((ProviderRef ref) {
  return EventHandlerMap(ref.container);
});

class EventHandlerMap extends BaseActor {
  final List<EventEventHandlerMapping> mappings = [];

  EventHandlerMap(ProviderContainer providerContainer)
      : super(providerContainer);

  void mapAsync1<C extends AsyncEventHandler1<T>, T>(
      Provider<AsyncEventBus1<T>> EventProvider,
      C Function(ProviderContainer providerContainer) EventHandlerFactory) {
    var Event = providerContainer.read(EventProvider);

    var subscription = Event.listen(
        (payload) => EventHandlerFactory(providerContainer).execute(payload));
    mappings.add(EventEventHandlerMapping(
        subscription: subscription,
        EventType: Event.runtimeType,
        EventHandlerType: C));
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
  final Type EventType;
  final Type EventHandlerType;

  EventEventHandlerMapping(
      {required this.subscription,
      required this.EventType,
      required this.EventHandlerType});
}
