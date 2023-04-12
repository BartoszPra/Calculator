//
//  LoadingView.swift
//  Calculator
//
//  Created by Bartosz Prazmo on 11/04/2023.
//

import Foundation
import SwiftUI

struct LoaderView: View {
	var tintColor: Color = .black
	var scaleSize: CGFloat = 1.0
	
	var body: some View {
		ProgressView()
			.scaleEffect(scaleSize, anchor: .center)
			.progressViewStyle(CircularProgressViewStyle(tint: tintColor))
	}
}

extension View {
	@ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
		switch shouldHide {
		case true: self.hidden()
		case false: self
		}
	}
}
