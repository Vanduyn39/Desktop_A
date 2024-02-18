CREATE DATABASE GAME_APPLICATION
GO
USE GAME_APPLICATION 
CREATE TABLE Game 
(
    ID_Game INT IDENTITY CONSTRAINT PK_Game PRIMARY KEY NOT NULL,
    NameGame NVARCHAR(100) NOT NULL,
    Descriptions NTEXT,
    ReleaseDate SMALLDATETIME NOT NULL DEFAULT GETDATE(),
    Genre NVARCHAR(100)
)
CREATE TABLE Users
(
    ID_User INT IDENTITY CONSTRAINT PK_User PRIMARY KEY NOT NULL,
    DisplayName VARCHAR(100) NOT NULL DEFAULT 'user',
    DisplayName VARCHAR(100) NOT NULL,
    Fullname NVARCHAR(100) NOT NULL,
    Email VARCHAR(200) NOT NULL UNIQUE,
    PhoneNumber  VARCHAR(15),
    UserName VARCHAR(100) UNIQUE NOT NULL,
    Password NVARCHAR(1000) NOT NULL DEFAULT 'PA==',
    Type INT NOT NULL DEFAULT 0, --1:ADMIN//0:USER
    CreatedAtUser SMALLDATETIME NOT NULL DEFAULT GETDATE(),
    LastLogin SMALLDATETIME NOT NULL DEFAULT GETDATE() 
)
CREATE TABLE FavoriteGame
(
    ID_Game INT NOT NULL,
    ID_User INT NOT NULL,
    PlayCount INT NOT NULL DEFAULT 0,
    Rate FLOAT,
    CreatedAtFG SMALLDATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY( ID_GAME,ID_USER),
    CONSTRAINT FK_Game_FG FOREIGN KEY (ID_Game) REFERENCES GAME(ID_Game),
    CONSTRAINT FK_User_FG FOREIGN KEY (ID_User) REFERENCES USERS(ID_User)
)
CREATE TABLE  Record 
(
    ID_Record INT IDENTITY CONSTRAINT PK_Record PRIMARY KEY NOT NULL,
    ID_Game INT NOT NULL,
    ID_User INT NOT NULL,
    Scores INT,
    CreatdAtRecord SMALLDATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Game_Record FOREIGN KEY (ID_Game) REFERENCES GAME(ID_Game),
    CONSTRAINT FK_Users_Record FOREIGN KEY (ID_User) REFERENCES USERS(ID_User)
)
--------------------------------------------
SET DATEFORMAT DMY
ALTER TABLE Record ADD CONSTRAINT CK_Record CHECK(Scores>=0)
UPDATE Users SET DisplayName = 'admin' WHERE Type = 1
ALTER TABLE FavoriteGame ADD CONSTRAINT FK_FavoriteGame_Game FOREIGN KEY (ID_Game) REFERENCES Game (ID_Game) ON DELETE CASCADE
ALTER TABLE Record ADD CONSTRAINT FK_Record_Game FOREIGN KEY (ID_Game) REFERENCES Game (ID_Game) ON DELETE CASCADE
UPDATE Users SET LastLogin=GETDATE();
GO 
-----------------------------------------
--Cập nhật số lần chơi bảng FavoriteGame dựa vào số lần chơi
CREATE PROC IncreasePlayCount @userID INT, @gameID INT
AS
BEGIN
        UPDATE FavoriteGame SET PlayCount = PlayCount + 1 WHERE ID_User = @userID AND ID_Game = @gameID
        SELECT *FROM FavoriteGame WHERE ID_User = @userID ORDER BY PlayCount DESC
END
GO
-----------------------------------------
--Cập nhật điểm cao nhất trong bảng Record 
CREATE PROCEDURE UpdateScores @userID INT, @gameID INT, @newscores INT
AS
BEGIN
    DECLARE @oldscores INT
    SELECT @oldscores = Scores FROM Record WHERE ID_User = @userID AND ID_Game = @gameID
    IF @newcores > @oldscores
    BEGIN
        UPDATE Record SET Scores = @newscores WHERE ID_User = @userID AND ID_Game = @gameID
    END
END
GO
---------------------------------------------
--Nhận tài khoản dựa vào tên đăng nhập
CREATE PROC USP_GetUsersByUserName @username VARCHAR(100)
AS
BEGIN 
        SELECT*FROM USERS WHERE UserName=@username
END 
GO 
------------------------------------------
--Trùng username và password thì đăng nhập thành công
CREATE PROC USP_Login @username VARCHAR(100), @password NVARCHAR(1000)
AS
BEGIN 
        SELECT*FROM Users WHERE UserName=@username AND Password=@password 
END 
GO 
------------------------------------------
--Người dùng thay đổi mật khẩu 
CREATE PROC USP_UpdateUsers
@username VARCHAR(100), @password NVARCHAR(1000), @newPassword NVARCHAR(1000), @displayname VARCHAR(100)
AS
BEGIN
        DECLARE @isRightPass Int =0
        SELECT @isRightPass= COUNT(*)FROM Users WHERE UserName=@username AND Password=@password

        IF (@isRightPass=1)
        BEGIN
                IF(@newPassword=NULL OR @newPassword ='')
                BEGIN
                        UPDATE Users SET DisplayName=@displayname  WHERE UserName=@username 
                END
                ELSE
                        UPDATE Users SET DisplayName=@displayname, Password=@newPassword WHERE UserName=@username 
        END
END
GO 
------------------------------------------
CREATE PROC USP_GetGameList 
AS 
BEGIN
        SELECT*FROM Game
END 
GO
------------------------------------------
CREATE PROC USP_GetFavoriteGameList 
AS 
BEGIN
        SELECT*FROM FavoriteGame
END 
GO
------------------------------------------
CREATE PROC USP_GetRecordList 
AS 
BEGIN
        SELECT*FROM Record 
END 
GO
------------------------------------------
CREATE PROC USP_UpdateUsers
@username VARCHAR(100), @password NVARCHAR(1000), @newPassword NVARCHAR(1000), @displayname VARCHAR(100)
AS
BEGIN
        DECLARE @isRightPass Int =0
        SELECT @isRightPass= COUNT(*)FROM Users WHERE UserName=@username AND Password=@password

        IF (@isRightPass=1)
        BEGIN
                IF(@newPassword=NULL OR @newPassword ='')
                BEGIN
                        UPDATE Users SET DisplayName=@displayname  WHERE UserName=@username 
                END
                ELSE
                        UPDATE Users SET DisplayName=@displayname, Password=@newPassword WHERE UserName=@username 
        END
END
GO 
------------------------------------------