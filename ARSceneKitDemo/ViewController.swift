//
//  ViewController.swift
//  ARSceneKitDemo
//
//  Created by Rasmus Knoth Nielsen on 15/05/2020.
//  Copyright © 2020 Rasmus Knoth Nielsen. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var arsckView: ARSCNView!
    var configuration = ARImageTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arsckView.delegate = self
        setupImageToBeFound()
        arsckView.scene = SCNScene()
        arsckView.session.run(configuration)
        
    }
    
    func setupImageToBeFound() {
        // The guard statement works like an if statement
        guard let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("No images found")
        }
        // If we get to this line, we know that the image has a value
        configuration.trackingImages = images
    }
    
    // Each time the image is recognized, do the following
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("found image")
        if let anc = anchor as? ARImageAnchor {
            addNode(anchor: anc, node: node)
        }
    }
    
    // Add the node
    func addNode(anchor: ARImageAnchor, node: SCNNode) {
        if let newNode = getGraphicNode(size: anchor.referenceImage.physicalSize) {
            node.addChildNode(newNode)
        }
    }
    
    // Create a SCNNode, which holds our trex.png image
    func getGraphicNode(size: CGSize) -> SCNNode? {
        
        // 1. get material
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "trex")  // Adds an image to the upcomming node
        
        // 2. Create the plane on which the image will be, which wil decide size and material
        let plane = SCNPlane(width: size.width, height: size.height)
        plane.materials = [material]
        
        // 3. Get a SCNNode
        let node = SCNNode(geometry: plane)
        
        // Use the following to rotate the node and thus image, as the user moves.
        node.eulerAngles.x = -.pi / 4
        
        return node
    }


}

