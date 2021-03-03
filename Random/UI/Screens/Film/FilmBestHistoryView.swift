//
//  FilmBestHistoryView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 03.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct FilmBestHistoryView: View {
    
    private var filmsBest: [BestFilm]
    init(filmsBest: [BestFilm]) {
        self.filmsBest = filmsBest
    }
    
    var body: some View {
        VStack {
            listResults
        }
        .navigationBarTitle(Text(NSLocalizedString("История генерации", comment: "")), displayMode: .inline)
    }
}

private extension FilmBestHistoryView {
    var listResults: some View {
        Form {
            ForEach(Array(filmsBest.enumerated()), id: \.0) { (index, film) in
                
                VStack {
                    NavigationLink(
                        destination: FilmInformationBestFilmView(filmsInfo: film, iframeSrc: "").allowAutoDismiss { false },
                        label: {
                            VStack(spacing: 4) {
                                HStack {
                                    Text(NSLocalizedString("домен", comment: "") == "ru" ? "\(film.nameRu ?? "нет")" : "\(film.nameEn ?? "no")")
                                        .foregroundColor(.primaryGray())
                                        .font(.robotoMedium18())
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("Год: \(film.year ?? "")")
                                        .foregroundColor(.primaryGray())
                                        .font(.robotoRegular16())
                                    Spacer()
                                }
                            }
                            
                            WebImage(url: URL(string: film.posterUrlPreview ?? ""))
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
                        })
                }
            }
        }
    }
}

struct FilmBestHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        FilmBestHistoryView(filmsBest: .init())
    }
}
