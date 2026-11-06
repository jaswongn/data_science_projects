# Importing functions
import streamlit as st
import chromadb
import ollama
from pathlib import Path
from sentence_transformers import SentenceTransformer

# Load the embedding model and existing ChromaDB collection.
@st.cache_resource
def load_resources():
    root = Path(__file__).resolve().parent
    model = SentenceTransformer("all-MiniLM-L6-v2")
    client = chromadb.PersistentClient(path=str(root / "data/chroma_db"))
    collection = client.get_collection("dbd_knowledge")
    return model, collection

model, collection = load_resources()

# Retrieve relevant information and generate an answer.
def ask_dbd(question):
    results = collection.query(
        query_embeddings=[model.encode(question).tolist()],
        n_results=2
    )

    context = "\n\n".join(results["documents"][0])

    response = ollama.chat(
        model="qwen3:4b-instruct",
        messages=[
            {"role": "system", "content": "Answer only using the provided context. If the answer is missing, say I don't know."},
            {"role": "user", "content": f"Context:\n{context}\n\nQuestion: {question}"}
        ]
    )

    return response["message"]["content"]

# Streamlit user interface.
st.title("Dead by Daylight AI Companion")
st.write("Ask questions about The Huntress's lore, powers, and perks.")

question = st.text_input("Enter your question:")

if st.button("Ask") and question.strip():
    with st.spinner("Generating answer..."):
        answer = ask_dbd(question)
        st.write(answer)