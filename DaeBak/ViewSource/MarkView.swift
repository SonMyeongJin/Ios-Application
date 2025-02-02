//
//  MarkView.swift
//  DaeBak
//
//  Created by 손명진 on 1/23/25.
//

import SwiftUI

struct MarkView: View {
    let artist: Artist
    
    var body: some View {
        VStack {
            Image(artist.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.gray, lineWidth: 6)
                )
                .shadow(radius: 5)
            Text(artist.rawValue)
                .font(.headline)
                .contentColor()
        }
    }
}

#Preview {
    
    MarkView(artist: .ASTRO)
    MarkView(artist: .SEVENTEEN)
    MarkView(artist: .BTS)
}

