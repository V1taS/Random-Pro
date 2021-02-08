//
//  NumberResultsView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct NumberResultsView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    
    var body: some View {
        VStack {
            listResults
                .sheet(isPresented: appBinding.numberRandom.showShareSheet) {
                    ShareSheet(activityItems: [generateSend])
                }
        }
        .navigationBarTitle(Text("Список чисел"), displayMode: .inline)
//        .navigationBarItems(trailing: showShareSheetButton)
        
        
    }
}

private extension NumberResultsView {
    var listResults: some View {
        List {
                ForEach(appBinding.numberRandom.listResult.wrappedValue, id: \.self) { number in
                    
                    HStack {
                        Spacer()
                        Text("\(number)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                    }
                }
        }
    }
}

// MARK: UI
private extension NumberResultsView {
    private var showShareSheetButton: AnyView {
        AnyView(
            Button(action: {
                sendInvite()
            }) {
                Image(systemName: "arrowshape.turn.up.right.circle")
                    .font(.title)
            }
        )
    }
}


// MARK: Actions
private extension NumberResultsView {
    private func sendInvite() {
        appBinding.numberRandom.showShareSheet.wrappedValue.toggle()
    }
}

private extension NumberResultsView {
    private func generateSend() -> String {
        var send = ""
        var count = 0
        
        for num in appBinding.numberRandom.listResult.wrappedValue {
            count += 1
            let numStr = "\(num)"
            send += numStr
            
            if appBinding.numberRandom.listResult.wrappedValue.count == count {
                send += "."
            } else {
                if !send.isEmpty {
                    send += ", "
                }
            }
        }
        return send
    }
}

struct NumberResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NumberResultsView(appBinding: .constant(.init()))
    }
}
