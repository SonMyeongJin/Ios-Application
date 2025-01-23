//
//  ArtistListView.swift
//  DaeBak
//
//  Created by 손명진 on 1/22/25.
//

import SwiftUI

struct ArtistListView: View {
    let scripts: [Script] = Script.loadFromJSON(fileName: "testScript")

    var body: some View {
           NavigationView {
               ScrollView {
                   LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 50) {
                       ForEach(Artist.allCases) { artist in
                           NavigationLink(destination: ScriptListView(artist: artist, allScripts: scripts)) {
                               MarkView(artist: artist)
                           }
                       }
                   }
                   .padding()
               }
               .navigationTitle("가수 목록")
           }
       }
}

#Preview {
    ArtistListView()
}
