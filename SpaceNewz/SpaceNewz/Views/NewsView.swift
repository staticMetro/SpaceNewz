//
//  NewsView.swift
//  SpaceNewz
//
//  Created by Aimeric on 5/2/24.
//

import Foundation
import SwiftUI

struct NewsView: View {
    @EnvironmentObject var spaceData: APIClient
    @Environment(\.openURL) var openURL
    private var textWidth: CGFloat = 300
    
    var body: some View {
        List {
            ForEach(spaceData.articles) { article in
                NewsArticle(title: article.title, url: article.url, site: article.newsSite, summary: article.summary)
                    .onTapGesture {
                        openURL(URL(string: article.url)!)
                    }
            }
        }
        .refreshable {
            spaceData.getData()
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
            .environmentObject(APIClient())
    }
}
