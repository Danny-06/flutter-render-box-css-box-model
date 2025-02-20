import 'package:events_emitter/emitters/restricted_event_emitter.dart';

import 'dart:async';


enum AbortSignalEvent {

  abort,

}

class AbortException implements Exception {

  const AbortException([this.message = 'No reason specified']);

  final String? message;

}

class AbortTimeoutException implements AbortException, TimeoutException {

  AbortTimeoutException(
    this.message,
    {
      this.duration,
    }
  );

  @override
  final String? message;

  @override
  final Duration? duration;

}


class AbortSignal {

  AbortSignal._() {

  }

  final eventEmitter = RestrictedEventEmitter(
    allow: (
      AbortSignalEvent.values.map((abortSignalType) => abortSignalType.name).toSet()
    ),
  );

  bool _aborted = false;

  get aborted {
    return this._aborted;
  }

  void _abort(AbortException? reason) {
    if (this.aborted) {
      return;
    }

    this._aborted = true;
    this._reason = reason;

    this.eventEmitter.emit(
      AbortSignalEvent.abort.name,
    );
  }

  AbortException? _reason;

  get reason {
    return this._reason;
  }

  void throwIfAborted() {
    if (this.aborted) {
      throw this.reason!;
    }
  }

  static abort(AbortException? reason) {
    final abortSignal = AbortSignal._();

    abortSignal._abort(reason ?? AbortException());

    return abortSignal;
  }

  static any(Iterable<AbortSignal> abortSignalCollection) {
    final combinedAbortSignal = AbortSignal._();

    for (final abortSignal in abortSignalCollection) {
      abortSignal.eventEmitter.once(
        AbortSignalEvent.abort.name,
        (_) {
          combinedAbortSignal._abort(abortSignal.reason);
        },
      );
    }

    return combinedAbortSignal;
  }

  static timeout(Duration duration, {String? message}) {
    final abortSignal = AbortSignal._();

    Timer(
      duration,
      () {
        abortSignal._abort(
          AbortTimeoutException(message, duration: duration)
        );
      },
    );

    return abortSignal;
  }

}


class AbortController {

  AbortController() {
    this.signal = AbortSignal._();
  }

  late final AbortSignal signal;

  void abort(AbortException? reason) {
    this.signal._abort(reason);
  }

}
