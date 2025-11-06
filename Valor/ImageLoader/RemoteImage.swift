//
//  RemoteImage.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 14.06.2025.
//

//import SwiftUI
//import Kingfisher
//
///// Abstraction layer for loading and caching remote images.
///// Allows easy replacement of the underlying image loading library.
//struct RemoteImage: View {
//    let url: String
//    var contentMode: SwiftUI.ContentMode = .fill
//    var body: some View {
//        Group {
//            if let url = URL(string: url) {
//                KFImage(url)
//                    .resizable()
//            } else {
//                Image(systemName: CustomImage.photo.rawValue)
//                    .resizable()
//            }
//        }
//        .aspectRatio(contentMode: contentMode)
//    }
//}
//
//#Preview {
//    RemoteImage(
//        url: MocData.testProduct.thumbnail,
//        contentMode: .fill
//    )
//}
