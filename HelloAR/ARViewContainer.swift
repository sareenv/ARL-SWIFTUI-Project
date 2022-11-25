//
//  ARContainerView.swift
//  HelloAR
//
//  Created by DataBunker on 2022-11-23.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {

    var modelName: String
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    // archor entity is from the realitykit vs aranchor is from the ARKit.
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.addGestureRecognizer(UITapGestureRecognizer.init(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        context.coordinator.view = arView
        context.coordinator.modelName = modelName
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}


