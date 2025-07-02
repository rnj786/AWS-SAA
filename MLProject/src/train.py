# SageMaker training script
# This script should load meal_data.csv from S3, train a recommendation model, and save the model artifact back to S3

import pandas as pd
import joblib
import os
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier

def train():
    # Download data from S3 (SageMaker will mount it in /opt/ml/input/data)
    data_path = "/opt/ml/input/data/meal_data.csv"
    df = pd.read_csv(data_path)

    # Preprocessing: encode categorical features
    le_background = LabelEncoder()
    le_meal = LabelEncoder()
    le_time = LabelEncoder()
    le_health = LabelEncoder()

    df["background_enc"] = le_background.fit_transform(df["background"])
    df["time_of_day_enc"] = le_time.fit_transform(df["time_of_day"])
    df["health_enc"] = le_health.fit_transform(df["health_consciousness"])
    df["meal_enc"] = le_meal.fit_transform(df["meal"])

    # Features: background, time_of_day, family_size, health_consciousness
    X = df[["background_enc", "time_of_day_enc", "family_size", "health_enc"]]
    # Target: meal
    y = df["meal_enc"]

    # Fast training: RandomForest with few trees
    model = RandomForestClassifier(n_estimators=10, max_depth=8, n_jobs=-1, random_state=42)
    model.fit(X, y)

    # Save model and encoders
    output_path = "/opt/ml/model/model.joblib"
    joblib.dump({
        "model": model,
        "le_background": le_background,
        "le_time": le_time,
        "le_health": le_health,
        "le_meal": le_meal
    }, output_path)
    print(f"Model and encoders saved to {output_path}")

if __name__ == "__main__":
    train()
