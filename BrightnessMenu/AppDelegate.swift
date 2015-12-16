import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var verticalSlider: NSSlider!
    @IBOutlet weak var quitMenuItem: NSMenuItem!
    @IBOutlet weak var lockMenuItem: NSMenuItem!
    @IBOutlet weak var separatorMenuItem: NSMenuItem!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        let sliderMenuItem = NSMenuItem()
        let icon = NSImage(named: "AppIcon")
        icon?.size = NSSize(width: 16, height: 16)
        
        statusItem.image = icon
        
        verticalSlider.minValue = 0
        verticalSlider.maxValue = 1
        
        sliderMenuItem.view = verticalSlider
        statusMenu.addItem(sliderMenuItem)
        statusMenu.addItem(separatorMenuItem)
        statusMenu.addItem(lockMenuItem)
        statusMenu.addItem(quitMenuItem)
        
        statusItem.menu = statusMenu
    }

    @IBAction func brightnessSlider(sender: NSSlider) {
        setBrightnessLevel(sender.floatValue)
    }
    
    @IBAction func lockClicked(sender: NSMenuItem) {
        if(sender.state == NSOnState) {
            sender.state = NSOffState
        } else {
            sender.state = NSOnState
        }
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    func setBrightnessLevel(level: Float) {
        
        var iterator: io_iterator_t = 0
        let screens = NSScreen.screens()
        let screenService = IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"), &iterator)
        
        if screenService == kIOReturnSuccess {
            
            var service: io_object_t = 1
            
            for screen in screens! {
                service = IOIteratorNext(iterator)
                
                if (lockMenuItem.state == NSOnState) || (screen == NSScreen.mainScreen()) {
                    IODisplaySetFloatParameter(service, 0, kIODisplayBrightnessKey, level)
                    IOObjectRelease(service)
                }
            }
        }
    }
}

