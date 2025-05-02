//
//  ArtistListView.swift
//  DaeBak
//
//  Created by 손명진 on 1/22/25.
//

import SwiftUI
import MessageUI

struct ArtistListView: View {
    @State private var isRequestSheetPresented: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                // 제목 뷰 (TitleView는 기존에 정의된 뷰로 가정)
                TitleView(title: "K-POP の 魅力")
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 20),
                        GridItem(.flexible(), spacing: 20)
                    ], spacing: 50) {
                        ForEach(Artist.allCases) { artist in
                            NavigationLink(destination: ScriptListView(artist: artist)) {
                                MarkView(artist: artist) // 기존에 정의된 아티스트 표시 뷰
                            }
                        }
                    }
                    .padding()
                }
                
                // 신청하기 버튼
                RequestButton(action: {
                    isRequestSheetPresented = true
                })
                .padding(.bottom, 20)
            }
            .globalBackground()
            .sheet(isPresented: $isRequestSheetPresented) {
                RequestFormView()
            }
        }
    }
}

// 하단에 신청하기 버튼 컴포넌트
struct RequestButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "video.badge.plus")
                    .font(.title2)
                Text("この動画もお願い！")
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 30)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 156/255, green: 102/255, blue: 68/255),
                        Color(red: 205/255, green: 190/255, blue: 176/255)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// 버튼 누를 때 애니메이션 효과를 위한 버튼 스타일
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}

#Preview {
    ArtistListView()
}
