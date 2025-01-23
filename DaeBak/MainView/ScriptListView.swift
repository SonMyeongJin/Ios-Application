//
//  ScriptpListView.swift
//  DaeBak
//
//  Created by 손명진 on 1/23/25.
//

import SwiftUI

struct ScriptListView: View {
    let artist: Artist
    let allScripts: [Script]
    
    var body: some View {
        let filteredScripts = Script.scripts(for: artist.rawValue, from: allScripts)
        
        List(filteredScripts) { script in
            NavigationLink(destination: DetailPage(script: script)) { // DetailPage로 이동
                Text(script.title)
                    .font(.headline)
            }
        }
        .navigationTitle("\(artist.rawValue)의 스크립트 목록")
    }
}

#Preview {
    let scripts: [Script] = Script.loadFromJSON(fileName: "testScript")
    return ScriptListView(artist: .BTS, allScripts: scripts)
}
