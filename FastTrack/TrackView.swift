//
//  TrackView.swift
//  FastTrack
//
//  Created by Weerawut Chaiyasomboon on 26/11/2567 BE.
//

import SwiftUI


struct TrackView: View {
    let track: Track
    let onSelected: (Track) -> Void
    
    @State private var isHovering: Bool = false
    
    var body: some View {
        Button {
            onSelected(track)
        } label: {
            ZStack(alignment: .bottom) {
                AsyncImage(url: track.artworkURL){ phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                    case .failure:
                        Image(systemName: "questionmark")
                            .symbolVariant(.circle)
                            .font(.largeTitle)
                    default:
                        ProgressView()
                    }
                }
                .frame(width: 150, height: 150)
                .scaleEffect(isHovering ? 1.2 : 1.0)
                
                VStack{
                    Text(track.trackName)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(track.artistName)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .padding(5)
                .frame(width: 150)
                .background(.regularMaterial)
            }
        }
        .buttonStyle(.borderless)
        .border(.primary, width: isHovering ? 3 : 0)
        .onHover { hovering in
            withAnimation {
                isHovering = hovering
            }
        }
    }
    
}

#Preview {
    TrackView(track: Track(trackId: 1, artistName: "Nirvana", trackName: "Smells Like Teen Spirit", previewUrl: URL(string: "abc")!, artworkUrl100: "https://bit.ly/teen-spirit")){ track in
        
    }

}
