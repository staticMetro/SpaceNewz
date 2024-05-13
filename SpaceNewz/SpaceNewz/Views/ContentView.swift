//
//  ContentView.swift
//  SpaceNewz
//
//  Created by Aimeric on 5/2/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var spaceData = APIClient()
    
    var body: some View {
        NavigationView {
            VStack {
//                if spaceData.articles.isEmpty {
//                    Text("Loading...")
//                } else {
                    NewsView(spaceData: spaceData)
//                }
            }
            .navigationTitle("SpaceNewz")
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
    
#Preview {
    ContentView()
}
