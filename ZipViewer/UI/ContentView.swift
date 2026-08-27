//
//  ContentView.swift
//  ZipViewer
//
//  Created by uhimania on 2025/11/13.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(AppDelegate.self) private var appDelegate
    let viewModel: ZipViewModel
    @State private var showImporter: Bool = false
    @State private var columnVisibility = NavigationSplitViewVisibility.detailOnly
    @State private var width: CGFloat = 0
    @State private var initialWidth: CGFloat = 0
    
    private var windowToolbarFullScreenVisibility: WindowToolbarFullScreenVisibility {
        #if os(macOS)
        .onHover
        #else
        .automatic
        #endif
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            if columnVisibility != .detailOnly {
                SidebarView(viewModel: viewModel)
            }
        } detail: {
            DetailView(entry: viewModel.selected, width: $width)
                .id(viewModel.selected?.id)
                .focusable()
                .onKeyPress { press in
                    if press.key == .rightArrow {
                        viewModel.moveNext()
                        return .handled
                    } else if press.key == .leftArrow {
                        viewModel.movePrevious()
                        return .handled
                    }
                    return .ignored
                }
        }
        .windowToolbarFullScreenVisibility(windowToolbarFullScreenVisibility)
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.width < -50 {
                    viewModel.moveNext()
                } else if value.translation.width > 50 {
                    viewModel.movePrevious()
                }
            }
        )
        .onTapGesture(count: 2) {
            #if os(macOS)
            if let window = NSApp.keyWindow {
                window.toggleFullScreen(nil)
                resetWidth()
            }
            #endif
        }
        .focusedSceneValue(\.openFileAction, OpenFileAction(showImporter: { showImporter = true }))
        .focusedSceneValue(\.zoomAction, ZoomAction(
            zoomIn: { width += 100 },
            zoomOut: { width = max(width - 100, 100) },
            zoomReset: { width = initialWidth }
        ))
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.zip], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    guard url.startAccessingSecurityScopedResource() else { return }
                    defer { url.stopAccessingSecurityScopedResource() }
                    viewModel.load(url: url)
                    resetWidth()
                }
            case .failure(let error):
                print(error)
            }
        }
        .dropDestination(for: URL.self) { items, session in
            if let url = items.first {
                viewModel.load(url: url)
                resetWidth()
            }
        }
        .onChange(of: appDelegate.urls) { _, _ in
            if let url = appDelegate.urls.first {
                viewModel.load(url: url)
                resetWidth()
            }
        }
    }
    
    private func resetWidth() {
        #if os(macOS)
        width = NSApplication.shared.mainWindow?.frame.width ?? 100
        #else
        width = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.width ?? 100
        #endif
        initialWidth = width
    }
}

#Preview {
    let repository = FakeFileRepository()
    let viewModel = ZipViewModel(repository)
    ContentView(viewModel: viewModel)
}

private class FakeFileRepository: FileRepository {
    func getEntries(of url: URL) throws -> [any FileEntry] { [] }
}
