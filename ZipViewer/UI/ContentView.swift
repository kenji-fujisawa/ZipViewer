//
//  ContentView.swift
//  ZipViewer
//
//  Created by uhimania on 2025/11/13.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @Bindable var viewModel: ZipViewModel
    @State private var showImporter: Bool = false
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
            if columnVisibility != .detailOnly {
                SidebarView(viewModel: viewModel)
            }
        } detail: {
            DetailView(entry: viewModel.selected, width: $viewModel.imageWidth)
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
                viewModel.initWidth()
            }
            #endif
        }
        .focusedSceneValue(\.openFileAction, OpenFileAction(showImporter: { showImporter = true }))
        .focusedSceneValue(\.zoomAction, ZoomAction(
            zoomIn: { viewModel.zoomIn() },
            zoomOut: { viewModel.zoomOut() },
            zoomReset: { viewModel.zoomReset() }
        ))
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.zip], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    guard url.startAccessingSecurityScopedResource() else { return }
                    defer { url.stopAccessingSecurityScopedResource() }
                    viewModel.load(url: url)
                    viewModel.initWidth()
                }
            case .failure(let error):
                print(error)
            }
        }
        .dropDestination(for: URL.self) { items, session in
            if let url = items.first {
                viewModel.load(url: url)
                viewModel.initWidth()
            }
        }
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
