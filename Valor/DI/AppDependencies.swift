//
//  Dependency.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 14.06.2025.
//

import Foundation

final class AppDependencies {
    static let shared = AppDependencies()
    
    let imageCacheManager: ImageCacheManager
    let remoteProductManager: IRemoteProductManager
    let networkMonitor: INetworkMonitor
    let localProductManager: ILocalProductManager
    
    private init(){
        self.imageCacheManager = ImageCacheManager()
        self.remoteProductManager = RemoteProductManager()
        self.networkMonitor = NetworkMonitor()
        self.localProductManager = LocalProductManager()
    }
}
