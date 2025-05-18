CREATE TABLE User ( 
username VARCHAR(50) PRIMARY KEY, 
password_hash VARCHAR(100) NOT NULL, -- İsmini password_hash yaptım
name VARCHAR(50) , 
surname VARCHAR(50) , 
nationality VARCHAR(50) ,
role ENUM('Player', 'Coach', 'Arbiter', 'Admin') NOT NULL  -- BURA YENİ
); 
CREATE TABLE Admin(
  username VARCHAR(50) PRIMARY KEY,
  FOREIGN KEY (username) REFERENCES USER(username));
CREATE TABLE Title ( 
title_id INT PRIMARY KEY AUTO_INCREMENT, 
title_name VARCHAR(50) UNIQUE NOT NULL 
); 
CREATE TABLE Player ( 
username VARCHAR(50) PRIMARY KEY, -- password vardı sildim
date_of_birth DATE NOT NULL, 
elo_rating INT CHECK (elo_rating > 1000), 
fide_id VARCHAR(20) UNIQUE NOT NULL, 
title_id INT NOT NULL, 
FOREIGN KEY (username) REFERENCES User(username), 
FOREIGN KEY (title_id) REFERENCES Title(title_id) 
); 
CREATE TABLE Coach ( 
username VARCHAR(50) PRIMARY KEY, 
FOREIGN KEY (username) REFERENCES User(username) ON DELETE CASCADE 
); 
CREATE TABLE CoachCertification ( 
coach_username VARCHAR(50) NOT NULL, 
coach_certification VARCHAR(50) NOT NULL, 
PRIMARY KEY (coach_username, coach_certification), 
FOREIGN KEY (coach_username) REFERENCES Coach(username) 
); 
CREATE TABLE Arbiter ( 
username VARCHAR(50) PRIMARY KEY, 
experience_level ENUM('Beginner', 'Intermediate', 'Advanced', 'Expert') NOT NULL, 
FOREIGN KEY (username) REFERENCES User(username) ON DELETE CASCADE 
); 
CREATE TABLE ArbiterCertification ( 
arbiter_username VARCHAR(50) NOT NULL, 
arbiter_certification VARCHAR(50) NOT NULL, 
PRIMARY KEY (arbiter_username, arbiter_certification), 
FOREIGN KEY (arbiter_username) REFERENCES Arbiter(username) 
);
CREATE TABLE Sponsor (
  sponsor_id INT PRIMARY KEY,
  sponsor_name VARCHAR(100) NOT NULL
);
CREATE TABLE Team ( 
  team_id INT PRIMARY KEY AUTO_INCREMENT, 
  team_name VARCHAR(100) NOT NULL,
  sponsor_id INT NOT NULL,
  FOREIGN KEY (sponsor_id) REFERENCES Sponsor(sponsor_id)
);
CREATE TABLE Player_Team (
  player_username VARCHAR(50),
  team_id INT,
  PRIMARY KEY (player_username, team_id),
  FOREIGN KEY (player_username) REFERENCES Player(username),
  FOREIGN KEY (team_id) REFERENCES Team(team_id)
);
CREATE TABLE Coach_Team_Agreement ( 
coach_username VARCHAR(50), 
team_id INT, 
contract_start DATE NOT NULL, 
contract_finish DATE NOT NULL, 
PRIMARY KEY (coach_username, team_id), 
FOREIGN KEY (coach_username) REFERENCES Coach(username) ON DELETE 
RESTRICT, 
FOREIGN KEY (team_id) REFERENCES Team(team_id) ON DELETE CASCADE 
); 
CREATE TABLE Hall ( 
hall_id INT PRIMARY KEY AUTO_INCREMENT, 
hall_name VARCHAR(100) NOT NULL, 
hall_country VARCHAR(50) NOT NULL, 
hall_capacity INT CHECK (hall_capacity > 0) NOT NULL 
); 
CREATE TABLE ChessTable ( 
table_id INT PRIMARY KEY AUTO_INCREMENT, 
hall_id INT NOT NULL, 
FOREIGN KEY (hall_id) REFERENCES Hall(hall_id) 
); 
CREATE TABLE ChessMatch (
  match_id                     INT            PRIMARY KEY AUTO_INCREMENT,
  hall_id                      INT            NOT NULL,
  table_id                     INT            NOT NULL,
  white_player_team_id         INT            NOT NULL,
  white_player                 VARCHAR(50)    NOT NULL,
  black_player_team_id         INT            NULL,
  black_player                 VARCHAR(50)    NULL,
  time_slot                    INT            NOT NULL CHECK (time_slot BETWEEN 1 AND 4),
  match_date                   DATE           NOT NULL,
  assigned_arbiter_username    VARCHAR(50)    NOT NULL,
  created_by                   VARCHAR(50)    NOT NULL,
  rating                       INT            CHECK (rating BETWEEN 1 AND 10),
  result ENUM('White Wins', 'Black Wins', 'Draw'),


  FOREIGN KEY (hall_id)                   REFERENCES Hall(hall_id),
  FOREIGN KEY (table_id)                  REFERENCES ChessTable(table_id),
  FOREIGN KEY (white_player_team_id)      REFERENCES Team(team_id),
  FOREIGN KEY (black_player_team_id)      REFERENCES Team(team_id),
  FOREIGN KEY (white_player)              REFERENCES Player(username),
  FOREIGN KEY (black_player)              REFERENCES Player(username),
  FOREIGN KEY (assigned_arbiter_username) REFERENCES Arbiter(username),
  FOREIGN KEY (created_by)                REFERENCES Coach(username),

  CHECK (white_player_team_id <> black_player_team_id),

  UNIQUE (white_player, match_date, time_slot),
  UNIQUE (black_player, match_date, time_slot),
  UNIQUE (assigned_arbiter_username, match_date, time_slot),
  UNIQUE (table_id, match_date, time_slot)
) ENGINE=InnoDB;








-- BURADAN İTİBAREN YENİ --------------

-- baba bu user rolei alio 
DELIMITER //

CREATE PROCEDURE AuthenticateUser(
    IN in_username VARCHAR(50),
    IN in_password VARCHAR(100),
    OUT out_role VARCHAR(10)
)
BEGIN
    SELECT role INTO out_role
    FROM User
    WHERE username = in_username AND password_hash = in_password;
END //

DELIMITER ;

DELIMITER $$
-- bu baba yeni user ekliyo
CREATE PROCEDURE AddUser(
  IN username VARCHAR(50),
  IN password VARCHAR(100), 
  IN name VARCHAR(50), 
  IN surname VARCHAR(50), 
  IN nationality VARCHAR(50),
  IN role VARCHAR(50)
)
BEGIN
    INSERT INTO User (username, password_hash, name, surname, nationality,role)
    VALUES (username, password, name, surname, nationality, role);
END$$

DELIMITER ;


-- bu baba yeni player ekliyo
DELIMITER $$

CREATE PROCEDURE AddPlayer(
    IN p_username VARCHAR(50),
    IN p_date_of_birth DATE,
    IN p_elo_rating INT,
    IN p_fide_id VARCHAR(20),
    IN p_title_id INT
)
BEGIN
    INSERT INTO Player (username, date_of_birth, elo_rating, fide_id, title_id)
    VALUES (p_username, p_date_of_birth, p_elo_rating, p_fide_id, p_title_id);
END$$


DELIMITER ;


DELIMITER $$

CREATE PROCEDURE AddArbiter(
    IN c_username VARCHAR(50),
    IN experience VARCHAR(50)
)
BEGIN
  INSERT INTO Arbiter (username,experience_level)
  VALUES (c_username,experience);
END$$
  
DELIMITER ; 


DELIMITER $$

CREATE PROCEDURE AddCoach(
    IN c_username VARCHAR(50)
)
BEGIN
  INSERT INTO Coach (username)
  VALUES (c_username);
END$$
  
DELIMITER ; 







DELIMITER $$

CREATE TRIGGER trg_no_white_player_overlap
BEFORE INSERT ON ChessMatch
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM ChessMatch
    WHERE match_date = NEW.match_date
      AND time_slot IN (NEW.time_slot, NEW.time_slot + 1)
      AND (white_player = NEW.white_player OR black_player = NEW.white_player)
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'White player is already in a match during this time slot.';
  END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_no_black_player_overlap
BEFORE INSERT ON ChessMatch
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM ChessMatch
    WHERE match_date = NEW.match_date
      AND time_slot IN (NEW.time_slot, NEW.time_slot + 1)
      AND (white_player = NEW.black_player OR black_player = NEW.black_player)
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Black player is already in a match during this time slot.';
  END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_no_arbiter_overlap
BEFORE INSERT ON ChessMatch
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM ChessMatch
    WHERE match_date = NEW.match_date
      AND time_slot IN (NEW.time_slot, NEW.time_slot + 1)
      AND assigned_arbiter_username = NEW.assigned_arbiter_username
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Arbiter is already assigned to another match during this time slot.';
  END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_no_table_overlap
BEFORE INSERT ON ChessMatch
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM ChessMatch
    WHERE match_date = NEW.match_date
      AND time_slot IN (NEW.time_slot, NEW.time_slot + 1)
      AND table_id = NEW.table_id
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'The table is already assigned to another match during this time slot.';
  END IF;
END$$

DELIMITER ;




DELIMITER $$

CREATE TRIGGER trg_no_double_rating
BEFORE UPDATE ON ChessMatch
FOR EACH ROW
BEGIN
  IF OLD.rating IS NOT NULL AND NEW.rating IS NOT NULL AND OLD.rating != NEW.rating THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Match has already been rated. Ratings cannot be changed.';
  END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_rating_only_after_match_date
BEFORE UPDATE ON ChessMatch
FOR EACH ROW
BEGIN
  IF NEW.rating IS NOT NULL AND NEW.match_date > CURDATE() THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot rate a match before its scheduled date.';
  END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_no_overlapping_coach_contracts
BEFORE INSERT ON Coach_Team_Agreement
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM Coach_Team_Agreement
    WHERE coach_username = NEW.coach_username
      AND NOT (
        NEW.contract_finish < contract_start OR
        NEW.contract_start > contract_finish
      )
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Coach has an overlapping team contract.';
  END IF;
END$$

DELIMITER ;



-- Enforce & hash passwords on User:
DELIMITER $$

CREATE TRIGGER trg_user_password_policy
BEFORE INSERT ON User
FOR EACH ROW
BEGIN
  IF CHAR_LENGTH(NEW.password_hash) < 8
     OR NEW.password_hash NOT REGEXP '[A-Z]'
     OR NEW.password_hash NOT REGEXP '[a-z]'
     OR NEW.password_hash NOT REGEXP '[0-9]'
     OR NEW.password_hash NOT REGEXP '[^A-Za-z0-9]' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Password must be ≥8 chars with upper, lower, digit & special.';
  END IF;

  SET NEW.password_hash = SHA2(NEW.password_hash, 256);
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_user_password_policy_upd
BEFORE UPDATE ON User
FOR EACH ROW
BEGIN
  IF NEW.password_hash <> OLD.password_hash THEN
    IF CHAR_LENGTH(NEW.password_hash) < 8
       OR NEW.password_hash NOT REGEXP '[A-Z]'
       OR NEW.password_hash NOT REGEXP '[a-z]'
       OR NEW.password_hash NOT REGEXP '[0-9]'
       OR NEW.password_hash NOT REGEXP '[^A-Za-z0-9]' THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password must be ≥8 chars with upper, lower, digit & special.';
    END IF;

    SET NEW.password_hash = SHA2(NEW.password_hash, 256);
  END IF;
END$$

DELIMITER ;



-- -- Only the assigned arbiter may rate
-- DELIMITER $$
-- CREATE TRIGGER trg_only_assigned_arbiter
-- BEFORE UPDATE ON ChessMatch
-- FOR EACH ROW
-- BEGIN
--   IF NEW.rating IS NOT NULL
--      AND SUBSTRING_INDEX(CURRENT_USER(),'@',1) <> OLD.assigned_arbiter_username
--   THEN
--     SIGNAL SQLSTATE '45000'
--       SET MESSAGE_TEXT = 'Only the assigned arbiter can submit a rating.';
--   END IF;
-- END$$
-- DELIMITER ;

DELIMITER //
CREATE PROCEDURE SubmitRating (
    IN p_match_id INT,
    IN p_rating INT,
    IN p_arbiter_username VARCHAR(50)
)
BEGIN
  -- Check: only assigned arbiter can rate
  IF NOT EXISTS (
    SELECT 1 FROM ChessMatch
    WHERE match_id = p_match_id
      AND assigned_arbiter_username = p_arbiter_username
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Only the assigned arbiter can submit a rating.';
  END IF;

  -- Check: match already rated
  IF EXISTS (
    SELECT 1 FROM ChessMatch
    WHERE match_id = p_match_id AND rating IS NOT NULL
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Match has already been rated.';
  END IF;

  -- Check: match date in past
  IF EXISTS (
    SELECT 1 FROM ChessMatch
    WHERE match_id = p_match_id AND match_date > CURDATE()
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot rate match before its scheduled date.';
  END IF;

  -- All good → update
  UPDATE ChessMatch
  SET rating = p_rating
  WHERE match_id = p_match_id;
END;
//
DELIMITER ;




-- Enforce both players really belong to their teams
DELIMITER $$
CREATE TRIGGER trg_match_players_in_team
BEFORE INSERT ON ChessMatch
FOR EACH ROW
BEGIN
  -- white
  IF NOT EXISTS (
    SELECT 1
      FROM Player_Team pt
     WHERE pt.player_username = NEW.white_player
       AND pt.team_id        = NEW.white_player_team_id
  )
  THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'White player not on specified team.';
  END IF;

  -- black (if provided)
  IF NEW.black_player IS NOT NULL
     AND NOT EXISTS (
          SELECT 1
            FROM Player_Team pt
           WHERE pt.player_username = NEW.black_player
             AND pt.team_id        = NEW.black_player_team_id
        )
  THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Black player not on specified team.';
  END IF;
END$$
DELIMITER ;


-- -- Track “who created” each match & restrict deletions to that coach
-- DELIMITER $$

-- CREATE TRIGGER trg_only_creator_delete
-- BEFORE DELETE ON ChessMatch
-- FOR EACH ROW
-- BEGIN
--   IF SUBSTRING_INDEX(CURRENT_USER(), '@', 1) <> OLD.created_by THEN
--     SIGNAL SQLSTATE '45000'
--       SET MESSAGE_TEXT = 'Only the coach who created this match can delete it.';
--   END IF;
-- END$$

-- DELIMITER ;

DELIMITER $$

CREATE PROCEDURE DeleteMatchByCoach (
    IN p_match_id INT,
    IN p_coach_username VARCHAR(50)
)
BEGIN
  DECLARE match_creator VARCHAR(50);

  SELECT created_by INTO match_creator
  FROM ChessMatch
  WHERE match_id = p_match_id;

  IF match_creator IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Match does not exist.';
  END IF;

  IF match_creator <> p_coach_username THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Only the coach who created this match can delete it.';
  END IF;

  DELETE FROM ChessMatch
  WHERE match_id = p_match_id;
END$$

DELIMITER ;





DELIMITER $$
CREATE TRIGGER trg_match_players_in_team_upd
BEFORE UPDATE ON ChessMatch
FOR EACH ROW
BEGIN
  IF NEW.black_player IS NOT NULL
     AND NOT EXISTS (
       SELECT 1
         FROM Player_Team pt
        WHERE pt.player_username = NEW.black_player
          AND pt.team_id        = NEW.black_player_team_id
     )
  THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Black player not on specified team.';
  END IF;
END$$
DELIMITER ;





--  PROCEDURE















DELIMITER $$

CREATE PROCEDURE assign_black_player (
    IN p_match_id INT,
    IN p_black_player VARCHAR(50),
    IN p_black_team_id INT
)
BEGIN
    DECLARE conflict INT DEFAULT 0;
    DECLARE player_valid INT DEFAULT 0;
    DECLARE match_date_val DATE;
    DECLARE match_time_slot INT;

    -- Get match date and time_slot
    SELECT match_date, time_slot INTO match_date_val, match_time_slot
    FROM ChessMatch WHERE match_id = p_match_id;

    -- Check time conflict for black player
    SELECT 1 INTO conflict
    FROM ChessMatch
    WHERE match_id != p_match_id
      AND match_date = match_date_val
      AND time_slot IN (match_time_slot, match_time_slot + 1)
      AND (
        white_player = p_black_player OR
        black_player = p_black_player
      )
    LIMIT 1;

    IF conflict IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Conflict: player is already in a match during this time.';
    END IF;

    -- Check if the player belongs to the specified team
    SELECT 1 INTO player_valid
    FROM Player_Team
    WHERE player_username = p_black_player
      AND team_id = p_black_team_id
    LIMIT 1;

    IF player_valid IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Player does not belong to the given team.';
    END IF;

    -- Assign black player if all checks pass
    UPDATE ChessMatch
    SET black_player = p_black_player,
        black_player_team_id = p_black_team_id
    WHERE match_id = p_match_id;
END$$

DELIMITER ;


-- Opponents per player (example proc)
DELIMITER $$
CREATE PROCEDURE GetPlayerOpponents(IN p_username VARCHAR(50))
BEGIN
  SELECT opponent,
         COUNT(*)      AS times_played
    FROM (
      SELECT black_player   AS opponent
        FROM ChessMatch
       WHERE white_player = p_username
         AND black_player IS NOT NULL
      UNION ALL
      SELECT white_player   AS opponent
        FROM ChessMatch
       WHERE black_player = p_username
         AND white_player IS NOT NULL
    ) AS sub
   GROUP BY opponent
   ORDER BY times_played DESC;
END$$
DELIMITER ;


DELIMITER $$

CREATE PROCEDURE GetAssignedMatches(IN p_arbiter VARCHAR(50))
BEGIN
  SELECT *
    FROM ChessMatch
    WHERE assigned_arbiter_username = p_arbiter
    ORDER BY match_date, time_slot;
END$$

DELIMITER ;



--  Include ELO in your co-player stats
DELIMITER $$
CREATE PROCEDURE GetPlayerOpponentsWithELO(IN p_username VARCHAR(50))
BEGIN
  WITH OppCounts AS (
    SELECT o.opponent,
           COUNT(*)               AS times_played,
           p.elo_rating AS elo
      FROM (
        SELECT black_player   AS opponent
          FROM ChessMatch
         WHERE white_player = p_username
           AND black_player IS NOT NULL
        UNION ALL
        SELECT white_player   AS opponent
          FROM ChessMatch
         WHERE black_player = p_username
           AND white_player IS NOT NULL
      ) AS o
      JOIN Player AS p ON p.username = o.opponent
     GROUP BY o.opponent
  ),
  MaxCount AS (
    SELECT MAX(times_played) AS max_played
      FROM OppCounts
  )
  SELECT 
    CASE 
      WHEN COUNT(*) = 1 THEN MIN(opponent)
      ELSE CONCAT('TIE between ', GROUP_CONCAT(opponent)) 
    END AS most_played_opponent,
    CASE 
      WHEN COUNT(*) = 1 THEN MIN(elo) 
      ELSE ROUND(AVG(elo),2)
    END AS reported_elo
  FROM OppCounts, MaxCount
  WHERE times_played = max_played;
END$$
DELIMITER ;



















-- VIEWS --
-- Arbiter rating summary
CREATE VIEW ArbiterRatingStats AS
SELECT
  assigned_arbiter_username AS arbiter,
  COUNT(*)                  AS total_rated,
  ROUND(AVG(rating),2)      AS avg_rating
FROM ChessMatch
WHERE rating IS NOT NULL
GROUP BY assigned_arbiter_username;


-- Let coaches view available halls
CREATE VIEW AvailableHalls AS
SELECT
  h.hall_id,
  h.hall_name,
  h.hall_country,
  COUNT(ct.table_id) AS total_tables
FROM Hall AS h
LEFT JOIN ChessTable AS ct USING (hall_id)
GROUP BY h.hall_id;




