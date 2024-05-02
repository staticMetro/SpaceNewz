//
//  NewsArticle.swift
//  SpaceNewz
//
//  Created by Aimeric on 5/2/24.
//

import Foundation
import SwiftUI
import CachedAsyncImage

struct NewsArticle: View {
    let title: String
    let url: String
    let site: String
    let summary: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(site)
                .foregroundStyle(.blue)
                .italic()
            HStack(alignment: .center) {
                CachedAsyncImage(url: URL(string: url)! ,transaction: Transaction(animation: .easeInOut)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .transition(.opacity)
                    } else if phase.error != nil {
                        Image(systemName: "questionmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    } else {
                        HStack {
                            
                        }
                        
//                        ProgressView()
//                            .frame(width: 200, height: 200)
                    }
                }
            }
            
            Text(title)
                .font(.title)
                .bold()
                .padding(8)
            Text(summary)
                .lineLimit(6)
                .font(.subheadline)
                .padding(8)
        }
    }
}

struct NewsArticle_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticle(title: "title", url: "url", site: "site", summary: "summary")
    }
}
