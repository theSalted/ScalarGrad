//
//  Arithmetic.swift
//  ScalarGrad
//
//  Created by Yuhao Chen on 10/16/24.
//

import Foundation

// MARK: Operators
extension Scalar {
    public static func +(_ lhs: Scalar, _ rhs: Scalar) -> Scalar {
        let out = Scalar(lhs.value + rhs.value, elements: (lhs, rhs), operator: "+")
        out._backward = {
            lhs.gradient = 1.0 * (out.gradient ?? 0.0) + (lhs.gradient ?? 0.0)
            rhs.gradient = 1.0 * (out.gradient ?? 0.0) + (rhs.gradient ?? 0.0)
        }
        return out
    }
    
    public static func -(_ lhs: Scalar, _ rhs: Scalar) -> Scalar {
        return lhs + (-rhs)
    }
    
    public static func *(_ lhs: Scalar, _ rhs: Scalar) -> Scalar {
        let out = Scalar(lhs.value * rhs.value, elements: (lhs, rhs), operator: "*")
        out._backward = {
            lhs.gradient = rhs.value * (out.gradient ?? 0.0) + (lhs.gradient ?? 0.0)
            rhs.gradient = lhs.value * (out.gradient ?? 0.0) + (rhs.gradient ?? 0.0)
        }
        return out
    }
    
    public static func /(_ lhs: Scalar, _ rhs: Scalar) -> Scalar {
        guard rhs.value != 0 else {
            fatalError("Division by zero")
        }
        let out = Scalar(lhs.value / rhs.value, elements: (lhs, rhs), operator: "/")
        out._backward = {
            lhs.gradient = (1 / rhs.value) * (out.gradient ?? 0.0) + (lhs.gradient ?? 0.0)
            rhs.gradient = (-lhs.value / pow(rhs.value, 2)) * (out.gradient ?? 0.0) + (rhs.gradient ?? 0.0)
        }
        return out
    }
    
    public static prefix func -(_ value: Scalar) -> Scalar {
        return -1 * value
    }
    
    // MARK: Overload Operators
    public static func +(_ lhs: Scalar, _ rhs: Float) -> Scalar {
        return lhs + Scalar(rhs)
    }
    
    public static func +(_ lhs: Float, _ rhs: Scalar) -> Scalar {
        return Scalar(lhs) + rhs
    }
    
    public static func -(_ lhs: Scalar, _ rhs: Float) -> Scalar {
        return lhs - Scalar(rhs)
    }
    
    public static func -(_ lhs: Float, _ rhs: Scalar) -> Scalar {
        return Scalar(lhs) - rhs
    }
    
    public static func *(_ lhs: Scalar, _ rhs: Float) -> Scalar {
        return lhs * Scalar(rhs)
    }
    
    public static func *(_ lhs: Float, _ rhs: Scalar) -> Scalar {
        return Scalar(lhs) * rhs
    }
    
    public static func /(_ lhs: Scalar, _ rhs: Float) -> Scalar {
        return lhs / Scalar(rhs)
    }
    
    public static func /(_ lhs: Float, _ rhs: Scalar) -> Scalar {
        return Scalar(lhs) / rhs
    }
}

// MARK: Free Functions
public func tanh(_ x: Scalar) -> Scalar {
    let t = tanh(x.value)
    let out = Scalar(t, elements: (x, nil), operator: "tanh")
    out._backward = {
        let grad = (1 - t * t) * (out.gradient ?? 0.0)
        x.gradient = grad + (x.gradient ?? 0.0)
    }
    return out
}

public func exp(_ x: Scalar) -> Scalar {
    let out = Scalar(exp(x.value), elements: (x, nil), operator: "exp")
    out._backward = {
        x.gradient = out.value * (out.gradient ?? 0.0) + (x.gradient ?? 0.0)
    }
    return out
}

public func log(_ x: Scalar) -> Scalar {
    let out = Scalar(log(x.value), elements: (x, nil), operator: "log")
    out._backward = {
        x.gradient = (1 / x.value) * (out.gradient ?? 0.0) + (x.gradient ?? 0.0)
    }
    
    return out
}

public func sin(_ x: Scalar) -> Scalar {
    let out = Scalar(sin(x.value), elements: (x, nil), operator: "sin")
    out._backward = {
        x.gradient = cos(x.value) * (out.gradient ?? 0.0) + (x.gradient ?? 0.0)
    }
    
    return out
}

public func cos(_ x: Scalar) -> Scalar {
    let out = Scalar(cos(x.value), elements: (x, nil), operator: "cos")
    out._backward = {
        x.gradient = -sin(x.value) * (out.gradient ?? 0.0) + (x.gradient ?? 0.0)
    }
    
    return out
}

public func sqrt(_ x: Scalar) -> Scalar {
    let out = Scalar(sqrt(x.value), elements: (x, nil), operator: "sqrt")
    out._backward = {
        x.gradient = (1 / (2 * sqrt(x.value))) * (out.gradient ?? 0.0) + (x.gradient ?? 0.0)
    }
    
    return out
} 

public func pow(_ lhs: Scalar, _ rhs: Scalar) -> Scalar {
    let out = Scalar(pow(lhs.value, rhs.value), elements: (lhs, rhs), operator: "pow")
    
    out._backward = {
        lhs.gradient = rhs.value * pow(lhs.value, (rhs.value - 1)) * (out.gradient ?? 0.0) + (lhs.gradient ?? 0.0)
        rhs.gradient = out.value * log(lhs.value) * (out.gradient ?? 0.0) + (rhs.gradient ?? 0.0)
    }
    
    return out
}



// MARK: Free Function Overloads
public func pow(_ lhs: Scalar, _ rhs: Float) -> Scalar {
    return pow(lhs, Scalar(rhs))
}

public func pow(_ lhs: Float, _ rhs: Scalar) -> Scalar {
    return pow(Scalar(lhs), rhs)
}

