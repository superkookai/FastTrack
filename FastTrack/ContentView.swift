//
//  ContentView.swift
//  FastTrack
//
//  Created by Weerawut Chaiyasomboon on 26/11/2567 BE.
//

import SwiftUI
import AVKit

struct ContentView: View {
    enum SearchState {
        case none, searching, success, error
    }
    
    let gridItems: [GridItem] = [
        GridItem(.adaptive(minimum: 150, maximum: 200))
    ]
    
    @AppStorage("searchText") var searchText: String = ""
    @State private var tracks = [Track]()
    @State private var audioPlayer: AVPlayer?
    @State private var searchState = SearchState.none
    @State private var searchCollection: [String] = []
    @State private var selectedSearchIndex: Int?
    
    var body: some View {
        NavigationSplitView {
            List(0..<searchCollection.count, id: \.self,selection: $selectedSearchIndex){ index in
                Text(searchCollection[index])
            }
            .frame(minWidth: 200)
        } detail: {
            VStack {
                //            HStack {
                //                TextField("Search for a song", text: $searchText)
                //                    .onSubmit(startSearch)
                //                Button("Search", action: startSearch)
                //            }
                //            .padding([.top,.horizontal])
                
                switch searchState {
                case .none:
                    Text("Enter a search term to begin")
                        .frame(maxHeight: .infinity)
                case .searching:
                    ProgressView()
                        .frame(maxHeight: .infinity)
                case .success:
                    ScrollView {
                        LazyVGrid(columns: gridItems) {
                            //                    ForEach(tracks, content: TrackView.init)
                            ForEach(tracks) { track in
                                TrackView(track: track, onSelected: play)
                            }
                        }
                        .padding()
                    }
                case .error:
                    Text("Sorry, your search failed – please check your internet connection then try again.")
                        .frame(maxHeight: .infinity)
                }
                
                
            }
            .frame(minWidth: 400)
        }
        .searchable(text: $searchText,placement: .sidebar, prompt: "Search for a song")
        .onSubmit(of: .search, checkInSearchCollection)
        .onChange(of: selectedSearchIndex, checkInSearchCollection)
    }
    
    func checkInSearchCollection(){
        if !searchCollection.contains(searchText){
            searchCollection.append(searchText)
            startSearch()
        }else{
            if let selectedSearchIndex = selectedSearchIndex{
                searchText = searchCollection[selectedSearchIndex]
                startSearch()
            }
        }
    }
    
    func startSearch() {
        searchState = .searching
        Task {
            do{
                try await performSearch()
                searchState = .success
            }catch{
                searchState = .error
            }
        }
    }
    
    func performSearch() async throws {
        guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchText)&limit=100&entity=song") else { return }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
        
        tracks = searchResult.results
        
    }
    
    func play(_ track: Track){
        audioPlayer?.pause()
        audioPlayer = AVPlayer(url: track.previewUrl)
        audioPlayer?.play()
    }
}

#Preview {
    ContentView()
}
