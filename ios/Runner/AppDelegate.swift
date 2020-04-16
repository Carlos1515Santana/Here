import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    [GMSServices provideAPIKey: @"AIzaSyBH9jPUi9Pez_HtbXkS1LANmZa-YFg5q6E"];
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
