import SwiftUI
import YouTubePlayerKit

struct TimestampView: View {
    @StateObject private var youTubePlayer: YouTubePlayer = "https://youtube.com/watch?v=psL_5RIBqnY"
    
    // 타임스탬프와 초를 나타내는 데이터
    let timestamps: [(time: String, seconds: Double)] = [
        ("[0:05]", 5),
        ("[0:15]", 15),
        ("[0:30]", 30),
        ("[1:00]", 60),
        ("[1:30]", 90)
    ]

    var body: some View {
        VStack {
            // 유튜브 플레이어
            YouTubePlayerView(self.youTubePlayer) { state in
                switch state {
                case .idle:
                    ProgressView()
                case .ready:
                    EmptyView()
                case .error:
                    Text("YouTube 영상을 불러올 수 없습니다.")
                        .foregroundColor(.red)
                }
            }
            .frame(height: 200)
            
            // 타임스탬프 리스트
            List(timestamps, id: \.seconds) { timestamp in
                Button(action: {
                    let timeMeasurement = Measurement(value: timestamp.seconds, unit: UnitDuration.seconds)
                    youTubePlayer.seek(to: timeMeasurement, allowSeekAhead: true) { result in
                        switch result {
                        case .success:
                            print("Moved to \(timestamp.time)")
                        case .failure(let error):
                            print("Error seeking: \(error)")
                        }
                    }
                }) {
                    Text("Jump to \(timestamp.time)")
                        .font(.headline)
                }
            }
        }
        .padding()
    }
}

#Preview {
    TimestampView()
}
