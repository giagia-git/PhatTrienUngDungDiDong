use db_chatapp;

CREATE TABLE Users (
        id INT(11) AUTO_INCREMENT PRIMARY KEY,
        email varchar(50),
        password varchar(50),
        chatID varchar(50)
)

CREATE TABLE Message (
        id INT(11) AUTO_INCREMENT PRIMARY KEY,
        senderChatID varchar(255),
        receiverChatID varchar(255),
        content varchar(255)
)