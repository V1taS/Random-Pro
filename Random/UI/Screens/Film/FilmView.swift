//
//  FilmView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct FilmView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    @State private var isPressedButton = false
    @State private var isPressedTouch = false
    @State private var name = "?"
    @State private var image = UIImage(named: "filmIMG")
    
    var body: some View {
        ZStack {
            Color(.clear)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Image(uiImage: image!)
//                    .resizable()
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.clear)))
                    .frame(maxHeight: 300)
                    .padding(.horizontal, 16)
                    .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 320),
                           height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 280))
                
                Text(name)
                    .font(.robotoBold70())
                    .foregroundColor(.primaryGray())
                    .padding(.horizontal, 16)
                    .opacity(isPressedButton || isPressedTouch ? 0.8 : 1)
                    .scaleEffect(isPressedButton || isPressedTouch ? 0.8 : 1)
                    .animation(.easeInOut(duration: 0.2), value: isPressedButton || isPressedTouch)
                
                Spacer()
                
                generateButton
            }
            .padding(.top, 16)
            
            .navigationBarTitle(Text(NSLocalizedString("Контакт", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                appBinding.contact.showSettings.wrappedValue.toggle()
            }) {
                Image(systemName: "gear")
                    .font(.system(size: 24))
            })
            .sheet(isPresented: appBinding.contact.showSettings, content: {
                ContactSettingsView(appBinding: appBinding)
            })
        }
        .dismissingKeyboard()
    }
}

private extension FilmView {
    var generateButton: some View {
        Button(action: {
            Networking.share.getMovies { films in
                let randomNum = Int.random(in: 0...films.data.count - 1)
                name = "\(films.data.count)"
                
                var request = URLRequest(url: URL(string: "https://kinopoiskapiunofficial.tech/api/v2.1/films/\(String(describing: films.data[randomNum].kinopoiskID))/frames")!)
                request.httpMethod = "GET"
                request.setValue("f835989c-b489-4624-9209-6d93bfead535", forHTTPHeaderField: "X-API-KEY")
                let session = URLSession(configuration: URLSessionConfiguration.default)
                session.dataTask(with: request as URLRequest) { [self] (data, response, error) -> Void in
                    do {
                        let filmsInfo = try JSONDecoder().decode(FramesFilms.self, from: data!)
                        if filmsInfo.frames?[0].preview != nil {
                            let url = URL(string: filmsInfo.frames![0].preview!)
                            Networking.share.downloadedImageFilm(from: url!) { uiImage in
                                image = uiImage
                            }
                        }
                    } catch {
                        print("error: ", error)
                    }
                }.resume()
                
            }
//            generateContacts(state: appBinding)
//            saveContactToUserDefaults(state: appBinding)
            Feedback.shared.impactHeavy(.medium)
        }) {
            ButtonView(background: .primaryTertiary(),
                       textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Сгенерировать", comment: ""),
                       switchImage: false,
                       image: "")
        }
        .opacity(isPressedButton ? 0.8 : 1)
        .scaleEffect(isPressedButton ? 0.9 : 1)
        .animation(.easeInOut(duration: 0.1))
        .pressAction {
            isPressedButton = true
        } onRelease: {
            isPressedButton = false
        }
        .padding(16)
    }
}

struct FilmView_Previews: PreviewProvider {
    static var previews: some View {
        FilmView(appBinding: .constant(.init()))
    }
}
