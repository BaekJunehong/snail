from transformers import pipeline
from pydub import AudioSegment

model_name_or_path = "./modeling/whisper_model"
asr = pipeline(model=model_name_or_path, task="automatic-speech-recognition")

def transcribe_audio(audio_path):
    audio = AudioSegment.from_file(audio_path, format="m4a")
    audio.export("temp.wav", format="wav")
    transcription = asr("temp.wav")
    return transcription['text']