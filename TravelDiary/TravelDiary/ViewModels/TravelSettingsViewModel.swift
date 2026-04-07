//
//  TravelSettingsViewModel.swift
//  TravelDiary
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class TravelSettingsViewModel {
    private let store: TravelStoreProtocol

    init(store: TravelStoreProtocol = TravelStore.shared) {
        self.store = store
    }

    var preferences: TravelPreferences {
        store.preferences
    }

    func updatePreferences(distanceUnit: DistanceUnit, currencyCode: String) {
        store.updatePreferences(distanceUnit: distanceUnit, currencyCode: currencyCode)
    }
}
