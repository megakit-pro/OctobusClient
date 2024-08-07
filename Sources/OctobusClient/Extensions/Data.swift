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
        isGzipped ? try? gunzipped() : self
    }

    func gzipCompress() -> Data? {
        try? self.gzipped(level: .bestCompression)
    }
}
