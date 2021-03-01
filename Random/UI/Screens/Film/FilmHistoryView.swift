//
//  FilmHistoryView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 01.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct FilmHistoryView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    
    var body: some View {
        VStack {
            listResults
        }
        .navigationBarTitle(Text(NSLocalizedString("История генерации", comment: "")), displayMode: .inline)
    }
}

private extension FilmHistoryView {
    var listResults: some View {
        List {
            ForEach(Array(appBinding.film.filmsHistory.wrappedValue.enumerated()), id: \.0) { (index, film) in
                
                HStack(spacing: 16) {
                    NavigationLink(
                        destination: FilmInformationView(filmsInfo: film, iframeSrc: (appBinding.film.filmsVideoHistory.wrappedValue[index].iframeSrc!))
                            .allowAutoDismiss { false }) {
                        
                        Text(NSLocalizedString("домен", comment: "") == "ru" ? "\(film.data?.nameRu ?? "нет")" : "\(film.data?.nameEn ?? "нет")")
                            .gradientForeground(colors: [Color.primaryGreen(), Color.primaryTertiary()])
                            .font(.robotoMedium18())

                        Spacer()
                        
                        WebImage(url: URL(string: film.data?.posterUrlPreview ?? ""))
                            .resizable()
                            .renderingMode(.original)
                            .onSuccess { image, data, cacheType in }
                            .placeholder(Image("no_image"))
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFill()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 70)
                    }
                }
            }
        }
    }
}

struct FilmHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        FilmHistoryView(appBinding: .constant(.init()))
    }
}
