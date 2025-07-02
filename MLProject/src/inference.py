# SageMaker inference script
# This script should load the trained model and return meal recommendations based on input features

import joblib
import json
import os

def model_fn(model_dir):
    bundle = joblib.load(os.path.join(model_dir, "model.joblib"))
    return bundle

def input_fn(request_body, request_content_type):
    data = json.loads(request_body)
    # Expecting input: {"background": str, "time_of_day": str, "family_size": int, "health_consciousness": str}
    return data

def predict_fn(input_data, bundle):
    model = bundle["model"]
    le_background = bundle["le_background"]
    le_time = bundle["le_time"]
    le_health = bundle["le_health"]
    le_meal = bundle["le_meal"]

    # Prepare features
    X = [[
        le_background.transform([input_data["background"]])[0],
        le_time.transform([input_data["time_of_day"]])[0],
        int(input_data["family_size"]),
        le_health.transform([input_data["health_consciousness"]])[0]
    ]]
    pred_idx = model.predict(X)[0]
    meal = le_meal.inverse_transform([pred_idx])[0]
    return {"recommendation": meal}

def output_fn(prediction, content_type):
    return json.dumps(prediction)
