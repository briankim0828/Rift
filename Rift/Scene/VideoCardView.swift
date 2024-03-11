//
//  VideoCardView.swift
//  Rift
//
//  Created by Brian Kim on 3/10/24.
//

import SwiftUI
import AVFoundation
import UIKit

/// Constants that represent the supported styles for video cards.
//enum VideoCardStyle {
//    
//    /// A full video card style.
//    ///
//    /// This style presents a poster image on top and information about the video
//    /// below, including video description and genres.
//    case full
//
//    /// A style for cards in the Up Next list.
//    ///
//    /// This style presents a medium-sized poster image on top and a title string below.
//    case upNext
//    
//    /// A compact video card style.
//    ///
//    /// This style presents a compact-sized poster image on top and a title string below.
//    case compact
//    
//    var cornerRadius: Double {
//        switch self {
//        case .full:
//            #if os(tvOS)
//            12.0
//            #else
//            20.0
//            #endif
//            
//        case .upNext: 12.0
//        case .compact: 10.0
//        }
//    }
//
//}

/// A view that represents a video in the library.
///
/// A user can select a video card to view the video details.
import SwiftUI

struct VideoCardView: View {
    @ObservedObject var viewModel = ThumbnailViewModel()
    let video: Video
    
    init(video: Video) {
        self.video = video
        // Optionally load the thumbnail here if the URL is known and static
        guard let url = Bundle.main.url(forResource: video.fileName, withExtension: nil) else {
            fatalError("Couldn't find \(video.fileName) in main bundle.")
        }
        self.viewModel.loadThumbnail(from: url) // Replace with actual video URL property if available
    }
    
    var body: some View {
        VStack {

            if let thumbnail = viewModel.thumbnail {
                thumbnail
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 395, height: 220)
                    .cornerRadius(20.0)
            } else {
                // Placeholder view if the thumbnail isn't loaded yet
                Color.gray
                    .frame(width: 395, height: 220)
                    .cornerRadius(20.0)
            }

            VStack(alignment: .leading) {

                HStack {
                    Text(video.title)
                        .font(.title)
                    Text("\(video.info.releaseYear) | \(video.info.duration)")
                        .font(.subheadline.weight(.medium))
                }
                .foregroundStyle(.secondary)
                .padding(.top, 10)
            }
            .padding(20)
        }
        .background(.thinMaterial)
        .frame(width: 395)
        .shadow(radius: 5)
        .hoverEffect()
        .cornerRadius(20)
        .background(Color.black.opacity(0.48).cornerRadius(30))
        .ignoresSafeArea()
    }
}
