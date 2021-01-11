//
//  AppDelegate.swift
//  JSONMapping
//
//  Created by BraveShine on 2020/10/5.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {

        let contentView = ContentView().frame(minWidth: 800, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)


        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 960, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.setFrameAutosaveName("JSONMapping")
        window.title = "JSONMapping"
        window.contentView = NSHostingView(rootView: contentView)
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        window.delegate = self
    }

    @IBAction func preferenceItemClick(_ sender: NSMenuItem) {
        openPreferenceWindow()
    }
    @objc func reOpenWindow(){
        for window: NSWindow in NSApplication.shared.windows {
            if window == self.window {
                window.makeKeyAndOrderFront(self)
            }
        }
       
    }
    @IBAction func reopenMainWindow(_ sender: NSMenuItem) {
        reOpenWindow()
    }
    
    func openPreferenceWindow(){
        let size : NSSize = NSSize(width: 350, height: 200)

        let contentView = PreferenceView()
            .frame(width: size.width, height: size.height, alignment: .center)
        let preferenceWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: size.width, height: size.height),
            styleMask: [.titled, .closable,],
            backing: .buffered, defer: false)
        preferenceWindow.isReleasedWhenClosed = false
        preferenceWindow.center()
        preferenceWindow.title = NSLocalizedString("Preferences", comment: "")
        preferenceWindow.contentView = NSHostingView(rootView: contentView)
        preferenceWindow.center()
        preferenceWindow.makeKeyAndOrderFront(nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
       let menu = NSMenu()
       let reopenItem = NSMenuItem(title: NSLocalizedString("JSONMapping", comment: ""), action: #selector(reOpenWindow), keyEquivalent: "O")
        
        let prefreenceItem = NSMenuItem(title: NSLocalizedString("Preferences", comment: ""), action: #selector(preferenceItemClick(_:)), keyEquivalent: "0")
       menu.addItem(reopenItem)
        menu.addItem(prefreenceItem)
       return menu
    }
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            reOpenWindow()
            return true
        }
        return true
    }

}

extension AppDelegate : NSWindowDelegate{
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(self)
        if sender.isZoomed {
            return true
        }else{
            sender.orderOut(self)
        }
        return false
    }
}
