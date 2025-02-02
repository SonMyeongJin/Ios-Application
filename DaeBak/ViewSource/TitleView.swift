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
        Text(title)
            .font(.largeTitle)
            .fontWeight(Font.Weight.bold)
            .shadow(color: .black.opacity(0.5), radius: 3, x: 2, y: 2)
            .multilineTextAlignment(.center)
            .titleColor()
    }
}

#Preview {
    TitleView(title: "제목 테스트")
}
