//
//  MetricsnSections.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public enum MetricsSections: String {

  // MARK: - BottleScreen

  case bottleScreenOpen = "bottle_screen_open"
  case bottleScreenClose = "bottle_screen_close"
  case bottleScreenButtonRotation = "bottle_screen_button_rotation"
  case bottleScreenButtonReset = "bottle_screen_button_reset"
  case bottleScreenButtonSetting = "bottle_screen_button_setting"

  // MARK: - BottleStyleScreen

  case bottleStyleScreenOpen = "bottle_style_screen_open"
  case bottleStyleScreenClose = "bottle_style_screen_close"
  case bottleStyleScreenButtonNoPremiumAccessAction = "bottle_style_screen_button_no_premium_access_action"
  case bottleStyleScreenButtonDidSelectStyle = "bottle_style_screen_button_did_select_style"
  case bottleStyleScreenButtonDidSelectStyleSuccessfully = "bottle_style_screen_button_did_select_style_successfully"

  // MARK: - CoinScreen

  case coinScreenOpen = "coin_screen_open"
  case coinScreenClose = "coin_screen_close"
  case coinScreenButtonGenerate = "coin_screen_button_generate"
  case coinScreenButtonCopy = "coin_screen_button_copy"
  case coinScreenButtonSettings = "coin_screen_button_settings"

  // MARK: - CoinStyle

  case coinStyleScreenOpen = "coin_style_screen_open"
  case coinStyleScreenClose = "coin_style_screen_close"
  case coinStyleScreenButtonNoPremiumAccessAction = "coin_style_screen_button_no_premium_access_action"
  case coinStyleScreenButtonDidSelectStyle = "coin_style_screen_button_did_select_style"
  case coinStyleScreenButtonDidSelectStyleSuccessfully = "coin_style_screen_button_did_select_style_successfully"

  // MARK: - ColorsScreen

  case colorsScreenOpen = "colors_screen_open"
  case colorsScreenClose = "colors_screen_close"
  case colorsScreenButtonGenerateResult = "colors_screen_button_generate_result"
  case colorsScreenButtonResultLabelCopied = "colors_screen_button_result_label_copied"
  case colorsScreenButtonResultNavigationCopied = "colors_screen_button_result_navigation_copied"
  case colorsScreenButtonResultNavigationShare = "colors_screen_button_result_navigation_share"

  // MARK: - CongratulationsScreen

  case congratulationsScreenOpen = "congratulations_screen_open"
  case congratulationsScreenClose = "congratulations_screen_close"
  case congratulationsScreenButtonGenerate = "congratulations_screen_button_generate"
  case congratulationsScreenButtonResultLabelCopied = "congratulations_screen_button_result_label_copied"
  case congratulationsScreenValueDidChange = "congratulations_screen_value_did_change"
  case congratulationsScreenSomethingWentWrong = "congratulations_screen_something_went_wrong"
  case congratulationsScreenButtonResultNavigationCopied = "congratulations_screen_button_result_navigation_copied"
  case congratulationsScreenButtonSetting = "congratulations_screen_button_setting"

  // MARK: - ContactScreen

  case contactScreenOpen = "contact_screen_open"
  case contactScreenClose = "contact_screen_close"
  case contactScreenButtonGenerate = "contact_screen_button_generate"
  case contactScreenButtonResultLabelCopied = "contact_screen_button_result_label_copied"
  case contactScreenButtonResultNavigationCopied = "contact_screen_button_result_navigation_copied"
  case contactScreenButtonSetting = "contact_screen_button_setting"

  // MARK: - CubesScreen

  case cubesScreenOpen = "cubes_screen_open"
  case cubesScreenClose = "cubes_screen_close"
  case cubesScreenButtonDiceAction = "cubes_screen_button_dice_action"
  case cubesScreenButtonResultNavigationCopied = "cubes_screen_button_result_navigation_copied"
  case cubesScreenButtonSetting = "cubes_screen_button_setting"

  // MARK: - CubesStyleScreen

  case cubesStyleScreenOpen = "cubes_style_screen_open"
  case cubesStyleScreenClose = "cubes_style_screen_close"
  case cubesStyleScreenButtonNoPremiumAccessAction = "cubes_style_screen_button_no_premium_access_action"
  case cubesStyleScreenButtonDidSelectStyle = "cubes_style_screen_button_did_select_style"
  case cubesStyleScreenButtonDidSelectStyleSuccessfully = "cubes_style_screen_button_did_select_style_successfully"

  // MARK: - DateTimeScreen

  case dateTimeScreenOpen = "date_time_screen_open"
  case dateTimeScreenClose = "date_time_screen_close"
  case dateTimeScreenButtonResultLabelCopied = "date_time_screen_button_result_label_copied"
  case dateTimeScreenButtonGenerateDay = "date_time_screen_button_generate_day"
  case dateTimeScreenButtonGenerateDate = "date_time_screen_button_generate_date"
  case dateTimeScreenButtonGenerateTime = "date_time_screen_button_generate_time"
  case dateTimeScreenButtonGenerateMonth = "date_time_screen_button_generate_month"
  case dateTimeScreenButtonResultNavigationCopied = "date_time_screen_button_result_navigation_copied"
  case dateTimeScreenButtonSetting = "date_time_screen_button_setting"

  // MARK: - FilmsScreen

  case filmsScreenOpen = "films_screen_open"
  case filmsScreenClose = "films_screen_close"
  case filmsScreenStartLoad = "films_screen_start_load"
  case filmsScreenStopLoad = "films_screen_stop_load"
  case filmsScreenDidReceiveFilm = "films_screen_did_receive_film"
  case filmsScreenModelsIsEmpty = "films_screen_models_is_empty"
  case filmsScreenSomethingWentWrong = "films_screen_something_went_wrong"
  case filmsScreenButtonPlayTrailertWrong = "films_screen_button_play_trailert_wrong"
  case filmsScreenButtonPlayTrailertSuccess = "films_screen_button_play_trailert_success"

  // MARK: - FortuneWheelEditSectionScreen

  case fortuneWheelEditSectionScreenOpen = "fortune_wheel_edit_section_screen_open"
  case fortuneWheelEditSectionScreenClose = "fortune_wheel_edit_section_screen_close"
  case fortuneWheelEditSectionScreenEditSection = "fortune_wheel_edit_section_screen_edit_section"
  case fortuneWheelEditSectionScreenEditEmoticon = "fortune_wheel_edit_section_screen_edit_emoticon"
  case fortuneWheelEditSectionScreenDeleteObject = "fortune_wheel_edit_section_screen_delete_object"
  case fortuneWheelEditSectionScreenCreateObject = "fortune_wheel_edit_section_screen_create_object"
  case fortuneWheelEditSectionScreenButtonNavigationRemoveItem = "fortune_wheel_edit_section_screen_button_navigation_remove_item"

  // MARK: - FortuneWheelScreen

  case fortuneWheelScreenOpen = "fortune_wheel_screen_open"
  case fortuneWheelScreenClose = "fortune_wheel_screen_close"
  case fortuneWheelScreenButtonGenerate = "fortune_wheel_screen_button_generate"
  case fortuneWheelScreenButtonSelectedSection = "fortune_wheel_screen_button_selected_section"
  case fortuneWheelScreenButtonSetting = "fortune_wheel_screen_button_setting"

  // MARK: - FortuneWheelSelectedSectionScreen

  case fortuneWheelSelectedSectionScreenOpen = "fortune_wheel_selected_section_screen_open"
  case fortuneWheelSelectedSectionScreenClose = "fortune_wheel_selected_section_screen_close"
  case fortuneWheelSelectedSectionScreenDeleteSection = "fortune_wheel_selected_section_screen_delete_section"
  case fortuneWheelSelectedSectionScreenEditCurrentSection = "fortune_wheel_selected_section_screen_edit_current_section"
  case fortuneWheelSelectedSectionScreenSectionSelected = "fortune_wheel_selected_section_screen_section_selected"
  case fortuneWheelSelectedSectionScreenCreateNewSection = "fortune_wheel_selected_section_screen_create_new_section"

  // MARK: - GiftsScreen

  case giftsScreenOpen = "gifts_screen_open"
  case giftsScreenClose = "gifts_screen_close"
  case giftsScreenButtonGenerate = "gifts_screen_button_generate"
  case giftsScreenButtonResultLabelCopied = "gifts_screen_button_result_label_copied"
  case giftsScreenValueDidChange = "gifts_screen_value_did_change"
  case giftsScreenSomethingWentWrong = "gifts_screen_something_went_wrong"
  case giftsScreenDidReceiveModelData = "gifts_screen_did_receive_model_data"
  case giftsScreenButtonResultNavigationCopied = "gifts_screen_button_result_navigation_copied"
  case giftsScreenButtonSetting = "gifts_screen_button_setting"

  // MARK: - JokeScreen

  case jokeScreenOpen = "joke_screen_open"
  case jokeScreenClose = "joke_screen_close"
  case jokeScreenButtonGenerate = "joke_screen_button_generate"
  case jokeScreenButtonResultLabelCopied = "joke_screen_button_result_label_copied"
  case jokeScreenSomethingWentWrong = "joke_screen_something_went_wrong"
  case jokeScreenDidReceiveModelData = "joke_screen_did_receive_model_data"
  case jokeScreenButtonResultNavigationCopied = "joke_screen_button_result_navigation_copied"
  case jokeScreenButtonSetting = "joke_screen_button_setting"

  // MARK: - LetterScreen

  case letterScreenOpen = "letter_screen_open"
  case letterScreenClose = "letter_screen_close"
  case letterScreenButtonGenerateEng = "letter_screen_button_generate_eng"
  case letterScreenButtonGenerateRus = "letter_screen_button_generate_rus"
  case letterScreenButtonResultLabelCopied = "letter_screen_button_result_label_copied"
  case letterScreenButtonResultNavigationCopied = "letter_screen_button_result_navigation_copied"
  case letterScreenButtonSetting = "letter_screen_button_setting"

  // MARK: - ListAddItemsScreen

  case listAddItemsScreenOpen = "list_add_items_screen_open"
  case listAddItemsScreenClose = "list_add_items_screen_close"
  case listAddItemsScreenTextAdded = "list_add_items_screen_text_added"
  case listAddItemsScreenTextRemoved = "list_add_items_screen_text_removed"
  case listAddItemsScreenButtonNavigationRemoveTexts = "list_add_items_screen_button_navigation_remove_texts"

  // MARK: - ListScreen

  case listScreenOpen = "list_screen_open"
  case listScreenClose = "list_screen_close"
  case listScreenCloseButtonGenerate = "list_screen_close_button_generate"
  case listScreenCloseButtonResultLabelCopied = "list_screen_close_button_result_label_copied"
  case listScreenCloseButtonResultNavigationCopied = "list_screen_close_button_result_navigation_copied"
  case listScreenCloseButtonSetting = "list_screen_close_button_setting"

  // MARK: - ListResultScreen

  case listResultScreenOpen = "list_result_screen_open"
  case listResultScreenClose = "list_result_screen_close"
  case listResultScreenResultCopied = "list_result_screen_result_copied"
  case listResultScreenButtonShareImage = "list_result_screen_button_share_image"

  // MARK: - LotteryScreen

  case lotteryScreenOpen = "lottery_screen_open"
  case lotteryScreenClose = "lottery_screen_close"
  case lotteryScreenButtonGenerate = "lottery_screen_button_generate"
  case lotteryScreenButtonResultLabelCopied = "lottery_screen_button_result_label_copied"
  case lotteryScreenButtonResultNavigationCopied = "lottery_screen_button_result_navigation_copied"
  case lotteryScreenButtonSetting = "lottery_screen_button_setting"

  // MARK: - MainScreen

  case mainScreenOpen = "main_screen_open"
  case mainScreenButtonOpenADV = "main_screen_button_open_adv"
  case mainScreenButtonNoPremiumAccess = "main_screen_button_no_premium_access"
  case mainScreenButtonPremium = "main_screen_button_premium"
  case mainScreenButtonSetting = "main_screen_button_setting"

  // MARK: - MemesScreen

  case memesScreenOpen = "memes_screen_open"
  case memesScreenClose = "memes_screen_close"
  case memesScreenButtonGenerate = "memes_screen_button_generate"
  case memesScreenSomethingWentWrong = "memes_screen_something_went_wrong"
  case memesScreenRequestPhotosError = "memes_screen_request_photos_error"
  case memesScreenDidReceiveMemes = "memes_screen_did_receive_memes"
  case memesScreenButtonShareImage = "memes_screen_button_share_image"
  case memesScreenButtonSetting = "memes_screen_button_setting"

  // MARK: - NumberScreen

  case numberScreenOpen = "number_screen_open"
  case numberScreenClose = "number_screen_close"
  case numberScreenButtonResultLabelCopied = "number_screen_button_result_label_copied"
  case numberScreenRangeStartDidChange = "number_screen_range_start_did_change"
  case numberScreenRangeEndDidChange = "number_screen_range_end_did_change"
  case numberScreenButtonGenerate = "number_screen_button_generate"
  case numberScreenButtonResultNavigationCopied = "number_screen_button_result_navigation_copied"
  case numberScreenButtonSetting = "number_screen_button_setting"

  // MARK: - PasswordScreen

  case passwordScreenOpen = "password_screen_open"
  case passwordScreenClose = "password_screen_close"
  case passwordScreenButtonGenerate = "password_screen_button_generate"
  case passwordScreenUppercaseSwitchAction = "password_screen_uppercase_switch_action"
  case passwordScreenLowercaseSwitchAction = "password_screen_lowercase_switch_action"
  case passwordScreenNumbersSwitchAction = "password_screen_numbers_switch_action"
  case passwordScreenSymbolsSwitchAction = "password_screen_symbols_switch_action"
  case passwordScreenButtonResultLabelCopied = "password_screen_button_result_label_copied"
  case passwordScreenButtonResultNavigationCopied = "password_screen_button_result_navigation_copied"
  case passwordScreenButtonSetting = "password_screen_button_setting"

  // MARK: - SettingsScreen

  case settingsScreenOpen = "settings_screen_open"
  case settingsScreenClose = "settings_screen_close"
  case settingsScreenCoinStyleSelectionAction = "settings_screen_coin_style_selection_action"
  case settingsScreenBottleStyleSelectionAction = "settings_screen_bottle_style_selection_action"
  case settingsScreenCubesStyleSelectionAction = "settings_screen_cubes_style_selection_action"
  case settingsScreenPlayerCardSelectionAction = "settings_screen_player_card_selection_action"
  case settingsScreenCreateListAction = "settings_screen_create_list_action"
  case settingsScreenListOfObjectsAction = "settings_screen_list_of_objects_action"
  case settingsScreenWithoutRepetitionAction = "settings_screen_without_repetition_action"
  case settingsScreenCleanButtonAction = "settings_screen_clean_button_action"

  // MARK: - ShareScreen

  case shareScreenOpen = "share_screen_open"
  case shareScreenClose = "share_screen_close"
  case shareScreenButtonShare = "share_screen_button_share"

  // MARK: - ListPlayersScreen

  case listPlayersScreenOpen = "list_players_screen_open"
  case listPlayersScreenClose = "list_players_screen_close"
  case listPlayersScreenGenderValueChanged = "list_players_screen_gender_value_changed"
  case listPlayersScreenPlayerRemoved = "list_players_screen_player_removed"
  case listPlayersScreenPlayerAdded = "list_players_screen_player_added"
  case listPlayersScreenUpdatePlayer = "list_players_screen_update_player"

  // MARK: - PlayerCardSelectionScreen

  case playerCardSelectionScreenOpen = "player_card_selection_screen_open"
  case playerCardSelectionScreenClose = "player_card_selection_screen_close"
  case playerCardSelectionScreenDidSelectStyleSuccessfully = "player_card_selection_screen_did_select_style_successfully"
  case playerCardSelectionScreenNoPremiumAccessAction = "player_card_selection_screen_no_premium_access_action"
  case playerCardSelectionScreenDidSelectStyle = "player_card_selection_screen_did_select_style"

  // MARK: - TeamsScreen

  case teamsScreenOpen = "teams_screen_open"
  case teamsScreenClose = "teams_screen_close"
  case teamsScreenUpdateTeams = "teams_screen_update_teams"
  case teamsScreenTeamRename = "teams_screen_team_rename"
  case teamsScreenButtonShareImage = "teams_screen_button_share_image"
  case teamsScreenButtonGenerate = "teams_screen_button_generate"
  case teamsScreenButtonSetting = "teams_screen_button_setting"

  // MARK: - YesNoScreen

  case yesNoScreenOpen = "yes_no_screen_open"
  case yesNoScreenClose = "yes_no_screen_close"
  case yesNoScreenButtonGenerate = "yes_no_screen_button_generate"
  case yesNoScreenButtonResultLabelCopied = "yes_no_screen_button_result_label_copied"
  case yesNoScreenButtonResultNavigationCopied = "yes_no_screen_button_result_navigation_copied"
  case yesNoScreenButtonSetting = "yes_no_screen_button_setting"

  // MARK: - CustomMainSectionsScreen

  case customMainSectionsScreenOpen = "custom_main_sections_screen_open"
  case customMainSectionsScreenClose = "custom_main_sections_screen_close"
  case customMainSectionsScreenSectionChanged = "custom_main_sections_screen_section_changed"

  // MARK: - MainSettingsScreen

  case mainSettingsScreenOpen = "main_settings_screen_open"
  case mainSettingsScreenClose = "main_settings_screen_close"
  case mainSettingsScreenButtonShareApp = "main_settings_screen_button_share_app"
  case mainSettingsScreenButtonApplyPremium = "main_settings_screen_button_apply_premium"
  case mainSettingsScreenButtonIconSectionsSelected = "main_settings_screen_button_icon_sections_selected"
  case mainSettingsScreenButtonPremiumSectionsSelected = "main_settings_screen_button_premium_sections_selected"
  case mainSettingsScreenButtonFeedBackButtonAction = "main_settings_screen_button_feed_back_button_action"
  case mainSettingsScreenButtonCustomMainSectionsSelected = "main_settings_screen_button_custom_main_sections_selected"
  case mainSettingsScreenButtonApplyDarkTheme = "main_settings_screen_button_apply_dark_theme"

  // MARK: - SelecteAppIconScreen

  case selecteAppIconScreenOpen = "selecte_app_icon_screen_open"
  case selecteAppIconScreenClose = "selecte_app_icon_screen_close"
  case selecteAppIconScreenNoPremiumAccessAction = "selecte_app_icon_screen_no_premium_access_action"
  case selecteAppIconScreenDidSelectAppImage = "selecte_app_icon_screen_did_select_app_image"

  // MARK: - AppUnavailableScreen

  case appUnavailableScreenOpen = "app_unavailable_screen_open"
  case appUnavailableScreenClose = "app_unavailable_screen_close"
  case appUnavailableScreenFeedBackButtonAction = "app_unavailable_screen_feed_back_button_action"

  // MARK: - ForceUpdateAppScreen

  case forceUpdateAppScreenOpen = "force_update_app_screen_open"
  case forceUpdateAppScreenClose = "force_update_app_screen_close"
  case forceUpdateButtonAction = "force_update_button_action"

  // MARK: - PremiumScreen

  case premiumScreenOpen = "premium_screen_open"
  case premiumScreenClose = "premium_screen_close"
  case premiumScreenButtonPurchaseAction = "premium_screen_button_purchase_action"
  case premiumScreenButtonRestorePurchase = "premium_screen_button_restore_purchase"
  case premiumScreenMonthlySubscriptionCardSelected = "premium_screen_monthly_subscription_card_selected"
  case premiumScreenAnnualSubscriptionCardSelected = "premium_screen_annual_subscription_card_selected"
  case premiumScreenLifetimeAccessCardSelected = "premium_screen_lifetime_access_card_selected"
  case premiumScreenDidReceiveSubscriptionPurchaseSuccess = "premium_screen_did_receive_subscription_purchase_success"
  case premiumScreenDidReceiveOneTimePurchaseSuccess = "premium_screen_did_receive_one_time_purchase_success"
  case premiumScreenSomethingWentWrong = "premium_screen_something_went_wrong"
  case premiumScreenDidReceivePurchasesMissing = "premium_screen_did_receive_purchases_missing"
  case premiumScreenDidReceiveRestoredSuccess = "premium_screen_did_receive_restored_success"
  case premiumScreenStartPaymentProcessing = "premium_screen_start_payment_processing"
  case premiumScreenStopPaymentProcessing = "premium_screen_stop_payment_processing"
}
