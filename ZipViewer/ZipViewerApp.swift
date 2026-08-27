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
    #endif
    @State private var viewModel: ZipViewModel
    
    init() {
        let source = DefaultZipDataSource()
        let repository = DefaultFileRepository(source)
        viewModel = ZipViewModel(repository)
        
        #if os(macOS)
        appDelegate.onOpenURL = { [viewModel] urls in
            if let url = urls.first {
                viewModel.load(url: url)
                viewModel.initWidth()
            }
        }
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
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
class AppDelegate: NSObject, NSApplicationDelegate {
    var onOpenURL: ([URL]) -> Void = { _ in }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        onOpenURL(urls)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
#endif
