//
//  Track.swift
//  FastTrack
//
//  Created by Weerawut Chaiyasomboon on 26/11/2567 BE.
//

import Foundation

struct Track: Identifiable, Decodable{
    let trackId: Int
    let artistName: String
    let trackName: String
    let previewUrl: URL
    let artworkUrl100: String
    
    var id: Int { trackId }
    var artworkURL: URL?{
        let replacedString = artworkUrl100.replacingOccurrences(of: "100x100", with: "300x300")
        return URL(string: replacedString)
    }
}

struct SearchResult: Decodable{
    let results: [Track]
}
