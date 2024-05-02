//
//  ContentView.swift
//  SpaceNewz
//
//  Created by Aimeric on 5/2/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var spaceData = APIClient()
    @State private var opac = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                NewsView()
                    .opacity(opac)
            }
            .navigationTitle("SpaceNewz")
            .environmentObject(spaceData)
            .onAppear {
                spaceData.getData()
                
                withAnimation(.easeInOut(duration: 2.0)) {
                    opac = 1.0
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
