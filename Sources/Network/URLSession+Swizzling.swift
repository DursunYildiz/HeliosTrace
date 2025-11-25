import Foundation

extension URLSession {
    private static var isSwizzled = false
    
    static func enableHeliosTraceSwizzling() {
        guard !isSwizzled else { return }
        
        // Target the Objective-C class factory method directly
        let selector = Selector("sessionWithConfiguration:delegate:delegateQueue:")
        let swizzledSelector = #selector(URLSession.heliosTrace_session(configuration:delegate:delegateQueue:))
        
        guard let originalMethod = class_getClassMethod(URLSession.self, selector),
              let swizzledMethod = class_getClassMethod(URLSession.self, swizzledSelector)
        else {
            print("HeliosTrace: Failed to swizzle URLSession. Method not found.")
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
        isSwizzled = true
    }
    
    static func disableHeliosTraceSwizzling() {
        guard isSwizzled else { return }
        
        let selector = Selector("sessionWithConfiguration:delegate:delegateQueue:")
        let swizzledSelector = #selector(URLSession.heliosTrace_session(configuration:delegate:delegateQueue:))
        
        guard let originalMethod = class_getClassMethod(URLSession.self, selector),
              let swizzledMethod = class_getClassMethod(URLSession.self, swizzledSelector)
        else {
            return
        }
        
        method_exchangeImplementations(swizzledMethod, originalMethod)
        isSwizzled = false
    }
    
    @objc class func heliosTrace_session(configuration: URLSessionConfiguration, delegate: URLSessionDelegate?, delegateQueue queue: OperationQueue?) -> URLSession {
        if configuration.protocolClasses != nil {
            configuration.protocolClasses?.insert(CustomHTTPProtocol.self, at: 0)
        } else {
            configuration.protocolClasses = [CustomHTTPProtocol.self]
        }
        
        // Call the original method (which is now swizzled to this one)
        return self.heliosTrace_session(configuration: configuration, delegate: delegate, delegateQueue: queue)
    }
}
