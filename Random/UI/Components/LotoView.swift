//
//  LotoView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.02.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

struct LotoView: View {
    
    @State var attempts: Int = .zero
    
    @State var kegs: [KegView] = []
    
    var body: some View {
        ZStack {
            
            VStack {
                
            }
            VStack {
                Spacer()
                Image("bag")
                    .resizable()
                    .frame(width: 300, height: 300, alignment: .center)
                    .offset(y: 150)
                    .modifier(Shake(animatableData: CGFloat(attempts)))
                    .onTapGesture {
                        let keg = KegView(number: "55", offsetX: .zero, offsetY: 100, rotation: .constant(.zero))
                        kegs.append(keg)
                        
                        withAnimation(.easeInOut(duration: 1)) {
                            attempts += 1
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                            kegs.first!.offsetY = 0
                        }
                    }
            }
        }
    }
}

//private extension LotoView {
//    mutating func createKegView(number: String) {
//
//    }
//}

struct LotoView_Previews: PreviewProvider {
    static var previews: some View {
        LotoView()
    }
}
