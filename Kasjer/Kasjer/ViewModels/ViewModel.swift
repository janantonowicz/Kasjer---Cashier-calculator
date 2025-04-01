//
//  ViewModel.swift
//  Kasjer
//
//  Created by Jan Antonowicz on 11/08/2022.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var sum: Double = 0.0
    @Published var limit: Double = 500.0
    @Published var cashboxFinal: Double = 0.0
    @Published var indexOfValue: Int = 0
    
        
    @Published var records: [RecordModel] = []
    var pomArray: [RecordModel] = []
    @Published var safeInput: [RecordModel] = []
    @Published var cashboxInput: [RecordModel] = []

    /// This function sums the total ammount of money
    func sumItems() {
        sum = records.sum({ model in
            model.nominal*Double(model.count)
        })
    }
    
    
    /// This function manages saving new nominal instance or updating existing one, if already exists, from user input.
    public func saveAndUpdate(nominalCount: Int, selectedNominal: Double) {
        guard selectedNominal != 0.0 else { return }
        
        if let index = records.firstIndex(where: { $0.nominal == selectedNominal}) {
            records[index].count = nominalCount
        } else {
            records.append(
                RecordModel(
                    nominal: selectedNominal,
                    count: nominalCount
                )
            )
        }
        sum += Double(nominalCount)*selectedNominal
        indexOfValue += 1
    }
    
    /// This function manages logic behind changing nominal.
    /// When user selects other nominal it checks if there is already quantity set for it and fetches it.
    public func nominalChange(nominal: Double) -> Int {
        records.first(where: { $0.nominal == nominal })?.count ?? 0
    }
    
    /// This function calculates which nominals and in what quantity user should put to safabox
    func createSummary(cashboxLimit: Double = 500) {
        // Coin nominals that always stay in the cashbox. (We want them for change, not in safebox)
        let coinNominals: Set<Double> = [0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1, 2]
        
        // Separate coins and banknotes.
        let coins = records.filter { coinNominals.contains($0.nominal) }
        let banknotes = records.filter { !coinNominals.contains($0.nominal) }
        
        // Calculate coins sum.
        let coinSum = coins.reduce(0.0) { $0 + $1.nominal * Double($1.count) }
        
        // Expand banknotes into individual banknotes.
        var banknoteNominals: [Double] = []
        for record in banknotes {
            for _ in 0..<record.count {
                banknoteNominals.append(record.nominal)
            }
        }
        
        // Sort banknote nominals descending.
        // Largest first because we will start putting the largest to safebox and want to keep the lowest nominals in cashbox.
        banknoteNominals.sort(by: >)
        
        // Calculate total note sum and overall cashbox sum initially.
        let banknoteSum = banknoteNominals.reduce(0, +)
        var cashboxSum = coinSum + banknoteSum
        
        // We will move banknotes to the safebox if removing them leaves the cashbox sum >= cashboxLimit.
        var safeboxBanknoteUnits: [Double] = []
        var cashboxBanknoteUnits: [Double] = []
        
        // Process each note unit (largest first).
        for singleBanknote in banknoteNominals {
            if cashboxSum - singleBanknote >= cashboxLimit {
                // Remove this banknote from cashbox to safebox.
                cashboxSum -= singleBanknote
                safeboxBanknoteUnits.append(singleBanknote)
            } else {
                cashboxBanknoteUnits.append(singleBanknote)
            }
        }
        
        /// This Function makes array of RecordModel from array of Doubles
        /// It groups identical values and maps it to RecordModel [nominal: Double, count: quantity of same value]
        func groupNominals(_ nominals: [Double]) -> [RecordModel] {
            // Dictionary with nominal as kay and quantity as value
            var groups: [Double: Int] = [:]
            for banknote in nominals {
                // if nominal doesnt exist in dictionary we create one with value 0 and increase it by 1
                groups[banknote, default: 0] += 1
            }
            return groups.map { RecordModel(nominal: $0.key, count: $0.value) }
        }
        
        // Convert dictionaries to RecordModel arrays.
        cashboxInput = coins + groupNominals(cashboxBanknoteUnits)
        safeInput = groupNominals(safeboxBanknoteUnits)
        cashboxFinal = cashboxSum
    }
    
    /// This function resets all properties to their initial values
    func reset() {
        sum = 0.0
        cashboxFinal = 0.0
        records = []
        safeInput = []
        cashboxInput = []
        indexOfValue = 0
    }
}

