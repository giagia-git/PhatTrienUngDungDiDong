const app = require('express')()
const http = require('http').createServer(app);
const io = require('socket.io')(http, {
    cors: {
        // origin: "http://localhost:3000"
    }
});
require("dotenv").config();

const { randomInt, randomUUID } = require('crypto');
var mysql = require('mysql');
var currentUser;
var receiveUser;

var db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'db_chatapp'
});

db.connect(function(err) {
    if(err) throw err;
    console.log("Connecting Database is success!!");
})

app.get('/', (req, res) => {
    res.send("Node Server is running. Yay!!")
})

app.get('/users',async (req,res) => {
    try {
        const sql = `SELECT * FROM Users`;
        await db.query(sql,(err,result) => {
        if(err) throw err;
            if(Number(result.length)>0) {
                users = result;
                return res.send(Array.from(result));
            } else {
                return res.send(null);
            }
        })
    }catch(err) {
        throw err;
    }
})

app.get('/users/messages',async (req,res) => {
    try {
        const sql = `SELECT * FROM Message`;
        db.query(sql,async (err,result) => {
            if(err) {
                throw err;
            }
            if(Number(result.length)>0) {
                return res.send(result);
            } else {
                return res.send(null);
            }
        })
    }catch(err) {
        throw err;
    }
})

app.get('/users/messages/:chatID',async (req,res) => {
    try {
        const sql = `SELECT * FROM Message WHERE receiverChatID = ? OR senderChatID = ?`;
        db.query(sql,[String(req.params.chatID),String(req.params.chatID)],async (err,result) => {
            if(err) {
                throw err;
            }
            console.log(result);
            if(Number(result.length)>0) {
                return res.send(result);
            } else {
                return res.send();
            }
        })
    }catch(err) {
        throw err;
    }
})

io.use((socket,next) => {
    // console.log(randomUUID());
    console.log("Middleware of Socket.IO as io.use");
    next();
});

io.on('connection', socket => {
    console.log("Connect Socket.IO is success!");
    console.log(socket.rooms);

    socket.onAny((event,...args) => {
        // console.log(event,args);
    })

    socket.on("leaveroom_currentUser", (currentUser) => {
        socket.leave(currentUser.chatID);
    })

    socket.on("joinRoom_currentUser", (currentUser) => {
        socket.join(currentUser.chatID);
    });

    socket.on("newMessage", (req_fromClient) => {
        try {
            var sql = "INSERT INTO Message(senderChatID,receiverChatID,content) VALUES(?,?,?)";
            db.query(sql,[String(req_fromClient.senderChatID),String(req_fromClient.receiverChatID),String(req_fromClient.content)],(err,result) => {
                if(err) {
                    throw err;
                }
                console.log("Thêm tin nhắn vào cơ sở dữ liệu thành công!");
            })
        } catch(err) {
            throw err;
        }
            socket.in(req_fromClient.receiverChatID).emit("receiveMessage",req_fromClient);
    });


    socket.on("User_Login", async (user) => {
        try {
            // Find email of Users in Database
            var sql = "SELECT * FROM Users WHERE email = ? AND password = ?";
            await db.query(sql,[user.email.toString(), user.password.toString()], async (err,result) => {
                if(err) throw err;
                if(Number(result.length)>0) {
                    console.log("Đăng nhập thành công");    
                    //Add username into socket
                    socket.email = result[0].email;
                    socket.chatID = result[0].chatID;

                    console.log(socket.email + "-" + socket.chatID);
                    
                    socket.emit("Login_Success", {
                        email: result[0].email,
                        chatID: result[0].chatID
                    });
                }
            });
        }catch(err) {
            throw err;
        }
    })

    socket.on("User_Registery", (user) => {
        try {
            var sqlParent = "SELECT * FROM Users WHERE email = ?";
            db.query(sqlParent, [user.email.toString()], (err,result) => {
                if(err) throw err;
                if(Number(result.length)<1) {
                    var sqlChild = `INSERT INTO Users(email,password,chatID) values(?,?,?)`;
                    db.query(sqlChild,[user.email.toString(), user.password.toString(),randomUUID()], (err,res) => {
                        if(err) throw err;
                        console.log("Đăng ký tài khoản vào cơ sở dữ liệu thành công");
                        socket.emit("Registery_Success");
                    })
                }
            });
        }catch(err) {
            throw err;
        }
    })
});
http.listen(process.env.PORT, () => {
    console.log(`Server is running on ${process.env.PORT}`);
})