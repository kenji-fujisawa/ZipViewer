//
//  ZipEntry.swift
//  ZipViewer
//
//  Created by uhimania on 2026/08/26.
//

import SwiftUI
import ZIPFoundation

class ZipEntry: FileEntry {
    private let archive: Archive
    private let entry: Entry
    
    init(archive: Archive, entry: Entry) {
        self.archive = archive
        self.entry = entry
    }
    
    private var _filename: String? = nil
    var filename: String {
        if _filename == nil {
            _filename = String(entry.path.split(separator: "/").last ?? "")
        }
        
        return _filename ?? ""
    }
    
    private var _image: OSImage? = nil
    var image: OSImage? {
        if _image == nil {
            var data = Data()
            let _ = try? archive.extract(entry) { chunk in
                data.append(chunk)
            }
            _image = OSImage(data: data)
        }
        
        return _image
    }
}
