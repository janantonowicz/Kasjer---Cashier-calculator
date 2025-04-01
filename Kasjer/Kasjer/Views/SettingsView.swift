//
//  SettingsView.swift
//  Kasjer
//
//  Created by Jan Antonowicz on 11/08/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var vm: ViewModel
    @State var textFieldPrice: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Image(systemName: "xmark.app.fill")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                Spacer()
            }
            .padding(.top)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Minimal value to keep in cashbox:  \(vm.limit.asCurrencyWith2Decimals())")
                        .font(.headline)
                }
                Text("Set new minimal value:")
                    .frame(height: 55)
                    .font(.title2)
                    .minimumScaleFactor(0.5)
                ZStack {
                    TextField("Nowa wartość", text: $textFieldPrice)
                        .font(.headline)
                        .padding(.leading)
                        .frame(height: 55)
                        .background(
                            Color.orange
                                .opacity(0.5)
                        )
                        .cornerRadius(10)
                        .keyboardType(.numberPad)
                }
                Button {
                    vm.limit = Double(textFieldPrice) ?? 500
                } label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(Color.black)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }

            }
            .padding()
            .padding(.top, 100)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ViewModel())
            .preferredColorScheme(.dark)
    }
}
