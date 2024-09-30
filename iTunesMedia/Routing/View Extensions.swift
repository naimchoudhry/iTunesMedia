//
//  View Extensions.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 24/09/2024.
//

import SwiftUI

extension View {

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
    
    /// Closure given view if conditional.
    /// - Parameters:
    ///   - conditional: Boolean condition.
    ///   - truthy: Closure to run on view if true.
    ///   - falsy: Closure to run on view if false.
    @ViewBuilder func `if`<Truthy: View, Falsy: View>(_ conditional: Bool = true, @ViewBuilder _ truthy: (Self) -> Truthy, @ViewBuilder else falsy: (Self) -> Falsy) -> some View {
        if conditional {
            truthy(self)
        } else {
            falsy(self)
        }
    }
    
    /// Closure given view and unwrapped optional value if optional is set.
    /// - Parameters:
    ///   - conditional: Optional value.
    ///   - content: Closure to run on view with unwrapped optional.
    @ViewBuilder func iflet<Content: View, T>(_ conditional: Optional<T>, @ViewBuilder _ content: (Self, _ value: T) -> Content) -> some View {
        if let value = conditional {
            content(self, value)
        } else {
            self
        }
    }
}
