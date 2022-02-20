//
//  LotoView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.02.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

struct LotoView: View {
    
    private var appBinding: Binding<AppState.AppData>
    private var actionButton: (() -> Void)?
    
    init(appBinding: Binding<AppState.AppData>, actionButton: (() -> Void)?) {
        self.appBinding = appBinding
        self.actionButton = actionButton
    }
    @Environment(\.injected) private var injected: DIContainer
    
    @State var attempts: Int = .zero
    @State var currentKegOffsetY: CGFloat = 0
    @State var currentKegIsHidden = false
    @State var currentKeg = 0
    
    @State var kegs: [AnyView] = []
    
    @State var isDisableBag = false
    
    var body: some View {
        ZStack {
            VStack {
                makeGrid()
                    .padding(.vertical, 8)
                    .background(Color.primaryPale())
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4)
                                .stroke(Color(.primaryDefault())))
                    .frame(height: UIScreen.screenHeight / 2 - 80)
                
                    .padding(.horizontal, 16)
                
                Spacer()
            }
            
            VStack {
                Spacer()
                KegView(number: "\(appBinding.russianLotto.currentKegNumber.wrappedValue)", rotation: .constant(.zero))
                    .offset(x: 0, y: currentKegOffsetY)
                    .opacity(currentKegIsHidden ? 0 : 1)
                    .animation(.spring())
            }
            
            VStack {
                Spacer()
                bagImage
                    .offset(y: 150)
                    .modifier(Shake(animatableData: CGFloat(attempts)))
                    .onTapGesture {
                        guard appBinding.russianLotto.kegsNumber.wrappedValue.count != 0 else { return }
                        Feedback.shared.impactHeavy(.medium)
                        isDisableBag = true
                        actionButton?()
                        
                        currentKegIsHidden = true
                        
                        withAnimation(.easeInOut(duration: 1)) {
                            attempts += 1
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            getCurrentKeg(state: appBinding)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            currentKegOffsetY = 0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                            currentKegIsHidden = false
                            currentKegOffsetY = -(UIScreen.screenHeight / 2 - 150)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                kegs.append(AnyView(KegMiniView(number: "\(appBinding.russianLotto.currentKegNumber.wrappedValue)", rotation: .constant(.zero))))
                                saveRussianLottoToUserDefaults(state: appBinding)
                                isDisableBag = false
                            }
                        }
                    }
                    .disabled(isDisableBag)
            }
            
        }
        .onAppear {
            generateKegs(state: appBinding)
            if kegs.isEmpty {
                for number in appBinding.russianLotto.kegsNumberDesk.wrappedValue {
                    kegs.append(AnyView(KegMiniView(number: "\(number)", rotation: .constant(.zero))))
                }
            }
        }
        .navigationBarItems(trailing: HStack(spacing: 24) {
            Spacer()
            navigationButtonReset
        })
    }
}

private extension LotoView {
    var navigationButtonReset: some View {
        Button(action: {
            currentKegIsHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                cleanKegs(state: appBinding)
                generateKegs(state: appBinding)
                kegs = []
                saveRussianLottoToUserDefaults(state: appBinding)
            }
        }) {
            Image(systemName: "trash")
                .font(.system(size: 16))
                .foregroundColor(.blue)
        }
    }
}

private extension LotoView {
    var bagImage: some View {
        ZStack {
            Image("bag")
                .resizable()
                .frame(width: 300, height: 300, alignment: .center)
            
            Text("\(appBinding.russianLotto.kegsNumber.wrappedValue.count)")
                .gradientForeground(colors: [Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))]).opacity(0.4)
                .lineLimit(1)
                .font(.robotoBold40())
                .offset(x: 18, y: -20)
            
            
        }
    }
}

private extension LotoView {
    private func makeGrid() -> some View {
        let columns = 6
        let count = kegs.count
        let rows = count / columns + (count % columns == 0 ? 0 : 1)
        
        return ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(alignment: .center, spacing: 16) {
                        ForEach(0..<columns, id: \.self) { column -> AnyView in
                            let index = row * columns + column
                            if index < count {
                                let view = kegs[index]
                                return AnyView(view)
                            } else {
                                return AnyView(EmptyView())
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: Actions
private extension LotoView {
    func generateKegs(state: Binding<AppState.AppData>) {
        injected.interactors.russianLottoInteractor
            .generateKegs(state: state)
    }
    
    func getCurrentKeg(state: Binding<AppState.AppData>) {
        injected.interactors.russianLottoInteractor
            .getCurrentKeg(state: state)
    }
    
    func cleanKegs(state: Binding<AppState.AppData>) {
        injected.interactors.russianLottoInteractor
            .cleanKegs(state: state)
    }
    
    private func saveRussianLottoToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.russianLottoInteractor
            .saveRussianLottoToUserDefaults(state: state)
    }
}

struct LotoView_Previews: PreviewProvider {
    static var previews: some View {
        LotoView(appBinding: .constant(.init()), actionButton: nil)
    }
}
