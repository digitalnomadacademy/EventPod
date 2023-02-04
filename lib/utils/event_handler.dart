import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverflow/utils/service.dart';
import 'package:riverflow/utils/event.dart';
import 'package:riverflow/utils/store.dart';

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

  T readEvent<T extends AsyncEventBus1>(Provider<T> provider) {
    return providerContainer.read(provider);
  }
}

abstract class AsyncEventHandler1<T> extends _BaseEventHandler {
  AsyncEventHandler1(ProviderContainer container) : super(container);

  Future<void> execute(T payload);
}
