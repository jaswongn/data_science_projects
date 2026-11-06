import streamlit as st
import pandas as pd
from pathlib import Path
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# Streamlit interface.
st.title("Steam Game Recommendation System")
st.write("Discover similar games based on genres, categories, and tags.")

# Load and prepare the dataset.
@st.cache_resource
def load_data():
    df = pd.read_csv(Path(__file__).parent / "data/steam.csv")

    games = df[["appid", "name", "genres", "categories", "steamspy_tags"]]
    games = games.drop_duplicates("appid").dropna(subset=["name"]).reset_index(drop=True)

    cols = ["genres", "categories", "steamspy_tags"]
    games[cols] = games[cols].fillna("")

    features = games[cols].agg(" ".join, axis=1).str.replace(";", " ", regex=False)
    matrix = TfidfVectorizer().fit_transform(features)

    return games, matrix

games, matrix = load_data()

game = st.selectbox("Select a game:", sorted(games["name"].unique()))

if st.button("Recommend"):
    idx = games.index[games["name"] == game][0]

    scores = cosine_similarity(matrix[idx], matrix).flatten()
    scores[games["name"] == game] = -1

    top = scores.argsort()[-5:][::-1]

    recommendations = games.iloc[top][["name", "genres"]].copy()
    recommendations["similarity"] = scores[top].round(3)

    st.dataframe(recommendations, hide_index=True)