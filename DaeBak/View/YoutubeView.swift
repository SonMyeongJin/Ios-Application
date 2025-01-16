//
//  YoutubeWebView.swift
//  DaeBak
//
//  Created by 손명진 on 1/16/25.
//

import SwiftUI
import WebKit

struct YoutubeView: UIViewRepresentable {
    let videoID: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false // 스크롤 방지
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let embedHTML = """
        <!DOCTYPE html>
        <html>
        <head>
        <style>
        body, html {
            margin: 0;
            padding: 0;
        }
        iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
        </style>
        </head>
        <body>
        <iframe
            src="https://www.youtube.com/embed/\(videoID)?playsinline=1&modestbranding=1&rel=0&showinfo=0&autoplay=1"
            frameborder="0"
            allow="autoplay; encrypted-media"
            allowfullscreen>
        </iframe>
        </body>
        </html>
        """
        uiView.loadHTMLString(embedHTML, baseURL: nil)
    }
}

// Preview
#Preview {
    // 유효한 YouTube URL에서 videoID를 추출합니다.
    let youtubeURL = "https://www.youtube.com/watch?v=juM_qadVY1E"
    guard let videoID = extractVideoID(from: youtubeURL) else {
        fatalError("유효한 YouTube videoID를 추출하지 못했습니다.")
    }
    return YoutubeView(videoID: videoID)
}

// Helper 함수: YouTube URL에서 videoID 추출
private func extractVideoID(from url: String) -> String? {
    guard let components = URLComponents(string: url),
          let queryItems = components.queryItems else {
        return nil
    }
    return queryItems.first(where: { $0.name == "v" })?.value
}
