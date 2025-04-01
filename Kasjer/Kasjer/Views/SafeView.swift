//
//  SafeView.swift
//  Kasjer
//
//  Created by Jan Antonowicz on 12/08/2022.
//

import SwiftUI

struct SafeView: View {
    
    @EnvironmentObject private var vm: ViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var cashbox: [RecordModel] = []
    @State var safebox: [RecordModel] = []
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 5) {
                Image(systemName: "xmark.app.fill")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }

                
                ScrollView {
                    VStack {
                            VStack {
                                HStack{
                                    Text("Minimal cashbox value:")
                                    Spacer()
                                    Text("\(vm.limit.asCurrencyWith2Decimals())")
                                        .fontWeight(.black)
                                        .font(.title2)
                                }
                                .padding()
                                .background(Color.blue)
                                .withSafeDataModifier()
                                
                                HStack{
                                    Text("Whole cash:")
                                    Spacer()
                                    Text("\(vm.sum.asCurrencyWith2Decimals())")
                                        .fontWeight(.black)
                                        .font(.title2)
                                }
                                .padding()
                                .background(.green)
                                .withSafeDataModifier()
                                
                                HStack{
                                    Text("Leave in cashbox:")
                                    Spacer()
                                    Text("\(vm.cashboxFinal.asCurrencyWith2Decimals())")
                                        .fontWeight(.black)
                                        .font(.title2)
                                }
                                .padding()
                                .background(.pink)
                                .withSafeDataModifier()
                                
                                ListView(array: vm.cashboxInput)

                                HStack{
                                    Text("Put into the safebox:")
                                    Spacer()
                                    Text("\((vm.sum - vm.cashboxFinal).asCurrencyWith2Decimals())")
                                        .fontWeight(.black)
                                        .font(.title2)
                                }
                                .padding()
                                .background(Color.cyan)
                                .withSafeDataModifier()
                            }
                            
                        ListView(array: vm.safeInput)
                        
                        
                    }
                    .padding(.horizontal)

                }
            }
        }
        .onAppear {
            vm.createSummary()
        }
    }
}

struct SafeView_Previews: PreviewProvider {
    static var previews: some View {
        SafeView()
            .environmentObject(ViewModel())
            .preferredColorScheme(.dark)
    }
}

