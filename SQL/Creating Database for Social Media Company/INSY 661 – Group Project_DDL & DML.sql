create schema grp_proj1;
use grp_proj1;

CREATE TABLE `Event` (
    eventID INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    `date` DATE NOT NULL,
    price DECIMAL(10 , 2 ),
    audience VARCHAR(255) NOT NULL CHECK (audience IN ('Private' , 'Public', 'Friends')),
    description VARCHAR(255),
    PRIMARY KEY (eventID)
);

CREATE TABLE `Group` (
    groupID INT(10) NOT NULL,
    title VARCHAR(255) NOT NULL,
    audience VARCHAR(255) NOT NULL CHECK (audience IN ('Public' , 'Private')),
    description VARCHAR(255),
    PRIMARY KEY (groupID)
);

CREATE TABLE `User` (
    userID INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    city VARCHAR(255),
    relationship_status VARCHAR(255) CHECK (relationship_status IN ('Single' , 'In a relationship',
        'Engaged',
        'Married',
        'In an open relationship',
        'It’s complicated',
        'Divorced',
        'Widowed')),
    phone_number VARCHAR(255),
    email VARCHAR(255) NOT NULL,
    gender VARCHAR(255),
    birth_date DATE NOT NULL,
    PRIMARY KEY (userID)
);

CREATE TABLE `Post` (
    postID INT NOT NULL,
    about VARCHAR(255),
    type VARCHAR(255) NOT NULL,
    audience VARCHAR(255) NOT NULL CHECK (audience IN ('Public' , 'Friends', 'Specific Friends', 'Only me')),
    `date` TIMESTAMP NOT NULL,
    groupID INT,
    eventID INT,
    userID INT,
    PRIMARY KEY (postID),
    FOREIGN KEY (groupID)
        REFERENCES `Group` (groupID),
    FOREIGN KEY (eventID)
        REFERENCES `Event` (eventID),
    FOREIGN KEY (userID)
        REFERENCES `User` (userID)
);

CREATE TABLE Comment (
    userID INT NOT NULL,
    postID INT NOT NULL,
    about VARCHAR(255),
    date_commented DATE NOT NULL,
    PRIMARY KEY (userID , postID),
    FOREIGN KEY (userID)
        REFERENCES `User` (UserID),
    FOREIGN KEY (postID)
        REFERENCES Post (postID)
);

CREATE TABLE Friend (
    userID INT NOT NULL,
    friendID INT NOT NULL,
    date_friendship DATE NOT NULL,
    PRIMARY KEY (userID , friendID),
    FOREIGN KEY (userID)
        REFERENCES `User` (userID),
    FOREIGN KEY (friendID)
        REFERENCES `User` (userID)
);

CREATE TABLE `Like` (
    userID INT NOT NULL,
    postID INT NOT NULL,
    date_liked DATE NOT NULL,
    PRIMARY KEY (userID , postID),
    FOREIGN KEY (userID)
        REFERENCES `User` (userID),
    FOREIGN KEY (postID)
        REFERENCES Post (postID)
);

CREATE TABLE User_Event (
userID int NOT NULL, 
eventID int NOT NULL, 
attitude varchar(255) NOT NULL CHECK (attitude in ('Going', 'Maybe','Can’t go')),
PRIMARY KEY (userID, eventID),
FOREIGN KEY (userID) REFERENCES `User`(userID),
FOREIGN KEY (eventID) REFERENCES `Event`(eventID)
);

CREATE TABLE User_Group (
userID int NOT NULL, 
groupID int NOT NULL, 
date_joined date NOT NULL, 
PRIMARY KEY (userID, groupID),
FOREIGN KEY (userID) REFERENCES `User`(userID),
FOREIGN KEY (groupID) REFERENCES `Group`(groupID)
);


insert into `User` (userID, name, surname, city, relationship_status, phone_number, email, gender, birth_date) values (1, 'Jacquenetta', 'Servis', 'Kisasa', 'Single', '803-488-4528', 'jservis0@shop-pro.jp', 'Female', '1979-03-10');
insert into `User` (userID, name, surname, city, relationship_status, phone_number, email, gender, birth_date) values (2, 'Dorine', 'Byrnes', 'Khisarya', 'Married', '586-604-5644', 'dbyrnes1@indiatimes.com', 'Male', '1939-04-15');
insert into `User` (userID, name, surname, city, relationship_status, phone_number, email, gender, birth_date) values (3, 'Everard', 'Morforth', 'Pilar', NULL, '951-477-5806', 'emorforth2@linkedin.com', 'Male', '1999-10-19');
insert into `User` (userID, name, surname, city, relationship_status, phone_number, email, gender, birth_date) values (4, 'Goldie', 'Spurr', 'Sumberkindagan', 'It’s complicated', '258-323-8453', 'gspurr3@irs.gov', 'Male', '1927-12-19');
insert into `User` (userID, name, surname, city, relationship_status, phone_number, email, gender, birth_date) values (5, 'Dido', 'Lorey', 'Lampa', 'Married','874-968-8088', 'dlorey4@spiegel.de', 'Male', '1949-11-19');
INSERT INTO `User` (userID,name,surname,city,relationship_status,email,gender,birth_date) VALUES (6,"Alexis","Powers","Baricella","Engaged","mi@felisullamcorper.org","Male","1997-12-31");
INSERT INTO `User` (userID,name,surname,city,relationship_status,email,gender,birth_date) VALUES (7,"Vivian","Shaw","Minto","Married","Nulla.interdum.Curabitur@habitantmorbitristique.edu","Male","1992-02-17");
INSERT INTO `User` (userID,name,surname,city,relationship_status,email,gender,birth_date) VALUES (8,"Amethyst","Kline","100 Mile House","Widowed","Mauris.magna@Vivamusmolestie.com","Male","1989-02-20");
INSERT INTO `User` (userID,name,surname,city,relationship_status,email,gender,birth_date) VALUES (9,"Xaviera","Anthony","Linkhout","Married","non@nisiCumsociis.net","Female","1994-05-06");
INSERT INTO `User` (userID,name,surname,city,relationship_status,email,gender,birth_date) VALUES (10,"Melanie","Clemons","Schwedt","Married","mauris.erat.eget@sitamet.net","Male","1993-11-29");
INSERT INTO `User` (userID,name,surname,city,relationship_status,email,gender,birth_date) VALUES (11,"Zephr","Blackwell","Elbląg","In an open relationship","nunc.Quisque@nectempus.edu","Female","1987-04-26");
INSERT INTO `User` (userID,name,surname,city,relationship_status,email,gender,birth_date) VALUES (12,"Beatrice","Snider","Denver","Single","metus@Integermollis.co.uk","Male","1993-09-22");
INSERT INTO `User` (userID,name,surname,city,relationship_status,email,gender,birth_date) VALUES (13,"Yoshi","Smith","Shillong","Divorced","erat.eget.tincidunt@purus.ca","Male","1994-03-31");
INSERT INTO `User` (userID,name,surname,city,relationship_status,email,gender,birth_date) VALUES (14,"Juliet","Roach","Sheikhupura","Divorced","penatibus@morbitristiquesenectus.co.uk","Female","1996-02-23");
INSERT INTO `User` (userID,name,surname,city,relationship_status,email,gender,birth_date) VALUES (15,"Uma","Morrison","Smolensk","Engaged","sem.ut@sollicitudinamalesuada.ca","Female","1990-07-26");
INSERT INTO `User` (userID,name,surname,city,relationship_status,email,gender,birth_date) VALUES (16,"Amaya","Vargas","Colbún","Engaged","Nullam@euismod.org","Male","1994-01-19");
INSERT INTO `User` (userID,name,surname,city,relationship_status,email,gender,birth_date) VALUES (17,"Leila","Aguirre","Corvino San Quirico","In a relationship","nulla.In.tincidunt@quisarcuvel.net","Female","1987-04-10");
INSERT INTO `User` (userID,name,surname,city,relationship_status,email,gender,birth_date) VALUES (18,"Mara","Fernandez","Renlies","Married","dictum.Proin@inhendreritconsectetuer.net","Female","1990-07-29");
INSERT INTO `User` (userID,name,surname,city,relationship_status,email,gender,birth_date) VALUES (19,"Cassidy","Patel","Paulatuk","Married","sem.semper.erat@feugiat.com","Female","1995-05-21");
INSERT INTO `User` (userID,name,surname,city,relationship_status,email,gender,birth_date) VALUES (20,"Stacy","Small","Norman Wells","In an open relationship","eleifend.nec.malesuada@loremeget.ca","Male","1987-06-19");
INSERT INTO `User` (userID,name,surname,city,relationship_status,phone_number, email,gender,birth_date) VALUES
(21,"Vaibhav","Vishal","Ranchi","In an open relationship",'803-488-4529',"vv@xyz.in","Male","1989-06-19"),
(22,"Rahul","Kumar","Ranchi","In an open relationship",'803-488-4511',"rk@xyz.in","Male","1988-06-19"),
(23,"Naman","Singh","Ranchi","In an open relationship",'803-488-4514',"ns@xyz.in","Male","1997-06-19"),
(24,"Ram","Yogi","Patna","In an open relationship",'803-488-4560',"ry@xyz.in","Male","1990-06-19"),
(25,"Rashmi","Kumari","Bangalore","In an open relationship",'803-488-4556',"rk2@xyz.in","Female","1991-06-19");

insert into `Group` (groupID, title, audience, description) values (1, 'MMA McGill', 'Private', '2021 cohort');
insert into `Group` (groupID, title, audience, description) values (2, 'Best Friend', 'Private', 'Marion and Agathe');
insert into `Group` (groupID, title, audience, description) values (3, 'Politics Department', 'Private', 'Students of the Politics Department');
insert into `Group` (groupID, title, audience, description) values (4, 'Junior Associates', 'Public', NULL);
insert into `Group` (groupID, title, audience, description) values (5, 'Soccer Fans', 'Public', 'Canadian National Team Fans');
INSERT INTO `Group`(groupID,title,audience,description) VALUES (6,"ORGB660","Public","facilisis. Suspendisse");
INSERT INTO `Group` (groupID,title,audience,description) VALUES (7,"SQL","Private","Phasellus dapibus quam quis diam. Pellentesque habitant morbi");
INSERT INTO `Group` (groupID,title,audience,description) VALUES (8,"INSY661","Private","lobortis mauris. Suspendisse aliquet molestie tellus.");
INSERT INTO `Group` (groupID,title,audience,description) VALUES (9,"PYTHON","Public","Donec fringilla. Donec feugiat metus sit amet ante. Vivamus non");
INSERT INTO `Group` (groupID,title,audience,description) VALUES (10,"EXCEL","Public","nunc. In at pede.");
INSERT INTO `group` (`groupID`, `title`, `audience`, `description`) VALUES (11, 'McGill', 'private', 'all McGill\'s Alumni'); 
INSERT INTO `group` (`groupID`, `title`, `audience`, `description`) VALUES (12, 'McGill Math', 'Private', 'All burnsiders!');
INSERT INTO `group` (`groupID`, `title`, `audience`, `description`) VALUES (13, 'McGill Book Excahnge', 'public', 'a place to buy/sell cheap textbooks!');

insert into `Event` (eventID, title, `date`, price, audience, description) values (1, 'Ski Trip', '2095-05-15', 272.22, 'Private', 'Trip to Whistler');
insert into `Event` (eventID, title, `date`, price, audience, description) values (2, 'Graduation 2022','2080-04-10', 77.98, 'Public', 'MMA Cohort');
insert into `Event` (eventID, title, `date`, price, audience, description) values (3, 'Celine Dion Concert','2047-03-09', 926.68, 'Friends', NULL);
insert into `Event` (eventID, title, `date`, price, audience, description) values (4, 'Daytrip to the mall','2087-04-22', 57179940.62, 'Private', "Let's go shopping");
insert into `Event` (eventID, title, `date`, price, audience, description) values (5, 'Party at my house','2047-02-05', 9.33, 'Public', 'BYOB');
INSERT INTO `Event` (eventID,title,`date`,price,audience,description) VALUES (6,"Rock Concert","2009-02-25",306,"Friends","vitae mauris sit amet lorem semper auctor. Mauris");
INSERT INTO `Event` (eventID,title,`date`,price,audience,description) VALUES (7,"Cooking Class","2008-10-24",282,"Private","magna sed dui. Fusce aliquam,");
INSERT INTO `Event` (eventID,title,`date`,price,audience,description) VALUES (8,"Filed Trip","2016-10-25",1829,"Public","mi tempor lorem, eget mollis lectus pede et");
INSERT INTO `Event` (eventID,title,`date`,price,audience,description) VALUES (9,"MMA Graduation","2018-01-13",24,"Private","commodo hendrerit. Donec porttitor tellus non magna. Nam");
INSERT INTO `Event` (eventID,title,`date`,price,audience,description) VALUES (10,"Animal Shelters Volunteer","2014-10-16",1085,"Friends","facilisi. Sed");
insert into `Event` (eventID, title, `date`, price, audience, description) values (11, 'Museum','2020-02-05', NULL, 'Public', 'Good to go ');
insert into `Event` (eventID, title, `date`, price, audience, description) values (12, 'Party at my house','2021-10-05', 9.33, 'Public', 'BYOB');

insert into Post (postID , about, type, audience, `date`, groupID, eventID, userID) values (1, 'Summer vacations', 'Photo', 'Friends', '2009-05-25 14:30:27', NULL, NULL, 1);
insert into Post (postID , about, type, audience, `date`, groupID, eventID, userID) values (2, 'Family dinner', 'Photo', 'Friends', '2026-03-11 17:36:24', NULL, NULL, 1);
insert into Post (postID , about, type, audience, `date`, groupID, eventID, userID) values (3, NULL, 'Video', 'Only me', '2019-07-22 02:24:16', 1, NULL, NULL );
insert into Post (postID , about, type, audience, `date`, groupID, eventID, userID) values (4, 'Graduation', 'Photo', 'Public', '2012-08-06 16:35:28', NULL, NULL, 3);
insert into Post (postID , about, type, audience, `date`, groupID, eventID, userID) values (5, NULL, 'Text', 'Friends','2014-04-11 04:56:44', NULL, 2, NULL);
INSERT INTO Post (postID,about,type,audience,date,groupID,eventID,userID) VALUES (6,"Music","Text","Friends","2007-01-09 03:05:25",NULL,NULL,7);
INSERT INTO Post (postID,about,type,audience,date,groupID,eventID,userID) VALUES (7,"Shopping","Video","Only me","2002-12-14 05:55:52",NULL,NULL,8);
INSERT INTO Post (postID,about,type,audience,date,groupID,eventID,userID) VALUES (8,"Movie night","Text","Only me","2021-08-02 09:45:36",4,NULL,NULL);
INSERT INTO Post (postID,about,type,audience,date,groupID,eventID,userID) VALUES (9,NULL,"Text","Specific Friends","2009-01-29 05:25:47",NULL,3,NULL);
INSERT INTO Post (postID,about,type,audience,date,groupID,eventID,userID) VALUES (10,NULL,"Video","Public","2017-10-20 13:23:39",NULL,NULL,2);
INSERT INTO Post (postID,about,type,audience,date,groupID,eventID,userID) VALUES (11,"Game night","Video","Friends","2004-11-28 19:29:32",1,NULL,NULL);
INSERT INTO Post (postID,about,type,audience,date,groupID,eventID,userID) VALUES (12,"Dogs","Video","Specific Friends","2020-12-02 01:49:32",8,NULL,NULL);
INSERT INTO Post (postID,about,type,audience,date,groupID,eventID,userID) VALUES (13,"Date","Text","Only me","2012-02-03 13:16:10",NULL,NULL,6);
INSERT INTO Post (postID,about,type,audience,date,groupID,eventID,userID) VALUES (14,"Cats","Video","Specific Friends","2012-01-21 04:10:22",9,NULL,NULL);
INSERT INTO Post (postID,about,type,audience,date,groupID,eventID,userID) VALUES (15,NULL,"Photo","Specific Friends","2022-01-09 21:29:18",NULL,NULL,7);
insert into Post (postID , about, type, audience, `date`, groupID, eventID, userID) values (16, 'Good day', 'Text', 'Friends','2014-04-11 04:56:44', NULL, NULL, 2);
insert into Post (postID , about, type, audience, `date`, groupID, eventID, userID) values (17, 'Bad day', 'Text', 'Friends','2014-04-11 04:56:44', NULL, NULL, 2);
insert into Post (postID , about, type, audience, `date`, groupID, eventID, userID) values (18, 'Wonderful', 'Text', 'Friends','2014-04-11 04:56:44', NULL, NULL, 2);

insert into Comment (userID, postID, about, date_commented) values (1, 1, 'Good photo!', '2012-12-23');
insert into Comment (userID, postID, about, date_commented) values (1, 4,'Amazing', '2025-08-08');
insert into Comment (userID, postID, about, date_commented) values (2, 1,'Nice one','2023-01-26');
insert into Comment (userID, postID, about, date_commented) values (3,1,'Looking good','2016-02-25');
insert into Comment (userID, postID, about, date_commented) values (4,4,'cool','2014-08-31');
INSERT INTO Comment (userID,postID,about,date_commented) VALUES (19,11,"WOW","2018-09-28");
INSERT INTO Comment (userID,postID,about,date_commented) VALUES (16,9,"QAQ","2023-09-30");
INSERT INTO Comment (userID,postID,about,date_commented) VALUES (14,11,"Cute!","2015-01-22");
INSERT INTO Comment (userID,postID,about,date_commented) VALUES (4,14,":)","2019-04-08");
INSERT INTO Comment (userID,postID,about,date_commented) VALUES (11,4,"TAT","2021-09-06");
INSERT INTO Comment (userID,postID,about,date_commented) VALUES (20,8,"lb","2015-06-16");
INSERT INTO Comment (userID,postID,about,date_commented) VALUES (15,11,"first","2017-06-12");
INSERT INTO Comment (userID,postID,about,date_commented) VALUES (10,1,"so happy","2018-08-29");
INSERT INTO Comment (userID,postID,about,date_commented) VALUES (10,9,"~~~","2015-07-27");
INSERT INTO Comment (userID,postID,about,date_commented) VALUES (8,1,"amazing","2024-02-26");
INSERT INTO Comment (userID,postID,about,date_commented) VALUES (13,4,"lovely","2024-09-09");
INSERT INTO Comment (userID,postID,about,date_commented) VALUES (8,14,"wonderful","2022-07-01");
INSERT INTO Comment (userID,postID,about,date_commented) VALUES (1,2,"ooooo","2019-02-05");
INSERT INTO Comment (userID,postID,about,date_commented) VALUES (1,15,"+_+","2020-06-17");
INSERT INTO Comment (userID,postID,about,date_commented) VALUES (10,13,"0_0","2021-04-08");

insert into Friend (userID, friendID, date_friendship) values (1,2,'2018-01-31');
insert into Friend (userID, friendID, date_friendship) values (1,4,'2020-12-09');
insert into Friend (userID, friendID, date_friendship) values (2,3,'2021-08-29');
insert into Friend (userID, friendID, date_friendship) values (5,1,'2014-12-10');
insert into Friend (userID, friendID, date_friendship) values (2,5,'2028-11-13');
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (1,11,"2020-04-13");

insert into Friend (friendID, userID, date_friendship) values (1,2,'2018-01-31'),(1,4,'2020-12-09'),
(2,3,'2021-08-29'),(5,1,'2014-12-10'),(2,5,'2028-11-13'),(18,6,"2020-04-13"),
(3,1,"2020-10-18"),(20,11,"2021-09-13"),(9,10,"2023-10-23"),(5,17,"2022-10-23"),
(4,5,"2023-02-21"),(8,1,"2024-08-05"),(3,8,"2020-04-17"),(7,6,"2025-02-27"),(4,14,"2021-11-28"),
(14,9,"2022-04-23"),(13,1,"2020-10-13"),(16,4,"2025-02-19"),(9,8,"2025-01-07"),(9,15,"2025-01-19"),
(19,2,"2018-10-01"),(1,11,"2020-04-13");

INSERT INTO Friend (userID,friendID,date_friendship) VALUES (18,6,"2020-04-13");
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (3,1,"2020-10-18");
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (20,11,"2021-09-13");
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (9,10,"2023-10-23");
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (5,17,"2022-10-23");
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (4,5,"2023-02-21");
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (8,1,"2024-08-05");
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (3,8,"2020-04-17");
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (7,6,"2025-02-27");
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (4,14,"2021-11-28");
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (14,9,"2022-04-23");
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (13,1,"2020-10-13");
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (16,4,"2025-02-19");
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (9,8,"2025-01-07");
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (9,15,"2025-01-19");
INSERT INTO Friend (userID,friendID,date_friendship) VALUES (19,2,"2018-10-01");


insert into `Like` (userID, postID, date_liked) values (1,1,'2029-02-01');
insert into `Like` (userID, postID, date_liked) values (1,2,'2009-11-06');
insert into `Like` (userID, postID, date_liked) values (3,4,'2009-09-01');
insert into `Like` (userID, postID, date_liked) values (5,1,'2016-12-31');
insert into `Like` (userID, postID, date_liked) values (4,2,'2025-05-11');
INSERT INTO `Like` (userID,postID,date_liked) VALUES (9,11,"2022-10-29");
INSERT INTO `Like` (userID,postID,date_liked) VALUES (6,3,"2024-10-09");
INSERT INTO `Like` (userID,postID,date_liked) VALUES (13,4,"2022-12-10");
INSERT INTO `Like` (userID,postID,date_liked) VALUES (19,3,"2022-03-02");
INSERT INTO `Like` (userID,postID,date_liked) VALUES (14,15,"2018-11-29");
INSERT INTO `Like` (userID,postID,date_liked) VALUES (19,13,"2022-11-16");
INSERT INTO `Like`(userID,postID,date_liked) VALUES (7,14,"2020-05-13");
INSERT INTO `Like` (userID,postID,date_liked) VALUES (12,8,"2024-10-06");
INSERT INTO `Like` (userID,postID,date_liked) VALUES (16,15,"2023-05-21");
INSERT INTO `Like` (userID,postID,date_liked) VALUES (7,12,"2023-07-31");
INSERT INTO `Like` (userID,postID,date_liked) VALUES (12,10,"2023-04-09");
INSERT INTO `Like` (userID,postID,date_liked) VALUES (5,11,"2020-01-11");
INSERT INTO `Like` (userID,postID,date_liked) VALUES (14,5,"2019-02-06");
INSERT INTO `Like` (userID,postID,date_liked) VALUES (10,3,"2024-11-07");


insert into User_Event (userID, eventID, attitude) values (1,1,'Going');
insert into User_Event (userID, eventID, attitude) values (2,2,'Maybe');
insert into User_Event (userID, eventID, attitude) values (3,3,'Going');
insert into User_Event (userID, eventID, attitude) values (4,5,'Can’t go');
insert into User_Event (userID, eventID, attitude) values (5,4,'Going');
INSERT INTO User_Event (userID,eventID,attitude) VALUES (9,7,"Going");
INSERT INTO User_Event (userID,eventID,attitude) VALUES (17,3,"Maybe");
INSERT INTO User_Event (userID,eventID,attitude) VALUES (10,9,"Maybe");
INSERT INTO User_Event (userID,eventID,attitude) VALUES (14,5,"Going");
INSERT INTO User_Event (userID,eventID,attitude) VALUES (11,2,"Going");
INSERT INTO User_Event (userID,eventID,attitude) VALUES (17,10,"Maybe");
INSERT INTO User_Event (userID,eventID,attitude) VALUES (12,10,"Maybe");
INSERT INTO User_Event (userID,eventID,attitude) VALUES (19,5,"Can’t go");
INSERT INTO User_Event (userID,eventID,attitude) VALUES (11,3,"Maybe");
INSERT INTO User_Event (userID,eventID,attitude) VALUES (6,7,"Maybe");
INSERT INTO User_Event (userID,eventID,attitude) VALUES (1,7,"Maybe");
INSERT INTO User_Event (userID,eventID,attitude) VALUES (2,1,"Can’t go");
INSERT INTO `User_Event` (`userID`, `eventID`, `attitude`) VALUES (4, 11, 'Going');
INSERT INTO `User_Event` (`userID`, `eventID`, `attitude`) VALUES (4, 1, 'Can\'t go');
INSERT INTO `User_Event` (`userID`, `eventID`, `attitude`) VALUES (2, 11, 'Going');
INSERT INTO `User_Event` (`userID`, `eventID`, `attitude`) VALUES (3, 11, 'Going');
INSERT INTO `User_Event` (`userID`, `eventID`, `attitude`) VALUES (1, 4, 'Can\'t go');
INSERT INTO `user_event` (`userID`, `eventID`, `attitude`) VALUES (9, 4, 'Going');

insert into User_Group (userID, groupID, date_joined) values (1,1,'2027-03-01');
insert into User_Group (userID, groupID, date_joined) values (2,1,'2013-02-10');
insert into User_Group (userID, groupID, date_joined) values (3,1,'2011-05-04');
insert into User_Group (userID, groupID, date_joined) values (1,2,'2018-02-28');
insert into User_Group (userID, groupID, date_joined) values (4,2,'2011-05-22');
INSERT INTO User_Group (userID,groupID,date_joined) VALUES (9,2,"2022-01-09");
INSERT INTO User_Group (userID,groupID,date_joined) VALUES (4,6,"2021-09-14");
INSERT INTO User_Group (userID,groupID,date_joined) VALUES (6,6,"2022-08-26");
INSERT INTO User_Group (userID,groupID,date_joined) VALUES (11,8,"2022-04-11");
INSERT INTO User_Group (userID,groupID,date_joined) VALUES (4,3,"2022-03-22");
INSERT INTO User_Group (userID,groupID,date_joined) VALUES (14,5,"2021-11-04");
INSERT INTO User_Group (userID,groupID,date_joined) VALUES (11,3,"2022-07-12");
INSERT INTO User_Group (userID,groupID,date_joined) VALUES (13,9,"2022-04-29");
INSERT INTO User_Group (userID,groupID,date_joined) VALUES (14,4,"2021-10-26");
INSERT INTO User_Group (userID,groupID,date_joined) VALUES (16,1,"2022-04-22");
INSERT INTO User_Group (userID,groupID,date_joined) VALUES (16,2,"2022-06-13");
INSERT INTO User_Group (userID,groupID,date_joined) VALUES (4,1,"2021-02-26");
INSERT INTO User_Group (userID,groupID,date_joined) VALUES (5, 11, '2020-9-1');
INSERT INTO User_Group (userID,groupID,date_joined) VALUES (2,2,"2022-01-09");
INSERT INTO User_Group (userID,groupID,date_joined) VALUES (11,2,"2021-09-14");
