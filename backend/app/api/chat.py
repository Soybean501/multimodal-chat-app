import os
from dotenv import load_dotenv
load_dotenv()
from openai import OpenAI

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
from fastapi import APIRouter, File, UploadFile, Form
from app.schemas.chat import ChatResponse


router = APIRouter()

@router.post("/chat", response_model=ChatResponse)
async def multimodal_chat(
    prompt: str = Form(...),
    audio: UploadFile = File(None),
    image: UploadFile = File(None),
):
    try:
        # Simple example using GPT-3.5-turbo (or use gpt-4 for more powerful responses if your key supports it)
        completion = client.chat.completions.create(model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "You are a helpful assistant. Answer the user's query clearly."},
            {"role": "user", "content": prompt},
        ])
        response_text = completion.choices[0].message.content.strip()

        return {"response_text": response_text}

    except Exception as e:
        return {"response_text": f"OpenAI API error: {e}"}
