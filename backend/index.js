// ftp로 ec2 서버에 현재 index.js를 옮긴 후
// putty를 사용해 node index.js 실행 후 사용가능

const express    = require('express'); //express import
const mysql      = require('mysql'); // mysql import
const dbconfig   = require('./config/database.js'); //master 연결 정보
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

//-------------------------------------------------------------------------------------
// Query

// 회원정보 저장(회원가입)
app.post('/saveUserInfo', (req, res) => {
  const user_id = req.body.USER_ID;
  const user_pw = req.body.USER_PW;

  const query = 'INSERT INTO PARENT (USER_ID, USER_PW) VALUES (?, ?)';

  connection.query(query, [user_id, user_pw], (err, result) => {
    if (err) {
      res.status(500).send('Internal Server Error');
      return;
    }

    const id = result.insertId;

    res.set('Location', `/user/${id}`);

    res.status(200).send({id});
  });
});

// 아이디 중복 확인
app.get('/checkDuplicatedID', (req, res) => {
  const user_id = req.query.USER_ID;

  const query = 'SELECT EXISTS(SELECT 1 FROM PARENT WHERE USER_ID = ?) as exist';

  connection.query(query, [user_id], (err, rows) => {
    if (err) {
      res.status(500).send('Internal Server Error');
      return;
    }
    const exist = rows[0].exist;

    res.status(200).send({exist});
  });
});

// 로그인 정보 확인
app.post('/login',(req,res) =>{
  const user_id = req.body.USER_ID;
  const password = req.body.USER_PW;

  const query = 'SELECT EXISTS(SELECT 1 FROM PARENT WHERE USER_ID = ? and USER_PW = ?) as exist';

  connection.query(query,[user_id, password],(err,rows)=>{
    if (err){
      res.status(500).send('Internal Server Error');
      return;
    }
    if (rows.length === 0 ){
      res.status(404).send('User not found');
      return;
    }
    
    const isCorrect = rows[0].exist;
    
    if(isCorrect){
      res.status(200).send('1');
    }else{
      res.status(200).send('0');
    }
  })
});
//-------------------------------------------------------------------------------------
// listener
app.listen(app.get('port'), () => {
  console.log(`Server is running on port ${app.get('port')}`);
});