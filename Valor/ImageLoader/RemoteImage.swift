//
//  RemoteImage.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 14.06.2025.
//

import SwiftUI
import Kingfisher

/*
 Абстракция для удобной замены библиотеки загрузки и кеширования изображений
 */

struct ImageCacheManager {
    init(){
        configure()
    }
    private func configure() {
        let cache = ImageCache.default
        cache.diskStorage.config.sizeLimit = 90 * 1024 * 1024
        cache.diskStorage.config.expiration = .days(1)
        cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
    }
    
    func clear() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
    }
}

struct RemoteImage: View {
    let url: String
    var contentMode: SwiftUI.ContentMode = .fill
    
    var body: some View {
        if let url = URL(string: url) {
            KFImage(url)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        }
    }
}

#Preview {
    RemoteImage(url: "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp", contentMode: .fill)
}

