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
            VStack {
                // 제목 뷰 (TitleView는 기존에 정의된 뷰로 가정)
                TitleView(title: "K-POP の 魅力")
                 
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 50) {
                        ForEach(Artist.allCases) { artist in
                            NavigationLink(destination: ScriptListView(artist: artist)) {
                                MarkView(artist: artist) // 기존에 정의된 아티스트 표시 뷰
                            }
                        }
                    }
                    .padding()
                }
            }
            .globalBackground() // 전역 배경 modifier (기존 정의)
        }
    }
}

#Preview {
    ArtistListView()
}
