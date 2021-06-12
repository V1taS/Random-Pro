//
//  InteractorsContainer.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

extension DIContainer {
    struct Interactors {
        let mainInteractor: MainInteractor
        let numberInteractor: NumberInteractor
        let listWordsInteractor: ListWordsInteractor
        let yesOrNoInteractor: YesOrNoInteractor
        let charactersInteractor: CharactersInteractor
        let coinInteractor: CoinInteractor
        let cubeInterator: CubeInterator
        let settingsInterator: SettingsInterator
        let dateAndTimeInteractor: DateAndTimeInteractor
        let lotteryInteractor: LotteryInteractor
        let teamInteractor: TeamInteractor
        let contactInteractor: ContactInteractor
        let filmInteractor: FilmInteractor
        let musicInteractor: MusicInteractor
        let travelInteractor: TravelInteractor

        init(mainInteractor: MainInteractor,
             numberInteractor: NumberInteractor,
             listWordsInteractor: ListWordsInteractor,
             yesOrNoInteractor: YesOrNoInteractor,
             charactersInteractor: CharactersInteractor,
             coinInteractor: CoinInteractor,
             cubeInterator: CubeInterator,
             settingsInterator: SettingsInterator,
             dateAndTimeInteractor: DateAndTimeInteractor,
             lotteryInteractor: LotteryInteractor,
             teamInteractor: TeamInteractor,
             contactInteractor: ContactInteractor,
             filmInteractor: FilmInteractor,
             musicInteractor: MusicInteractor,
             travelInteractor: TravelInteractor) {
            self.mainInteractor = mainInteractor
            self.numberInteractor = numberInteractor
            self.listWordsInteractor = listWordsInteractor
            self.yesOrNoInteractor = yesOrNoInteractor
            self.charactersInteractor = charactersInteractor
            self.coinInteractor = coinInteractor
            self.cubeInterator = cubeInterator
            self.settingsInterator = settingsInterator
            self.dateAndTimeInteractor = dateAndTimeInteractor
            self.lotteryInteractor = lotteryInteractor
            self.teamInteractor = teamInteractor
            self.contactInteractor = contactInteractor
            self.filmInteractor = filmInteractor
            self.musicInteractor = musicInteractor
            self.travelInteractor = travelInteractor
        }

        static var stub: Self {
            .init(mainInteractor: MainInteractorImpl(),
                  numberInteractor: NumberInteractorImpl(),
                  listWordsInteractor: ListWordsInteractorImpl(),
                  yesOrNoInteractor: YesOrNoInteractorImpl(),
                  charactersInteractor: CharactersInteractorImpl(),
                  coinInteractor: CoinInteractorImpl(),
                  cubeInterator: CubeInteratorImpl(),
                  settingsInterator: SettingsInteratorImpl(),
                  dateAndTimeInteractor: DateAndTimeInteractorImpl(),
                  lotteryInteractor: LotteryInteractorImpl(),
                  teamInteractor: TeamInteractorImpl(),
                  contactInteractor: ContactInteractorImpl(),
                  filmInteractor: FilmInteractorImpl(),
                  musicInteractor: MusicInteractorImpl(),
                  travelInteractor: TravelInteractorImpl())
        }
    }
}
