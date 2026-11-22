import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart' show LazySingleton;

abstract interface class ConnectivityService {
  Future<bool> get isOnline;

  Stream<bool> get onlineChanges;
}

@LazySingleton(as: ConnectivityService)
class ConnectivityPlusService implements ConnectivityService {
  ConnectivityPlusService(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isOnline async =>
      _hasNetwork(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get onlineChanges =>
      _connectivity.onConnectivityChanged.map(_hasNetwork).distinct();

  bool _hasNetwork(List<ConnectivityResult> results) =>
      results.any((result) => result != ConnectivityResult.none);
}
