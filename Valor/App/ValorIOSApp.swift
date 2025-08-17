//
//  ValorIOSApp.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI

@main
struct ValorIOSApp: App {
    @Environment(\.scenePhase) private var scenePhase
    init() {
        configureNavigationBarAppearance()
    }
    @StateObject private var router = Router(startAt: .pricesAndDiscounts(.error))
    var body: some Scene {
        WindowGroup {
            RoutingView()
                .environmentObject(router)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification), perform: { _ in
                    UIPasteboard.general.string?.removeAll()
                })
               
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                removeCopiedID()
                Dependency.shared.imageCacheManager.clear()
            }
        }
    
    }
    
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = Color.vlColor.uiWhite
        appearance.backgroundColor = Color.vlColor.uiWhite
        appearance.titleTextAttributes = [
            .foregroundColor: Color.vlColor.uiBlack,
            .font: Font.aBeeZeeRegular
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private func removeCopiedID() {
        //убивает м/у приложениями
        //не успел доделать - думаю что через делегат придется делать
        //UIPasteboard.general.string = nil
    }
}
