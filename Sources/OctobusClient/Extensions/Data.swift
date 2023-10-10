//
//  Data.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 31.08.2023.
//

import Foundation
import Gzip

extension Data {
    func gzipDecompress() -> Data? {
        let decompressedData: Data?
        
        if self.isGzipped {
            decompressedData = try? self.gunzipped()
        } else {
            decompressedData = self
        }
        
        return decompressedData
    }
    
    func gzipCompress() -> Data? {
        try? self.gzipped(level: .bestCompression)
    }
}
