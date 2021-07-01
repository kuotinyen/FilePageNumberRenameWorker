//
//  FileFinderWorker.swift
//  FileRenameHelper
//
//  Created by TK on 2021/7/1.
//

import Foundation

class FileFinderWorker {
    let folerPath: String
    private let fileManager: FileManager
    
    init(folderPath: String, fileManager: FileManager = .default) {
        self.folerPath = folderPath
        self.fileManager = fileManager
    }
    
    func getFiles() -> [URL] {
        let url = URL(fileURLWithPath: folerPath)
        var files = [URL]()
        
        if let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                    if fileAttributes.isRegularFile! {
                        files.append(fileURL)
                    }
                } catch { print(error, fileURL) }
            }
        }
        
        return files
    }
}
