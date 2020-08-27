//
//  ViewController.swift
//  FloorWater
//
//  Created by Gor on 8/28/20.
//  Copyright © 2020 user1. All rights reserved.
//

import UIKit
import ARKit

var waterImageView = UIImageView()
var flowerImageView = UIImageView()

class ViewController: UIViewController,ARSCNViewDelegate {
    
    let configuration = ARWorldTrackingConfiguration()
    
    @IBOutlet weak var sceneView: ARSCNView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            configuration.planeDetection = .horizontal
            configuration.environmentTexturing = .automatic
            
            sceneView.automaticallyUpdatesLighting = true
            sceneView.session.run(configuration)
            sceneView.delegate = self
            
            waterImageView.loadGif(name: "water")
            flowerImageView.loadGif(name: "flowers")
            waterImageView.addSubview(flowerImageView)
        }
        
        func createWater(with planeAnchor : ARPlaneAnchor) -> SCNNode{
            
            DispatchQueue.main.sync {
                waterImageView.frame = CGRect(x: CGFloat(planeAnchor.center.x), y: CGFloat(planeAnchor.center.y), width: self.view.frame.width / 2, height: self.view.frame.height / 2)
                flowerImageView.frame.size = CGSize(width: waterImageView.frame.width * 2/3, height: waterImageView.frame.height / 2)
                flowerImageView.center.x = waterImageView.center.x
                flowerImageView.center.y = waterImageView.center.y
            }
            
            let waterNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
            waterNode.geometry?.firstMaterial?.diffuse.contents = waterImageView
            waterNode.geometry?.firstMaterial?.isDoubleSided = true
            waterNode.geometry?.firstMaterial?.lightingModel = .physicallyBased
            waterNode.geometry?.firstMaterial?.roughness.intensity = 1.0
            waterNode.geometry?.firstMaterial?.specular.contents = 1.0
            waterNode.position = SCNVector3(planeAnchor.center.x,planeAnchor.center.y,planeAnchor.center.z)
            waterNode.eulerAngles = SCNVector3(90.degreesToRadians,0,0)
            return waterNode
        }

        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
            let waterNode = createWater(with: planeAnchor)
            node.addChildNode(waterNode)
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
            node.enumerateChildNodes { (childNode, _) in
                childNode.removeFromParentNode()
            }
            let waterNode = createWater(with: planeAnchor)
            node.addChildNode(waterNode)
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
            
            guard let _ = anchor as? ARPlaneAnchor else {return}
            node.enumerateChildNodes { (childNode, _) in
                childNode.removeFromParentNode()
            }
        }
        
        
    }

    extension Int {
        
        var degreesToRadians : Double {return Double(self) * .pi/180}
    }

