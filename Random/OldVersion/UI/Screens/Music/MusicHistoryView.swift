//
//  MusicHistoryView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 18.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MusicHistoryView: View {
    
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

private extension MusicHistoryView {
    var listResults: some View {
        Form {
            ForEach(Array(appBinding.music.listMusicHistory.wrappedValue.enumerated()), id: \.0) { (index, music) in
                
                HStack {
                    VStack(spacing: 4) {
                        HStack {
                            Text("\(music.attributes?.name ?? "Название песни")")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            Spacer()
                        }
                        
                        HStack {
                            Text("\(music.attributes?.artistName ?? "Имя артиста")")
                                .foregroundColor(.primaryGray())
                                .font(.robotoRegular16())
                            Spacer()
                        }
                        
                        HStack {
                            Text("\(music.attributes?.releaseDate ?? "")")
                                .foregroundColor(.primaryGray())
                                .font(.robotoRegular16())
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    WebImage(url: URL(string: music.attributes?.artwork?.url?.replacingOccurrences(of: "{w}", with: "100").replacingOccurrences(of: "{h}", with: "100") ?? ""))
                        .resizable()
                        .renderingMode(.original)
                        .onSuccess { image, data, cacheType in }
                        .placeholder(Image("no_image"))
                        .indicator(.activity)
                        .frame(width: 100, height: 100)
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

struct MusicHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        MusicHistoryView(appBinding: .constant(.init()))
    }
}
