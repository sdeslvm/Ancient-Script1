//
//  Ancient_ScriptApp.swift
//  Ancient Script


import SwiftUI

@main
struct Ancient_ScriptApp: App {
    @UIApplicationDelegateAdaptor(AncientScriptAppDelegate.self) private var appDelegate
    var body: some Scene {
        WindowGroup {
            AncientScriptGameInitialView()
        }
    }
}
