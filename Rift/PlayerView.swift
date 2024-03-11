//
//  PlayerView.swift
//  Rift
//
//  Created by Brian Kim on 3/10/24.
//

import SwiftUI

/// Constants that define the style of controls a player presents.
enum PlayerControlsStyle {
    /// A value that indicates to use the system interface that AVPlayerViewController provides.
    case system
    /// A value that indicates to use compact controls that display a play/pause button.
    case custom
}

/// A view that presents the video player.
struct PlayerView: View {
    
    let controlsStyle: PlayerControlsStyle
    @State private var showContextualActions = false
    @Environment(PlayerModel.self) private var model
    
    /// Creates a new player view.
    init(controlsStyle: PlayerControlsStyle = .system) {
        print("initializing PlayerView")
        self.controlsStyle = controlsStyle
    }
    
    var body: some View {
        switch controlsStyle {
        case .system:
            VideoPlayerView(showContextualActions: showContextualActions)
                .onAppear{
                    print("VideoPlayerViewAppeared")
                }
            
        case .custom:
            //placeholder
            ContentView()
//            InlinePlayerView()
        }
    }
}

