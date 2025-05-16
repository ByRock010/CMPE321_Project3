CREATE TABLE User ( 
username VARCHAR(50) PRIMARY KEY, 
password_hash VARCHAR(100) NOT NULL, -- İsmini password_hash yaptım
name VARCHAR(50) NOT NULL, 
surname VARCHAR(50) NOT NULL, 
nationality VARCHAR(50) NOT NULL,
role ENUM('Player', 'Coach', 'Arbiter', 'Admin') NOT NULL  -- BURA YENİ
); 
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
experience_level ENUM('Beginner', 'Intermediate', 'Advanced') NOT NULL, 
FOREIGN KEY (username) REFERENCES User(username) ON DELETE CASCADE 
); 
CREATE TABLE ArbiterCertification ( 
arbiter_username VARCHAR(50) NOT NULL, 
arbiter_certification VARCHAR(50) NOT NULL, 
PRIMARY KEY (arbiter_username, arbiter_certification), 
FOREIGN KEY (arbiter_username) REFERENCES Arbiter(username) 
); 
CREATE TABLE Team ( 
team_id INT PRIMARY KEY AUTO_INCREMENT, 
team_name VARCHAR(100) NOT NULL
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
    match_id INT PRIMARY KEY AUTO_INCREMENT,
    hall_id INT NOT NULL,
    table_id INT NOT NULL,
    white_player_team_id INT NOT NULL,
    white_player VARCHAR(50) NOT NULL,
    black_player_team_id INT NOT NULL,
    black_player VARCHAR(50) NOT NULL,
    time_slot INT CHECK (time_slot BETWEEN 1 AND 4) NOT NULL,
    match_date DATE NOT NULL,
    assigned_arbiter_username VARCHAR(50) NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 10),

    -- Foreign Keys
    FOREIGN KEY (hall_id) REFERENCES Hall(hall_id),
    FOREIGN KEY (table_id) REFERENCES ChessTable(table_id),
    FOREIGN KEY (white_player_team_id) REFERENCES Team(team_id),
    FOREIGN KEY (black_player_team_id) REFERENCES Team(team_id),
    FOREIGN KEY (white_player) REFERENCES Player(username),
    FOREIGN KEY (black_player) REFERENCES Player(username),
    FOREIGN KEY (assigned_arbiter_username) REFERENCES Arbiter(username),

    -- Constraints
    CHECK (white_player_team_id != black_player_team_id),

    UNIQUE (white_player, match_date, time_slot),
    UNIQUE (black_player, match_date, time_slot),
    UNIQUE (assigned_arbiter_username, match_date, time_slot),
    UNIQUE (table_id, match_date, time_slot)
);
CREATE TABLE Player_Team ( 
player_username VARCHAR(50), 
team_id INT, 
PRIMARY KEY (player_username, team_id), 
FOREIGN KEY (player_username) REFERENCES Player(username), 
FOREIGN KEY (team_id) REFERENCES Team(team_id) 
); 







-- BURADAN İTİBAREN YENİ --------------











-- Prevent overlapping matches for white player:
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
END;


-- Prevent overlapping matches for black player:
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
END;

-- Prevent overlapping matches for arbiter:
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
END;

-- Prevent overlapping matches for table:
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
END;



-- Prevent Arbiter from Re-rating a Match:
CREATE TRIGGER trg_no_double_rating
BEFORE UPDATE ON ChessMatch
FOR EACH ROW
BEGIN
  IF OLD.rating IS NOT NULL AND NEW.rating IS NOT NULL AND OLD.rating != NEW.rating THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Match has already been rated. Ratings cannot be changed.';
  END IF;
END;

-- Prevent rating before match date:
CREATE TRIGGER trg_rating_only_after_match_date
BEFORE UPDATE ON ChessMatch
FOR EACH ROW
BEGIN
  IF NEW.rating IS NOT NULL AND NEW.match_date > CURDATE() THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot rate a match before its scheduled date.';
  END IF;
END;


-- BEFORE INSERT Trigger: Coach Can Only Assign Players From Their Own Team:
CREATE TRIGGER trg_coach_assigns_only_own_player
BEFORE INSERT ON ChessMatch
FOR EACH ROW
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM Player_Team pt
    JOIN Coach_Team_Agreement ca ON pt.team_id = ca.team_id
    WHERE pt.player_username = NEW.white_player
      AND ca.coach_username = CURRENT_USER() -- or pass coach via backend
      AND NEW.match_date BETWEEN ca.contract_start AND ca.contract_finish
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Coach can only assign a player from their own team (contract-valid).';
  END IF;
END;


-- BEFORE INSERT Trigger: Prevent Overlapping Coach Contracts:
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
END;









--  PROCEDURE


-- Stored Procedure create_match:
DELIMITER $$

CREATE PROCEDURE create_match (
    IN p_white_player VARCHAR(50),
    IN p_white_team_id INT,
    IN p_black_team_id INT,
    IN p_match_date DATE,
    IN p_time_slot INT,
    IN p_hall_id INT,
    IN p_table_id INT,
    IN p_arbiter_username VARCHAR(50)
)
BEGIN
    DECLARE conflict INT DEFAULT 0;

    -- Check for conflicts on player, arbiter, table
    SELECT 1 INTO conflict FROM ChessMatch
    WHERE match_date = p_match_date
      AND time_slot IN (p_time_slot, p_time_slot + 1)
      AND (
        white_player = p_white_player OR
        black_player = p_white_player OR
        assigned_arbiter_username = p_arbiter_username OR
        table_id = p_table_id
    )
    LIMIT 1;

    IF conflict IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Conflict: white player, arbiter, or table already in use at that time.';
    ELSE
        INSERT INTO ChessMatch (
            hall_id, table_id,
            white_player_team_id, white_player,
            black_player_team_id,
            match_date, time_slot,
            assigned_arbiter_username
        ) VALUES (
            p_hall_id, p_table_id,
            p_white_team_id, p_white_player,
            p_black_team_id,
            p_match_date, p_time_slot,
            p_arbiter_username
        );
    END IF;
END$$

DELIMITER ;



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
