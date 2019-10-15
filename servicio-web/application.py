from flask import Flask, request, jsonify
import joblib
import numpy as np
import features_extractor
from invalid_prediction_exception import InvalidPrediction

application = Flask(__name__)


@application.errorhandler(InvalidPrediction)
def handle_invalid_prediction(error):
    response = jsonify(error.to_dict())
    response.status_code = error.status_code
    return response

@application.route("/")
def home():
    return "CatchPhish Home"

@application.route("/predict", methods=['POST'])
def predict():
    try:
        classifier = joblib.load("mp_model_catch_phish-90.74.pkl") # Load Perceptron Multilayer model
        json = request.get_json()
        url = json['url']
        dataset = features_extractor.generate_data_set(url)
        print(dataset)
        np_dataset = np.array(dataset)
        np_dataset = np_dataset.reshape(1,-1)
        prediction = classifier.predict(np_dataset)[0]
        print("Prediction value is: ", prediction)
        return jsonify({'prediction': str(prediction)})
    except Exception as e:
        raise InvalidPrediction("The prediction can't be delivered at this time, due to " + str(e) + ".")



if __name__ == '__main__':

    application.run(debug=True)
