-- You have to design (describe in natural language all parameters and the
-- working of) at least 3 triggers, and implement in SQL 1 of them.

-- a) Prevent non-valid actualizations of taps regarding billed months (no
-- change of is allowed).
CREATE OR REPLACE TRIGGER UPDATE_TAPS_BILLED_MONTHS


-- b) Prevent non-valid visualizations regarding contracts (there cannot be taps
-- in a date out of contract).
CREATE OR REPLACE TRIGGER


-- c) Split genres/keywords sequences into individual values.
CREATE OR REPLACE TRIGGER SEQUENCE_TO_INDIVIDUAL


-- d) Prevent contract overlapping: if a client with an effective contract signs
-- a new one, the former will end the day before the new one becomes effective
-- Update dates in contracts.
CREATE OR REPLACE TRIGGER CONTRACT_OVERLAPPING


-- e) Store new licenses of digital contents regarding the first purchases of a
-- content with a contract of type PPC.
CREATE OR REPLACE TRIGGER NAME


-- f) In case you have implemented the view All_movies, add triggers to enable
-- all its functionality (I/D/U) (first, test its functionality and then add
-- triggers to complete it, in case).
CREATE OR REPLACE TRIGGER NAME
