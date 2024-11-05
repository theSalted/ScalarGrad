# Scalar Grad
A tiny CPU-bound Scalar based Machine Learning framework.

## Features
- Autograd: The `Scalar` class tracks operations applied to its instances, automatically building a computational graph. Autograd computes gradients by backpropagating through this graph using the chain rule, making it essential for gradient-based optimization tasks.
- Unary Operations: Unary operations like tanh(), exp(), sin(), cos(), and more.
- Binary Operations: Overloaded operators such as +, -, *, and / handle element-wise operations `Scalar` instances, enabling the construction of complex mathematical expressions.
- Built in Neron, Layer and NueralNetwork helpers for easy constrtuction of deep learning networks
- Support for ASCII Tree printing for visualization

Special Thanks to Andrej Karpathy.
