//
//  TravelHistoryView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct TravelHistoryView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        VStack {
            listResults
        }
        
        .navigationBarTitle(Text(NSLocalizedString("История генерации", comment: "")), displayMode: .inline)
    }
}

private extension TravelHistoryView {
    var listResults: some View {
        Form {
            ForEach(Array(appBinding.film.filmsHistory.wrappedValue.enumerated()), id: \.0) { (index, film) in
                
                NavigationLink(destination: EmptyView().allowAutoDismiss(false)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(NSLocalizedString("СТРАНА", comment: ""))
                                    .font(UIScreen.screenHeight < 700 ? .robotoMedium10() : .robotoRegular18())
                                    .lineLimit(1)
                                    .foregroundColor(.primaryInactive())
                                
                                Text("Россия")
                                    .font(UIScreen.screenHeight < 700 ? .robotoMedium14() : .robotoMedium20())
                                    .lineLimit(1)
                                    .foregroundColor(.black)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(NSLocalizedString("ДАТА ВЫЛЕТА", comment: ""))
                                    .font(UIScreen.screenHeight < 700 ? .robotoMedium10() : .robotoRegular18())
                                    .lineLimit(1)
                                    .foregroundColor(.primaryInactive())
                                
                                Text("26 июня")
                                    .font(UIScreen.screenHeight < 700 ? .robotoMedium14() : .robotoMedium20())
                                    .lineLimit(1)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Spacer()
                        
                        WebImage(url: URL(string: ""))
                            .resizable()
                            .renderingMode(.original)
                            .onSuccess { image, data, cacheType in }
                            .placeholder(Image("no_image"))
                            .indicator(.activity)
                            .frame(width: 170, height: 125)
                            .transition(.fade(duration: 0.5))
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.systemGray4)))
                    }
                }
            }
        }
    }
}

struct TravelHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        TravelHistoryView(appBinding: .constant(.init()))
    }
}
