//
//  InternetManager.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//

import Foundation
import Network

enum HTTPMethod: String {
    case head = "HEAD"
}

protocol INetworkMonitor {
    func isInternetAvailable() async -> Bool
}


final class NetworkMonitor: INetworkMonitor {
    
    //функция проверки доступности backend даже при включенном VPN
    func isInternetAvailable() async -> Bool {
        let monitorStatus = await checkInternetConnection()
        if !monitorStatus { return false }
        guard let url = URLProducts.allProducts.url else {
            return false
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.head.rawValue
        request.timeoutInterval = 5
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            try response.validate()
            return true
        } catch {
            return false
        }
    }
    
    //проверка интернет соединения
    //Проверка selectedSegment при переходе на страницу "Все товары" или "Товары без цены"
    //В логике моего приложения "Все товары" -> сетевой запрос (true)
    //"Товары без цены" -> загрузка из локального хранилища (false)
    private func checkInternetConnection() async -> Bool {
        return await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: "InternetCheck")
            monitor.pathUpdateHandler = { path in
                continuation.resume(returning: path.status == .satisfied)
                monitor.cancel()
            }
            monitor.start(queue: queue)
        }
    }
}
