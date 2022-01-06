//
//  AddPlayerSheet.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 14.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct AddPlayerSheet: View {
    
    var appBinding: Binding<AppState.AppData>
    @Environment(\.injected) private var injected: DIContainer
    
    @State var viewState = CGSize.zero
    var isExpanded: Bool {
        appBinding.team.showAddPlayer.wrappedValue
    }
    
    var body: some View {
        ZStack {

            
            if appBinding.team.showAddPlayer.wrappedValue {
                VStack(spacing: 0) {
                    divider
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text(NSLocalizedString("Добавить игрока", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium32())
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            Image("\(appBinding.team.playerImageTemp.wrappedValue)")
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                            Spacer()
                        }
                        .padding(.top, 16)
                        
                        HStack {
                            Spacer()
                            TextField
                            Spacer()
                        }
                        .padding(.top, 16)
                        
                        HStack {
                            Spacer()
                            generateButton
                            Spacer()
                        }
                        .padding(.top, 16)
                        
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 24)
                    
                    Color.clear
                        .frame(height: 104)
                        .padding(.horizontal, 24)
                }
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: Color(.black)
                            .opacity(self.viewState.height == 0 ? 0.2 : 0),
                        radius: 5)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5))
            }
        }
        .offset(y: offset())
        .gesture(
            DragGesture().onChanged { value in
                self.viewState = value.translation
            }
            .onEnded(onDragEnded)
        )
    }
}

// MARK: UI

private extension AddPlayerSheet {
    var TextField: some View {
        HStack {
            TextFieldUIKit(placeholder: NSLocalizedString("Напишите имя", comment: ""),
                           text: appBinding.team.playerNameTF,
                           font: UIFont.robotoMedium16()!,
                           foregroundColor: UIColor.primaryGray(),
                           keyType: .default,
                           isSecureText: false,
                           textAlignment: .center,
                           limitLength: 20)
                .frame(height: 40)
                .background(Color.white)
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.primaryDefault())))
                .foregroundColor(.clear)
        }
        .padding(.horizontal, 16)
    }
}

private extension AddPlayerSheet {
    var generateButton: some View {
        Button(action: {
            if !appBinding.team.playerNameTF.wrappedValue.isEmpty {
                createPlayer(state: appBinding)
                appBinding.team.playerNameTF.wrappedValue = ""
                appBinding.team.showAddPlayer.wrappedValue = false

                    saveTeamToUserDefaults(state: appBinding)
                
                Feedback.shared.impactHeavy(.medium)
            }
        }) {
            ButtonView(textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Добавить", comment: ""),
                       switchImage: false,
                       image: "")
        }
        .padding(.horizontal, 16)
    }
}

private extension AddPlayerSheet {
    private var divider: AnyView {
        AnyView(
            Color(.primaryDivider())
                .frame(width: 48, height: 5)
                .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(.clear)))
                .offset(y: 10)
        )
    }
}


// MARK: Actions
private extension AddPlayerSheet {
    private func onDragEnded(drag: DragGesture.Value) {
        self.viewState = .zero
        let direction = drag.predictedEndLocation.y - drag.location.y
        
        if direction > 200 {
            self.collapse()
        } else {
            self.expand()
        }
    }

    private func offset()  -> CGFloat {
        var offset: CGFloat = 0
        if self.isExpanded {
            offset = 0 + self.viewState.height
        } else {
            offset = 500 + self.viewState.height
        }
        
        return offset < 0 ? 0 : offset > 500 ? 500 : offset
    }

    private func collapse() {
        appBinding.team.showAddPlayer.wrappedValue = false
    }

    private func expand() {
        
    }
}

private extension AddPlayerSheet {
    func createPlayer(state: Binding<AppState.AppData>) {
        injected.interactors.teamInteractor
            .createPlayer(state: state)
    }
}

private extension AddPlayerSheet {
    private func saveTeamToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.teamInteractor
            .saveTeamToUserDefaults(state: state)
    }
}


struct AddPlayerSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddPlayerSheet(appBinding: .constant(.init()))
    }
}
