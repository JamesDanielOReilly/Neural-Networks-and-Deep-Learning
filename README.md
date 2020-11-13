# Neural-Networks-and-Deep-Learning
Code and notes for my artificial neural networks and deep learning course at KU Leuven. Link to the final [25 page report](final-report.pdf). 
The course and repo are split into four sections:

## 1. Supervised Learning and Generalisation
This section focuses on understanding the basic elements of neural networks through applying simple networks to function fitting and exploring different ways to train the network. This section includes:
  * Comparison of different learning algorithms such as GD, GDA, conjugate methods like Fletcher-Reeves and Polak-Ribiere, BFGS quasi-newton, and Levenberg-Marquardt
  * Feed-forward networks for approximating 1D and 2D functions
  * Exploring activation functions
  * Network topology and exploring network hyperparameters
  * Bayesian inference of network hyperparameters

![test](/images/fitted_curves.png)
  
## 2. Recurrent Networks
A recurrent neural network (RNN) is a class of artificial neural networks where connections between nodes form a directed graph along a temporal sequence. This section explores different types of recurrent neural networks and applications with time-series analysis. This section includes:
* Hopfield networks and attractor states for two and three-neuron Hopfield nets
* Convergence of Hopfield networks with different initialisation points
* Hopfield networks for handwritten digits
* Time-series prediction with LSTMs

## 3. Deep Feature Learning
Here I discuss different methods for learning features from and classifying image data, including:
* PCA for random and correlated data
* Reconstruction of data from reduced dimensionality space
* PCA on handwritten digits
* Autoencoders, stacked autoencoders and methods for finetuning
* Theory of convolutional neural networks: convolution kernels and max-pooling 
* Local connectivity, parameter sharing, and translation invariance

## 4. Generative Models
In this section I explore a number of different generative models and compare their performance on different datasets.
* Restricted Boltzmann machines and training an RBM on the MNIST dataset. Generation of new datasets from the RBM with Gibbs sampling
* Deep Boltzmann machines. Training a DBM on the MNIST dataset and viewing interconnection weights in each layer, illustrating the low-level features which are learning in early layer in deeper networks
* Training deep convolutional generative adversarial networks (DCGANs) on the CIFAR dataset and exploring different architectural guidelines
* Evaluating GAN performance, stability, and mode collapse
* Optimal transport and the Wasserstein metric
* Wasserstein GANs, comparison of distance metrics for probability distributions
* Wasserstein GANs, weight clipping, and performance evaluation
