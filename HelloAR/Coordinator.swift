//
//  Coordinator.swift
//  HelloAR
//
//  Created by DataBunker on 2022-11-14.
//

import Foundation
import ARKit
import RealityKit
import Combine

class Coordinator: NSObject {
    weak var view: ARView?
    var modelName: String?
    var isAdded: Bool = false
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        // check if it is only the view which we are looking for.
        guard let view = view else { return }
        let tapLocation = recognizer.location(in: view)
        if isAdded == true  { return }
        let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        if let result = results.first {
            // result which we got from the ray cast.
            guard let modelName = modelName else { return }
            let anchorEntity = AnchorEntity(raycastResult: result)
            guard let modelEntity = try? ModelEntity.load(named: modelName) else {
                print("Unable to load model")
                return
            }
            view.scene.anchors.removeAll()
            anchorEntity.addChild(modelEntity)
            print("loaded the model entity")
            view.scene.anchors.append(anchorEntity)
            isAdded = true
        }
    }
    
   
    
}

