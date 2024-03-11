//
//  VideoListView.swift
//  Rift
//
//  Created by Brian Kim on 3/10/24.
//

import SwiftUI

struct VideoListView: View {
    
    typealias SelectionAction = (Video) -> ()

    private let title: String?
    private let videos: [Video]
    private let cardSpacing: Double

    private let selectionAction: SelectionAction?
    
    /// Creates a view to display the specified list of videos.
    /// - Parameters:
    ///   - title: An optional title to display above the list.
    ///   - videos: The list of videos to display.
    ///   - cardSpacing: The spacing between cards.
    ///   - selectionAction: An optional action that you can specify to directly handle the card selection.
    ///    When the app doesn't specify a selection action, the view presents the card as a `NavigationLink.
    init(title: String? = nil, videos: [Video], cardSpacing: Double, selectionAction: SelectionAction? = nil) {
        self.title = title
        self.videos = videos
        self.cardSpacing = cardSpacing
        self.selectionAction = selectionAction
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title!)

                .font(.largeTitle)
                .padding(.leading, margins)
                .padding(.bottom, 12)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: cardSpacing) {
                    ForEach(videos) { video in
                        Group {
//                  If the app initializes the view with a selectio action closure,
//                  display a video card button that calls it.
//                            if let selectionAction {
                                Button {
                                    selectionAction!(video)
                                } label: {
                                            
//                                    ZStack {
//                                        Color.red.ignoresSafeArea()
//                                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 100, height: 100), style: .continuous))
//                                            .offset(z: -0.1)
////                                            .animation(.easeInOut)
                                        
                                       
                                    
                                     
                                  
                                    VideoCardView(video: video)
                                }
                            //}
//                             Otherwise, create a navigation link.
//                             else {
//                                NavigationLink(value: video) {
//                                    VideoCardView(video: video)
//                                }
//                            }
                        }
                        .accessibilityLabel("\(video.title)")
                    }
                }
                .buttonStyle(.plain)
                // In tvOS, add vertical padding to accommodate card resizing.
                .padding([.top, .bottom], 0)
                .padding([.leading, .trailing], margins)
            }
        }
    }
    
    var margins: Double = 30 //for visionOS
}
