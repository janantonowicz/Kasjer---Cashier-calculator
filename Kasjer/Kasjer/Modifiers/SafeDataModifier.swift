//
//  SafeDataModifier.swift
//  Kasjer
//
//  Created by Jan Antonowicz on 11/02/2023.
//

import SwiftUI

struct SafeDataModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .cornerRadius(10)
            .font(.headline)
            .foregroundColor(.black)
    }
    
}

extension View {
    func withSafeDataModifier() -> some View {
        self
            .modifier(SafeDataModifier())
    }
}
