//
//  Video.swift
//  Rift
//
//  Created by Brian Kim on 3/10/24.
//

import Foundation
import UIKit

struct Video: Identifiable, Hashable, Codable {
    
    let fileName: String
    
    /// The unique identifier of the item.
    let id: Int
    /// The URL of the video, which can be local or remote.
    let url: URL
    /// A Boolean value that indicates whether the video contains 3D content.
    let is3D: Bool
    /// The title of the video.
    let title: String
    /// The base image name.
    let imageName: String
    /// The description of the video.
    let description: String
    /// The name of the video's portrait image.
    var portraitImageName: String { "\(imageName)_portrait" }
    /// The name of the video's landscape image.
    var landscapeImageName: String { "\(imageName)_landscape" }
    /// The data for the landscape image to create a metadata item to display in the Info panel.
    var imageData: Data {
        UIImage(named: landscapeImageName)?.pngData() ?? Data()
    }
    /// Detailed information about the video like its stars and content rating.
    let info: Info
    /// A url that resolves to specific local or remote media.
    var resolvedURL: URL {
        if url.scheme == nil {
            return URL(fileURLWithPath: "\(Bundle.main.bundlePath)/\(url.path)")
        }
        return url
    }
    
    /// A Boolean value that indicates whether the video is hosted in a remote location.
    var hasRemoteMedia: Bool {
        url.scheme != nil
    }
    
    /// A Boolean value that indicates whether the video is playable on the current platform.
    var isPlayable: Bool {
        // Only evaluate 3D content; 2D content is always playable.
        guard is3D else { return true }
        #if os(visionOS)
            return true
        #else
            return false
        #endif
    }
    
    /// A destination in which to watch the video.
    /// The app presents this destination in an immersive space.
//    var destination: Destination
    
    /// An object that provides detailed information for a video.
    struct Info: Hashable, Codable {
        var releaseYear: String
        var contentRating: String
        var duration: String
        var genres: [String]
        var stars: [String]
        var directors: [String]
        var writers: [String]
        
        var releaseDate: Date {
            var components = DateComponents()
            components.year = Int(releaseYear)
            let calendar = Calendar(identifier: .gregorian)
            return calendar.date(from: components)!
        }
    }
}

// MARK: - #Preview Extensions
//extension Video {
//    static var preview: Video {
//        VideoLibrary().videos[0]
//    }
//}
//
//extension Array {
//    static var all: [Video] {
//        VideoLibrary().videos
//    }
//}

