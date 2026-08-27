//
//  ZipViewerApp.swift
//  ZipViewer
//
//  Created by uhimania on 2025/11/13.
//

import SwiftUI

@main
struct ZipViewerApp: App {
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    #else
    @State private var appDelegate = AppDelegate()
    #endif
    @State private var viewModel: ZipViewModel
    
    init() {
        let source = DefaultZipDataSource()
        let repository = DefaultFileRepository(source)
        viewModel = ZipViewModel(repository)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .environment(appDelegate)
        }
        .commands {
            CommandGroup(replacing: .newItem) {}
            CommandGroup(replacing: .pasteboard) {}
            CommandGroup(replacing: .undoRedo) {}
            OpenFileCommands()
            ZoomCommands()
        }
    }
}

#if os(macOS)
@Observable
class AppDelegate: NSObject, NSApplicationDelegate {
    var urls: [URL] = []
    
    func application(_ application: NSApplication, open urls: [URL]) {
        self.urls = urls
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
#else
@Observable
class AppDelegate {
    var urls: [URL] = []
}
#endif
