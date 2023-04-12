//
//  ContentView.swift
//  Calculator
//
//  Created by Bartosz Prazmo on 07/04/2023.
//

import SwiftUI

struct ContentView: View {

	@EnvironmentObject private var vm : CalculatorViewModel
	
	var body: some View {
		
		GeometryReader { bounds in
			ZStack (alignment: .center) {
				Color.theme.appBackgroundColor.edgesIgnoringSafeArea(.all)
				
				VStack(alignment: .center, spacing: 12) {
					ZStack (alignment: .center) {
						
						HStack {
							Spacer()
							
							Text(vm.displayLabel).foregroundColor(Color.theme.outputLabelColor)
								.font(.system(size: 64))
							
						}.padding()
						LoaderView(tintColor: .green, scaleSize: 1.0).hidden(!vm.isLoading)
					}
					
					ForEach(vm.buttons, id: \.self) { row in
						HStack (spacing: 12) {
							ForEach(row, id: \.id) { button in
								CalculatorButtonView(button: button)
							}
						}
					}
				}.padding()
				
			}.alert(isPresented: $vm.alertManager.shouldShowAlert ) {
				guard let alert = vm.alertManager.alert else { fatalError("Alert not available")
				}
				return Alert(alert)
			}
		}
		
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView().environmentObject(CalculatorViewModel(ApiManager: NetworkManager.shared, AlertManager: AlertManager(), ConectionManager: ConnectionManager()))
    }
}
