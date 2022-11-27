//
//  ScientistController.swift
//  HelloAR
//
//  Created by DataBunker on 2022-11-27.
//

import UIKit
import ARKit

class ScientistController: UIViewController, ARSCNViewDelegate {
    
    var scientists = [String: Scientist]()
    
    var sceneView: ARSCNView = {
        let sceneView = ARSCNView(frame: .zero)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        return sceneView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addARSceneView()
        navigationSettings()
    }
    
    fileprivate func addARSceneView() {
        self.view.addSubview(sceneView)
        sceneView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    fileprivate func navigationSettings() {
        self.navigationItem.title = "SVDetector"
        sceneView.delegate = self
        loadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // create the configuration.
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackingImages =  ARReferenceImage.referenceImages(inGroupNamed: "scientists", bundle: nil) else {
            fatalError("could not locate the images")
        }
        
        configuration.trackingImages = trackingImages
        
        // run the view session using the configuration
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageArchor = anchor as? ARImageAnchor else { return nil}
        guard let name = imageArchor.referenceImage.name else { return nil }
        guard let scientist = scientists[name] else { return nil}
        

        // Plane to draw in the 2d plane.
        // NOTE:- Plane is like an image and node is like a imageView
        let plane = SCNPlane(width: imageArchor.referenceImage.physicalSize.width, height: imageArchor.referenceImage.physicalSize.height)
        
        plane.firstMaterial?.diffuse.contents = UIColor.clear

        // node is like an imageView which is place in the virtual world where the archor is in the device orientation.
        let planeNode = SCNNode(geometry: plane)
            
        // junky maths to fix the orientation of the device and move the SCNNode into the anchor
        planeNode.eulerAngles.x = -.pi / 2
        
        let spacing: Float = 0.005
        let titleNode = textNode(scientist.name, font: UIFont.boldSystemFont(ofSize: 10))
        titleNode.pivotOnTopLeft()

        titleNode.position.x += Float(plane.width / 2) + spacing
        titleNode.position.y += Float(plane.height / 2)

        planeNode.addChildNode(titleNode)
        
        
        let bioNode = textNode(scientist.bio, font: UIFont.systemFont(ofSize: 4), maxWidth: 100)
        bioNode.pivotOnTopLeft()

        bioNode.position.x += Float(plane.width / 2) + spacing
        bioNode.position.y = titleNode.position.y - titleNode.height - spacing
        planeNode.addChildNode(bioNode)
        
        
        
        let node = SCNNode()
        node.addChildNode(planeNode)
        
        // description
        
//        let bioNode = textNode(scientist.bio, font: UIFont.systemFont(ofSize: 4), maxWidth: 100)
//        bioNode.pivotOnTopLeft()
//
//        bioNode.position.x += Float(plane.width / 2) + spacing
//        bioNode.position.y = titleNode.position.y - titleNode.height - spacing
//        planeNode.addChildNode(bioNode)
        return node
    }
    
    
    func textNode(_ str: String, font: UIFont, maxWidth: Int? = nil) -> SCNNode {
        let text = SCNText(string: str, extrusionDepth: 0)

        text.flatness = 0.1
        text.font = font

        if let maxWidth = maxWidth {
            text.containerFrame = CGRect(origin: .zero, size: CGSize(width: maxWidth, height: 500))
            text.isWrapped = true
        }

        let textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3(0.002, 0.002, 0.002)

        return textNode
    }
    
    fileprivate func loadData() {
        guard let url = Bundle.main.url(forResource: "scientists", withExtension: "json") else {
            fatalError("Error in loading the data from json file")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load json")
        }
        
        let decoder = JSONDecoder()
        guard let loadedScientists = try? decoder.decode([String: Scientist].self, from: data) else {
            fatalError("Decoding Error")
        }
        scientists = loadedScientists
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        // stop the session
        sceneView.session.pause()
    }

}

extension SCNNode {
    var height: Float {
        return (boundingBox.max.y - boundingBox.min.y) * scale.y
    }

    func pivotOnTopLeft() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation(min.x, max.y, 0)
    }

    func pivotOnTopCenter() {
        let (_, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation(0, max.y, 0)
    }
}

