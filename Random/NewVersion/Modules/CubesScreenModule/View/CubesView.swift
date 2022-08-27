//
//  CubesView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//

import UIKit
import RandomUIKit

/// View для экрана
final class CubesView: UIView {
  
  // MARK: - Private properties
  
  private let cubeOneImageView = UIImageView()
  private var cubeOneConstraints: [NSLayoutConstraint] = []
  
  private let cubesTwoImageView = UIImageView()
  private var cubesTwoConstraints: [NSLayoutConstraint] = []
  
  private let cubesThreeImageView = UIImageView()
  private var cubesThreeConstraints: [NSLayoutConstraint] = []
  
  private let cubesFourImageView = UIImageView()
  private var cubesFourConstraints: [NSLayoutConstraint] = []
  
  private let cubesFiveImageView = UIImageView()
  private var cubesFiveConstraints: [NSLayoutConstraint] = []
  
  private let cubesSixImageView = UIImageView()
  private var cubesSixConstraints: [NSLayoutConstraint] = []
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  /// Обновляет экран с кубиками
  ///  - Parameter type: Тип кубиков
  func updateCubesWith(type: CubesScreenModel.CubesType) {
    self.configureConstraintsWith(type: type)
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    [cubeOneImageView, cubesTwoImageView, cubesThreeImageView,
     cubesFourImageView, cubesFiveImageView, cubesSixImageView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
  }
  
  private func configureConstraintsWith(type: CubesScreenModel.CubesType) {
    let appearance = Appearance()
    deactivateCubes()
    
    switch type {
    case .cubesOne(let number):
      cubeOneImageView.image = configureCubeImageFrom(number: number)
      
      cubeOneImageView.isHidden = false
      cubeOneConstraints = [
        cubeOneImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        cubeOneImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      ]
      
      cubeOneConstraints.forEach {
        $0.isActive = true
      }
    case .cubesTwo(let numberOne, let numberTwo):
      cubeOneImageView.image = configureCubeImageFrom(number: numberOne)
      cubeOneImageView.isHidden = false
      
      cubesTwoImageView.image = configureCubeImageFrom(number: numberTwo)
      cubesTwoImageView.isHidden = false
      
      cubesTwoConstraints = [
        cubeOneImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                  constant: -appearance.fiftySpacing),
        cubeOneImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        
        cubesTwoImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                   constant: appearance.fiftySpacing),
        cubesTwoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      ]
      
      cubesTwoConstraints.forEach {
        $0.isActive = true
      }
    case .cubesThree(let numberOne, let numberTwo, let numberThree):
      cubeOneImageView.image = configureCubeImageFrom(number: numberOne)
      cubeOneImageView.isHidden = false
      
      cubesTwoImageView.image = configureCubeImageFrom(number: numberTwo)
      cubesTwoImageView.isHidden = false
      
      cubesThreeImageView.image = configureCubeImageFrom(number: numberThree)
      cubesThreeImageView.isHidden = false
      
      cubesThreeConstraints = [
        cubeOneImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                  constant: -appearance.oneHundredSpacing),
        cubeOneImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        
        cubesTwoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        cubesTwoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        
        cubesThreeImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                     constant: appearance.oneHundredSpacing),
        cubesThreeImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      ]
      
      cubesThreeConstraints.forEach {
        $0.isActive = true
      }
      
    case .cubesFour(let numberOne, let numberTwo, let numberThree, let numberFour):
      cubeOneImageView.image = configureCubeImageFrom(number: numberOne)
      cubeOneImageView.isHidden = false
      
      cubesTwoImageView.image = configureCubeImageFrom(number: numberTwo)
      cubesTwoImageView.isHidden = false
      
      cubesThreeImageView.image = configureCubeImageFrom(number: numberThree)
      cubesThreeImageView.isHidden = false
      
      cubesFourImageView.image = configureCubeImageFrom(number: numberFour)
      cubesFourImageView.isHidden = false
      
      cubesFourConstraints = [
        cubeOneImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                  constant: -appearance.fiftySpacing),
        cubeOneImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                  constant: appearance.fiftySpacing),
        
        cubesTwoImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                   constant: appearance.fiftySpacing),
        cubesTwoImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                   constant: appearance.fiftySpacing),
        
        cubesThreeImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                     constant: -appearance.fiftySpacing),
        cubesThreeImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                     constant: -appearance.fiftySpacing),
        
        cubesFourImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                    constant: appearance.fiftySpacing),
        cubesFourImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                    constant: -appearance.fiftySpacing),
      ]
      
      cubesFourConstraints.forEach {
        $0.isActive = true
      }
      
    case .cubesFive(let numberOne, let numberTwo, let numberThree,
                    let numberFour, let numberFive):
      cubeOneImageView.image = configureCubeImageFrom(number: numberOne)
      cubeOneImageView.isHidden = false
      
      cubesTwoImageView.image = configureCubeImageFrom(number: numberTwo)
      cubesTwoImageView.isHidden = false
      
      cubesThreeImageView.image = configureCubeImageFrom(number: numberThree)
      cubesThreeImageView.isHidden = false
      
      cubesFourImageView.image = configureCubeImageFrom(number: numberFour)
      cubesFourImageView.isHidden = false
      
      cubesFiveImageView.image = configureCubeImageFrom(number: numberFive)
      cubesFiveImageView.isHidden = false
      
      cubesFiveConstraints = [
        cubeOneImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                  constant: -appearance.oneHundredSpacing),
        cubeOneImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                  constant: appearance.fiftySpacing),

        cubesTwoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        cubesTwoImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                   constant: appearance.fiftySpacing),

        cubesThreeImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                     constant: appearance.oneHundredSpacing),
        cubesThreeImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                     constant: appearance.fiftySpacing),

        cubesFourImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                    constant: -appearance.fiftySpacing),
        cubesFourImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                    constant: -appearance.fiftySpacing),
        
        cubesFiveImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                    constant: appearance.fiftySpacing),
        cubesFiveImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                    constant: -appearance.fiftySpacing),
      ]
      
      cubesFiveConstraints.forEach {
        $0.isActive = true
      }
      
    case .cubesSix(let numberOne, let numberTwo, let numberThree,
                   let numberFour, let numberFive, let numberSix):
      cubeOneImageView.image = configureCubeImageFrom(number: numberOne)
      cubeOneImageView.isHidden = false
      
      cubesTwoImageView.image = configureCubeImageFrom(number: numberTwo)
      cubesTwoImageView.isHidden = false
      
      cubesThreeImageView.image = configureCubeImageFrom(number: numberThree)
      cubesThreeImageView.isHidden = false
      
      cubesFourImageView.image = configureCubeImageFrom(number: numberFour)
      cubesFourImageView.isHidden = false
      
      cubesFiveImageView.image = configureCubeImageFrom(number: numberFive)
      cubesFiveImageView.isHidden = false
      
      cubesSixImageView.image = configureCubeImageFrom(number: numberSix)
      cubesSixImageView.isHidden = false
      
      cubesSixConstraints = [
        cubeOneImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                  constant: -appearance.oneHundredSpacing),
        cubeOneImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                  constant: appearance.fiftySpacing),
        
        cubesTwoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        cubesTwoImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                   constant: appearance.fiftySpacing),
        
        cubesThreeImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                     constant: appearance.oneHundredSpacing),
        cubesThreeImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                     constant: appearance.fiftySpacing),
        
        cubesFourImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                    constant: -appearance.oneHundredSpacing),
        cubesFourImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                    constant: -appearance.fiftySpacing),
        
        cubesFiveImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        cubesFiveImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                    constant: -appearance.fiftySpacing),
        
        cubesSixImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                   constant: appearance.oneHundredSpacing),
        cubesSixImageView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                   constant: -appearance.fiftySpacing),
      ]
      
      cubesSixConstraints.forEach {
        $0.isActive = true
      }
    }
  }
  
  private func deactivateCubes() {
    cubeOneConstraints.forEach {
      $0.isActive = false
    }
    
    cubesTwoConstraints.forEach {
      $0.isActive = false
    }
    
    cubesThreeConstraints.forEach {
      $0.isActive = false
    }
    
    cubesFourConstraints.forEach {
      $0.isActive = false
    }
    
    cubesFiveConstraints.forEach {
      $0.isActive = false
    }
    
    cubesSixConstraints.forEach {
      $0.isActive = false
    }
    
    [cubeOneImageView, cubesTwoImageView, cubesThreeImageView,
     cubesFourImageView, cubesFiveImageView, cubesSixImageView].forEach {
      $0.isHidden = true
    }
  }
  
  private func configureCubeImageFrom(number: Int) -> UIImage? {
    guard number >= 1 && number <= 6 else {
      return nil
    }
    
    let appearance = Appearance()
    let largeConfig = UIImage.SymbolConfiguration(pointSize: appearance.pointSize,
                                                  weight: .bold,
                                                  scale: .large)
    if number == appearance.numberOne {
      return UIImage(systemName: appearance.cubeOneImage,
                     withConfiguration: largeConfig)
    }
    
    if number == appearance.numberTwo {
      return UIImage(systemName: appearance.cubesTwoImage,
                     withConfiguration: largeConfig)
    }
    
    if number == appearance.numberThree {
      return UIImage(systemName: appearance.cubesThreeImage,
                     withConfiguration: largeConfig)
    }
    
    if number == appearance.numberFour {
      return UIImage(systemName: appearance.cubesFourImage,
                     withConfiguration: largeConfig)
    }
    
    if number == appearance.numberFive {
      return UIImage(systemName: appearance.cubesFiveImage,
                     withConfiguration: largeConfig)
    }
    
    if number == appearance.numberSix {
      return UIImage(systemName: appearance.cubesSixImage,
                     withConfiguration: largeConfig)
    }
    return nil
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = RandomColor.primaryWhite
    
    cubeOneImageView.setImageColor(color: RandomColor.primaryGreen)
    cubesTwoImageView.setImageColor(color: RandomColor.primaryGreen)
    cubesThreeImageView.setImageColor(color: RandomColor.primaryGreen)
    cubesFourImageView.setImageColor(color: RandomColor.primaryGreen)
    cubesFiveImageView.setImageColor(color: RandomColor.primaryGreen)
    cubesSixImageView.setImageColor(color: RandomColor.primaryGreen)
  }
}

// MARK: - Appearance

private extension CubesView {
  struct Appearance {
    let cubeOneImage = "die.face.1.fill"
    let cubesTwoImage = "die.face.2.fill"
    let cubesThreeImage = "die.face.3.fill"
    let cubesFourImage = "die.face.4.fill"
    let cubesFiveImage = "die.face.5.fill"
    let cubesSixImage = "die.face.6.fill"
    let oneHundredSpacing: CGFloat = 100
    let fiftySpacing: CGFloat = 50
    let pointSize: CGFloat = 70
    let numberOne: Int = 1
    let numberTwo: Int = 2
    let numberThree: Int = 3
    let numberFour: Int = 4
    let numberFive: Int = 5
    let numberSix: Int = 6
  }
}
