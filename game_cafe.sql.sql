DROP DATABASE IF EXISTS game_cafe_portfolio_db;
CREATE DATABASE game_cafe_portfolio_db DEFAULT CHARACTER SET utf8mb4;
USE game_cafe_portfolio_db;

-- -------------------------
-- Customers
-- -------------------------
CREATE TABLE customers (
  customer_id INT NOT NULL AUTO_INCREMENT,
  full_name   VARCHAR(80) NOT NULL,
  email       VARCHAR(120) NOT NULL,
  phone       VARCHAR(20),
  PRIMARY KEY (customer_id),
  UNIQUE KEY email_unique (email)
) ENGINE=InnoDB;

-- -------------------------
-- Cafe Tables
-- -------------------------
CREATE TABLE cafe_tables (
  table_id      INT NOT NULL AUTO_INCREMENT,
  table_number  INT NOT NULL,
  capacity      INT NOT NULL,
  PRIMARY KEY (table_id),
  UNIQUE KEY table_number_unique (table_number)
) ENGINE=InnoDB;

-- -------------------------
-- Reservations
-- -------------------------
CREATE TABLE reservations (
  reservation_id INT NOT NULL AUTO_INCREMENT,
  customer_id    INT NOT NULL,
  table_id       INT NOT NULL,
  res_date       DATE NOT NULL,
  start_time     TIME NOT NULL,
  end_time       TIME NOT NULL,
  status         VARCHAR(20) NOT NULL DEFAULT 'Booked',
  notes          VARCHAR(255),

  PRIMARY KEY (reservation_id),

  CONSTRAINT fk_res_customer
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT fk_res_table
    FOREIGN KEY (table_id)
    REFERENCES cafe_tables(table_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- -------------------------
-- Games
-- -------------------------
CREATE TABLE games (
  game_id      INT NOT NULL AUTO_INCREMENT,
  title        VARCHAR(120) NOT NULL,
  category     VARCHAR(60) NOT NULL,
  min_players  INT NOT NULL,
  max_players  INT NOT NULL,
  PRIMARY KEY (game_id),
  UNIQUE KEY title_unique (title)
) ENGINE=InnoDB;

-- -------------------------
-- Game Copies
-- -------------------------
CREATE TABLE games_copies (
  copy_id        INT NOT NULL AUTO_INCREMENT,
  game_id        INT NOT NULL,
  copy_status    VARCHAR(45) NOT NULL DEFAULT 'Available',
  game_condition VARCHAR(45) NOT NULL DEFAULT 'Good',
  PRIMARY KEY (copy_id),

  CONSTRAINT fk_copy_game
    FOREIGN KEY (game_id)
    REFERENCES games(game_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- -------------------------
-- Loans
-- -------------------------
CREATE TABLE loans (
  loan_id        INT NOT NULL AUTO_INCREMENT,
  reservation_id INT NOT NULL,
  copy_id        INT NOT NULL,
  loan_time      DATETIME NOT NULL,
  return_time    DATETIME NULL,

  PRIMARY KEY (loan_id),

  CONSTRAINT fk_loan_reservation
    FOREIGN KEY (reservation_id)
    REFERENCES reservations(reservation_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT fk_loan_copy
    FOREIGN KEY (copy_id)
    REFERENCES games_copies(copy_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO customers (full_name, email, phone)
VALUES
('Aisha Rahman', 'aisha@example.com', '917-555-1111'),
('Daniel Park', 'daniel@example.com', '646-555-2222');
INSERT INTO cafe_tables (table_number, capacity)
VALUES
(1, 2),
(2, 4),
(3, 6);
INSERT INTO games (title, category, min_players, max_players)
VALUES
('Catan', 'Strategy', 3, 4),
('Uno', 'Card', 2, 10);

INSERT INTO games_copies (game_id, copy_status, game_condition)
VALUES
(1, 'Available', 'Good'),
(1, 'Available', 'Good'),
(2, 'Available', 'Good');

INSERT INTO reservations (customer_id, table_id, res_date, start_time, end_time, status, notes)
VALUES
(1, 2, '2026-03-01', '18:10:00', '19:50:00', 'Booked', 'Walk-in'),
(2, 1, '2026-03-01', '19:10:00', '20:50:00', 'Booked', 'Friends night'),
(1, 3, '2026-03-02', '17:05:00', '18:45:00', 'Booked', NULL);


INSERT INTO loans (reservation_id, copy_id, loan_time, return_time)
VALUES
(1, 1, '2026-03-01 18:10:00', '2026-03-01 19:50:00'),
(2, 3, '2026-03-01 19:10:00', '2026-03-01 20:50:00'),
(3, 2, '2026-03-02 17:05:00', NULL);


SHOW TABLES;

DESCRIBE reservations;
DESCRIBE games_copies;
DESCRIBE loans;
