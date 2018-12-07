import Flutter
import UIKit

public class SwiftMgOauth2Plugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "mg_oauth3", binaryMessenger: registrar.messenger())
        let instance = SwiftMgOauth2Plugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "myFirstMethod":
                result("my method")
            case "getPlatformVersion":
                result("iOS " + UIDevice.current.systemVersion)
            default:
                result(FlutterMethodNotImplemented)
        }
    }
}
