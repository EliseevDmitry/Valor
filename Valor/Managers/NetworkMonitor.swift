//
//  InternetManager.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//

import Foundation
import Network

/// Protocol defining an interface for monitoring network availability.
/// Provides a method to check if the internet or a specific backend URL is reachable.
protocol INetworkMonitor {
    func isInternetAvailable(url: URL?) async -> Bool
}

/// Class responsible for monitoring network connectivity and checking backend availability.
final class NetworkMonitor {
    enum Consts {
        static let timeoutInterval: TimeInterval = 5
        static let queueLabel = "InternetCheck"
    }
    
    enum HTTPMethod: String {
        case head = "HEAD"
    }
    
    private let monitor: NWPathMonitor
    
    init(monitor: NWPathMonitor = NWPathMonitor()) {
        self.monitor = monitor
    }
}

// MARK: - Public functions

extension NetworkMonitor: INetworkMonitor {
    /// Checks whether the backend or internet is reachable.
    /// Performs a quick NWPathMonitor check first, then sends a HEAD request to the provided URL.
    /// Returns true only if the network is available and the backend responds successfully.
    func isInternetAvailable(url: URL?) async -> Bool {
        let monitorStatus = await checkInternetConnection()
        if !monitorStatus { return false }
        guard let url = url else {
            return false
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.head.rawValue
        request.timeoutInterval = Consts.timeoutInterval
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            try response.validate()
            return true
        } catch {
            return false
        }
    }
}

// MARK: - Private functions

extension NetworkMonitor {
    /// Checks general internet connectivity using NWPathMonitor.
    /// Uses withCheckedContinuation to bridge NWPathMonitor's callback to async/await.
    /// Returns true if the network status is satisfied.
    private func checkInternetConnection() async -> Bool {
        return await withCheckedContinuation { continuation in
            let queue = DispatchQueue(label: Consts.queueLabel)
            self.monitor.pathUpdateHandler = { path in
                continuation.resume(returning: path.status == .satisfied)
                self.monitor.cancel()
            }
            self.monitor.start(queue: queue)
        }
    }
}
