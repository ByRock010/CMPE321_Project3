-- DATABASE MANAGERS

-- kevin:  Valid
INSERT INTO User (username, password_hash, role, name, surname, nationality)
VALUES ('kevin', 'K3v!n#2024', 'Admin', NULL, NULL, NULL);
INSERT INTO Admin (username) VALUES ('kevin');

-- bob:  Valid
INSERT INTO User (username, password_hash, role, name, surname, nationality)
VALUES ('bob', 'Bob@Secure88', 'Admin', NULL, NULL, NULL);
INSERT INTO Admin (username) VALUES ('bob');

-- admin1:  Invalid - password too short, no uppercase, no special character
INSERT INTO User (username, password_hash, role, name, surname, nationality)
VALUES ('admin1', '326593', 'Admin', NULL, NULL, NULL); -- ❌ Invalid: too short, lacks upper/lower/special
-- INSERT INTO Admin (username) VALUES ('admin1'); -- ❌ Skip: password rejected by trigger

-- jessica:  Valid
INSERT INTO User (username, password_hash, role, name, surname, nationality)
VALUES ('jessica', 'secretpw.33#', 'Admin', NULL, NULL, NULL);
INSERT INTO Admin (username) VALUES ('jessica');

-- admin2:  Invalid - lacks uppercase, digit, and special character
INSERT INTO User (username, password_hash, role, name, surname, nationality)
VALUES ('admin2', 'admin2pw', 'Admin', NULL, NULL, NULL); -- ❌ Invalid: lacks required char types
-- INSERT INTO Admin (username) VALUES ('admin2'); -- ❌ Skip: password rejected by trigger

-- fatima:  Valid
INSERT INTO User (username, password_hash, role, name, surname, nationality)
VALUES ('fatima', 'F4tima!DBmngr', 'Admin', NULL, NULL, NULL);
INSERT INTO Admin (username) VALUES ('fatima');

-- yusuf:  Valid
INSERT INTO User (username, password_hash, role, name, surname, nationality)
VALUES ('yusuf', 'Yu$ufSecure1', 'Admin', NULL, NULL, NULL);
INSERT INTO Admin (username) VALUES ('yusuf');

-- maria:  Valid
INSERT INTO User (username, password_hash, role, name, surname, nationality)
VALUES ('maria', 'M@r1a321', 'Admin', NULL, NULL, NULL);
INSERT INTO Admin (username) VALUES ('maria');






-- TITLES

INSERT INTO Title (title_id, title_name) VALUES (1, 'Grandmaster');
INSERT INTO Title (title_id, title_name) VALUES (2, 'International Master');
INSERT INTO Title (title_id, title_name) VALUES (3, 'FIDE Master');
INSERT INTO Title (title_id, title_name) VALUES (4, 'Candidate Master');
INSERT INTO Title (title_id, title_name) VALUES (5, 'National Master');








-- PLAYERS

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('alice', 'Pass@123', 'Alice', 'Smith', 'USA', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('alice', '2000-05-10', 2200, 'FIDE001', 1);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('bob1', 'Bob@2023', 'Bob', 'Jones', 'UK', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('bob1', '1998-07-21', 2100, 'FIDE002', 5);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('clara', 'Clara#21', 'Clara', 'Kim', 'KOR', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('clara', '2001-03-15', 2300, 'FIDE003', 2);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('david', 'D@vid2024', 'David', 'Chen', 'CAN', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('david', '1997-12-02', 2050, 'FIDE004', 3);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('emma', 'Emm@9win', 'Emma', 'Rossi', 'ITA', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('emma', '1999-06-19', 2250, 'FIDE005', 2);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('felix', 'F3lix$88', 'Felix', 'Novak', 'GER', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('felix', '2002-09-04', 2180, 'FIDE006', 4);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('grace', 'Gr@ce2025', 'Grace', 'Ali', 'TUR', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('grace', '2000-08-12', 2320, 'FIDE007', 1);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('henry', 'Hen!ry777', 'Henry', 'Patel', 'IND', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('henry', '1998-04-25', 2150, 'FIDE008', 3);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('isabel', 'Isa#Blue', 'Isabel', 'Lopez', 'MEX', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('isabel', '2001-02-17', 2240, 'FIDE009', 3);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('jack', 'Jack@321', 'Jack', 'Brown', 'USA', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('jack', '1997-11-30', 2000, 'FIDE010', 4);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('kara', 'Kara$99', 'Kara', 'Singh', 'IND', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('kara', '2003-01-07', 2350, 'FIDE011', 5);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('liam', 'Li@mChess', 'Liam', 'Müller', 'GER', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('liam', '1999-05-23', 2200, 'FIDE012', 2);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('mia', 'M!a2020', 'Mia', 'Wang', 'CHN', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('mia', '2002-12-14', 2125, 'FIDE013', 4);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('noah', 'Noah#44', 'Noah', 'Evans', 'CAN', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('noah', '1996-08-08', 2400, 'FIDE014', 1);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('olivia', 'Oliv@99', 'Olivia', 'Taylor', 'UK', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('olivia', '2001-06-03', 2280, 'FIDE015', 2);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('peter', 'P3ter!1', 'Peter', 'Dubois', 'FRA', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('peter', '2000-10-11', 2140, 'FIDE016', 3);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('quinn', 'Quinn%x', 'Quinn', 'Ma', 'CHN', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('quinn', '1998-09-16', 2210, 'FIDE017', 4);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('rachel', 'Rach3l@', 'Rachel', 'Silva', 'BRA', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('rachel', '1999-07-06', 2290, 'FIDE018', 2);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('sam', 'S@mWise', 'Sam', 'O’Neill', 'IRE', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('sam', '2002-01-29', 2100, 'FIDE019', 3);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('tina', 'T!naChess', 'Tina', 'Zhou', 'KOR', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('tina', '2003-03-13', 2230, 'FIDE020', 3);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('umar', 'Umar$22', 'Umar', 'Haddad', 'UAE', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('umar', '1997-11-01', 2165, 'FIDE021', 4);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('vera', 'V3ra#21', 'Vera', 'Nowak', 'POL', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('vera', '2001-04-22', 2260, 'FIDE022', 2);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('will', 'Will@321', 'Will', 'Johnson', 'AUS', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('will', '2000-06-18', 2195, 'FIDE023', 3);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('xena', 'Xena$!', 'Xena', 'Popov', 'RUS', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('xena', '1998-02-09', 2330, 'FIDE024', 1);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('yusuff', 'Yusuf88@', 'Yusuf', 'Demir', 'TUR', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('yusuff', '1999-12-26', 2170, 'FIDE025', 4);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('zoe', 'Zo3!pass', 'Zoe', 'Tanaka', 'JPN', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('zoe', '2001-05-05', 2220, 'FIDE026', 2);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('hakan', 'H@kan44', 'Hakan', 'Şimşek', 'TUR', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('hakan', '1997-10-14', 2110, 'FIDE027', 4);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('julia', 'J!ulia77', 'Julia', 'Nilsen', 'SWE', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('julia', '2002-03-02', 2300, 'FIDE028', 1);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('mehmet', 'Mehmet#1', 'Mehmet', 'Yıldız', 'TUR', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('mehmet', '1998-07-31', 2080, 'FIDE029', 3);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('elena', 'El3na@pw', 'Elena', 'Kuznetsova', 'RUS', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('elena', '2000-09-24', 2345, 'FIDE030', 1);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('nina', 'Nina@2024', 'Nina', 'Martinez', 'ESP', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('nina', '2001-07-12', 2150, 'FIDE031', 3);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('louis', 'Louis#88', 'Louis', 'Schneider', 'GER', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('louis', '1998-11-08', 2100, 'FIDE032', 4);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('sofia', 'Sofia$22', 'Sofia', 'Russo', 'ITA', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('sofia', '2000-02-17', 2250, 'FIDE033', 2);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('ryan', 'Ryan@77', 'Ryan', 'Edwards', 'USA', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('ryan', '1997-09-02', 2170, 'FIDE034', 3);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('claire', 'Claire#01', 'Claire', 'Dupont', 'FRA', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('claire', '2002-01-11', 2225, 'FIDE035', 2);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('jacob', 'Jacob!pass', 'Jacob', 'Green', 'AUS', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('jacob', '1999-10-20', 2120, 'FIDE036', 4);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('ava', 'Ava@Chess', 'Ava', 'Kowalski', 'POL', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('ava', '2003-05-04', 2300, 'FIDE037', 2);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('ethan', 'Ethan$win', 'Ethan', 'Yamamoto', 'JPN', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('ethan', '1998-03-25', 2190, 'FIDE038', 3);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('isabella', 'Isabella#77', 'Isabella', 'Moretti', 'ITA', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('isabella', '2001-08-19', 2240, 'FIDE039', 2);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('logan', 'Logan@55', 'Logan', "O'Connor", 'IRL', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('logan', '1997-04-14', 2115, 'FIDE040', 4);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('sophia', 'Sophia$12', 'Sophia', 'Weber', 'GER', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('sophia', '2000-06-01', 2280, 'FIDE041', 2);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('lucas', 'Lucas!88', 'Lucas', 'Novak', 'CZE', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('lucas', '1999-12-30', 2145, 'FIDE042', 4);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('harper', 'Harper@pw', 'Harper', 'Clarke', 'UK', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('harper', '2002-07-06', 2200, 'FIDE043', 2);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('james', 'James!44', 'James', 'Silva', 'BRA', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('james', '1998-03-21', 2155, 'FIDE044', 3);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('amelia', 'Amelia#99', 'Amelia', 'Zhang', 'CHN', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('amelia', '2001-09-09', 2275, 'FIDE045', 2);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('benjamin', 'Ben@2023', 'Benjamin', 'Fischer', 'GER', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('benjamin', '1997-01-27', 2095, 'FIDE046', 4);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('ella', 'Ella@pw', 'Ella', 'Svensson', 'SWE', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('ella', '2000-11-03', 2235, 'FIDE047', 3);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('alex', 'Alex$88', 'Alex', 'Dimitrov', 'BUL', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('alex', '1999-05-22', 2180, 'FIDE048', 3);

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('lily', 'Lily@sun', 'Lily', 'Nakamura', 'USA', 'Player');

INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
VALUES ('lily', '2003-02-12', 2310, 'FIDE049', 2);








-- SPONSORS

INSERT INTO Sponsor (sponsor_id, sponsor_name) VALUES (100, 'ChessVision');
INSERT INTO Sponsor (sponsor_id, sponsor_name) VALUES (101, 'Grandmaster Corp');
INSERT INTO Sponsor (sponsor_id, sponsor_name) VALUES (102, 'Queen’s Gambit Ltd.');
INSERT INTO Sponsor (sponsor_id, sponsor_name) VALUES (103, 'MateMate Inc.');
INSERT INTO Sponsor (sponsor_id, sponsor_name) VALUES (104, 'RookTech');
INSERT INTO Sponsor (sponsor_id, sponsor_name) VALUES (105, 'PawnPower Solutions');
INSERT INTO Sponsor (sponsor_id, sponsor_name) VALUES (106, 'CheckSecure AG');
INSERT INTO Sponsor (sponsor_id, sponsor_name) VALUES (107, 'Endgame Enterprises');
INSERT INTO Sponsor (sponsor_id, sponsor_name) VALUES (108, 'King''s Arena Foundation');




-- TEAMS

INSERT INTO Team (team_id, team_name, sponsor_id) VALUES (1, 'Knights', 100);
INSERT INTO Team (team_id, team_name, sponsor_id) VALUES (2, 'Rooks', 101);
INSERT INTO Team (team_id, team_name, sponsor_id) VALUES (3, 'Bishops', 102);
INSERT INTO Team (team_id, team_name, sponsor_id) VALUES (4, 'Pawns', 100);
INSERT INTO Team (team_id, team_name, sponsor_id) VALUES (5, 'Queens', 103);
INSERT INTO Team (team_id, team_name, sponsor_id) VALUES (6, 'Kings', 104);
INSERT INTO Team (team_id, team_name, sponsor_id) VALUES (7, 'Castles', 101);
INSERT INTO Team (team_id, team_name, sponsor_id) VALUES (8, 'Checkmates', 105);
INSERT INTO Team (team_id, team_name, sponsor_id) VALUES (9, 'En Passants', 106);
INSERT INTO Team (team_id, team_name, sponsor_id) VALUES (10, 'Blitz Masters', 107);









-- COACHES

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('carol', 'coachpw', 'Carol', 'White', 'Canada', 'Coach');

INSERT INTO Coach (username) VALUES ('carol');

INSERT INTO Coach_Team_Agreement (coach_username, team_id, contract_start, contract_finish)
VALUES ('carol', 1, '2023-01-01', '2026-01-01');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('david_b', 'dPass!99', 'David', 'Brown', 'USA', 'Coach');       --VALİD

INSERT INTO Coach (username) VALUES ('david_b');

INSERT INTO Coach_Team_Agreement (coach_username, team_id, contract_start, contract_finish)
VALUES ('david_b', 2, '2024-02-15', '2026-02-15');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('emma_green', 'E@mma77', 'Emma', 'Green', 'UK', 'Coach');

INSERT INTO Coach (username) VALUES ('emma_green');

INSERT INTO Coach_Team_Agreement (coach_username, team_id, contract_start, contract_finish)
VALUES ('emma_green', 3, '2022-03-01', '2025-03-01');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('fatih', 'FatihC21', 'Fatih', 'Ceylan', 'Turkey', 'Coach');

INSERT INTO Coach (username) VALUES ('fatih');

INSERT INTO Coach_Team_Agreement (coach_username, team_id, contract_start, contract_finish)
VALUES ('fatih', 4, '2024-05-10', '2026-05-10');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('hana', 'Hana$45', 'Hana', 'Yamada', 'Japan', 'Coach');

INSERT INTO Coach (username) VALUES ('hana');

INSERT INTO Coach_Team_Agreement (coach_username, team_id, contract_start, contract_finish)
VALUES ('hana', 5, '2023-04-01', '2024-10-01');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('lucaas', 'Lucas#1', 'Lucas', 'Müller', 'Germany', 'Coach');

INSERT INTO Coach (username) VALUES ('lucaas');

INSERT INTO Coach_Team_Agreement (coach_username, team_id, contract_start, contract_finish)
VALUES ('lucaas', 6, '2024-01-01', '2025-01-01');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('mia_rose', 'Mia!888', 'Mia', 'Rossi', 'Italy', 'Coach');

INSERT INTO Coach (username) VALUES ('mia_rose');

INSERT INTO Coach_Team_Agreement (coach_username, team_id, contract_start, contract_finish)
VALUES ('mia_rose', 7, '2024-06-01', '2025-06-01');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('onur', 'onUr@32', 'Onur', 'Kaya', 'Turkey', 'Coach');

INSERT INTO Coach (username) VALUES ('onur');

INSERT INTO Coach_Team_Agreement (coach_username, team_id, contract_start, contract_finish)
VALUES ('onur', 8, '2023-03-15', '2025-09-15');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('sofia_lop', 'S0fia#', 'Sofia', 'López', 'Spain', 'Coach');

INSERT INTO Coach (username) VALUES ('sofia_lop');

INSERT INTO Coach_Team_Agreement (coach_username, team_id, contract_start, contract_finish)
VALUES ('sofia_lop', 9, '2024-05-01', '2025-11-01');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('arslan_yusuf', 'Yusuf199', 'Yusuf', 'Arslan', 'Turkey', 'Coach');

INSERT INTO Coach (username) VALUES ('arslan_yusuf');

INSERT INTO Coach_Team_Agreement (coach_username, team_id, contract_start, contract_finish)
VALUES ('arslan_yusuf', 10, '2024-02-01', '2026-08-01');




--COACH CERTIFICATES

INSERT INTO CoachCertification (coach_username, coach_certification)
VALUES ('carol', 'FIDE Certified');
INSERT INTO CoachCertification (coach_username, coach_certification)
VALUES ('carol', 'National Level');
INSERT INTO CoachCertification (coach_username, coach_certification)
VALUES ('david_b', 'National Level');
INSERT INTO CoachCertification (coach_username, coach_certification)
VALUES ('emma_green', 'FIDE Certified');
INSERT INTO CoachCertification (coach_username, coach_certification)
VALUES ('fatih', 'National Level');
INSERT INTO CoachCertification (coach_username, coach_certification)
VALUES ('hana', 'Regional Certified');
INSERT INTO CoachCertification (coach_username, coach_certification)
VALUES ('lucaas', 'Club Level');
INSERT INTO CoachCertification (coach_username, coach_certification)
VALUES ('lucaas', 'Regional Certified');
INSERT INTO CoachCertification (coach_username, coach_certification)
VALUES ('mia_rose', 'FIDE Certified');
INSERT INTO CoachCertification (coach_username, coach_certification)
VALUES ('onur', 'National Level');
INSERT INTO CoachCertification (coach_username, coach_certification)
VALUES ('sofia_lop', 'Regional Certified');
INSERT INTO CoachCertification (coach_username, coach_certification)
VALUES ('arslan_yusuf', 'Club Level');
INSERT INTO CoachCertification (coach_username, coach_certification)
VALUES ('arslan_yusuf', 'National Level');



-- ARBITERS

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('erin', 'arbpw', 'Erin', 'Gray', 'Germany', 'Arbiter');

INSERT INTO Arbiter (username, experience_level)
VALUES ('erin', 'Advanced');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('mark', 'refpass', 'Mark', 'Blake', 'USA', 'Arbiter');

INSERT INTO Arbiter (username, experience_level)
VALUES ('mark', 'Intermediate');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('lucy', 'arb123', 'Lucy', 'Wang', 'China', 'Arbiter');

INSERT INTO Arbiter (username, experience_level)
VALUES ('lucy', 'Expert');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('ahmet', 'pass2024', 'Ahmet', 'Yılmaz', 'Turkey', 'Arbiter');

INSERT INTO Arbiter (username, experience_level)
VALUES ('ahmet', 'Beginner');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('ana', 'secretpw', 'Ana', 'Costa', 'Brazil', 'Arbiter');

INSERT INTO Arbiter (username, experience_level)
VALUES ('ana', 'Advanced');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('james', 'secure1', 'James', 'Taylor', 'UK', 'Arbiter');

INSERT INTO Arbiter (username, experience_level)
VALUES ('james', 'Intermediate');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('sara', 'sara!2024', 'Sara', 'Kim', 'South Korea', 'Arbiter');    -- BURADA HATA VERMELİ büyük harf yok, ama kabul eti

INSERT INTO Arbiter (username, experience_level)
VALUES ('sara', 'Expert');

INSERT INTO User (username, password_hash, name, surname, nationality, role)
VALUES ('mohamed', 'mpass', 'Mohamed', 'Farouk', 'Egypt', 'Arbiter');

INSERT INTO Arbiter (username, experience_level)
VALUES ('mohamed', 'Advanced');




-- ARBITER CERTIFICATIONS

INSERT INTO ArbiterCertification (arbiter_username, arbiter_certification)
VALUES ('erin', 'FIDE Certified');
INSERT INTO ArbiterCertification (arbiter_username, arbiter_certification)
VALUES ('mark', 'National Arbiter');
INSERT INTO ArbiterCertification (arbiter_username, arbiter_certification)
VALUES ('lucy', 'International Arbiter');
INSERT INTO ArbiterCertification (arbiter_username, arbiter_certification)
VALUES ('ahmet', 'Local Certification');
INSERT INTO ArbiterCertification (arbiter_username, arbiter_certification)
VALUES ('ana', 'FIDE Certified');
INSERT INTO ArbiterCertification (arbiter_username, arbiter_certification)
VALUES ('james', 'Regional Certification');
INSERT INTO ArbiterCertification (arbiter_username, arbiter_certification)
VALUES ('sara', 'International Arbiter');
INSERT INTO ArbiterCertification (arbiter_username, arbiter_certification)
VALUES ('mohamed', 'National Arbiter');




-- HALLS

INSERT INTO Hall (hall_id, hall_name, hall_country, hall_capacity) VALUES (1, 'USA Hall', 'USA', 10);
INSERT INTO Hall (hall_id, hall_name, hall_country, hall_capacity) VALUES (2, 'UK Hall', 'UK', 8);
INSERT INTO Hall (hall_id, hall_name, hall_country, hall_capacity) VALUES (3, 'Germany Hall', 'Germany', 12);
INSERT INTO Hall (hall_id, hall_name, hall_country, hall_capacity) VALUES (4, 'Turkey Hall', 'Turkey', 6);
INSERT INTO Hall (hall_id, hall_name, hall_country, hall_capacity) VALUES (5, 'France Hall', 'France', 9);
INSERT INTO Hall (hall_id, hall_name, hall_country, hall_capacity) VALUES (6, 'Spain Hall', 'Spain', 10);
INSERT INTO Hall (hall_id, hall_name, hall_country, hall_capacity) VALUES (7, 'Italy Hall', 'Italy', 7);
INSERT INTO Hall (hall_id, hall_name, hall_country, hall_capacity) VALUES (8, 'India Hall', 'India', 8);
INSERT INTO Hall (hall_id, hall_name, hall_country, hall_capacity) VALUES (9, 'Canada Hall', 'Canada', 6);
INSERT INTO Hall (hall_id, hall_name, hall_country, hall_capacity) VALUES (10, 'Japan Hall', 'Japan', 5);




-- TABLES
INSERT INTO ChessTable (table_id, hall_id) VALUES (1, 1);
INSERT INTO ChessTable (table_id, hall_id) VALUES (2, 1);
INSERT INTO ChessTable (table_id, hall_id) VALUES (3, 1);
INSERT INTO ChessTable (table_id, hall_id) VALUES (4, 2);
INSERT INTO ChessTable (table_id, hall_id) VALUES (5, 2);
INSERT INTO ChessTable (table_id, hall_id) VALUES (6, 3);
INSERT INTO ChessTable (table_id, hall_id) VALUES (7, 3);
INSERT INTO ChessTable (table_id, hall_id) VALUES (8, 3);
INSERT INTO ChessTable (table_id, hall_id) VALUES (9, 4);
INSERT INTO ChessTable (table_id, hall_id) VALUES (10, 5);
INSERT INTO ChessTable (table_id, hall_id) VALUES (11, 6);
INSERT INTO ChessTable (table_id, hall_id) VALUES (12, 6);
INSERT INTO ChessTable (table_id, hall_id) VALUES (13, 7);
INSERT INTO ChessTable (table_id, hall_id) VALUES (14, 8);
INSERT INTO ChessTable (table_id, hall_id) VALUES (15, 9);
INSERT INTO ChessTable (table_id, hall_id) VALUES (16, 10);




-- PLAYERS TEAMS

INSERT INTO Player_Team (player_username, team_id)
VALUES ('alice', 1);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('bob1', 2);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('clara', 3);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('david', 4);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('emma', 5);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('felix', 6);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('grace', 7);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('henry', 8);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('isabel', 9);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('jack', 10);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('kara', 1);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('liam', 2);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('mia', 3);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('noah', 4);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('olivia', 5);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('peter', 6);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('quinn', 7);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('rachel', 8);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('sam', 9);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('tina', 10);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('umar', 1);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('vera', 2);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('will', 3);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('xena', 4);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('yusuff', 5);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('zoe', 6);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('hakan', 7);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('julia', 8);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('mehmet', 9);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('elena', 10);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('nina', 1);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('louis', 2);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('sofia', 3);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('ryan', 4);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('claire', 5);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('jacob', 6);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('ava', 7);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('ethan', 8);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('isabella', 9);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('logan', 10);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('sophia', 1);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('lucas', 2);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('harper', 3);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('james', 4);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('amelia', 5);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('benjamin', 6);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('ella', 7);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('alex', 8);
INSERT INTO Player_Team (player_username, team_id)
VALUES ('lily', 9);





-- MATCHES

INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    1, '2025-02-01', 1, 1, 1,
    1, 2,
    'erin', 8.2
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    2, '2025-02-01', 3, 1, 2,
    3, 4,
    'lucy', 7.9
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    3, '2025-02-02', 1, 2, 1,
    5, 6,
    'mark', NULL
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    4, '2025-02-02', 3, 2, 2,
    7, 8,
    'erin', 8.5
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    5, '2025-02-03', 1, 3, 1,
    9, 10,
    'lucy', NULL
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    6, '2025-02-03', 3, 3, 2,
    1, 3,
    'mohamed', NULL
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    7, '2025-02-04', 1, 4, 1,
    2, 5,
    'erin', 4.5
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    8, '2025-02-04', 3, 4, 2,
    6, 7,
    'sara', 3.1
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    9, '2025-02-05', 1, 5, 1,
    8, 9,
    'ana', 7.7
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    10, '2025-02-05', 3, 5, 2,
    10, 1,
    'mark', 6.4
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    11, '2025-02-06', 1, 1, 1,
    3, 5,
    'james', 5.1
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    12, '2025-02-06', 3, 1, 2,
    4, 6,
    'lucy', NULL
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    13, '2025-02-07', 1, 2, 1,
    7, 9,
    'sara', NULL
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    14, '2025-02-07', 3, 2, 2,
    8, 10,
    'mohamed', 2.6
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    15, '2025-02-08', 1, 3, 1,
    1, 4,
    'erin', 7.1
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    16, '2025-02-08', 3, 3, 2,
    2, 5,
    'ana', 6.3
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    17, '2025-02-09', 1, 4, 1,
    3, 6,
    'james', NULL
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    18, '2025-02-09', 3, 4, 2,
    7, 10,
    'mark', 4.9
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    19, '2025-02-10', 1, 5, 1,
    5, 8,
    'lucy', 9.7
);
INSERT INTO ChessMatch (
    match_id, match_date, time_slot, hall_id, table_id,
    white_player_team_id, black_player_team_id,
    assigned_arbiter_username, rating
) VALUES (
    20, '2025-02-10', 3, 5, 2,
    6, 9,
    'ahmet', 7.4
);



-- ÇALIŞAN BİR MAÇ EKLEME
INSERT INTO ChessMatch (
    match_date, time_slot, hall_id, table_id,
    white_player_team_id, white_player,
    black_player_team_id, black_player,
    assigned_arbiter_username, created_by, result
)
VALUES (
    '2025-03-01', 1, 1, 1,
    2, 'bob1',
    1, 'alice',
    'sara', 'david_b', 'Draw'    -- RATİNG YOK ARBİTER OLMAN LAZIM DİYOR
);




-- MATCH ASSIGNMENTS

UPDATE ChessMatch
SET white_player = 'alice', black_player = 'bob1', result = 'Draw'
WHERE match_id = 1;
UPDATE ChessMatch
SET white_player = 'clara', black_player = 'david', result = 'Black Wins'
WHERE match_id = 2;
UPDATE ChessMatch
SET white_player = 'emma', black_player = 'felix', result = 'Black Wins'
WHERE match_id = 3;
UPDATE ChessMatch
SET white_player = 'grace', black_player = 'henry', result = 'Draw'
WHERE match_id = 4;
UPDATE ChessMatch
SET white_player = 'isabel', black_player = 'jack', result = 'Black Wins'
WHERE match_id = 5;
UPDATE ChessMatch
SET white_player = 'kara', black_player = 'liam', result = 'White Wins'
WHERE match_id = 6;
UPDATE ChessMatch
SET white_player = 'mia', black_player = 'noah', result = 'Black Wins'
WHERE match_id = 7;
UPDATE ChessMatch
SET white_player = 'olivia', black_player = 'peter', result = 'White Wins'
WHERE match_id = 8;
UPDATE ChessMatch
SET white_player = 'quinn', black_player = 'rachel', result = 'Black Wins'
WHERE match_id = 9;
UPDATE ChessMatch
SET white_player = 'sam', black_player = 'tina', result = 'Black Wins'
WHERE match_id = 10;
UPDATE ChessMatch
SET white_player = 'tina', black_player = 'umar', result = 'White Wins'
WHERE match_id = 11;
UPDATE ChessMatch
SET white_player = 'umar', black_player = 'vera', result = 'White Wins'
WHERE match_id = 12;
UPDATE ChessMatch
SET white_player = 'vera', black_player = 'will', result = 'Black Wins'
WHERE match_id = 13;
UPDATE ChessMatch
SET white_player = 'will', black_player = 'xena', result = 'Draw'
WHERE match_id = 14;
UPDATE ChessMatch
SET white_player = 'xena', black_player = 'yusuff', result = 'Draw'
WHERE match_id = 15;
UPDATE ChessMatch
SET white_player = 'yusuff', black_player = 'zoe', result = 'White Wins'
WHERE match_id = 16;
UPDATE ChessMatch
SET white_player = 'zoe', black_player = 'hakan', result = 'Black Wins'
WHERE match_id = 17;
UPDATE ChessMatch
SET white_player = 'hakan', black_player = 'julia', result = 'Black Wins'
WHERE match_id = 18;
UPDATE ChessMatch
SET white_player = 'julia', black_player = 'mehmet', result = 'Black Wins'
WHERE match_id = 19;
UPDATE ChessMatch
SET white_player = 'mehmet', black_player = 'elena', result = 'White Wins'
WHERE match_id = 20;