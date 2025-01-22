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
            List(Artist.allCases) { artist in
                NavigationLink(destination: ScriptListView(artist: artist, allScripts: scripts)) {
                    Text(artist.rawValue)
                        .font(.headline)
                }
            }
            .navigationTitle("가수 목록")
        }
    }
}

#Preview {
    ArtistListView()
}
