//
//  RiftApp.swift
//  Rift
//
//  Created by Brian Kim on 3/9/24.
//

#if os(visionOS)
import CompositorServices
#endif
import SwiftUI

@main
struct RiftApp: App {
    var body: some Scene {
        WindowGroup("MetalSplatter Sample App", id: "main") {
            ContentView()
        }

#if os(macOS)
        WindowGroup(for: ModelIdentifier.self) { modelIdentifier in
            MetalKitSceneView(modelIdentifier: modelIdentifier.wrappedValue)
                .navigationTitle(modelIdentifier.wrappedValue?.description ?? "No Model")
        }
#endif // os(macOS)

#if os(visionOS)
        ImmersiveSpace(for: ModelIdentifier.self) { modelIdentifier in
            CompositorLayer(configuration: ContentStageConfiguration()) { layerRenderer in
                let renderer = VisionSceneRenderer(layerRenderer)
                do {
                    try renderer.load(modelIdentifier.wrappedValue)
                } catch {
                    print("Error loading model: \(error.localizedDescription)")
                }
                renderer.startRenderLoop()
            }
        }
        .immersionStyle(selection: .constant(.full), in: .full)
#endif // os(visionOS)
    }
}


