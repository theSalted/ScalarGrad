//
//  Arithmetic.swift
//  TinyGrad
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
    let t = (exp(2 * x.value) - 1) / (exp(2 * x.value) + 1)
    let out = Scalar(t, elements: (x, nil), operator: "tanh")
    out._backward = {
        x.gradient = (1 - pow(t, 2)) * (out.gradient ?? 0.0) + (x.gradient ?? 0.0)
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

public func exp(_ x: Scalar) -> Scalar {
    let out = Scalar(exp(x.value), elements: (x, nil), operator: "exp")
    out._backward = {
        x.gradient = out.value * (out.gradient ?? 0.0) + (x.gradient ?? 0.0)
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
