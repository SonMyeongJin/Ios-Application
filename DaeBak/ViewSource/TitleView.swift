//
//  TitleView.swift
//  DaeBak
//
//  Created by 손명진 on 1/25/25.
//

import SwiftUI

struct TitleView: View {
    let title: String
    
    var body: some View {
        Image("Mark")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .padding(.bottom, -20)
        
        Text(title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .shadow(color: .black.opacity(0.5), radius: 6, x: 4, y: 4)
            .multilineTextAlignment(.center)
            .titleColor()
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 68 / 255, green: 28 / 255, blue: 4 / 255))
                    .padding(.horizontal, 20)
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
            )
    }
}

#Preview {
    TitleView(title: "제목 테스트")
}
