//===----------------------------------------------------------------------===//
//
// This source file is part of the AsyncHTTPClient open source project
//
// Copyright (c) 2018-2021 Apple Inc. and the AsyncHTTPClient project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of AsyncHTTPClient project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import NIOCore

public final class HTTPClientCopyingDelegate: HTTPClientResponseDelegate {
    public typealias Response = Void

    let chunkHandler: (ByteBuffer) -> EventLoopFuture<Void>

    public init(chunkHandler: @escaping (ByteBuffer) -> EventLoopFuture<Void>) {
        self.chunkHandler = chunkHandler
    }

    public func didReceiveBodyPart(task: HTTPClient.Task<Void>, _ buffer: ByteBuffer) -> EventLoopFuture<Void> {
        return self.chunkHandler(buffer)
    }

    public func didFinishRequest(task: HTTPClient.Task<Void>) throws {
        return ()
    }
}

/// A utility function that runs the body code only in debug builds, without
/// emitting compiler warnings.
///
/// This is currently the only way to do this in Swift: see
/// https://forums.swift.org/t/support-debug-only-code/11037 for a discussion.
@inlinable
internal func debugOnly(_ body: () -> Void) {
    assert({ body(); return true }())
}
