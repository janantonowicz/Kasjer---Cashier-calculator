//
//  ItemModel.swift
//  Kasjer
//
//  Created by Jan Antonowicz on 10/08/2022.
//

import Foundation
import SwiftUI

/// Model for current calculation data
/// Every record has nominal and count
struct RecordModel: Hashable {
    var nominal: Double
    var count: Int
}
