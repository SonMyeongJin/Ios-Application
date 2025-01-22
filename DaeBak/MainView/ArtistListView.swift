//
//  ArtistListView.swift
//  DaeBak
//
//  Created by 손명진 on 1/22/25.
//

import SwiftUI

struct ArtistListView: View {
    var body: some View {
        NavigationView {
            List(Artist.allCases) { artist in
                NavigationLink(destination: Text("\(artist.description)의 영상 목록")) {
                    HStack {
                        // 이미지를 표시하려면 AsyncImage 사용 가능
                        Text(artist.rawValue)
                            .font(.headline)
                        Spacer()
                        Text(artist.description)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("가수 목록")
        }
    }
}

#Preview {
    ArtistListView()
}
