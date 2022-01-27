//
//  URLSession+CompatibilityAsyncAwaitExtension.swift
//  BetshopAPI
//
//  Created by Hugo Alonso on 27/01/2022.
//

import Foundation

//Picked up from https://www.swiftbysundell.com/articles/making-async-system-apis-backward-compatible/
//As my Mac is currently @ version 11.6.2
@available(iOS, deprecated: 15.0, message: "Use the built-in API instead")
@available(macOS, deprecated: 12.0, message: "Use the built-in API instead")

extension URLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }

            task.resume()
        }
    }
}
