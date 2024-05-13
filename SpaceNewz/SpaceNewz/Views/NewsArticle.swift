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
    let articleUrl: String
    let imageUrl: String?
    let site: String
    let summary: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(site)
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.bottom, 2)
            
            if let validImageUrl = imageUrl, let imageURL = URL(string: validImageUrl) {
                CachedAsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    case .success(let image):
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(maxWidth: 300, maxHeight: 200)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(.bottom, 8)
            } else {
                // Placeholder image if imageUrl is nil or invalid
                Image(systemName: "photo.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
            }
            
            Text(title)
                .font(.title2)
                .bold()
                .padding(.bottom, 2)
            
            Text(summary)
                .font(.body)
                .padding(.bottom, 2)
            
            Link("Read more...", destination: URL(string: articleUrl)!)
                .font(.footnote)
                .foregroundColor(.purple)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct NewsArticle_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticle(
            title: "The U.N. needs to form a parliament to regulate space mining",
            articleUrl: "https://spacenews.com/the-un-needs-form-parliament-regulate-space-mining/",
            imageUrl: "https://i0.wp.com/spacenews.com/wp-content/uploads/2024/05/20240424_LF_4030.jpg",
            site: "SpaceNews",
            summary: "The U.N. must form a parliament to properly regulate space mining and other international matters of dispute."
        )
    }
}
