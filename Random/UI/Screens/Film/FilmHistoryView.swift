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
        Form {
            ForEach(Array(appBinding.film.filmsHistory.wrappedValue.enumerated()), id: \.0) { (index, film) in
                
                VStack {
                    NavigationLink(
                        destination: FilmInformationAllFilmView(filmsInfo: film, iframeSrc: (appBinding.film.filmsVideoHistory.wrappedValue[index].iframeSrc!), appBinding: appBinding)
                            .allowAutoDismiss { false }) {
                        
                        VStack(spacing: 4) {
                            HStack {
                                Text(NSLocalizedString("домен", comment: "") == "ru" ? "\(film.data?.nameRu ?? "нет")" : "\(film.data?.nameEn ?? "нет")")
                                    .foregroundColor(.primaryGray())
                                    .font(.robotoMedium18())
                                Spacer()
                            }
                            
                            HStack {
                                Text("Год: \(film.data?.year ?? "")")
                                    .foregroundColor(.primaryGray())
                                    .font(.robotoRegular16())
                                Spacer()
                            }
                        }

                        WebImage(url: URL(string: film.data?.posterUrlPreview ?? ""))
                            .resizable()
                            .renderingMode(.original)
                            .onSuccess { image, data, cacheType in }
                            .placeholder(Image("no_image"))
                            .indicator(.activity)
                            .frame(width: 70, height: 100)
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

struct FilmHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        FilmHistoryView(appBinding: .constant(.init()))
    }
}
