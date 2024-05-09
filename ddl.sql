CREATE TABLE COUNTRY
(
  Country_Abbrev VARCHAR(20) NOT NULL,
  Country_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (Country_Abbrev)
);

CREATE TABLE OLYMPIC
(
  Year INT NOT NULL,
  Season VARCHAR(20) NOT NULL,
  Start_date DATE NOT NULL,
  End_date DATE NOT NULL,
  City VARCHAR(50) NOT NULL,
  Country_Abbrev VARCHAR(20) NOT NULL,
  PRIMARY KEY (Year, Season),
  FOREIGN KEY (Country_Abbrev) REFERENCES COUNTRY(Country_Abbrev)
);

CREATE TABLE SPORT
(
  Sport_id INT NOT NULL,
  Sport_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (Sport_id)
);

CREATE TABLE consist_of
(
  Year INT NOT NULL,
  Season VARCHAR(20) NOT NULL,
  Sport_id INT NOT NULL,
  PRIMARY KEY (Year, Season, Sport_id),
  FOREIGN KEY (Year, Season) REFERENCES OLYMPIC(Year, Season),
  FOREIGN KEY (Sport_id) REFERENCES SPORT(Sport_id)
);

CREATE TABLE ATHLETE
(
  Athlete_id INT NOT NULL,
  Fname VARCHAR(50) NOT NULL,
  Lname VARCHAR(50) NOT NULL,
  Gender CHAR(2) NOT NULL,
  Country_Abbrev VARCHAR(20) NOT NULL,
  Sport_id INT NOT NULL,
  PRIMARY KEY (Athlete_id),
  FOREIGN KEY (Country_Abbrev) REFERENCES COUNTRY(Country_Abbrev),
  FOREIGN KEY (Sport_id) REFERENCES SPORT(Sport_id)
);

CREATE TABLE DISCIPLINE
(
  Discipline_name VARCHAR(40) NOT NULL,
  Type VARCHAR(20) NOT NULL,
  Kind VARCHAR(20) NOT NULL,
  Sport_id INT NOT NULL,
  PRIMARY KEY (Discipline_name, Kind, Type),
  FOREIGN KEY (Sport_id) REFERENCES SPORT(Sport_id)
);

CREATE TABLE RESULT
(
  Athlete_id INT NOT NULL,
  Year INT NOT NULL,
  Season VARCHAR(20) NOT NULL,
  Discipline_name VARCHAR(40) NOT NULL,
  Type VARCHAR(20) NOT NULL,
  Kind VARCHAR(20) NOT NULL,
  Medal_type VARCHAR(30) NOT NULL,
  PRIMARY KEY (Athlete_id, Year, Season, Discipline_name, Kind, Type),
  FOREIGN KEY (Athlete_id) REFERENCES ATHLETE(Athlete_id),
  FOREIGN KEY (Year, Season) REFERENCES OLYMPIC(Year, Season),
  FOREIGN KEY (Discipline_name, Kind, Type) REFERENCES DISCIPLINE(Discipline_name, Kind, Type)
);

CREATE TABLE PARTICIPATED_IN
(
  Athlete_id INT NOT NULL,
  Year INT NOT NULL,
  Season VARCHAR(20) NOT NULL,
  PRIMARY KEY (Athlete_id, Year, Season),
  FOREIGN KEY (Athlete_id) REFERENCES ATHLETE(Athlete_id),
  FOREIGN KEY (Year, Season) REFERENCES OLYMPIC(Year, Season)
);