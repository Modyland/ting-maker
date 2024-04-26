import UIKit
import Flutter
import flutter_background_service_ios // add this

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var appLifeCycle: FlutterBasicMessageChannel!
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
    SwiftFlutterBackgroundServicePlugin.taskIdentifier = "your.custom.task.identifier"
    GeneratedPluginRegistrant.register(with: self)
    appLifeCycle = FlutterBasicMessageChannel(
            name: "appLifeCycle",
            binaryMessenger: (window?.rootViewController as! FlutterViewController).binaryMessenger,
            codec: FlutterStringCodec.sharedInstance())
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
    }
    override func applicationWillTerminate(_ application: UIApplication) {
        appLifeCycle.sendMessage("lifeCycleStateWithDetached")
    }
}
