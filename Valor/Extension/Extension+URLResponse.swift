//
//  Extension+URLResponse.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//
import Foundation

extension URLResponse {
    func validate() throws {
        guard let httpResponse = self as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
