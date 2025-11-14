//
//  ZipItem.swift
//  ZipViewer
//
//  Created by uhimania on 2025/11/14.
//

import SwiftUI
import ZIPFoundation

#if os(macOS)
typealias OSImage = NSImage
#else
typealias OSImage = UIImage
#endif

struct ZipItem: Identifiable, Hashable {
    let id = UUID()
    var archive: Archive
    var entry: Entry
    
    var filename: String {
        String(entry.path.split(separator: "/").last ?? "")
    }
    
    var image: OSImage? {
        var data = Data()
        
        do {
            let _ = try archive.extract(entry) { chunk in
                data.append(chunk)
            }
        } catch {
            return nil
        }
        
        return OSImage(data: data)
    }
    
    static func == (lhs: ZipItem, rhs: ZipItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
