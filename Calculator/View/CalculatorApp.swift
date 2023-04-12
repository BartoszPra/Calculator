//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Bartosz Prazmo on 07/04/2023.
//

import SwiftUI

@main
struct CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
			ContentView().environmentObject(CalculatorViewModel(ApiManager: NetworkManager.shared, AlertManager: AlertManager(), ConectionManager: ConnectionManager())).preferredColorScheme(FeatureToggles.ColorSchemeToogle)
		}
	}
}
