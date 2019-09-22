//
//  MarsSceneView.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 16.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import SceneKit

class MarsSceneView {
    
    // MARK: - Properties
    let sceneView: SCNView
    let position: SCNVector3 = SCNVector3(x: 0, y: 0, z: 10.0)
    var scene: SCNScene!
    var cameraNode: SCNNode!
    var sphere: SCNGeometry!
    
    init(sceneView: SCNView) {
        self.sceneView = sceneView
        setupScene()
        setupCamera()
        createSphere()
        configureSceneView()
    }
    
    private func configureSceneView() {
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
    }
    
    private func setupScene() {
        scene = SCNScene()
        sceneView.scene = scene
    }
    
    private func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = position
    }
    
    private func createSphere() {
        sphere = SCNSphere(radius: 0.5)
        sphere.firstMaterial?.diffuse.contents = UIImage(named: "marstexture")
        sphere.firstMaterial?.isDoubleSided = true
        
        let geometryNode = SCNNode(geometry: sphere)
        scene.rootNode.addChildNode(geometryNode)
        
        let action = SCNAction.rotate(by: 360 * CGFloat((Double.pi) / 180), around: SCNVector3(0, 1, 0), duration: 16)
        let repeatAction = SCNAction.repeatForever(action)
        
        geometryNode.runAction(repeatAction)
    }
    
}
