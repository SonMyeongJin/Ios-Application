//
//  StartLoadingView.swift
//  DaeBak
//
//  Created by 손명진 on 2/1/25.
//

import SwiftUI

struct StartLoadingView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            ArtistListView()
        } else {
            ZStack {
                Color(red: 68 / 255, green: 28 / 255, blue: 4 / 255)
                    .edgesIgnoringSafeArea(.all)
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200) 
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // 2초 후 전환
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    StartLoadingView()
}
