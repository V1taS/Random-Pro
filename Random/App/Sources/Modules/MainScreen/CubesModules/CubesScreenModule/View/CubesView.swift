//
//  CubesView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 11.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle
import SceneKit
import QuartzCore

final class CubesView: UIView {
  
  // MARK: - Internal properties
  
  var totalValueDiceAction: ((Int) -> Void)?
  var feedbackGeneratorAction: (() -> Void)?
  
  // MARK: - Private properties
  
  private var scnView = SCNView()
  private var scnScene = SCNScene()
  private var cameraNode = SCNNode()
  private var diceNodes: [SCNNode] = []
  private var speeds: [SCNVector3] = []
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
    setupScene()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  /// Обновляет экран с кубиками
  ///  - Parameter type: Тип кубиков
  func updateCubesWith(type: CubesScreenModel.CubesType) {
    addCubes(type: type)
  }
  
  /// Обработать нажатие
  func handleTap() {
    scnScene.physicsWorld.speed = 3.0
    let torque = setTorque()
    let force = setForce()
    
    for die in diceNodes {
      die.physicsBody?.applyTorque(torque, asImpulse: true)
      die.physicsBody?.applyForce(force, asImpulse: true)
    }
  }
}

// MARK: - SCNPhysicsContactDelegate

extension CubesView: SCNPhysicsContactDelegate {
  func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
    let appearance = Appearance()

    if (contact.nodeA.name == appearance.cubesNodeName && contact.nodeB.name == appearance.positionFloor) ||
        (contact.nodeA.name == appearance.positionFloor && contact.nodeB.name == appearance.cubesNodeName) ||
        (contact.nodeA.name == appearance.cubesNodeName && contact.nodeB.name == appearance.positionLeft) ||
        (contact.nodeA.name == appearance.positionLeft && contact.nodeB.name == appearance.cubesNodeName) ||
        (contact.nodeA.name == appearance.cubesNodeName && contact.nodeB.name == appearance.positionRight) ||
        (contact.nodeA.name == appearance.positionRight && contact.nodeB.name == appearance.cubesNodeName) ||
        (contact.nodeA.name == appearance.cubesNodeName && contact.nodeB.name == appearance.positionFront) ||
        (contact.nodeA.name == appearance.positionFront && contact.nodeB.name == appearance.cubesNodeName) ||
        (contact.nodeA.name == appearance.cubesNodeName && contact.nodeB.name == appearance.positionBack) ||
        (contact.nodeA.name == appearance.positionBack && contact.nodeB.name == appearance.cubesNodeName) {
      feedbackGeneratorAction?()
    }
  }
}

// MARK: - SCNSceneRendererDelegate

extension CubesView: SCNSceneRendererDelegate {
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    DispatchQueue.global(qos: .userInteractive).sync { [weak self] in
      guard let self else {
        return
      }
      
      for (num, die) in diceNodes.enumerated() {
        if let pb = die.physicsBody {
          guard speeds.indices.contains(num) else {
            continue
          }
          let os = speeds[num]
          if !os.isZero && pb.velocity.isZero {
            DispatchQueue.main.async {
              self.totalValueDiceAction?(self.boxUpIndex(n: die.presentation) + 1)
            }
          }
          speeds[num] = pb.velocity
        }
      }
    }
  }
}

// MARK: - SCNVector3

private extension SCNVector3 {
  var isZero: Bool {
    return self.x == .zero && self.y == .zero && self.z == .zero
  }
}

// MARK: - Private

private extension CubesView {
  func randomPosition() -> SCNVector3 {
    let x = Float.random(in: -5...5)
    let y = Float.random(in: 0...10)
    let z = Float.random(in: -5...5)
    return SCNVector3(x, y, z)
  }
  
  func reposition(_ node: SCNNode, to position: SCNVector3, with normal: SCNVector3) {
    let transVector1 = SCNVector3Make(1, 0, 0)
    let transVector2 = SCNVector3Make(0, 1, 0)
    var tangent0 = scnVector3CrossProduct(left: normal, right: transVector1)
    
    let dotprod = scnVector3DotProduct(left: tangent0, right: tangent0)
    if dotprod < 0.001 {
      tangent0 = scnVector3CrossProduct(left: normal, right: transVector2)
    }
    tangent0 = scnVector3Normalize(vector: tangent0)
    
    let helpVector1 = scnVector3CrossProduct(left: normal, right: tangent0)
    let tangent1 = scnVector3Normalize(vector: helpVector1)
    
    let tangent0GLK = GLKVector4Make(tangent0.x, tangent0.y, tangent0.z, 0)
    let tangent1GLK = GLKVector4Make(tangent1.x, tangent1.y, tangent1.z, 0)
    let normalGLK = GLKVector4Make(normal.x, normal.y, normal.z, 0)
    
    let rotMat = GLKMatrix4MakeWithColumns(tangent0GLK, tangent1GLK, normalGLK, GLKVector4Make(0, 0, 0, 1))
    let transMat = SCNMatrix4MakeTranslation(node.position.x, node.position.y, node.position.z)
    node.transform = SCNMatrix4Mult(transMat, SCNMatrix4FromGLKMatrix4(rotMat))
    node.position = position
  }
  
  func wall(at position: SCNVector3,
            with normal: SCNVector3,
            sized size: CGSize,
            name: String,
            color: UIColor = .clear) -> SCNNode {
    let geometry = SCNPlane(width: size.width, height: size.height)
    geometry.materials.first?.diffuse.contents = color
    geometry.materials.first?.isDoubleSided = true
    
    let geometryNode = SCNNode(geometry: geometry)
    geometryNode.name = name
    geometryNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
    geometryNode.physicsBody?.collisionBitMask = 1
    geometryNode.physicsBody?.contactTestBitMask = 1
    geometryNode.position = position
    reposition(geometryNode, to: position, with: normal)
    return geometryNode
  }
  
  func createDie(position: SCNVector3, sides: [UIImage]) -> SCNNode {
    let geometry = SCNBox(width: 2.3, height: 2.3, length: 2.3, chamferRadius: 0.1)
    
    let material1 = SCNMaterial()
    material1.diffuse.contents = sides[0]
    let material2 = SCNMaterial()
    material2.diffuse.contents = sides[1]
    let material3 = SCNMaterial()
    material3.diffuse.contents = sides[2]
    let material4 = SCNMaterial()
    material4.diffuse.contents = sides[3]
    let material5 = SCNMaterial()
    material5.diffuse.contents = sides[4]
    let material6 = SCNMaterial()
    material6.diffuse.contents = sides[5]
    geometry.materials = [material1, material2, material3, material4, material5, material6]
    
    let node = SCNNode(geometry: geometry)
    node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
    node.position = position
    node.name = Appearance().cubesNodeName
    return node
  }
  
  func scnVector3CrossProduct(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.y * right.z - left.z * right.y,
                          left.z * right.x - left.x * right.z,
                          left.x * right.y - left.y * right.x)
  }
  
  func scnVector3DotProduct(left: SCNVector3, right: SCNVector3) -> float_t {
    return (left.x * right.x + left.y * right.y + left.z * right.z)
  }
  
  func scnVector3Normalize(vector: SCNVector3) -> SCNVector3 {
    let scale = 1.0 / sqrt(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z)
    return SCNVector3Make(vector.x * scale, vector.y * scale, vector.z*scale)
  }
  
  func boxUpIndex(n: SCNNode) -> Int {
    let rotation = n.rotation
    let invRotation = SCNVector4(rotation.x,
                                 rotation.y,
                                 rotation.z,
                                 -rotation.w)
    let up = SCNVector3(0, 1, 0)
    let transform = SCNMatrix4MakeRotation(invRotation.w,
                                           invRotation.x,
                                           invRotation.y,
                                           invRotation.z)
    let glkTransform = SCNMatrix4ToGLKMatrix4(transform)
    let glkUp = SCNVector3ToGLKVector3(up)
    let rotatedUp = GLKMatrix4MultiplyVector3(glkTransform, glkUp)
    let boxNormals: [GLKVector3] = [
      GLKVector3(v: (0, 0, 1)),
      GLKVector3(v: (1, 0, 0)),
      GLKVector3(v: (0, 0, -1)),
      GLKVector3(v: (-1, 0, 0)),
      GLKVector3(v: (0, 1, 0)),
      GLKVector3(v: (0, -1, 0)),
    ]
    
    var bestIndex = 0
    var maxDot: Float = -1.0
    
    for (i, bNormal) in boxNormals.enumerated() {
      let dot = GLKVector3DotProduct(bNormal, rotatedUp)
      if dot > maxDot {
        maxDot = dot
        bestIndex = i
      }
    }
    return bestIndex
  }
  
  func setTorque() -> SCNVector4 {
    return SCNVector4(2, 4, -2, 2)
  }
  
  func setForce() -> SCNVector3 {
    return SCNVector3(1, 24, 2)
  }
  
  func setupScene() {
    let appearance = Appearance()
    scnView.scene = scnScene
    setupCamera()
    setupLight()
    
    scnScene.physicsWorld.speed = 3
    scnScene.physicsWorld.contactDelegate = self
    let wallSize = CGSize(width: 50.0, height: 50.0)
    
    let walls = [
      // верхняя стена X,Y,Z
      (position: SCNVector3(0, 13, 0),
       normal: SCNVector3Make(0, -1, 0),
       name: appearance.positionTop),
      // нижняя стена X,Y,Z
      (position: SCNVector3(0, -8, 0),
       normal: SCNVector3Make(0, 1, 0),
       name: appearance.positionFloor),
      // правая стена X,Y,Z
      (position: SCNVector3(7, -8, 0),
       normal: SCNVector3Make(-1, 0, 0),
       name: appearance.positionRight),
      // левая стена X,Y,Z
      (position: SCNVector3(-7, -8, 0),
       normal: SCNVector3Make(1, 0, 0),
       name: appearance.positionLeft),
      // задняя стена X,Y,Z
      (position: SCNVector3(0, -8, 11),
       normal: SCNVector3Make(0, 0, -1),
       name: appearance.positionBack),
      // передняя стена X,Y,Z
      (position: SCNVector3(0, -8, -11),
       normal: SCNVector3Make(0, 0, 1),
       name: appearance.positionFront)
    ]
    
    for wall in walls {
      let panel = self.wall(at: wall.position, with: wall.normal, sized: wallSize, name: wall.name)
      scnScene.rootNode.addChildNode(panel)
    }
  }
  
  func addCubes(type: CubesScreenModel.CubesType) {
    let appearance = Appearance()
    
    if !diceNodes.isEmpty {
      for die in diceNodes {
        die.removeFromParentNode()
      }
    }
    
    diceNodes = []
    speeds = []
    
    let sides = [
      appearance.cubeOneImage,
      appearance.cubesTwoImage,
      appearance.cubesThreeImage,
      appearance.cubesFourImage,
      appearance.cubesFiveImage,
      appearance.cubesSixImage,
    ]
    
    switch type {
    case .cubesOne:
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      speeds.append(SCNVector3(0, 0, 0))
    case .cubesTwo:
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      speeds.append(SCNVector3(0, 0, 0))
      speeds.append(SCNVector3(0, 0, 0))
    case .cubesThree:
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      speeds.append(SCNVector3(0, 0, 0))
      speeds.append(SCNVector3(0, 0, 0))
      speeds.append(SCNVector3(0, 0, 0))
    case .cubesFour:
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      speeds.append(SCNVector3(0, 0, 0))
      speeds.append(SCNVector3(0, 0, 0))
      speeds.append(SCNVector3(0, 0, 0))
      speeds.append(SCNVector3(0, 0, 0))
    case .cubesFive:
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      speeds.append(SCNVector3(0, 0, 0))
      speeds.append(SCNVector3(0, 0, 0))
      speeds.append(SCNVector3(0, 0, 0))
      speeds.append(SCNVector3(0, 0, 0))
      speeds.append(SCNVector3(0, 0, 0))
    case .cubesSix:
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      diceNodes.append(createDie(position: randomPosition(), sides: sides))
      speeds.append(SCNVector3(0, 0, 0))
      speeds.append(SCNVector3(0, 0, 0))
      speeds.append(SCNVector3(0, 0, 0))
      speeds.append(SCNVector3(0, 0, 0))
      speeds.append(SCNVector3(0, 0, 0))
      speeds.append(SCNVector3(0, 0, 0))
    }
    
    let torque = SCNVector4(1, 2, -1, 1)
    for die in diceNodes {
      die.physicsBody?.applyTorque(torque, asImpulse: true)
      scnScene.rootNode.addChildNode(die)
    }
  }
  
  func configureLayout() {
    [scnView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      scnView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scnView.topAnchor.constraint(equalTo: topAnchor),
      scnView.trailingAnchor.constraint(equalTo: trailingAnchor),
      scnView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func setupView() {
    configureLayout()
    scnView.autoenablesDefaultLighting = true
    scnView.delegate = self
    scnView.isPlaying = true
    scnView.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
  }
  
  func setupCamera() {
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3(x: 0, y: 20, z: 2)
    cameraNode.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
    scnScene.rootNode.addChildNode(cameraNode)
  }
  
  func setupLight() {
    let lightNode = SCNNode()
    lightNode.light = SCNLight()
    lightNode.light?.type = .omni
    lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
    
    let ambientLightNode = SCNNode()
    ambientLightNode.light = SCNLight()
    ambientLightNode.light?.type = .ambient
    ambientLightNode.light?.color = fancyColor.only.primaryRed
    scnScene.rootNode.addChildNode(ambientLightNode)
    
    let rotatingNode = SCNNode()
    scnScene.rootNode.addChildNode(rotatingNode)
    rotatingNode.addChildNode(lightNode)
    
    let lightOrbit = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 10)
    let repeatLightOrbit = SCNAction.repeatForever(lightOrbit)
    rotatingNode.runAction(repeatLightOrbit)
  }
}

// MARK: - Appearance

private extension CubesView {
  struct Appearance {
    let cubeOneImage = RandomAsset.dieOne.image
    let cubesTwoImage = RandomAsset.dieTwo.image
    let cubesThreeImage = RandomAsset.dieThree.image
    let cubesFourImage = RandomAsset.dieFour.image
    let cubesFiveImage = RandomAsset.dieFive.image
    let cubesSixImage = RandomAsset.dieSix.image
    
    let oneHundredSpacing: CGFloat = 100
    let fiftySpacing: CGFloat = 50
    let pointSize: CGFloat = 70
    let numberOne: Int = 1
    let numberTwo: Int = 2
    let numberThree: Int = 3
    let numberFour: Int = 4
    let numberFive: Int = 5
    let numberSix: Int = 6

    let positionTop = "Top"
    let positionFloor = "Floor"
    let positionRight = "Right"
    let positionLeft = "Left"
    let positionBack = "Back"
    let positionFront = "Front"

    let cubesNodeName = "Cube"
  }
}
