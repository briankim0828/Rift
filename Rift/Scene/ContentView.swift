import SwiftUI
import RealityKit
import UniformTypeIdentifiers
import AVKit
import os

struct ContentView: View {
        
    //initialize video player model
    @Environment(PlayerModel.self) private var player
    @Environment(VideoLibrary.self) private var library
    
    @State private var isPickingFile = false
    
#if os(macOS)
    @Environment(\.openWindow) private var openWindow
#elseif os(iOS)
    @State private var navigationPath = NavigationPath()
    
    private func openWindow(value: ModelIdentifier) {
        navigationPath.append(value)
    }
#elseif os(visionOS)
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @State var immersiveSpaceIsShown = false
    
    private func openWindow(value: ModelIdentifier) {
        Task {
            switch await openImmersiveSpace(value: value) {
            case .opened:
                immersiveSpaceIsShown = true
            case .error, .userCancelled:
                break
            @unknown default:
                break
            }
        }
    }
#endif
    
    // This is the main view Handler - PlayerView takes over as soon as video plays
    var body: some View {
#if os(macOS) || os(visionOS)
        Group {
            switch player.presentation {
            case .fullWindow:
                // Present the player full window and begin playback.
                PlayerView(video: player.currentItem!)
                    .onAppear {
                        print("PlayerViewAppeared")
                        player.play()
                    }
            default:
                // Show the app's content library by default.
                mainView
                    .onAppear { print("mainViewAppeared") }
            }
        }
        .onAppear { print("ContentViewAppeared") }
        
#elseif os(iOS)
        NavigationStack(path: $navigationPath) {
            mainView
                .navigationDestination(for: ModelIdentifier.self) { modelIdentifier in
                    MetalKitSceneView(modelIdentifier: modelIdentifier)
                        .navigationTitle(modelIdentifier.description)
                }
        }
#endif // os(iOS)
    }
    
    var verticalPadding: Double = 30
    
    func loadVideoWrapperFunction (video: Video) {
        player.loadVideo(video, presentation: .fullWindow)
    }
    
    @ViewBuilder
    var mainView: some View {
        NavigationStack() {
            // Wrap the content in a vertically scrolling view.
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: verticalPadding) {

                    Text("Rift V1")
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                        .padding(.leading, 40)
                        .padding(.top, 14)
                        .padding(.bottom, 10)
                    //                        .accessibilityHidden(true)
                    
                    // Displays a horizontally scrolling list of Featured videos.
                    VideoListView(title: "Recommended",
                                  videos: library.videos,
                                  cardSpacing: 30, selectionAction: loadVideoWrapperFunction)
                    
                    //                    // Displays a horizontally scrolling list of videos in the user's Up Next queue.
                    //                    VideoListView(title: "Up Next",
                    //                                  videos: library.upNext,
                    //                                  cardStyle: .upNext,
                    //                                  cardSpacing: horizontalSpacing)
                }
                .padding([.top, .bottom], verticalPadding)
//                .navigationDestination(for: Video.self) { video in
//
//                    PlayerView(video: video)
//                        .onAppear {
//                            print("PlayerViewAppeared")
//                            player.play()
//                        }
//                }
            }
        }
        
        HStack {
            Button("Read PLY") {
                isPickingFile = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.black.opacity(0.6))
            .padding()
            .disabled(isPickingFile)
#if os(visionOS)
            .disabled(immersiveSpaceIsShown)
#endif
            .fileImporter(isPresented: $isPickingFile,
                          allowedContentTypes: [ UTType(filenameExtension: "ply")! ]) {
                isPickingFile = false
                switch $0 {
                case .success(let url):
                    _ = url.startAccessingSecurityScopedResource()
                    Task {
                        // This is a sample app. In a real app, this should be more tightly scoped, not using a silly timer.
                        //                        try await Task.sleep(for: .seconds(2))
                        url.stopAccessingSecurityScopedResource()
                    }
                    openWindow(value: ModelIdentifier.gaussianSplat(url))
                case .failure:
                    break
                }
            }
            
            
            Button("Show Sample Box") {
                openWindow(value: ModelIdentifier.sampleBox)
            }
            .buttonStyle(.borderedProminent)
            .tint(.black.opacity(0.6))
            .padding()
#if os(visionOS)
            .disabled(immersiveSpaceIsShown)
#endif
            
            
#if os(visionOS)
            Button("Dismiss Immersive Space") {
                Task {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                }
            }
            .disabled(!immersiveSpaceIsShown)
            .buttonStyle(.borderedProminent)
            .tint(.black.opacity(0.6))
#endif
        } //HStack Close
        
    } // mainView Close
    
    
    //        VStack {
    //            Spacer()
    //
    //            Text("Rift V1")
    //                .font(.largeTitle)
    //                .foregroundStyle(.black)
    //
    //            Spacer()
    //
    //            Button("Read PLY") {
    //                isPickingFile = true
    //            }
    //            .buttonStyle(.borderedProminent)
    //            .tint(.black.opacity(0.6))
    //            .padding()
    //            .disabled(isPickingFile)
    //#if os(visionOS)
    //            .disabled(immersiveSpaceIsShown)
    //#endif
    //            .fileImporter(isPresented: $isPickingFile,
    //                          allowedContentTypes: [ UTType(filenameExtension: "ply")! ]) {
    //                isPickingFile = false
    //                switch $0 {
    //                case .success(let url):
    //                    _ = url.startAccessingSecurityScopedResource()
    //                    Task {
    //                        // This is a sample app. In a real app, this should be more tightly scoped, not using a silly timer.
    //                        //                        try await Task.sleep(for: .seconds(2))
    //                        url.stopAccessingSecurityScopedResource()
    //                    }
    //                    openWindow(value: ModelIdentifier.gaussianSplat(url))
    //                case .failure:
    //                    break
    //                }
    //            }
    //
    //            Spacer()
    //
    //            Button("Show Sample Box") {
    //                openWindow(value: ModelIdentifier.sampleBox)
    //            }
    //            .buttonStyle(.borderedProminent)
    //            .tint(.black.opacity(0.6))
    //            .padding()
    //#if os(visionOS)
    //            .disabled(immersiveSpaceIsShown)
    //#endif
    //
    //            Spacer()
    //
    //#if os(visionOS)
    //            Button("Dismiss Immersive Space") {
    //                Task {
    //                    await dismissImmersiveSpace()
    //                    immersiveSpaceIsShown = false
    //                }
    //            }
    //            .disabled(!immersiveSpaceIsShown)
    //            .buttonStyle(.borderedProminent)
    //            .tint(.black.opacity(0.6))
    //
    //            Spacer()
    //
    //            Button {
    //                //                            // Present the video player
    //                //                            let playerViewController = AVPlayerViewController()
    //                //                            let player = AVPlayer(url: videoURL)
    //                //                            playerViewController.player = player
    //                //
    //                //                            // To present full-screen in SwiftUI, use a UIViewControllerRepresentable or leverage .fullScreenCover
    //                //                            let window = UIApplication.shared.windows.first
    //                //                            window?.rootViewController?.present(playerViewController, animated: true, completion: {
    //                //                                player.play()
    //                //                            })
    //
    //                print("play button pressed")
    //                print(video.url)
    //                player.loadVideo(video, presentation: .fullWindow)
    //                print("buttontask over")
    //            } label: {
    //                Label("Play Video", systemImage: "play.fill")
    //                    .frame(maxWidth: .infinity)
    //            }
    //            .buttonStyle(.borderedProminent)
    //            .tint(.black.opacity(0.6))
}




