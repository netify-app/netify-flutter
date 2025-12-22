import Flutter
import UIKit

public class NetifyPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.netify/platform", binaryMessenger: registrar.messenger())
    let instance = NetifyPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getAppName":
      if let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
        result(appName)
      } else if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
        result(appName)
      } else {
        result("Netify")
      }
      
    case "getTempDirectory":
      result(NSTemporaryDirectory())
      
    case "getDocumentsDirectory":
      if let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
        result(documentsPath)
      } else {
        result("")
      }
      
    case "shareFile":
      guard let args = call.arguments as? [String: Any],
            let path = args["path"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        return
      }
      
      let fileURL = URL(fileURLWithPath: path)
      
      DispatchQueue.main.async {
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
          let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
          
          // For iPad
          if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
          }
          
          viewController.present(activityVC, animated: true, completion: nil)
          result(nil)
        } else {
          result(FlutterError(code: "NO_VIEW_CONTROLLER", message: "Cannot find view controller", details: nil))
        }
      }
      
    case "shareText":
      guard let args = call.arguments as? [String: Any],
            let text = args["text"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        return
      }
      
      DispatchQueue.main.async {
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
          let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
          
          // For iPad
          if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
          }
          
          viewController.present(activityVC, animated: true, completion: nil)
          result(nil)
        } else {
          result(FlutterError(code: "NO_VIEW_CONTROLLER", message: "Cannot find view controller", details: nil))
        }
      }
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
