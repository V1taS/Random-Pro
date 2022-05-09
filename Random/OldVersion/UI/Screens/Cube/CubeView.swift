//
//  CubeView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CubeView: View {
    
    private var appBinding: Binding<AppState.AppData>
    private var actionButton: (() -> Void)?
    
    init(appBinding: Binding<AppState.AppData>, actionButton: (() -> Void)?) {
        self.appBinding = appBinding
        self.actionButton = actionButton
    }
    @Environment(\.injected) private var injected: DIContainer
    @State var countCube = ["1", "2", "3", "4", "5", "6"]
    @State var selectedCube = 0
    @State private var isPressedButton = false
    
    var body: some View {
        VStack {
            VStack {
                Text(NSLocalizedString("Количество кубиков", comment: ""))
                    .font(.robotoMedium20())
                    .foregroundColor(.primaryGray())
                
                Picker(selection: $selectedCube,
                       label: Text("Picker")) {
                    ForEach(0..<countCube.count) {
                        Text("\(countCube[$0])")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 16)
                .padding(.horizontal, 16)
            }
            .padding(.top, 16)
            
            Spacer()
            
            if !appBinding.cube.listResult.wrappedValue.isEmpty {
                content
                    .opacity(isPressedButton ? 0.8 : 1)
                    .scaleEffect(isPressedButton ? 0.8 : 1)
                    .animation(.easeInOut(duration: 0.2), value: isPressedButton)
            } else {
                Text("?")
                    .font(.robotoBold70())
                    .foregroundColor(.primaryGray())
                    .opacity(isPressedButton ? 0.8 : 1)
                    .scaleEffect(isPressedButton ? 0.8 : 1)
                    .animation(.easeInOut(duration: 0.2), value: isPressedButton)
            }
            
            Spacer()
            listResults
            generateButton
        }.onAppear(perform: {
            AppMetrics.trackEvent(name: .cubeScreen)
        })
        .navigationBarTitle(Text(NSLocalizedString("Кубики", comment: "")), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            appBinding.cube.showSettings.wrappedValue.toggle()
        }) {
            Image(systemName: "gear")
                .font(.system(size: 24))
        })
        .sheet(isPresented: appBinding.cube.showSettings, content: {
            CubeSettingsView(appBinding: appBinding)
        })
    }
}

private extension CubeView {
    private var content: AnyView {
        switch appBinding.cube.selectedCube.wrappedValue {
        case 0:
            return AnyView(cubeOneView)
        case 1:
            return AnyView(cubeTwoView)
        case 2:
            return AnyView(cubeThreeView)
        case 3:
            return AnyView(cubeFourView)
        case 4:
            return AnyView(cubeFiveView)
        case 5:
            return AnyView(cubeSixView)
        default:
            return AnyView(cubeOneView)
        }
    }
}

private extension CubeView {
    var cubeOneView: some View {
        VStack {
            BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeOne.wrappedValue - 1)
        }
    }
}

private extension CubeView {
    var cubeTwoView: some View {
        HStack {
            BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeOne.wrappedValue - 1)
            BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeTwo.wrappedValue - 1)
        }
    }
}

private extension CubeView {
    var cubeThreeView: some View {
        VStack {
            BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeOne.wrappedValue - 1)
            HStack {
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeTwo.wrappedValue - 1)
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeThree.wrappedValue - 1)
            }
        }
    }
}

private extension CubeView {
    var cubeFourView: some View {
        VStack {
            HStack {
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeOne.wrappedValue - 1)
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeTwo.wrappedValue - 1)
            }
            HStack {
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeThree.wrappedValue - 1)
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeFour.wrappedValue - 1)
            }
        }
    }
}

private extension CubeView {
    var cubeFiveView: some View {
        VStack {
            BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeOne.wrappedValue - 1)
            
            HStack {
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeTwo.wrappedValue - 1)
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeThree.wrappedValue - 1)
            }
            HStack {
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeFour.wrappedValue - 1)
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeFive.wrappedValue - 1)
            }
        }
    }
}

private extension CubeView {
    var cubeSixView: some View {
        VStack {
            HStack {
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeOne.wrappedValue - 1)
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeTwo.wrappedValue - 1)
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeThree.wrappedValue - 1)
            }
            HStack {
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeFour.wrappedValue - 1)
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeFive.wrappedValue - 1)
                BoxCellCubeOneView(selectedCubeView: appBinding.cube.cubeSix.wrappedValue - 1)
            }
        }
    }
}

private extension CubeView {
    var listResults: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(appBinding.cube.listResult
                                .wrappedValue.enumerated()), id: \.0) { (index, sum) in
                    
                    if index == 0 {
                        TextRoundView(name: "\(sum)")
                            .opacity(isPressedButton ? 0.8 : 1)
                            .scaleEffect(isPressedButton ? 0.9 : 1)
                            .animation(.easeInOut(duration: 0.1), value: isPressedButton)
                    } else {
                        Text("\(sum)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                }
            }
            .padding(.leading, 16)
            .padding(.vertical, 16)
        }
    }
}

private extension CubeView {
    var generateButton: some View {
        Button(action: {
            appBinding.cube.selectedCube.wrappedValue = selectedCube
            generateCube(state: appBinding)
            saveCubeToUserDefaults(state: appBinding)
            actionButton?()
            Feedback.shared.impactHeavy(.medium)
        }) {
            AppButtonView(textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Бросить кубик(и)", comment: ""),
                       switchImage: false,
                       image: "")
        }
        .opacity(isPressedButton ? 0.8 : 1)
        .scaleEffect(isPressedButton ? 0.9 : 1)
        .animation(.easeInOut(duration: 0.1))
        .pressAction {
            isPressedButton = true
        } onRelease: {
            isPressedButton = false
        }
        .padding(16)
    }
}

// MARK: Actions
private extension CubeView {
    private func generateCube(state: Binding<AppState.AppData>) {
        injected.interactors.cubeInterator
            .generateCube(state: state)
    }
}

private extension CubeView {
    private func saveCubeToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.cubeInterator
            .saveCubeToUserDefaults(state: state)
    }
}

struct CubeView_Previews: PreviewProvider {
    static var previews: some View {
        CubeView(appBinding: .constant(.init()), actionButton: nil)
    }
}
