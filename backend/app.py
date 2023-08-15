from flask import Flask, request
from flask_cors import CORS
import json

from modeling import main

app = Flask(__name__)
CORS(app)

# STT
@app.route('/audioRecognition', methods=['POST'])
def audio2Text():
    audioFile = request.files['audio']
    transcription_text = main.transcribe_audio(audioFile)
    return transcription_text

if __name__ == '__main__':
    app.run(host='172.31.3.182', port=3033)