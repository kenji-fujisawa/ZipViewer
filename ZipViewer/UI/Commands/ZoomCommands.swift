//
//  ZoomCommands.swift
//  ZipViewer
//
//  Created by uhimania on 2026/08/21.
//

import SwiftUI

struct ZoomAction {
    var zoomIn: () -> Void
    var zoomOut: () -> Void
    var zoomReset: () -> Void
}

struct ZoomKey: FocusedValueKey {
    typealias Value = ZoomAction
}

extension FocusedValues {
    var zoomAction: ZoomAction? {
        get { self[ZoomKey.self] }
        set { self[ZoomKey.self] = newValue }
    }
}

struct ZoomCommands: Commands {
    @FocusedValue(\.zoomAction) private var action
    
    var body: some Commands {
        CommandGroup(before: .sidebar) {
            Button("Zoom in", systemImage: "plus.magnifyingglass") {
                action?.zoomIn()
            }
            .keyboardShortcut("+", modifiers: [.command])

            Button("Zoom out", systemImage: "minus.magnifyingglass") {
                action?.zoomOut()
            }
            .keyboardShortcut("-", modifiers: [.command])

            Button("Zoom reset", systemImage: "1.magnifyingglass") {
                action?.zoomReset()
            }
            .keyboardShortcut("0", modifiers: [.command])

            Divider()
        }
    }
}
