from sklearn import tree
from sklearn import svm
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.metrics import accuracy_score
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split
from feature_extractor import generate_data_set
from sklearn.neural_network import MLPClassifier
import joblib

import pandas as pd
import numpy as np
import sys

def load_data():

    # Load the training data from the CSV file
    training_data = np.genfromtxt('trainingdataset.csv', delimiter=',', dtype=np.int32)

    # Extract the inputs from the training data
    inputs = training_data[:,:-1]

    # Extract the outputs from the training data
    outputs = training_data[:, -1]

    # This model follow 80-20 rule on dataset
    # Split 80% for traning and 20% testing
    boundary = int(0.8*len(inputs))

    training_inputs, training_outputs, testing_inputs, testing_outputs = train_test_split(inputs, outputs, test_size=0.33)

    # Return the four arrays
    return training_inputs, training_outputs, testing_inputs, testing_outputs

def run(classifier, name):
    # Load the training data
    train_inputs, test_inputs,train_outputs, test_outputs = load_data()

    # Train the classifier
    classifier.fit(train_inputs, train_outputs)

    # Create of model file based on the classifier
    joblib.dump(classifier, name + "_mp_model_catch_phish.pkl")

    # Predictions of the validation data set
    predictions = classifier.predict(test_inputs)

    # Predictions of the training data set
    training_predictions = classifier.predict(train_inputs)

    # Accuracy of the validation data
    accuracy = 100.0 * accuracy_score(test_outputs, predictions)
    training_accuracy = 100.0 * accuracy_score(train_outputs, training_predictions)

    # Print the accuracy (percentage of phishing websites correctly predicted by training set and validation set)
    print(f"Accuracy score using {name} training data set: {training_accuracy} test data set: {accuracy}\n")


if __name__ == '__main__':
    # Decision tree
    classifier = tree.DecisionTreeClassifier()
    run(classifier, "Decision tree")

    # Random forest classifier
    classifier = RandomForestClassifier()
    run(classifier, "Random forest")

    # SVM classifier
    classifier = svm.OneClassSVM(gamma='auto', kernel='rbf')
    run(classifier, "One Class SVM")

    # K-nearest neighbours algorithm
    nbrs = KNeighborsClassifier(n_neighbors=3, algorithm='ball_tree')
    run(nbrs, "K nearest neighbours")

    # Logistic Regression
    classifier = LogisticRegression(solver='lbfgs', multi_class='auto')
    run(classifier, "Logistic Regression")

    # Neural Network - Multilayer Perceptron
    classifier = MLPClassifier(solver='lbfgs', alpha=0.001, hidden_layer_sizes=(60,), random_state=1, activation='logistic', learning_rate_init=0.0001, max_iter=500)
    run(classifier, "Multilayer Perceptron")
