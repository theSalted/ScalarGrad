//
//  main.swift
//  TinyGrad
//
//  Created by Yuhao Chen on 10/15/24.
//

import TinyGrad

let a = Scalar(2.0, label: "a")
let b = Scalar(-3.0, label: "b")
let c = Scalar(10.0, label: "c")
let d = a * b; d.label = "d"
let e = d + c; e.label = "e"
let f = Scalar(-2.0, label: "f")
let l = e * f; l.label = "l"

print("Simple Tree")
print("Value: ", l)
print("Tree:")
print(l.makeAsciiTree())
print("\n\n")


let x1 = Scalar(2.0, label: "x1")
let x2 = Scalar(0.0, label: "x2")
let w1 = Scalar(-3.0, label: "w1")
let w2 = Scalar(1.0, label: "w2")
let x = Scalar(6.8813735870195432, label: "x")
let x1w1 = x1*w1; x1w1.label = "x1*w1"
let x2w2 = x2*w2; x2w2.label = "x2*w2"
let x1w1x2w2 = x1w1 + x2w2; x1w1x2w2.label = "x1*w1+x2*w2"
let n = x1w1x2w2 + x; n.label = "n"
let o = tanh(n); o.label = "o"

o.backward()

print("Complex Grpah")
print("Value: ", o)
print("Tree:")
print(o.makeAsciiTree())
print("\n\n")


let y = Scalar(3.0, label: "y")
let z = y + y ; z.label = "z"

z.backward()

print("Actual Graph")
print("Value: ", z)
print("Tree:")
print(z.makeAsciiTree())
print("\n\n")

let s = Scalar(-2.0, label: "s")
let t = Scalar(3.0, label: "t")
let u = s * t; u.label = "u"
let v = s + t; v.label = "v"
let w = u * v; w.label = "w"

w.backward()

print("Actual More Complicated Graph")
print("Value: ", w)
print("Tree:")
print(w.makeAsciiTree())
print("\n\n")



