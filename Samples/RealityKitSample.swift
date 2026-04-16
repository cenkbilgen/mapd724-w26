//
//  ContentView.swift
//  RK1
//
//  Created by cenk on 2026-04-13.
//

import SwiftUI
import RealityKit

// NOTE:
// In Info.plist
// 1. add entry for Privacy - Camera Usage
// Optional
// 2. add entry for Privacy - World Tracking (not used here, but we will)
// 3. add entry for "Required Device Capabilities)",
//      expand it, add item entry for "ARKit"

struct ContentView: View {
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            
            // Simple sphere
            let sphere = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(color: .blue, isMetallic: false)]
            )
            // anchor the sphere the world
            content.add(sphere)
            
            // Simple box
            let box = ModelEntity(mesh: .generateBox(size: 0.2),
                                  materials: [SimpleMaterial(color: .yellow, isMetallic: true)])
            box.position = [0, 0.5, 0]
            box.orientation = simd_quaternion(Float.pi/3, [0, 0, 1])
            // anchor the box to the world
            content.add(box)
            
            // anchors the box to the sphere
            // sphere.addChild(box)
            
            // to keep things static with the user
            // create a CameraEntity
            // anchor/add entities to the CameraEntity, they will stay fixed
        }
    }
}

#Preview {
    ContentView()
}
