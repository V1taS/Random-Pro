//
//  FilmInformationBestFilmView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct FilmInformationBestFilmView: View {
    private var filmsInfo: KinopoiskBestFilmsResult.BestFilm
    private var iframeSrc: String
    
    init(filmsInfo: KinopoiskBestFilmsResult.BestFilm, iframeSrc: String) {
        self.filmsInfo = filmsInfo
        self.iframeSrc = iframeSrc
    }
    
    var body: some View {
        VStack {
            listResults
        }
        .navigationBarTitle(Text(NSLocalizedString("Информация по фильму", comment: "")), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            getLinkFromStringURL(strURL: iframeSrc)
        }) {
            Image(systemName: "play.rectangle")
                .font(.system(size: 24))
                .gradientForeground(colors: [Color.primaryError(), Color.red]).opacity(0.5)
                .hidden()
        })
    }
}

private extension FilmInformationBestFilmView {
    var listResults: some View {
        List {
            HStack(spacing: 16) {
                Text(NSLocalizedString("Название фильма:", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
                
                Spacer()
                
                Text(NSLocalizedString("домен", comment: "") == "ru" ? "\(filmsInfo.nameRu ?? "")" : "\(filmsInfo.nameEn ?? "")")
                    .foregroundColor(.primaryGray())
                    .font(.robotoRegular16())
            }
            
            HStack(spacing: 16) {
                Text(NSLocalizedString("Год:", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
                
                Spacer()
                
                Text("\(filmsInfo.year ?? "")")
                    .foregroundColor(.primaryGray())
                    .font(.robotoRegular16())
            }
            
            HStack(spacing: 16) {
                Text(NSLocalizedString("Продолжительность фильма:", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
                
                Spacer()
                
                Text("\(filmsInfo.filmLength ?? "")")
                    .foregroundColor(.primaryGray())
                    .font(.robotoRegular16())
            }
            
            HStack(spacing: 16) {
                Text(NSLocalizedString("Жанр:", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
                
                Spacer()
                
                Text("\(filmsInfo.genres?.first?.genre?.firstUppercased ?? "-")")
                    .foregroundColor(.primaryGray())
                    .font(.robotoRegular16())
            }
            
            HStack(spacing: 16) {
                Text(NSLocalizedString("Страна:", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
                
                Spacer()
                
                Text("\(filmsInfo.countries?.first?.country ?? "-")")
                    .foregroundColor(.primaryGray())
                    .font(.robotoRegular16())
            }
            
            HStack(spacing: 16) {
                Text(NSLocalizedString("Рейтинг:", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
                
                Spacer()
                
                Text("\(filmsInfo.rating ?? "-")")
                    .foregroundColor(.primaryGray())
                    .font(.robotoRegular16())
            }
        }
    }
}


struct FilmInformationBestFilmView_Previews: PreviewProvider {
    static var previews: some View {
        FilmInformationBestFilmView(filmsInfo: KinopoiskBestFilmsResult.plug, iframeSrc: "")
    }
}
