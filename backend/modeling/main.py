from transformers import pipeline
from pydub import AudioSegment

model_name_or_path = "./modeling/whisper_model"
asr = pipeline(model=model_name_or_path, task="automatic-speech-recognition")

def transcribe_audio(audioData):
    with open('temp.wav', 'wb') as f:
        f.write(audioData)
    transcription = asr("temp.wav")
    return transcription['text']