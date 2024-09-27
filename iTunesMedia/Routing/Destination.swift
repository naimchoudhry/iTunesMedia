//
//  Destination.swift
//
//  Created by Naim Choudhry on 16/08/2024.
//
//  Note!! DocC guide: https://www.swift.org/documentation/docc/
//  Note!! Hide docC documentation code
//  Editor -> Code Folding -> Fold Comment Blocks
//  Shortcut:
//  Fold: Shift + Control + Command + Left
//  Unfold: Shift + Control + Command + right

import SwiftUI

/// Internal struct, used to identify a unique screen(view).  This is the main NavigationStack destination type so that views can be pushed onto the NavigationStack.  Also used by the Router to identify current sheet and full screen cover views presented.
///
/// Not needed by calling screens or view models unless starting a new root routing flow.
/// >Tip: This Struct is returned in the ```Router``` class func **startRoute<T>(_ routeType: NavigationType, @ViewBuilder destination: @escaping (Router) -> T) -> Destination where T: View** return value
struct Destination: Identifiable, Hashable {
    let id = UUID().uuidString
    let view: AnyView
    var popoverAttributes: PopoverAttributes = PopoverAttributes()

    init<T:View>(_ view: T) {
        self.view = AnyView(view)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Destination, rhs: Destination) -> Bool {
        lhs.id == rhs.id
    }
}

/// The popover attributes to be applied on popover view displays.  Need to set the view size and plaecement via padding options.  Can also provide the transition and animation effects
struct PopoverAttributes {
    struct Padding: Equatable {
        var top: CGFloat?
        var bottom: CGFloat?
        var leading: CGFloat?
        var trailing: CGFloat?
    }
    
    /// The popopover size, can specify **CGFloat.infinity** to get max height or width
    var popoverSize: CGSize = CGSize(width: 300, height: 300)
    var padding: Padding = Padding()
    /// Note using a single transform like **move(edge: .leading)** causes the destination view to become unresponsive in certain cases, so use a combined transform like **.scale(scale: 0.9).combined(with: .move(edge: .leading))** to avoid this issue
    var transition: AnyTransition = .identity
    /// The animation to apply when presenting the popover, specify nill for no animations
    var animation: Animation? = .smooth
    /// To have a clear background - use this only when the popover is presented in a route, rather than in a new navigation stack route
    var translucent: Bool = false
    /// Specify the corner radius to apply around the popover
    var cornerRadius: CGFloat = 10
    /// Specify a stroke border color - if nill, no stroke is drawn
    var strokeBorderColor: Color?
    /// Specify a stroke border width - only used if ``strokeBorderColor`` is not nil
    var strokeBorderWidth: CGFloat = 1.0
    /// Specify wether the popover should be drawn ignoring safe areas
    var ignoresSafeAreas: Bool = false
    /// An identifier string to be used to dismiss a specific router in the ```Router``` function **dismissPopoverWith(id: ...)**
    var popoverId: String?
    /// The close action to be performed.  If this is non nill, a close button will be drawn on the top right of the popover (which escapes the popover bounds to appear semi outside the popover).  This is only needed if a close button should be drawn using the BananBets green cross button
    var closeAction: (() -> Void)?
    
}

extension PopoverAttributes: Equatable {
    static func == (lhs: PopoverAttributes, rhs: PopoverAttributes) -> Bool {
        return lhs.padding == rhs.padding && lhs.popoverSize == rhs.popoverSize && lhs.animation == rhs.animation && lhs.popoverId == rhs.popoverId
    }
}
