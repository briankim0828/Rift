//
//  ThumbnailViewModel.swift
//  Rift
//
//  Created by Brian Kim on 3/11/24.
//

import SwiftUI
import Combine
import AVFoundation

class ThumbnailViewModel: ObservableObject {
    @Published var thumbnail: Image?
    
    func loadThumbnail(from url: URL) {
//        guard let videoURL = URL(string: videoURLString) else { return }
        AVAsset(url: url).generateThumbnail { [weak self] uiImage in // uiImage is of type UIImage?
                    DispatchQueue.main.async {
                        guard let self = self, let uiImage = uiImage else { return }
                        self.thumbnail = Image(uiImage: uiImage)
                        // Correctly convertig UIImage to SwiftUI.Image
                    }
                }    }
}
