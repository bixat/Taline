import Cocoa
import FlutterMacOS
import LaunchAtLogin
import window_manager

class MainFlutterWindow: NSWindow {
    override func awakeFromNib() {
        let flutterViewController = FlutterViewController()
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)

        FlutterMethodChannel(
            name: "launch_at_startup", binaryMessenger: flutterViewController.engine.binaryMessenger
        )
        .setMethodCallHandler { (_ call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
            case "launchAtStartupIsEnabled":
                result(LaunchAtLogin.isEnabled)
            case "launchAtStartupSetEnabled":
                if let arguments = call.arguments as? [String: Any] {
                    LaunchAtLogin.isEnabled = arguments["setEnabledValue"] as! Bool
                }
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        RegisterGeneratedPlugins(registry: flutterViewController)

        // Add the context menu
        self.addContextMenu()
        
        super.awakeFromNib()
    }

    private func addContextMenu() {
        let menu = NSMenu()

        // Add custom menu items
        let customItem = NSMenuItem(title: "Custom Action", action: #selector(customAction), keyEquivalent: "")
        menu.addItem(customItem)

        let anotherItem = NSMenuItem(title: "Another Action", action: #selector(anotherAction), keyEquivalent: "")
        menu.addItem(anotherItem)

        // Set the context menu
        self.menu = menu
    }

    @objc private func customAction() {
        print("Custom Action Triggered")
        // Implement your custom action here
    }

    @objc private func anotherAction() {
        print("Another Action Triggered")
        // Implement another action here
    }

    override public func order(_ place: NSWindow.OrderingMode, relativeTo otherWin: Int) {
        super.order(place, relativeTo: otherWin)
        hiddenWindowAtLaunch()
    }
}