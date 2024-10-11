//
//  Router.swift
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

/// Router class to control navigation flows between screens
///
/// Each route action returns the same router for push navigation, or a new router for sheet and full sheet cover presentations.  
/// This new router can be stored on:
///
/// - Each screen and used to create the next route flow, either by the screen itself
///
/// - Or passing into a view model if using the **MVVM** pattern
///
/// - Or can be stored in a view model if using the **MVVMC** pattern
///
/// > Router instances are used to represent a reversely linked list of naviagtion stack view heirarchy's.  Each router will have a refference back to it's previous router if being presented, or nill if it's the root router.
///
///
/// To create a new root view at app content level, use the class func **Router.startRoute**, and make sure the view model is created before the router is passed in, since any changes to the router will trigger a recreation of the view model if created within the closure function:
/// ```
/// let lobbyViewModel = LobbyViewModel(rootController: rootController, initialRouter: Router())
/// let destination = Router.startRoute { router in
///     Lobby(lobbyViewModel: lobbyViewModel)
///         .task {
///             lobbyViewModel.router = router
///         }
/// }
/// destination.view
/// ```
/// the **destination.view** will be the root view
///
/// To push a new screen or create a new route from a **screen**, use the method **routeTo** from a router refference held by the screen:
/// ```
/// router.routeTo(.sheet) { router in
///    NewScreen(router: router)
/// }
/// ```
///
/// To push a new screen or create a new route using **MVVM**, use the method **routeTo** from the reference to a router instance held by the screen within the view model functions:
/// ```
/// func presentNewScreen(router: Router) {
///     router.routeTo(.sheet) { router in
///         NewScreen(viewModel: self, router: router)
///     }
/// }
/// ```
///
/// To push a new screen or create a new route using **MVVMC** (where the screen does not hold the router instance), use the method **routeTo** from the view model:
/// ```
/// func presentNewScreen() {
///     self.router = router.routeTo(.sheet) { _ in
///         NewScreen(viewModel: self)
///     }
/// }
/// ```
/// In this case the view model should always keep hold of the current router passed back from each **routeTo()** call or **dismiss()** call
///
/// To push a new popover create a new route
/// ```
/// func presentPopover() {
///     let popoverAttributes = PopoverAttributes(popoverSize: CGSize(width: 250, height: 300),
///                                                   padding: PopoverAttributes.Padding(top: 50, bottom: .infinity, trailing: .infinity),
///                                                transition: .scale(scale: 0.9).combined(with: .move(edge: .leading)),
///                                                 animation: .easeInOut(duration: 0.35),
///                                                 popoverId: "profile")
///    router = router.routeTo(.popover(popoverAttributes), hideNavigationBar: false) { router in
///        ProfileView(profileViewModel: ProfileViewModel(rootController: self.rootController, router: router, popoverId: "profile"))
///    }
/// }
/// ```
/// If you need a popover with a transparent background within the popover content, use the **router.present** method, this can be applied to sheets and full screen cover routes as well
/// ```
/// let popoverAttributes = PopoverAttributes(popoverSize: CGSize(width: 232, height: 334),
///                                               padding: PopoverAttributes.Padding(top: 30, bottom: .infinity, leading: .infinity, trailing: 37),
///                                            transition: .scale(scale: 0.1).combined(with: .move(edge: .trailing)),
///                                             animation: .easeInOut(duration: 0.35),
///                                           translucent: true,
///                                      ignoresSafeAreas: true,
///                                             popoverId: "settingsMenu")
/// router = router.present(.popover(popoverAttributes)) { router in
///     SettingsPopover(lobbyViewModel: self)
///        .background(.clear)
/// }
/// ```
@MainActor @Observable
class Router {
    enum NavigationType: Equatable {
        case push
        case sheet
        case fullScreenCover
        case popover(PopoverAttributes)
    }
    
    /// The parent router in the router heirarchy
    var previousRouter: Router?
    /// The navigation stack path property
    var path: NavigationPath = NavigationPath()
    /// The destination (screen) being presented by this router in a sheet
    var presentingSheet: Destination?
    /// The destination (screen) being presented by this router in a full screen cover
    var presentingFullScreenCover: Destination?
    /// An array of popover destinations (screens) being presented by this router
    var presentingPopovers: [Destination] = []
    /// Set to true to hide the navigation bar (including the back bar item) in a new navigation stack
    var hideNavigationBar = false
    /// Convenience va to check if a sheet is being presented by this router
    var isPresentingSheet: Bool {
        presentingSheet != nil
    }
    /// Convenience var to check if a full screen cover is being presented by this router
    var isPresentingFullSheetCover: Bool {
        return presentingFullScreenCover != nil
    }
    /// Convenience var to check if a sheet, full screen cover, or popover is being presented by this router
    var isPresenting: Bool {
        presentingSheet != nil || presentingFullScreenCover != nil || !presentingPopovers.isEmpty
    }
    /// Convenience var to check if if this router is being presented from within a parent router
    var isPresented: Bool {
        return self.previousRouter != nil
    }
    
    init(previousRouter: Router? = nil) {
        self.previousRouter = previousRouter
    }
    
    /// Create a new route flow using an existing router
    /// - Parameters:
    ///   - routeType: enum value of ``NavigationType``
    ///   - animated: To animate the transition, default is true
    ///   - hideNavigationBar: To hide the navigation bar, including the back bar item - set this on new navigation stack creation (i.e not .push routes, will be ignored on .push routes)
    ///   - destination: The destination view, will have a router object passed in, so that new routes can be driven from this route
    ///   - animated: To animate the transition, default is true
    ///   - hideNavigationBar: To hide the navigation bar, including the back bar item - set this on new navigation stack creation (i.e not .push routes, will be ignored on .push routes)
    /// - Returns: The new Router instance for a new navigation stack flow, or self if simply pushing a new view onto the current navigation stack
    @discardableResult func routeTo<T>(_ routeType: NavigationType, animated: Bool = true, hideNavigationBar: Bool = false, @ViewBuilder destination: @escaping (Router) -> T) -> Router where T: View {
        var newDestination: Destination
        var newRouter = self
        if routeType == .push {
            newDestination = Destination(destination(self))
        } else {
            self.hideNavigationBar = hideNavigationBar
            let routingView = RoutingView(previousRouter: self, hideNavigationBar: self.hideNavigationBar) { router in
                Destination(destination(router)).view
            }
            newDestination = Destination(routingView)
            newRouter = routingView.router
        }
        switch routeType {
        case .push:
            push(newDestination, animated: animated)
        case .sheet:
            presentSheet(newDestination, animated: animated)
        case .fullScreenCover:
            presentFullScreen(newDestination, animated: animated)
        case .popover(let popoverAttributes):
            newDestination.popoverAttributes = popoverAttributes
            presentPopover(newDestination)
        }
        return newRouter
    }
    
    /// Present a sheet, fullscreen cover, or popover **without a navigation stack so the views can be translucent** using the current router.  Note this will not allow new navigation routes using the current router within the view presented - any router calls will act upon the calling router and not this view, so avoid using new navigation flows from the presented view
    /// - Parameters:
    ///   - routeType: enum value of ``NavigationType`` - do not use .push
    ///   - animated: To animate the transition, default is true **ignored for popover**
    ///   - destination: The destination view, will have the same router object passed in, so that new routes can be driven from this route, but this will not create a new navigation stack
    /// - Returns: The same router used to present this view
    @discardableResult func present<T>(_ routeType: NavigationType, animated: Bool = true, @ViewBuilder destination: @escaping (Router) -> T) -> Router where T: View {
        var newDestination = Destination(destination(self))
        switch routeType {
        case .push:
            push(newDestination, animated: animated)
        case .sheet:
            presentSheet(newDestination, animated: animated)
        case .fullScreenCover:
            presentFullScreen(newDestination, animated: animated)
        case .popover(let popoverAttributes):
            newDestination.popoverAttributes = popoverAttributes
            presentPopover(newDestination)
        }
        return self
    }
    
    /// Create a new route flow from a new initial start route
    ///
    /// Use this class function to start an initial module route.  The returned Destination objects's view parameter can be used to set the root content view in the view heirarchy
    /// - Parameter destination: The destination view, will have a router object passed in, so that new routes can be driven from this route
    /// - Returns: A Destination object that represents the new screen.  This is used as the primamry mechanism for the NavigationStack to determine the initial root screen view.
    class func startRoute<T>(@ViewBuilder destination: @escaping (Router) -> T) -> Destination where T: View {
        return Destination(RoutingView(previousRouter: nil) { router in
            Destination(destination(router)).view
        })
    }
    
    /// Pops to the root screen in a navigation stack
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    /// Dismiss the current screen.
    /// 
    /// If the current **screen is presenting** a modal sheet or full screen cover, this is dismissed first, otherwise if the screen has been pushed in a navigation stack, the screen is popped.  In both these cases the current router is returned.
    /// If the screen **is being presented** in a sheet or full screen cover, then the screen is dismissed and the presenting router is returned.
    /// - Returns: The router in the current navigation stack flow, or the previous router if a navigation stack flow is dismissed.  This can be discarded if using the router in screen path navigation flows, or used by the view model to keep track of the current route if using the view model coordinater pattern, wheere the screen does not hold a refference to the router.
    /// - Parameter animated: Determine wether the dismiss is animated for popovers
    @discardableResult func dismiss(animated: Bool = true) -> Router {
        var router: Router = self
        
        func findAndDismiss() -> Router {
            if let router = dismiss(router: self) {
                return router
            } else if let router = dismiss(router: previousRouter) {
                return router
            } else {
                print("Nothing to Dismiss")
                return self
            }
        }
        if animated {
            withAnimation {
                router = findAndDismiss()
            }
        } else {
            withoutAnimation {
                router = findAndDismiss()
            }
        }
        return router
    }
    
    /// Dismiss all views presented by this router - usefull for avoiuding memory leaks when removing views from the view heirarchy
    /// - Parameter animated: Determine wether the dismiss is animated for popovers
    func dismissAll(animated: Bool = true) {
        presentingSheet = nil
        presentingFullScreenCover = nil
        presentingPopovers = []
        popToRoot()
    }
    
    /// Searches through the presented popovers to see if a popover is presented with the given Id
    /// - Parameter id: The id of the popover
    /// - Returns: true if found
    func hasPopoverWithId(id: String) -> Router? {
        if presentingPopovers.contains(where: {$0.popoverAttributes.popoverId == id}) {
            return self
        } else {
            if previousRouter?.presentingPopovers.contains(where: {$0.popoverAttributes.popoverId == id}) == true {
                return previousRouter
            } else {
                return nil
            }
        }
    }
    
    /// Dismisses the popover with the given Id
    /// - Parameter id: The id of the popover
    /// - Parameter animated: Determine wether the dismiss is animated
    /// - Returns: true if the presented popovers contains the given Id and is dismissed
    func dismissPopoverWith(id: String, animated: Bool = true) -> Bool {
        if let router = self.hasPopoverWithId(id: id) {
            if animated {
                withAnimation {
                    router.presentingPopovers = router.presentingPopovers.filter { $0.popoverAttributes.popoverId != id }
                }
            } else {
                router.presentingPopovers = router.presentingPopovers.filter { $0.popoverAttributes.popoverId != id }
            }
            return true
        } else {
            return false
        }
    }
    
    /// Dismiss all popovers from this router and it's previous router
    /// - Parameter animated: Determine wether the dismiss is animated
    func dismissAllPopovers(animated: Bool = true) {
        if animated {
            withAnimation {
                self.presentingPopovers = []
            }
        } else {
            self.presentingPopovers = []
        }
    }
    
    /// Used to count the number of routers being presented
    /// - Returns: The count of router's being presented from the initial base screen.  This will be 1 if no new push/full cover screens were presented from the initial screen
    func routerCount() -> Int {
        var i = 0
        var prev: Router? = self
        while prev != nil  {
            i+=1
            prev = prev?.previousRouter
        }
        return i
    }
    
    /// Used to get hold of the first router in a router heirarchy
    /// - Returns: The root router or self if no sheet/full screen covers have ever been presented in the router chain
    func initialRouter() -> Router {
        var prev = self
        while prev.previousRouter != nil {
            prev = prev.previousRouter!
        }
        return prev
    }
    
    //MARK: Private
    
    /// Private Method used internally only
    func dismiss(router: Router?) -> Router? {
        guard let router else {return self}
        if router.presentingPopovers.isEmpty == false {
            router.presentingPopovers.removeLast()
            return router
        } else if router.presentingSheet != nil {
            router.presentingSheet = nil
            return router
        } else if router.presentingFullScreenCover != nil {
            router.presentingFullScreenCover = nil
            return router
        } else if !router.path.isEmpty {
            router.path.removeLast()
            return router
        } else {
            return nil
        }
    }
    
    private func push(_ destination: Destination, animated: Bool) {
        if !animated {
            withoutAnimation {
                self.path.append(destination)
            }
        } else {
            path.append(destination)
        }
    }
    
    private func presentSheet(_ destination: Destination, animated: Bool) {
        if !animated {
            withoutAnimation {
                self.presentingSheet = destination
            }
        } else {
            self.presentingSheet = destination
        }
    }
    
    private func presentFullScreen(_ destination: Destination, animated: Bool) {
        if !animated {
            withoutAnimation {
                self.presentingFullScreenCover = destination
            }
        } else {
            self.presentingFullScreenCover = destination
        }
    }
    
    private func presentPopover(_ destination: Destination) {
        if let animation = destination.popoverAttributes.animation {
            withAnimation(animation) {
                self.presentingPopovers.append(destination)
            }
        } else {
            self.presentingPopovers.append(destination)
        }
    }
    
    private func withoutAnimation(action: @escaping () -> Void) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            action()
        }
    }
}

//MARK: Extensions
extension Router: Identifiable, Equatable, Hashable {
    nonisolated static func == (lhs: Router, rhs: Router) -> Bool {
        lhs.id == rhs.id
    }
    
    nonisolated public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
