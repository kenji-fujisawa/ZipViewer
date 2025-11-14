//
//  ContentView.swift
//  ZipViewer
//
//  Created by uhimania on 2025/11/13.
//

import SwiftUI
import UniformTypeIdentifiers
import ZIPFoundation

struct ContentView: View {
    @Environment(AppDelegate.self) private var appDelegate
    @State private var showImporter: Bool = false
    @State private var items: [ZipItem] = []
    @State private var selected: ZipItem? = nil
    @State private var columnVisibility = NavigationSplitViewVisibility.detailOnly
    
    private var windowToolbarFullScreenVisibility: WindowToolbarFullScreenVisibility {
        #if os(macOS)
        .onHover
        #else
        .automatic
        #endif
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(items: $items, selected: $selected)
        } detail: {
            DetailView(item: $selected)
                .id(selected?.id)
        }
        .windowToolbarFullScreenVisibility(windowToolbarFullScreenVisibility)
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.width < -50 {
                    moveNext()
                } else if value.translation.width > 50 {
                    movePrevious()
                }
            }
        )
        .onTapGesture(count: 2) {
            #if os(macOS)
            if let window = NSApp.keyWindow {
                window.toggleFullScreen(nil)
            }
            #endif
        }
        .focusedSceneValue(\.openFileAction, OpenFileAction(showImporter: { showImporter = true }))
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.zip], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    guard url.startAccessingSecurityScopedResource() else { return }
                    defer { url.stopAccessingSecurityScopedResource() }
                    loadEntries(url: url)
                }
            case .failure(let error):
                print(error)
            }
        }
        .dropDestination(for: URL.self) { items, session in
            if let url = items.first {
                loadEntries(url: url)
            }
        }
        .onChange(of: appDelegate.urls) { _, _ in
            if let url = appDelegate.urls.first {
                loadEntries(url: url)
            }
        }
    }
    
    private func loadEntries(url: URL) {
        items.removeAll()
        
        do {
            let archive = try Archive(url: url, accessMode: .read)
            for entry in archive {
                if entry.path.last != "/" {
                    items.append(ZipItem(archive: archive, entry: entry))
                }
            }
        } catch {
            print(error)
        }
        
        if let item = items.first {
            selected = item
        }
    }
    
    private func moveNext() {
        if let selected = selected,
           let index = items.firstIndex(of: selected) {
            if index == items.count - 1 {
                self.selected = items.first
            } else {
                self.selected = items[index + 1]
            }
        }
    }
    
    private func movePrevious() {
        if let selected = selected,
           let index = items.firstIndex(of: selected) {
            if index == 0 {
                self.selected = items.last
            } else {
                self.selected = items[index - 1]
            }
        }
    }
}

#Preview {
    ContentView()
}
