//
//  TravelSettingsView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct TravelSettingsView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    @State var departure = [NSLocalizedString("Сегодня", comment: ""),
                            NSLocalizedString("На неделе", comment: ""),
                            NSLocalizedString("В этом месяце", comment: "")
    ]
    
    @State var stars = [NSLocalizedString("не важно", comment: ""), "★★★★", "★★★★★"]
    @State var pansions = [NSLocalizedString("любое", comment: ""), "RO", "BB", "HB", "FB", "AL"]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    
                    Group {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(NSLocalizedString("Дата вылета:", comment: ""))
                                    .foregroundColor(.primaryGray())
                                    .font(.robotoMedium18())
                                pickerViewSelectedDeparture
                            }
                        }
                        .padding(.vertical, 8)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(NSLocalizedString("Количество звезд у отеля:", comment: ""))
                                    .foregroundColor(.primaryGray())
                                    .font(.robotoMedium18())
                                
                                pickerViewStarsForHotel
                            }
                        }
                        .padding(.vertical, 8)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(NSLocalizedString("Питание", comment: ""))
                                    .foregroundColor(.primaryGray())
                                    .font(.robotoMedium18())
                                
                                pickerViewPansions
                                descriptionPansions
                            }
                        }
                        .padding(.vertical, 8)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(NSLocalizedString("Количество ночей:", comment: ""))
                                    .foregroundColor(.primaryGray())
                                    .font(.robotoMedium18())
                                
                                textFieldCountOfNight
                            }
                        }
                        .padding(.vertical, 8)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(NSLocalizedString("Количество взрослых:", comment: ""))
                                    .foregroundColor(.primaryGray())
                                    .font(.robotoMedium18())
                                
                                textFieldCountAdults
                            }
                        }
                        .padding(.vertical, 8)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(NSLocalizedString("Стоимость тура:", comment: ""))
                                    .foregroundColor(.primaryGray())
                                    .font(.robotoMedium18())
                                
                                costTextFields
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    
                    HStack {
                        NavigationLink(
                            destination: filmInformation
                                .allowAutoDismiss { false }) {
                            Text(NSLocalizedString("Информация по туру", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    
                    HStack {
                        travelHistory
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    
                    HStack {
                        Text(NSLocalizedString("Всего сгенерировано", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        filmsCountGenerate
                    }
                    .padding(.vertical, 8)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            cleanFilms(state: appBinding)
                            appBinding.film.showSettings.wrappedValue = false
                            getMovies(state: appBinding)
                            saveFilmsToUserDefaults(state: appBinding)
                            Feedback.shared.impactHeavy(.medium)
                        }) {
                            Text(NSLocalizedString("Очистить", comment: ""))
                                .font(.robotoRegular16())
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Настройки", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                appBinding.travel.showSettings.wrappedValue = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.primaryGray())
            })
        }
    }
}

private extension TravelSettingsView {
    private var travelHistory: AnyView {
        switch appBinding.travel.selectedPlace.wrappedValue {
        case 0:
            return AnyView(NavigationLink(
                destination: TravelHistoryView(appBinding: appBinding)
                    .allowAutoDismiss { false }) {
                Text(NSLocalizedString("История генерации", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
            })
        case 1:
            return AnyView(NavigationLink(
                destination: FilmBestHistoryView(filmsBest: appBinding.film.filmsPopularHistory.wrappedValue)
                    .allowAutoDismiss { false }) {
                Text(NSLocalizedString("История генерации", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
            })
        case 2:
            return AnyView(NavigationLink(
                destination: FilmHistoryView(appBinding: appBinding)
                    .allowAutoDismiss { false }) {
                Text(NSLocalizedString("История генерации", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
            })
        default:
            return AnyView(Text("Error"))
        }
    }
}

private extension TravelSettingsView {
    private var filmsCountGenerate: AnyView {
        switch appBinding.film.selectedGenres.wrappedValue {
        case 0:
            return AnyView(Text("\(appBinding.film.filmsBestHistory.wrappedValue.count)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16()))
        case 1:
            return AnyView(Text("\(appBinding.film.filmsPopularHistory.wrappedValue.count)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16()))
        case 2:
            return AnyView(Text("\(appBinding.film.filmsHistory.wrappedValue.count)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16()))
        default:
            return AnyView(Text("Error"))
        }
    }
}

private extension TravelSettingsView {
    private var filmInformation: AnyView {
        switch appBinding.travel.selectedPlace.wrappedValue {
        case 0:
            return AnyView(TravelInformationView(appBinding: appBinding))
        case 1:
            return AnyView(FilmInformationBestFilmView(
                            filmsInfo: appBinding.film.filmsPopularInfo.wrappedValue,
                            iframeSrc: ""))
        case 2:
            return AnyView(FilmInformationAllFilmView(
                            filmsInfo: appBinding.film.filmInfo.wrappedValue,
                            appBinding: appBinding))
        default:
            return AnyView(Text("Error"))
        }
    }
}

private extension TravelSettingsView {
    var pickerViewSelectedDeparture: some View {
        VStack {
            Picker(selection: appBinding.travel.selectedDeparture,
                   label: Text("Picker")) {
                ForEach(0..<departure.count, id: \.self) {
                    Text("\(departure[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

private extension TravelSettingsView {
    var pickerViewStarsForHotel: some View {
        VStack {
            Picker(selection: appBinding.travel.selectedStars,
                   label: Text("Picker")) {
                ForEach(0..<stars.count, id: \.self) {
                    Text("\(stars[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

private extension TravelSettingsView {
    var pickerViewPansions: some View {
        VStack {
            Picker(selection: appBinding.travel.selectedPansions,
                   label: Text("Picker")) {
                ForEach(0..<pansions.count, id: \.self) {
                    Text("\(pansions[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

private extension TravelSettingsView {
    var descriptionPansions: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("RO -")
                        .font(.robotoMedium14())
                        .lineLimit(1)
                        .foregroundColor(.primaryInactive())
                    
                    Text(NSLocalizedString("без питания", comment: ""))
                        .font(.robotoMedium14())
                        .lineLimit(1)
                        .foregroundColor(.black)
                }
                
                HStack {
                    Text("BB -")
                        .font(.robotoMedium14())
                        .lineLimit(1)
                        .foregroundColor(.primaryInactive())
                    
                    Text(NSLocalizedString("завтрак", comment: ""))
                        .font(.robotoMedium14())
                        .lineLimit(1)
                        .foregroundColor(.black)
                }
                
                HStack {
                    Text("AL -")
                        .font(.robotoMedium14())
                        .lineLimit(1)
                        .foregroundColor(.primaryInactive())
                    
                    Text(NSLocalizedString("все включено", comment: ""))
                        .font(.robotoMedium14())
                        .lineLimit(1)
                        .foregroundColor(.black)
                }
            }
            
            
            Spacer(minLength: 16)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("HB -")
                        .font(.robotoMedium14())
                        .lineLimit(1)
                        .foregroundColor(.primaryInactive())
                    
                    Text(NSLocalizedString("завтрак + ужин", comment: ""))
                        .font(.robotoMedium14())
                        .lineLimit(1)
                        .foregroundColor(.black)
                }
                
                HStack {
                    Text("FB -")
                        .font(.robotoMedium14())
                        .lineLimit(1)
                        .foregroundColor(.primaryInactive())
                    
                    Text(NSLocalizedString("завтрак, обед, ужин", comment: ""))
                        .font(.robotoMedium14())
                        .lineLimit(1)
                        .foregroundColor(.black)
                }
            }
        }
    }
}

private extension TravelSettingsView {
    var textFieldCountOfNight: some View {
        HStack {
            TextFieldUIKit(placeholder: NSLocalizedString("Не обязательное поле", comment: ""),
                           text: appBinding.travel.countOfNight,
                           font: UIFont.robotoMedium16()!,
                           foregroundColor: UIColor.primaryGray(),
                           keyType: .numberPad,
                           isSecureText: false,
                           textAlignment: .center,
                           limitLength: 3)
                .frame(height: 30, alignment: .center)
                .background(Color.primaryPale())
                .cornerRadius(4)
                .foregroundColor(.clear)
        }
    }
}

private extension TravelSettingsView {
    var textFieldCountAdults: some View {
        HStack {
            TextFieldUIKit(placeholder: NSLocalizedString("Обязательное поле", comment: ""),
                           text: appBinding.travel.countAdults,
                           font: UIFont.robotoMedium16()!,
                           foregroundColor: UIColor.primaryGray(),
                           keyType: .numberPad,
                           isSecureText: false,
                           textAlignment: .center,
                           limitLength: 3)
                .frame(height: 30, alignment: .center)
                .background(Color.primaryPale())
                .cornerRadius(4)
                .foregroundColor(.clear)
        }
    }
}

private extension TravelSettingsView {
    var costTextFields: some View {
        HStack(spacing: 36) {
            VStack {
                HStack(spacing: 4) {
                    Text(NSLocalizedString("от:", comment: ""))
                        .foregroundColor(.black)
                        .font(.robotoMedium18())
                    
                    costFrom
                    
                    Text("₽")
                        .foregroundColor(.black)
                        .font(.robotoMedium18())
                }
            }
            
            VStack {
                HStack(spacing: 4) {
                    Text(NSLocalizedString("до:", comment: ""))
                        .foregroundColor(.black)
                        .font(.robotoMedium18())
                    
                    costUpTo
                    
                    Text("₽")
                        .foregroundColor(.black)
                        .font(.robotoMedium18())
                }
            }
        }
    }
}

private extension TravelSettingsView {
    var costFrom: some View {
        HStack {
            TextFieldUIKit(placeholder: "-",
                           text: appBinding.travel.costFrom,
                           font: UIFont.robotoMedium16()!,
                           foregroundColor: UIColor.primaryGray(),
                           keyType: .numberPad,
                           isSecureText: false,
                           textAlignment: .center,
                           limitLength: 9)
                .frame(width: 80, height: 30, alignment: .center)
                .background(Color.primaryPale())
                .cornerRadius(4)
                .foregroundColor(.clear)
        }
    }
}

private extension TravelSettingsView {
    var costUpTo: some View {
        HStack {
            TextFieldUIKit(placeholder: "-",
                           text: appBinding.travel.costUpTo,
                           font: UIFont.robotoMedium16()!,
                           foregroundColor: UIColor.primaryGray(),
                           keyType: .numberPad,
                           isSecureText: false,
                           textAlignment: .center,
                           limitLength: 9)
                .frame(width: 80, height: 30, alignment: .center)
                .background(Color.primaryPale())
                .cornerRadius(4)
                .foregroundColor(.clear)
        }
    }
}

// MARK: Actions
private extension TravelSettingsView {
    private func cleanFilms(state: Binding<AppState.AppData>) {
        injected.interactors.filmInteractor
            .cleanFilms(state: state)
    }
    
    private func getMovies(state: Binding<AppState.AppData>) {
        injected.interactors.filmInteractor
            .getMovies(state: state)
    }
}

private extension TravelSettingsView {
    private func saveFilmsToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.filmInteractor
            .saveFilmsToUserDefaults(state: state)
    }
}

struct TravelSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TravelSettingsView(appBinding: .constant(.init()))
    }
}
