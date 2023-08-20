from flask import Flask, request
from flask_cors import CORS
import base64

#from modeling import main
from eyetracking import eyetrack

app = Flask(__name__)
CORS(app)

'''
# STT
@app.route('/audioRecognition', methods=['POST'])
def audio2Text():
    encoded = request.form['audio']
    audioData = base64.b64decode(encoded)
    transcription_text = main.transcribe_audio(audioData)
    return transcription_text
'''

# 얼굴 이미지 데이터
@app.route('/faceRecognize', methods=['POST'])
def faceRecognize():
    imagefile = request.files['image']
    byteImg = imagefile.read()

    etCount = eyetrack.eyetract(byteImg)
    return str(etCount)

if __name__ == '__main__':
    app.run(host='172.31.3.182', port=3033)