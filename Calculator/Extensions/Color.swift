//
//  Color.swift
//  Calculator
//
//  Created by Bartosz Prazmo on 10/04/2023.
//

import SwiftUI

extension Color{
	static let theme = ColorTheme()
}

struct ColorTheme{
	let primaryTextColor = Color("PrimaryTextColor")
	let appBackgroundColor = Color("AppBackgroundColor")
	let numberColorColor = Color("NumberColor")
	let operantColor = Color("OperantColor")
	let deleteColor = Color("DeleteColor")
	let outputLabelColor = Color("OutputLabelColor")
}
