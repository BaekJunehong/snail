// ftp로 ec2 서버에 현재 index.js를 옮긴 후
// putty를 사용해 node index.js 실행 후 사용가능

const fs = require('fs')
const https = require('https');
const express = require('express'); //express import
const mysql = require('mysql'); // mysql import
const dbconfig = require('./config/database.js'); //master 연결 정보
//const dbconfig_slave = require('./config/database-slave.js'); // slave 연결 정보
const connection = mysql.createConnection(dbconfig); // master 연결
//const connection_slave = mysql.createConnection(dbconfig_slave); // slave 연결
const bodyParser = require('body-parser') // json 형식으로 받기 위한 body-parser 모듈
const app = express();

app.set('port', process.env.PORT || 3000); // 포트
app.use(bodyParser.urlencoded({ extended: false }));

const cors = require('cors');
const { log } = require('console');
app.use(cors());  // 모든 origin 요청 허용

const privateKey = fs.readFileSync('/etc/letsencrypt/live/server-snail.kro.kr/privkey.pem', 'utf8');
const certificate = fs.readFileSync('/etc/letsencrypt/live/server-snail.kro.kr/cert.pem', 'utf8');
const ca = fs.readFileSync('/etc/letsencrypt/live/server-snail.kro.kr/chain.pem', 'utf8');

const credentials = {
	key: privateKey,
	cert: certificate,
	ca: ca
};

const httpsServer = https.createServer(credentials, app);

//-------------------------------------------------------------------------------------
// Query

// 회원정보 저장(회원가입)
app.post('/saveUserInfo', (req, res) => {
  const user_id = req.body.USER_ID;
  const user_pw = req.body.USER_PW;

  const query = "INSERT INTO PARENT (PARENT_ID, USER_ID, USER_PW) SELECT CONCAT(COALESCE(MAX(PARENT_ID), 0) + 1, ''), ?, ? FROM PARENT";

  connection.query(query, [user_id, user_pw], (err, result) => {
    if (err) {
      res.status(500).send('Internal Server Error');
      return;
    }

    const id = result.insertId;

    res.set('Location', `/user/${id}`);

    res.status(200).send({ id });
  });
});

// 아이디 중복 확인
app.post('/checkDuplicatedID', (req, res) => {
  const user_id = req.body.USER_ID;

  const query = 'SELECT EXISTS(SELECT 1 FROM PARENT WHERE USER_ID = ?) as exist';

  connection.query(query, [user_id], (err, rows) => {
    if (err) {
      res.status(500).send('Internal Server Error');
      return;
    }
    const exist = rows[0].exist;

    res.status(200).send({ exist });
  });
});

// 아동정보 저장
app.post('/saveChildInfo', (req, res) => {
  const name = req.body.NAME;
  const sex = parseInt(req.body.SEX);
  const birth = req.body.BIRTH;
  const parent = req.body.PARENT;

  const query = "INSERT INTO CHILD (CHILD_ID, PARENT_ID, NAME, SEX, BIRTH) SELECT CONCAT(COALESCE(MAX(CHILD_ID), 0) + 1, ''), (SELECT PARENT_ID FROM PARENT WHERE USER_ID = ?), ?, ?, ? FROM CHILD";

  connection.query(query, [parent, name, sex, birth], (err, result) => {
    if (err) {
      res.status(500).send('Internal Server Error');
      return;
    }

    const id = result.insertId;

    res.set('Location', `/saveChildInfo/${id}`);

    res.status(200).send({ id });
  });
});

// 로그인 정보 확인
app.post('/login', (req, res) => {
  const user_id = req.body.USER_ID;
  const password = req.body.USER_PW;
  console.log('success');
  const query = 'SELECT EXISTS(SELECT 1 FROM PARENT WHERE USER_ID = ? and USER_PW = ?) as exist';

  connection.query(query, [user_id, password], (err, rows) => {
    if (err) {
      res.status(500).send('Internal Server Error');
      return;
    }
    if (rows.length === 0) {
      res.status(404).send('User not found');
      return;
    }

    const isCorrect = rows[0].exist;

    if (isCorrect) {
      res.status(200).send('1');
    } else {
      res.status(200).send('0');
    }
  })
});

// 자식 정보 가져오기
app.post('/fetchChildData', (req, res) => {
  const parent_id = req.body.USER_ID;

  const query = 'SELECT * FROM CHILD WHERE PARENT_ID = (SELECT PARENT_ID FROM PARENT WHERE USER_ID = ?)';

  connection.query(query, [parent_id], (err, rows) => {
    if (err) {
      res.status(500).send('Internal Server Error');
      return;
    }
    res.status(200).send(rows);
  });
});

// 국어사전 api
app.post('/KoreanAPI', (req, res) => {
  const word = req.body.word;

  const key = 'F5C5A3E80A690DCDBE97D60088D48B52';
  const url = `https://stdict.korean.go.kr/api/search.do?key=${key}&type_search=search&q=${word}`;

  const https = require('https');

  https.get(url, (response) => {
    let data = '';

    response.on('data', (chunk) => {
      data += chunk;
    });

    response.on('end', () => {
      res.status(200).send(data);
    });
  }).on('error', (error) => {
    console.error(error);
    
  });
})


//-------------------------------------------------------------------------------------
// listener
httpsServer.listen(3443, () => {
	console.log('HTTPS Server running on port 3443');
});