import 'package:flutter/services.dart';

enum CameraPermissionStatus { granted, denied, restricted, unknown }

abstract interface class CameraService {
  Future<CameraPermissionStatus> requestPermission();
  Future<CameraPermissionStatus> permissionStatus();
  Future<void> setLens({required bool frontFacing});
}

class NativeCameraService implements CameraService {
  NativeCameraService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('posecoach/camera');
  final MethodChannel _channel;
  @override
  Future<CameraPermissionStatus> requestPermission() async =>
      _parse(await _channel.invokeMethod<String>('requestPermission'));
  @override
  Future<CameraPermissionStatus> permissionStatus() async =>
      _parse(await _channel.invokeMethod<String>('permissionStatus'));
  @override
  Future<void> setLens({required bool frontFacing}) =>
      _channel.invokeMethod<void>('setLens', {'frontFacing': frontFacing});
  CameraPermissionStatus _parse(String? value) => switch (value) {
    'granted' => CameraPermissionStatus.granted,
    'denied' => CameraPermissionStatus.denied,
    'restricted' => CameraPermissionStatus.restricted,
    _ => CameraPermissionStatus.unknown,
  };
}
