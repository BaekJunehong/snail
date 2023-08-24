# SNaiL 🐌

> 안녕하세요. 팀 **Home Gravity**입니다.

> 최종 발표 ppt 첨부하고 싶어요~
>
SNaiL은 **음성인식**, **시선추적**, **AI 피드백**의 AI 기술을 활용하여 아동의 인지능력을 검사하는 서비스 입니다.


## AI 기술& 데이터

**1. 음성인식**

음성인식 모델은 **OpenAI**의 **Whisper**를 사용했습니다. Whisper는 다양한 언어와 더불어 한국어 데이터를 사용하여 한국어 인식에서도 뛰어난 성능을 보여 채택했습니다. SNaiL은 아동의 부정확한 발음도 인식해야 하기에 **AI Hub**의 **한국어 아동음성** 5만 문장 데이터로 추가 학습시켰습니다. 

![아동 음성 인식_학습2](https://github.com/home-gravity/snail/assets/137850633/920d747c-dc89-4edb-b18f-7921f3625fd7)

**2. 시선추적**

인지능력 검사를 진행하는 동안 아동의 시선을 추적하여 집중력 또한 측정합니다.
![KakaoTalk_20230824_114419686](https://github.com/home-gravity/snail/assets/137850633/b1d5fa9a-564e-46b7-8fa8-6e42e400ed1a)

**3. AI feedback**

인지능력 검사가 끝난 뒤에 평가 결과를 **OpenAI**의 **chatGPT**를 이용하여 생성합니다.
역량에 따른 결과를 일관되게 제공하고 마치 선생님께 직접 피드백을 받는듯한 느낌을 주도록 템플릿 텍스트를 작성했습니다.
![ai feedback](https://github.com/home-gravity/snail/assets/137850633/6bf32c9f-1b2c-4f53-9861-39f07c7604bd)
