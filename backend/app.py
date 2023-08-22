from flask import Flask, request, jsonify
from flask_cors import CORS
import base64

#from modeling import main
from eyetracking import eyetrack
from story_modeling.Answer_check import check_answers #이건 맞아

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

# 정답 처리
@app.route('/checkAnswer', methods=['POST'])
def checkAnswer():
    print('connect')
    data = request.get_json()
    print(data)
    answers = data['answers']
    videoNum = data['videoNum']

    result = check_answers(answers, videoNum)
    print(result)
    return jsonify(result)

if __name__ == '__main__':
    app.run(host='172.31.3.182', port=3444, ssl_context=('/etc/letsencrypt/live/server-snail.kro.kr/cert.pem', '/etc/letsencrypt/live/server-snail.kro.kr/privkey.pem'))
