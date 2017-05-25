//
//  SwizzledUIViewController.swift
//  AutomaticInvocationTracker
//
//  Created by Matteo Sassano on 16.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

private let swizzling: (UIViewController.Type) -> () = { viewController in
    
    let originalSelector = #selector(viewController.viewWillAppear(_:))
    let swizzledSelector = #selector(viewController.myViewWillAppear(animated:))
    
    let originalMethod = class_getInstanceMethod(viewController, originalSelector)
    let swizzledMethod = class_getInstanceMethod(viewController, swizzledSelector)
    
    method_exchangeImplementations(originalMethod, swizzledMethod) }

extension UIViewController {
    
    open override class func initialize() {
        // make sure this isn't a subclass
        guard self === UIViewController.self else { return }
        swizzling(self)
    }
    
    // MARK: - Method Swizzling
    
    func myViewWillAppear(animated: Bool) {
        // The agent starts tracking the viewWillAppear function
        // let invocationId = Agent().trackInvocation()
        
        // Executes the actual viewWillAppear function
        self.myViewWillAppear(animated: animated)
        
        // The agent stops tracking the viewWillAppear function
        // Agent().closeInvocation(id: invocationId)
    }
    
}
