//
//  ZipDataSource.swift
//  ZipViewer
//
//  Created by uhimania on 2026/08/26.
//

import Foundation
import ZIPFoundation

protocol ZipDataSource {
    func getEntries(of path: URL) throws -> [any FileEntry]
}

class DefaultZipDataSource: ZipDataSource {
    func getEntries(of path: URL) throws -> [any FileEntry] {
        var entries: [FileEntry] = []
        
        let archive = try Archive(url: path, accessMode: .read)
        for entry in archive {
            if entry.path.last != "/" {
                entries.append(ZipEntry(archive: archive, entry: entry))
            }
        }
        
        entries.sort { $0.filename < $1.filename }
        
        return entries
    }
}
