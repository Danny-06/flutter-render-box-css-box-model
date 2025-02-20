import 'package:events_emitter/events_emitter.dart';

import 'package:flutter/material.dart';


enum WidgetLyfecycleEvent {

  DISPOSE,

  INIT_STATE,

}


mixin WidgetLyfecycle<T extends StatefulWidget> on State<T> {

  final _lyfecyleEventEmitter = EventEmitter();

  late final _disposeEvent = Event(WidgetLyfecycleEvent.DISPOSE.name, null);

  late final _initStateEvent = Event(WidgetLyfecycleEvent.INIT_STATE.name, null);

  @override
  dispose() {
    super.dispose();

    this._lyfecyleEventEmitter.emitEvent(this._disposeEvent);
  }

  @override
  void initState() {
    super.initState();

    this._lyfecyleEventEmitter.emitEvent(this._initStateEvent);
  }

}
