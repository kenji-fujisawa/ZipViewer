//
//  ImageExtension.swift
//  ZipViewer
//
//  Created by uhimania on 2025/11/14.
//

import SwiftUI

#if os(macOS)
typealias OSImage = NSImage
#else
typealias OSImage = UIImage
#endif

extension Image {
    init(image: OSImage) {
        #if os(macOS)
        self.init(nsImage: image)
        #else
        self.init(uiImage: image)
        #endif
    }
}
