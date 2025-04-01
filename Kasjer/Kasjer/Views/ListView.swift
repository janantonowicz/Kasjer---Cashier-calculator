//
//  ListView.swift
//  Kasjer
//
//  Created by Jan Antonowicz on 12/03/2025.
//

/// This is generic view for displaying nominals and quantity list
/// will be used in main view user input summary and also in Safe View both for 'put to safe' and 'leave in cashbox lists'

import SwiftUI

struct ListView: View {

    var array: [RecordModel]
    
    var body: some View {
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
            
            VStack {
                ForEach(array, id: \.self) { item in
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

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let array: [RecordModel] = [
            RecordModel(nominal: 100, count: 10),
            RecordModel(nominal: 50, count: 6),
            RecordModel(nominal: 20, count: 1)
        ]
        
        ListView(array: array)
            .preferredColorScheme(.dark)
    }
}
