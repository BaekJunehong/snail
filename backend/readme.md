
# Backend

이 프로젝트는 Amazon AWS EC2와 RDS에서 호스팅되며, Node.js와 Flask를 사용하여 개발되었습니다.

![서비스 흐름](https://github.com/home-gravity/snail/assets/47132589/174b6368-6dac-4168-9a2c-f6add066fa74)

##

### 사전 요구사항

- Amazon AWS EC2, RDS
- Node.js
- Flask

### 실행 방법

1. 생성한 EC2 인스턴스에 SSH로 접속합니다. (putty 사용)
2. 다음 명령어를 실행하여 Node.js와 Flask를 실행합니다:

```bash
node index.js & python3 app.py
