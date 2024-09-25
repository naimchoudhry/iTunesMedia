//
//  RoutingView.swift
//
//  Created by Naim Choudhry on 18/08/2024.
//

import SwiftUI

/// The root routing view, this is created at the module root level **and** on every modal presentation (sheet/full screen cover) so that the view modifiers for sheet and full screen cover can be injected into each view in the chain.
///
///This creates a new navigation stack and attaches it to the router.  This enables independant routes(paths) to be created on this flow which can be either pushed or presentaed as sheets or full screen covers.
///
struct RoutingView<Content: View>: View {
    /// A new router will be created by the initialiser to this struct
    @State var router: Router
    /// Whether the navigation stack should hide the navigation bar, including back bar items
    @State var hideNavigationBar: Bool
    /// The initial root view content of the navigation stack, i.e. the first view shown and the view that will be shown when all subsequent screens are popped to root
    private let rootContent: (Router) -> Content
    /// Wrap your view into the intialiser `content` parameter
    /// - Parameters:
    ///   - previousRouter: Used internally when creating sub `RoutingView' instances for modal presentations.  Set to nill for root instance creation. Used to drop down to the previous navigation stack hierachy.
    ///   - hideNavigationBar: Wether the navigation stack should hide the navigation bar, including back bar items
    ///   - content: This should be the view you want to set as the initial view in a `NavigationStack` view hierarchy.  Used to drop down to the previous navigation stack hierachy.
    public init(previousRouter: Router? = nil, hideNavigationBar: Bool = false, @ViewBuilder content: @escaping (Router) -> Content) {
        self.rootContent = content
        self.router = Router(previousRouter: previousRouter)
        self.hideNavigationBar = hideNavigationBar
    }
    
    /// Creates the `NavigationStack` setting the root content as the view provided in the `content` closure initialiser
    public var body: some View {
        ZStack {
            NavigationStack(path: $router.path) {
                rootContent(router)
                    .navigationDestination(for: Destination.self) { destination in
                        destination.view
                            .if(self.hideNavigationBar == true) {
                                $0.toolbar(.hidden, for: .navigationBar)
                            } 
                    }
            }
            .sheet(item: $router.presentingSheet) { destination in
                destination.view
            }
            .fullScreenCover(item: $router.presentingFullScreenCover) { destination in
                destination.view
            }
            customPopover
        }
    }
    
    @ViewBuilder private var customPopover: some View {
        if !router.presentingPopovers.isEmpty {
            ForEach(router.presentingPopovers) { destination in
                let index = Double(router.presentingPopovers.firstIndex(where: {$0.id == destination.id }) ?? 99)
                ZStack {
                    VStack {
                        if let top = destination.popoverAttributes.padding.top {
                            if top == .infinity { Spacer() } else { Spacer().frame(maxHeight: top) }
                        }
                        HStack {
                            if let leading = destination.popoverAttributes.padding.leading {
                                if leading == .infinity { Spacer() } else { Spacer().frame(maxWidth: leading) }
                            }
                            destination.view
                                .if(destination.popoverAttributes.popoverSize.width == .infinity) {
                                    $0.frame(maxWidth: .infinity)
                                } else: {
                                    $0.frame(width: destination.popoverAttributes.popoverSize.width)
                                }
                                .if(destination.popoverAttributes.popoverSize.height == .infinity) {
                                    $0.frame(maxHeight: .infinity)
                                } else: {
                                    $0.frame(height: destination.popoverAttributes.popoverSize.height)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: destination.popoverAttributes.cornerRadius, style: .continuous))
                                .if(destination.popoverAttributes.translucent == false) {
                                    $0.background {
                                        RoundedRectangle(cornerRadius: destination.popoverAttributes.cornerRadius)
                                            .shadow(radius: destination.popoverAttributes.cornerRadius)
                                    }
                                }
                                .iflet(destination.popoverAttributes.strokeBorderColor) { view, color in
                                    view.overlay(alignment: .topTrailing) {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .strokeBorder(color, lineWidth: destination.popoverAttributes.strokeBorderWidth)
                                    }
                                }
                                .iflet(destination.popoverAttributes.closeAction) { view, action in
                                    view.overlay(alignment: .topTrailing) {
                                        Button {
                                            action()
                                        } label: {
                                            Label("Close", systemImage: "xmark.circle")
                                        }
                                    }
                                }
                            if let trailing = destination.popoverAttributes.padding.trailing {
                                if trailing == .infinity { Spacer() } else { Spacer().frame(maxWidth: trailing) }
                            }
                        }
                        if let bottom = destination.popoverAttributes.padding.bottom {
                            if bottom == .infinity { Spacer() } else { Spacer().frame(maxHeight: bottom) }
                        }
                    }
                    .if(destination.popoverAttributes.ignoresSafeAreas) {
                        $0.ignoresSafeArea()
                    }
                }
                .zIndex(index+1)
                .transition(destination.popoverAttributes.transition)
            }
        }
    }
}
