//
//  APIClient.swift
//  SpaceNewz
//
//  Created by Aimeric on 5/2/24.
//
// API Endpoint : https://api.spaceflightnewsapi.net/v4/articles/

import Foundation

// Define a model for the API data
struct SpaceData: Codable, Identifiable {
    var id: Int
    var title: String
    var url: String
    var imageUrl: String?
    var newsSite: String?
    var summary: String?
    var publishedAt: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case url
        case imageUrl = "image_url"
        case newsSite = "news_site"
        case summary = "summary"
        case publishedAt = "published_at"
        case updatedAt = "updated_at"
    }
}


// Define a model for the API response
struct ApiResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [SpaceData]
}

// DateFormatter extension for ISO 8601 date format
extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}


@MainActor
class APIClient: ObservableObject {
    @Published var articles: [SpaceData] = []
    private var currentPageURL: URL? = URL(string: "https://api.spaceflightnewsapi.net/v4/articles/?format=json&limit=10")
    private var isLoading = false

    func getData() {
        guard !isLoading, let url = currentPageURL else { return }
        isLoading = true

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("Network request error: \(error)")
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let apiResponse = try decoder.decode(ApiResponse.self, from: data)
                DispatchQueue.main.async {
                    self.articles.append(contentsOf: apiResponse.results)
                    self.currentPageURL = URL(string: apiResponse.next ?? "")
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
}
