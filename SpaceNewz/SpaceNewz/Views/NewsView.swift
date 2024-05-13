//
//  NewsView.swift
//  SpaceNewz
//
//  Created by Aimeric on 5/2/24.
//

import Foundation
import SwiftUI

struct NewsView: View {
    @ObservedObject var spaceData: APIClient
    @Environment(\.openURL) var openURL
    
    var body: some View {
        List(spaceData.articles) { article in
            NewsArticle(title: article.title, articleUrl: article.url, imageUrl: article.imageUrl ?? "Error",site: article.newsSite ?? "Error", summary: article.summary ?? "Error")
                .onTapGesture {
                    openURL(URL(string: article.url)!)
                }
        }
        .onAppear {
            if spaceData.articles.isEmpty {
                spaceData.getData()
            }
        }
        .onReachBottom(perform: {
            spaceData.getData()
        })
    }
}

// Extension to detect when the list reaches the bottom
extension View {
    func onReachBottom(perform action: @escaping () -> Void) -> some View {
        self.onAppear {
            NotificationCenter.default.addObserver(forName: .reachBottom, object: nil, queue: .main) { _ in
                action()
            }
        }
    }
}

// Notification when the list reaches the bottom
extension Notification.Name {
    static let reachBottom = Notification.Name("reachBottomNotification")
}

// Modifier for ScrollView/List to notify when reaching the bottom
struct ReachBottomModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(name: .reachBottom, object: nil)
                }
            }
    }
}

// Apply the modifier to the last element in the list
extension View {
    func reachBottom() -> some View {
        modifier(ReachBottomModifier())
    }
}
