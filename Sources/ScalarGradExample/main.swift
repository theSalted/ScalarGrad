//
//  main.swift
//  ScalarGrad
//
//  Created by Yuhao Chen on 10/15/24.
//

import ScalarGrad

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
let o = exp(2 * n)
let p = (o - 1) / (o + 1)
o.label = "o"
p.label = "p"
p.backward()

print("Complex Grpah")
print("Value: ", p)
print("Tree:")
print(p.makeAsciiTree())
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


let q: [Scalar] = [2.0, 3.0]
let neuron = Neuron(inputSize: 2)
let result = neuron.callAsFunction(q)
print("Neuron test: ", result)


let layer = Layer(inputSize: 2, outputSize: 3)
let result2 = layer.callAsFunction(q)
print("Layer test: ", result2)

let x_mlp: [Scalar] = [2.0, 3.0, -1.0]

let mlp = MLP(inputSize: 3, layerSizes: [4, 4, 1])
let result3 = mlp.callAsFunction(x_mlp)

print("Simple MLP Graph")
print("Value: ", result3[0])
print(result3[0].makeAsciiTree())
print("\n\n")

let xs: [[Scalar]] = [
    [2.0, 3.0, -1.0],
    [3.0, -1.0, 0.5],
    [0.5, 1.0, 1.0],
    [1.0, 1.0, -1.0]
]

let ys: [Scalar] = [1.0, -1.0, -1.0, 1.0]

for k in 0..<50 {
    let ypred = xs.map{ x in mlp(x)[0] }
    let loss = zip(ys, ypred)
        .map{ yGroundTruth, yOutput in pow((yOutput - yGroundTruth), 2) }
        .reduce(Scalar(0.0), +)
    
    // Zero grad
    for parameter in mlp.parameters {
        parameter.gradient = 0.0
    }
    
    loss.backward()
    
    for parameter in mlp.parameters {
        parameter.value += -0.05 * (parameter.gradient ?? 0.0)
    }
    
    print(k, loss.value, ypred)
}



//let ypred = xs.map{ x in mlp(x)[0] }
//print("y prediction: ", ypred)
//let loss = zip(ys, ypred)
//    .map{ yGroundTruth, yOutput in pow((yOutput - yGroundTruth), 2) }
//    .reduce(Scalar(0.0), +)
//print("loss: ", loss)
//loss.backward()
//print("gradient sample: ", mlp.layers[0].neurons[0].weight[0].gradient ?? 0.0)
//print("Simple MLP Graph Trained")
////print(loss.makeAsciiTree())
//print("parameter count: ", mlp.parameters.count)
//print("\n\n")
//
//for paremeter in mlp.parameters {
//    paremeter.value += -0.01 * (paremeter.gradient ?? 0.0)
//}
//
//let ypred2 = xs.map{ x in mlp(x)[0] }
//let loss2 = zip(ys, ypred2)
//    .map{ yGroundTruth, yOutput in pow((yOutput - yGroundTruth), 2) }
//    .reduce(Scalar(0.0), +)
//print("loss: ", loss2)
////for p in mlp.
