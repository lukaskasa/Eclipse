//
//  MarsSceneView.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 16.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import SceneKit

/// A Mars SceneView
class MarsSceneView: SCNView {
    
    /// Properties
    private let marsTexture = #imageLiteral(resourceName: "marstexture")
    let position: SCNVector3 = SCNVector3(x: 0, y: 0, z: 10.0)
    var cameraNode: SCNNode!
    var sphere: SCNGeometry!

    /**
     Initializes a scene view with a mars looking sphere ussing SceneKit
     
     - Parameters:
        - frame: CGRect used to configure size and postion of the SceneView
        - options: Options used to configure the SceneView
     
     - Returns: A MarsSceneView
     */
    override init(frame: CGRect, options: [String: Any]?) {
        super.init(frame: frame, options: options)
        setupScene()
        setupCamera()
        createSphere()
        configureSceneView()
    }
    
    /// Convenience initializer to setup the sceneview
    convenience init() {
        self.init(frame: CGRect(), options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configures the sceneview
    private func configureSceneView() {
        self.backgroundColor = .black
        self.allowsCameraControl = true
        self.autoenablesDefaultLighting = true
    }
    
    /// Sets ups the scene
    private func setupScene() {
        self.scene = SCNScene()
    }
    
    /// Sets up the scene camera
    private func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = position
    }
    
    /// Creates a sphere using a mars texture with a rotation animation
    private func createSphere() {
        sphere = SCNSphere(radius: 0.5)
        sphere.firstMaterial?.diffuse.contents = marsTexture
        sphere.firstMaterial?.isDoubleSided = true
        
        let geometryNode = SCNNode(geometry: sphere)
        self.scene?.rootNode.addChildNode(geometryNode)
        
        let action = SCNAction.rotate(by: 360 * CGFloat((Double.pi) / 180), around: SCNVector3(0, 1, 0), duration: 16)
        let repeatAction = SCNAction.repeatForever(action)
        
        geometryNode.runAction(repeatAction)
    }
    
}
