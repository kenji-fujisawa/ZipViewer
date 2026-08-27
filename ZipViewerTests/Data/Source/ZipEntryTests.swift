//
//  ZipEntryTests.swift
//  ZipViewerTests
//
//  Created by uhimania on 2026/08/26.
//

import Foundation
import SwiftUI
import Testing
import ZIPFoundation

@testable import ZipViewer

@Suite(.serialized)
class ZipEntryTests {

    private let workingDir: URL
    private let zipUrl: URL
    private let image: NSImage?
    private let workingDirname = "ZipEntryTests"
    private let txtFilename = "aaa.txt"
    private let imgFilename = "bbb.png"
    private let zipFilename = "ZipEntryTests.zip"
    
    init() throws {
        let tmp = FileManager.default.temporaryDirectory
        
        let work = tmp.appendingPathComponent(workingDirname, isDirectory: true)
        try FileManager.default.createDirectory(at: work, withIntermediateDirectories: true)
        
        let txt = work.appendingPathComponent(txtFilename)
        let text = "test text"
        try text.write(to: txt, atomically: true, encoding: .utf8)
        
        let img = work.appendingPathComponent(imgFilename)
        let image = NSImage(systemSymbolName: "circle.fill", accessibilityDescription: nil)
        try image?.cgImage?.data?.write(to: img)
        
        let zip = tmp.appendingPathComponent(zipFilename)
        try FileManager.default.zipItem(at: work, to: zip)
        
        self.workingDir = work
        self.zipUrl = zip
        self.image = image
    }
    
    deinit {
        try? FileManager.default.removeItem(at: workingDir)
        try? FileManager.default.removeItem(at: zipUrl)
    }
    
    @Test func testFilename() async throws {
        let archive = try Archive(url: zipUrl, accessMode: .read)
        guard let entry = archive["\(workingDirname)/\(txtFilename)"] else {
            Issue.record()
            return
        }
        
        var zip = ZipEntry(archive: archive, entry: entry)
        #expect(zip.filename == txtFilename)
        
        guard let entry = archive["\(workingDirname)/\(imgFilename)"] else {
            Issue.record()
            return
        }
        
        zip = ZipEntry(archive: archive, entry: entry)
        #expect(zip.filename == imgFilename)
    }
    
    @Test func testImage() async throws {
        let archive = try Archive(url: zipUrl, accessMode: .read)
        guard let entry = archive["\(workingDirname)/\(txtFilename)"] else {
            Issue.record()
            return
        }
        
        var zip = ZipEntry(archive: archive, entry: entry)
        #expect(zip.image == nil)
        
        guard let entry = archive["\(workingDirname)/\(imgFilename)"] else {
            Issue.record()
            return
        }
        
        zip = ZipEntry(archive: archive, entry: entry)
        #expect(zip.image?.cgImage?.data == image?.cgImage?.data)
    }
}

private extension NSImage {
    var cgImage: CGImage? {
        guard let imageData = self.tiffRepresentation else { return nil }
        guard let sourceData = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(sourceData, 0, nil)
    }
}

private extension CGImage {
    var data: Data? {
        let rep = NSBitmapImageRep(cgImage: self)
        return rep.representation(using: .png, properties: [:])
    }
}
