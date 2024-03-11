import SwiftUI
import RealityKit
import UniformTypeIdentifiers
import AVKit
import os

struct ContentView: View {
    
    private var video = VideoLibrary().videos[0]
        
    //initialize video player model
    @Environment(PlayerModel.self) private var player
    private let videoURL = URL(string: "file:///Users/brianjskim/Desktop/Screenshot : recording/CMU_1팀_52Habits.mp4")!
        
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

    var body: some View {
#if os(macOS) || os(visionOS)
        Group {
            switch player.presentation {
            case .fullWindow:
                // Present the player full window and begin playback.
                PlayerView()
                    .onAppear {
                        print("PlayerViewAppeared")
                        player.play()
                    }
            default:
                // Show the app's content library by default.
                mainView
                    .onAppear {
                        print("mainViewAppeared")
                    }
            }
        }
        .onAppear {
            print("ContentViewAppeared")
        }
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

    @ViewBuilder
    var mainView: some View {
        VStack {
            Spacer()

            Text("Rift V1")
                .font(.largeTitle)
                .foregroundStyle(.black)

            Spacer()

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

            Spacer()

            Button("Show Sample Box") {
                openWindow(value: ModelIdentifier.sampleBox)
            }
            .buttonStyle(.borderedProminent)
            .tint(.black.opacity(0.6))
            .padding()
#if os(visionOS)
            .disabled(immersiveSpaceIsShown)
#endif

            Spacer()

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
            
            Spacer()
            
            Button {
//                            // Present the video player
//                            let playerViewController = AVPlayerViewController()
//                            let player = AVPlayer(url: videoURL)
//                            playerViewController.player = player
//                            
//                            // To present full-screen in SwiftUI, use a UIViewControllerRepresentable or leverage .fullScreenCover
//                            let window = UIApplication.shared.windows.first
//                            window?.rootViewController?.present(playerViewController, animated: true, completion: {
//                                player.play()
//                            })
                
                print("play button pressed")
                print(video.url)
                player.loadVideo(video, presentation: .fullWindow)
                print("buttontask over")
            } label: {
                Label("Play Video", systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.black.opacity(0.6))
            
#endif // os(visionOS)
        }
    }
}
