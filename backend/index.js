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

// 검사 결과 저장
app.post('/saveTestScore', (req, res) => {
  const score_stroop = req.body.SCORE_STROOP;
  const score_line = req.body.SCORE_LINE;
  const score_chosung = req.body.SCORE_CHOSUNG;
  const score_repeat = req.body.SCORE_REPEAT;
  const score_story = req.body.SCORE_STORY;
  const score_eyetrack = req.body.SCORE_EYETRACK;
  const child_id = req.body.CHILD_ID;

  connection.query('SELECT COALESCE(MAX(RESULT_ID), 0) + 1 as new_id FROM RESULT', (err, result) => {
    if (err) {
      res.status(500).send('Internal Server Error');
      return;
    }
    const new_id = result[0].new_id;
  
    const query1 = `INSERT INTO RESULT (RESULT_ID, TEST_DATE, EYETRACK, STROOP, STORY, VOCA_RP, LINE, CHOSUNG, CHILD_ID)
                    VALUES (?, NOW(), ?, ?, ?, ?, ?, ?, ?)`;
    connection.query(query1, [new_id, score_eyetrack, score_stroop, score_story, score_repeat, score_line, score_chosung, child_id], (err, result) => {
      if (err) {
        res.status(500).send('Internal Server Error');
        return;
      }

      const query2 = 
        `CREATE TEMPORARY TABLE latest_results AS
        SELECT CHILD_ID, MAX(TEST_DATE) as MaxDate
        FROM RESULT
        GROUP BY CHILD_ID;` +
        
        ` CREATE TEMPORARY TABLE latest_scores AS
        SELECT r.*
        FROM latest_results lr
        JOIN RESULT r ON r.CHILD_ID = lr.CHILD_ID AND r.TEST_DATE = lr.MaxDate;` +
        
        ` CREATE TEMPORARY TABLE percentiles AS
        SELECT 
          CHILD_ID,
          TEST_DATE,
          (SELECT COUNT(*) FROM latest_scores WHERE EYETRACK <= ls.EYETRACK) / (SELECT COUNT(*) FROM latest_scores) * 100 AS EYETRACK_PERC,
          (SELECT COUNT(*) FROM latest_scores WHERE STROOP <= ls.STROOP) / (SELECT COUNT(*) FROM latest_scores) * 100 AS STROOP_PERC,
          (SELECT COUNT(*) FROM latest_scores WHERE STORY <= ls.STORY) / (SELECT COUNT(*) FROM latest_scores) * 100 AS STORY_PERC,
          (SELECT COUNT(*) FROM latest_scores WHERE VOCA_RP <= ls.VOCA_RP) / (SELECT COUNT(*) FROM latest_scores) * 100 AS VOCA_RP_PERC,
          (SELECT COUNT(*) FROM latest_scores WHERE LINE <= ls.LINE) / (SELECT COUNT(*) FROM latest_scores) * 100 AS LINE_PERC,
          (SELECT COUNT(*) FROM latest_scores WHERE CHOSUNG <= ls.CHOSUNG) / (SELECT COUNT(*) FROM latest_scores) * 100 AS CHOSUNG_PERC
        FROM latest_scores ls;` +
        
        ` UPDATE RESULT r
        JOIN percentiles p ON r.CHILD_ID = p.CHILD_ID AND r.TEST_DATE = p.TEST_DATE
        SET 
          r.EYETRACK_PERC = p.EYETRACK_PERC,
          r.STROOP_PERC = p.STROOP_PERC,
          r.STORY_PERC = p.STORY_PERC,
          r.VOCA_RP_PERC = p.VOCA_RP_PERC,
          r.LINE_PERC = p.LINE_PERC,
          r.CHOSUNG_PERC = p.CHOSUNG_PERC
        WHERE r.RESULT_ID = ?;` + 
        
        ` DROP TEMPORARY TABLE IF EXISTS latest_results;` +
        ` DROP TEMPORARY TABLE IF EXISTS latest_scores;` +
        ` DROP TEMPORARY TABLE IF EXISTS percentiles;`;

      connection.query(query2, new_id, (err, result) => {
        if (err) {
          res.status(500).send('Internal Server Error');
          return;
        }
        res.status(200).send({message: 'Saved', id: new_id});
      });
    });
  });
});

// 점수 가져오기 (result화면)
app.post('/getScores', (req, res) => {
  const result_id = req.body.RESULT_ID;

  const query = 'SELECT EYETRACK_PERC, STROOP_PERC, STORY_PERC, VOCA_RP_PERC, LINE_PERC, CHOSUNG_PERC, FEEDBACK FROM RESULT WHERE RESULT_ID = ?';
  connection.query(query, result_id, (err, row) => {
    if (err) {
      res.status(500).send('Internal Server Error');
      return;
    }
    res.status(200).send(row);
  })
});

// 한달 전 검사 result_id 가져오기
app.post('/getLastMonthResultID', (req, res) => {
  const child_id = req.body.CHILD_ID;

  const query = 'SELECT RESULT_ID FROM RESULT WHERE CHILD_ID = ? AND TEST_DATE <= DATE_SUB(CURDATE(), INTERVAL 1 MONTH) ORDER BY TEST_DATE DESC LIMIT 1;';
  connection.query(query, child_id, (err, id) => {
    if (err) {
      res.status(500).send('Internal Server Error');
      return;
    }
    res.status(200).send(id);
  })
});

// 최근 검사 result_id 가져오기
app.post('/getLastResultID', (req, res) => {
  const child_id = req.body.CHILD_ID;

  const query = 'SELECT RESULT_ID FROM RESULT WHERE CHILD_ID = ? ORDER BY TEST_DATE DESC LIMIT 1;';
  connection.query(query, child_id, (err, id) => {
    if (err) {
      res.status(500).send('Internal Server Error');
      return;
    }
    res.status(200).send(id);
  })
});

//-------------------------------------------------------------------------------------
// listener
httpsServer.listen(3443, () => {
	console.log('HTTPS Server running on port 3443');
});