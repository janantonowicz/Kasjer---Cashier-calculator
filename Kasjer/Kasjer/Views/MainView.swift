//
//  MainView.swift
//  Kasjer
//
//  Created by Jan Antonowicz on 10/08/2022.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var vm: ViewModel
    @State var toggleMinus: Bool = false
    
    // Sheets and Covers
    @State var showFullScreenCover: Bool = false
    @State var showSettingsCard: Bool = false

    // Count of current nominals
    @State var nominalCount: Int = 0
    
    // Starting with the highest nominal
    @State var selectedNominal: Double = 500.0
    
    // Nominals
    let nominals: [Double] = [
        500, 200, 100, 50, 20, 10, 5, 2, 1, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01,
    ]
    
    let change: [Int] = [
        10, 5, 2, 1
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            /// Calculator overlay is over everything else
            /// Contains:
            /// - horizontal nominal picker row
            /// - calculator row
            ///
            VStack {
                /// enables user to select which nominal to edit
                nominalPickerView
                /// enables user to add or substract from current nominal quantity
                calculator
                /// button row with button for applying changes and calculating summary
                buttonRow
            }
            .background(Color.black)
            .zIndex(999)
            
            VStack(alignment: .leading) {
                navigation
                HStack {
                    Button {
                        nominalCount = 0
                    } label: {
                        Text("Clear")
                            .foregroundStyle(.black)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color.red)
                            )
                    }
                    calculations
                }
                if vm.records.isEmpty {
                    ScrollView {
                        Text("""
                             1. Select nominal by tapping the rectangle with ammount.
                             
                             2. Add quantity by pressing rounded buttons. The numbers will be added to sum.
                             
                             3. Add quantity by pressing rounded buttons. The numbers will be added to sum.
                             
                             4. You can toggle subtraction mode by pressing the plus button. Now the number will be subtracted from the sum. You can also press the clear button to reset the ammount.
                             
                             5. Use 'apply' button to save the entry and use sum button to see the summary.
                             """)
                        .font(.callout)
                        .opacity(0.6)
                        .multilineTextAlignment(.leading)
                    }
                } else {
                    ListView(array: vm.records)
                }
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ViewModel())
            .preferredColorScheme(.dark)
    }
}

extension MainView {
    
    private var buttonRow: some View {
        HStack {
            Button {
                if (nominalCount >= 0) {
                    vm.saveAndUpdate(nominalCount: nominalCount, selectedNominal: selectedNominal)
                    if (vm.indexOfValue < nominals.count) {
                        selectedNominal = nominals[vm.indexOfValue]
                    }
                    nominalCount = vm.nominalChange(nominal: selectedNominal)
                }
            } label: {
                Text("Apply")
                    .foregroundStyle(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color.orange)
                    )
                    .opacity(nominalCount < 0 ? 0.7 : 1)
            }
            .disabled(nominalCount < 0)
            
            Button {
                if (vm.sum >= vm.limit) {
                    showFullScreenCover.toggle()
                }
            } label: {
                Text("Sum")
                    .foregroundStyle(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color.yellow)
                            .opacity(vm.sum < vm.limit ? 0.4 : 1)
                    )
            }
            .disabled(vm.sum < vm.limit)
            .fullScreenCover(isPresented: $showFullScreenCover, content: {
                SafeView()
            })
            .animation(.easeInOut, value: vm.sum >= vm.limit)
            .opacity(vm.sum < vm.limit ? 0.7 : 1)

        }
        .padding()
    }
    
    /// This view shows horizontal scroll view with nominals to pick from
    private var nominalPickerView: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(nominals, id: \.self) { value in
                        Text(value.asCurrencyWith2Decimals())
                            // Each value must have a unique id for scrolling.
                            .id(value)
                            .font(.title2)
                            .font(.footnote.weight(.semibold))
                            .padding(15)
                            .background(selectedNominal == value ? Color.blue : Color.white.opacity(0.2))
                            .cornerRadius(5)
                            .onTapGesture {
                                nominalCount = vm.nominalChange(nominal: value)
                                selectedNominal = value
                                toggleMinus = false
                                if let index = nominals.firstIndex(where: { $0 == value }){
                                    vm.indexOfValue = index
                                }
                                // Animate scrolling to the tapped element.
                                withAnimation {
                                    scrollProxy.scrollTo(value, anchor: .center)
                                }
                                print("\(selectedNominal)")
                                print("\(nominalCount)")
                            }
                    }
                }
            }
            // Optional: scroll automatically if selectedNominal changes externally.
            .onChange(of: selectedNominal) { newValue in
                withAnimation {
                    scrollProxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }

    /// This view shows calculator ui including:
    /// - plus / minus toggle button
    /// - buttons with quantity user can add or subtract from the total count of currently selected nominal
    private var calculator: some View {
        HStack {
            ZStack {
                Circle()
                    .foregroundColor(toggleMinus ? Color.red : Color.orange)
                
                Image(systemName: toggleMinus ? "minus" : "plus")
                    .font(.largeTitle)
            }
            .onTapGesture {
                toggleMinus.toggle()
            }
            .animation(.easeOut, value: toggleMinus)
            
            ForEach(change, id: \.self) { change in
                ZStack {
                    Circle()
                        .foregroundColor(Color.gray)
                    
                    Text("\(change)")
                        .font(.largeTitle)
                }
                .frame(maxWidth: 100)
                .onTapGesture {
                    if toggleMinus == false {
                        nominalCount = nominalCount + change
                    } else {
                        nominalCount = nominalCount - change
                        toggleMinus = false
                        guard nominalCount > 0 else { return nominalCount = 0 }
                    }
                }
            }
        }
        .frame(height: 80)
        .zIndex(2)
        .foregroundColor(Color.white)
        .padding(5)
    }
}

extension Sequence  {
    func sum<T: AdditiveArithmetic>(_ predicate: (Element) -> T) -> T { reduce(.zero) { $0 + predicate($1) } }
}

extension MainView {
    /// This view shows navigation bar with:
    /// - clear button to reset the calculator to initial values
    /// - sum of all money
    /// - settings button
    private var navigation: some View {
        HStack {
            Image(systemName: "xmark.bin.fill")
                .font(.title2)
                .foregroundColor(Color.red)
                .onTapGesture {
                    vm.reset()
                    nominalCount = 0
                }
            Spacer()
            ballance
            Spacer()
            Image(systemName: "gearshape.fill")
                .font(.title2)
                .foregroundColor(Color.blue)
                .onTapGesture {
                    showSettingsCard.toggle()
                }
                .sheet(isPresented: $showSettingsCard) {
                    SettingsView()
                }
        }
    }
    
    private var ballance: some View {
        Text(vm.sum == 0 ? "No money" : vm.sum.asCurrencyWith2Decimals())
            .font(.title2)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .center)
            .animation(.easeInOut, value: vm.sum == 0)
    }
    
    private var calculations: some View {
        HStack {
            Spacer()
            Text("\(nominalCount)")
                .font(.largeTitle)
                .font(.footnote.weight(.semibold))
            
            Image(systemName: "xmark")
                .font(.body)
                .font(.footnote.weight(.semibold))
            Text("\(selectedNominal.asCurrencyWith2Decimals())")
                .fontWeight(.semibold)
                .font(.largeTitle)
        }
            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
            .animation(.easeInOut, value: vm.sum == 0)
            .padding(.vertical, 20)
    }
    
    private var list: some View {
        // header
        VStack {
            HStack {
                Text("nominal:")
                    .font(.callout)
                    .frame(maxWidth: .infinity)
                    .font(.footnote.weight(.semibold))
                Text("count:")
                    .font(.callout)
                    .frame(maxWidth: .infinity)
                    .font(.footnote.weight(.semibold))
            }
            
            Divider()
                .background(Color.gray)
            
            List {
                ForEach(vm.records, id: \.self) { item in
                    if item.count > 0 {
                        HStack {
                            Text(item.nominal.asCurrencyWith2Decimals())
                                .frame(maxWidth: .infinity)
                            Text("\(item.count)")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        
    }
}
