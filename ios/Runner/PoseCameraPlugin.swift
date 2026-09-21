import AVFoundation
import Flutter
import UIKit

private let poseCameraLensChanged = Notification.Name("PoseCoachCameraLensChanged")

final class PoseCameraPlugin: NSObject, FlutterPlugin {
  static func register(with registrar: FlutterPluginRegistrar) {
    registrar.register(PoseCameraFactory(), withId: "posecoach/camera-preview")
    let channel = FlutterMethodChannel(name: "posecoach/camera", binaryMessenger: registrar.messenger())
    let instance = PoseCameraPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "requestPermission":
      AVCaptureDevice.requestAccess(for: .video) { granted in
        DispatchQueue.main.async { result(granted ? "granted" : "denied") }
      }
    case "permissionStatus":
      switch AVCaptureDevice.authorizationStatus(for: .video) {
      case .authorized: result("granted")
      case .denied: result("denied")
      case .restricted: result("restricted")
      case .notDetermined: result("unknown")
      @unknown default: result("unknown")
      }
    case "setLens":
      let frontFacing = (call.arguments as? [String: Any])?["frontFacing"] as? Bool ?? true
      NotificationCenter.default.post(name: poseCameraLensChanged, object: frontFacing)
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

private final class PoseCameraFactory: NSObject, FlutterPlatformViewFactory {
  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol { FlutterStandardMessageCodec.sharedInstance() }

  func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
    PoseCameraView(frame: frame)
  }
}

private final class PoseCameraView: NSObject, FlutterPlatformView {
  private let view: UIView
  private let session = AVCaptureSession()
  private let sessionQueue = DispatchQueue(label: "com.company.posecoach.camera")
  private var currentPosition: AVCaptureDevice.Position = .front

  init(frame: CGRect) {
    view = UIView(frame: frame)
    super.init()
    view.backgroundColor = .black
    NotificationCenter.default.addObserver(self, selector: #selector(lensChanged(_:)), name: poseCameraLensChanged, object: nil)
    configureSession()
  }

  func view() -> UIView { view }

  private func configureSession() {
    sessionQueue.async { [weak self] in
      guard let self else { return }
      guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else { return }
      self.session.beginConfiguration()
      self.session.sessionPreset = .high
      self.addInput(position: self.currentPosition)
      self.session.commitConfiguration()
      DispatchQueue.main.async {
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(previewLayer, at: 0)
        self.sessionQueue.async { self.session.startRunning() }
      }
    }
  }

  private func addInput(position: AVCaptureDevice.Position) {
    guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position), let input = try? AVCaptureDeviceInput(device: device), session.canAddInput(input) else { return }
    session.addInput(input)
  }

  @objc private func lensChanged(_ notification: Notification) {
    guard let frontFacing = notification.object as? Bool else { return }
    sessionQueue.async { [weak self] in
      guard let self else { return }
      self.session.beginConfiguration()
      self.session.inputs.forEach { self.session.removeInput($0) }
      self.currentPosition = frontFacing ? .front : .back
      self.addInput(position: self.currentPosition)
      self.session.commitConfiguration()
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
    sessionQueue.async { self.session.stopRunning() }
  }
}
