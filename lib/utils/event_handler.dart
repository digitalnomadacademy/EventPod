import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eventpod/utils/service.dart';
import 'package:eventpod/utils/event.dart';
import 'package:eventpod/utils/store.dart';

/// Event handler will handle events dispatched to it, it can also call
/// other event handlers
class _BaseEventHandler {
  @protected
  final ProviderContainer providerContainer;

  _BaseEventHandler(this.providerContainer);
  // T read<T>(Provider<T> provider) {
  //   return ref.watch(provider);
  // }

  T readStore<T extends BaseStore>(Provider<T> provider) {
    return providerContainer.read(provider);
  }

  T readService<T extends BaseService>(Provider<T> provider) {
    return providerContainer.read(provider);
  }

  T readEvent<T extends EventBus>(Provider<T> provider) {
    return providerContainer.read(provider);
  }
}

abstract class EventHandler<T> extends _BaseEventHandler {
  EventHandler(ProviderContainer container) : super(container);

  Future<void> execute(T payload);
}
