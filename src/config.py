import os
from dotenv import load_dotenv

load_dotenv()

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")
MODEL_NAME = os.getenv("MODEL_NAME", "gpt-4o-mini")
RAG_CHUNK_SIZE = 500
RAG_CHUNK_OVERLAP = 50
SEARCH_K = 3