//
//  APIClient.swift
//  SpaceNewz
//
//  Created by Aimeric on 5/2/24.
//
// API Endpoint : https://api.spaceflightnewsapi.net/v4/articles/

import Foundation

struct SpaceData: Codable, Identifiable {
    var id: Int
    var title: String
    var url: String
    var imageUrl: String
    var newsSite: String
    var summary: String
    var publishedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case url
        case imageUrl
        case newsSite
        case summary
        case publishedAt
    }
}

@MainActor class APIClient: ObservableObject {
    @Published var articles = [SpaceData]()
    
    func getData() {
        guard let url = URL(string: "https://api.spaceflightnewsapi.net/v4/articles/") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.articles = [SpaceData(id: 0, title: "No data", url: "No data", imageUrl: "No data", newsSite: "No data", summary: "Try Refreshing when you get Internet Connection", publishedAt: "No data")]
                }
                return
            }
            DispatchQueue.global().async {
              do {
                let decodedResponse = try JSONDecoder().decode([SpaceData].self, from: data)
                DispatchQueue.main.async {
                  print("Loaded New Data from API. Articles: \(decodedResponse.count)")
                  self.articles = decodedResponse
                }
              } catch {
                // Handle decoding error here
                print("Error decoding data: \(error)")
              }
            }

        }.resume()
    }
}
