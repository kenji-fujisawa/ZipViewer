//
//  FileEntry.swift
//  ZipViewer
//
//  Created by uhimania on 2026/08/26.
//

import Foundation

protocol FileEntry {
    var filename: String { get }
    var image: OSImage? { get }
}
