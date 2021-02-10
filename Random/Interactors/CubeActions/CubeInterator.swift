//
//  CubeInterator.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI

protocol CubeInterator {
    func generateCube(state: Binding<AppState.AppData>)
    func cleanCube(state: Binding<AppState.AppData>)
    func saveCubeToUserDefaults(state: Binding<AppState.AppData>)
}

struct CubeInteratorImpl: CubeInterator {
    
    func saveCubeToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.main.async {
            saveListResult(state: state)
            saveSelectedCube(state: state)
            saveCubeOne(state: state)
            saveCubeTwo(state: state)
            saveCubeThree(state: state)
            saveCubeFour(state: state)
            saveCubeFive(state: state)
            saveCubeSix(state: state)
        }
    }
    
    func generateCube(state: Binding<AppState.AppData>) {
        switch state.cube.selectedCube.wrappedValue {
        case 0:
            cubeOne(state: state)
        case 1:
            cubeTwo(state: state)
        case 2:
            cubeThree(state: state)
        case 3:
            cubeFour(state: state)
        case 4:
            cubeFive(state: state)
        case 5:
            cubeSix(state: state)
        default: break
        }
    }
    
    func cleanCube(state: Binding<AppState.AppData>) {
        state.cube.listResult.wrappedValue = []
        state.cube.cubeOne.wrappedValue = 0
        state.cube.cubeTwo.wrappedValue = 0
        state.cube.cubeThree.wrappedValue = 0
        state.cube.cubeFour.wrappedValue = 0
        state.cube.cubeFive.wrappedValue = 0
        state.cube.cubeSix.wrappedValue = 0

    }
}


extension CubeInteratorImpl {
    private func cubeOne(state: Binding<AppState.AppData>) {
        let randomCube = Int.random(in: 1...6)
        state.cube.cubeOne.wrappedValue = randomCube
        state.cube.listResult.wrappedValue.append(String(randomCube))
    }
    
    private func cubeTwo(state: Binding<AppState.AppData>) {
        let randomCubeOne = Int.random(in: 1...6)
        let randomCubeTwo = Int.random(in: 1...6)
        let sumRandomCube = randomCubeOne + randomCubeTwo
        
        state.cube.cubeOne.wrappedValue = randomCubeOne
        state.cube.cubeTwo.wrappedValue = randomCubeTwo
        
        state.cube.listResult.wrappedValue.append(String(sumRandomCube))
    }
    
    private func cubeThree(state: Binding<AppState.AppData>) {
        let randomCubeOne = Int.random(in: 1...6)
        let randomCubeTwo = Int.random(in: 1...6)
        let randomCubeThree = Int.random(in: 1...6)
        let sumRandomCube = randomCubeOne + randomCubeTwo + randomCubeThree
        
        state.cube.cubeOne.wrappedValue = randomCubeOne
        state.cube.cubeTwo.wrappedValue = randomCubeTwo
        state.cube.cubeThree.wrappedValue = randomCubeThree
        
        state.cube.listResult.wrappedValue.append(String(sumRandomCube))
    }
    
    private func cubeFour(state: Binding<AppState.AppData>) {
        let randomCubeOne = Int.random(in: 1...6)
        let randomCubeTwo = Int.random(in: 1...6)
        let randomCubeThree = Int.random(in: 1...6)
        let randomCubeFour = Int.random(in: 1...6)
        let sumRandomCube = randomCubeOne +
            randomCubeTwo + randomCubeThree + randomCubeFour
        
        state.cube.cubeOne.wrappedValue = randomCubeOne
        state.cube.cubeTwo.wrappedValue = randomCubeTwo
        state.cube.cubeThree.wrappedValue = randomCubeThree
        state.cube.cubeFour.wrappedValue = randomCubeFour
        
        state.cube.listResult.wrappedValue.append(String(sumRandomCube))
    }
    
    private func cubeFive(state: Binding<AppState.AppData>) {
        let randomCubeOne = Int.random(in: 1...6)
        let randomCubeTwo = Int.random(in: 1...6)
        let randomCubeThree = Int.random(in: 1...6)
        let randomCubeFour = Int.random(in: 1...6)
        let randomCubeFive = Int.random(in: 1...6)
        let sumRandomCube = randomCubeOne +
            randomCubeTwo + randomCubeThree + randomCubeFour +
            randomCubeFive
        
        state.cube.cubeOne.wrappedValue = randomCubeOne
        state.cube.cubeTwo.wrappedValue = randomCubeTwo
        state.cube.cubeThree.wrappedValue = randomCubeThree
        state.cube.cubeFour.wrappedValue = randomCubeFour
        state.cube.cubeFive.wrappedValue = randomCubeFive
        
        state.cube.listResult.wrappedValue.append(String(sumRandomCube))
    }
    
    private func cubeSix(state: Binding<AppState.AppData>) {
        let randomCubeOne = Int.random(in: 1...6)
        let randomCubeTwo = Int.random(in: 1...6)
        let randomCubeThree = Int.random(in: 1...6)
        let randomCubeFour = Int.random(in: 1...6)
        let randomCubeFive = Int.random(in: 1...6)
        let randomCubeSix = Int.random(in: 1...6)
        let sumRandomCube = randomCubeOne +
            randomCubeTwo + randomCubeThree + randomCubeFour +
            randomCubeFive + randomCubeSix
        
        state.cube.cubeOne.wrappedValue = randomCubeOne
        state.cube.cubeTwo.wrappedValue = randomCubeTwo
        state.cube.cubeThree.wrappedValue = randomCubeThree
        state.cube.cubeFour.wrappedValue = randomCubeFour
        state.cube.cubeFive.wrappedValue = randomCubeFive
        state.cube.cubeSix.wrappedValue = randomCubeSix
        
        state.cube.listResult.wrappedValue.append(String(sumRandomCube))
    }
}

extension CubeInteratorImpl {
    private func saveListResult(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.cube
                                    .listResult.wrappedValue,
                                  forKey: "CubeListResult")
    }
    
    private func saveSelectedCube(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.cube
                                    .selectedCube.wrappedValue,
                                  forKey: "CubeSelectedCube")
    }
    
    private func saveCubeOne(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.cube
                                    .cubeOne.wrappedValue,
                                  forKey: "CubeCubeOne")
    }
    
    private func saveCubeTwo(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.cube
                                    .cubeTwo.wrappedValue,
                                  forKey: "CubeCubeTwo")
    }
    
    private func saveCubeThree(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.cube
                                    .cubeThree.wrappedValue,
                                  forKey: "CubeCubeThree")
    }
    
    private func saveCubeFour(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.cube
                                    .cubeFour.wrappedValue,
                                  forKey: "CubeCubeFour")
    }
    
    private func saveCubeFive(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.cube
                                    .cubeFive.wrappedValue,
                                  forKey: "CubeCubeFive")
    }
    
    private func saveCubeSix(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.cube
                                    .cubeSix.wrappedValue,
                                  forKey: "CubeCubeSix")
    }
}
