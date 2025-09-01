--
-- PostgreSQL database dump
--

-- Dumped from database version 11.22 (Debian 11.22-0+deb10u1)
-- Dumped by pg_dump version 15.3

-- Started on 2024-02-08 17:10:31

SET statement_timeout = 3600;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- DROP DATABASE livres;
--
-- TOC entry 5415 (class 1262 OID 26303)
-- Name: livres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE livres WITH TEMPLATE = template0 ENCODING = 'SQL_ASCII' LOCALE_PROVIDER = libc LOCALE = 'fr_FR.UTF-8';


ALTER DATABASE livres OWNER TO postgres;

\connect livres

SET statement_timeout = 3600;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5416 (class 0 OID 0)
-- Dependencies: 5415
-- Name: DATABASE livres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE livres IS 'Base pour les cours de M.Brun (1A+2A)';


--
-- TOC entry 6 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 5417 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 1173 (class 1255 OID 26452)
-- Name: inscription(character varying, character varying, character varying, character, character varying, character varying); Type: FUNCTION; Schema: public; Owner: mbrun
--

CREATE FUNCTION public.inscription(character varying, character varying, character varying, character, character varying, character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 res client.code%type;

BEGIN 
	SELECT code INTO res from client where nom=$1 and prenom=$2 and adresse=$3;
	IF FOUND THEN res:=0;
	ELSE 
	INSERT INTO client(code, nom, prenom, adresse, cp, ville, pays) VALUES(DEFAULT,$1,$2,$3,$4,$5,$6) RETURNING code INTO res;
	END IF;
	RETURN res;
END;
$_$;


ALTER FUNCTION public.inscription(character varying, character varying, character varying, character, character varying, character varying) OWNER TO mbrun;

--
-- TOC entry 1159 (class 1255 OID 26453)
-- Name: plpgsql_call_handler(); Type: FUNCTION; Schema: public; Owner: lbrun
--

CREATE FUNCTION public.plpgsql_call_handler() RETURNS language_handler
    LANGUAGE c
    AS '$libdir/plpgsql', 'plpgsql_call_handler';


ALTER FUNCTION public.plpgsql_call_handler() OWNER TO lbrun;

SET default_tablespace = '';

--
-- TOC entry 464 (class 1259 OID 27160)
-- Name: auteurs; Type: TABLE; Schema: public; Owner: lbrun
--

CREATE TABLE public.auteurs (
    code integer NOT NULL,
    nom character varying(10) NOT NULL,
    prenom character varying(10) DEFAULT 'inconnu'::character varying,
    naissance date,
    code_nationalite integer
);


ALTER TABLE public.auteurs OWNER TO lbrun;

--
-- TOC entry 465 (class 1259 OID 27164)
-- Name: ecrit_par; Type: TABLE; Schema: public; Owner: lbrun
--

CREATE TABLE public.ecrit_par (
    code_ouvrage integer NOT NULL,
    code_auteur integer NOT NULL
);


ALTER TABLE public.ecrit_par OWNER TO lbrun;

--
-- TOC entry 466 (class 1259 OID 27167)
-- Name: editeurs; Type: TABLE; Schema: public; Owner: lbrun
--

CREATE TABLE public.editeurs (
    code integer NOT NULL,
    nom text NOT NULL,
    adresse text,
    "CP" integer,
    "Ville" character varying(10)
);


ALTER TABLE public.editeurs OWNER TO lbrun;

--
-- TOC entry 467 (class 1259 OID 27173)
-- Name: emplacements; Type: TABLE; Schema: public; Owner: lbrun
--

CREATE TABLE public.emplacements (
    code integer NOT NULL,
    nom text DEFAULT 'indefini'::text NOT NULL
);


ALTER TABLE public.emplacements OWNER TO lbrun;

--
-- TOC entry 468 (class 1259 OID 27180)
-- Name: emprunts; Type: TABLE; Schema: public; Owner: lbrun
--

CREATE TABLE public.emprunts (
    code_personne integer NOT NULL,
    code_exemplaire integer NOT NULL
);


ALTER TABLE public.emprunts OWNER TO lbrun;

--
-- TOC entry 469 (class 1259 OID 27183)
-- Name: exemplaire; Type: TABLE; Schema: public; Owner: lbrun
--

CREATE TABLE public.exemplaire (
    code integer NOT NULL,
    code_ouvrage integer NOT NULL,
    code_editeur integer,
    code_emplacement integer,
    date_achat date,
    prix numeric
);


ALTER TABLE public.exemplaire OWNER TO lbrun;

--
-- TOC entry 470 (class 1259 OID 27189)
-- Name: nationalites; Type: TABLE; Schema: public; Owner: lbrun
--

CREATE TABLE public.nationalites (
    code integer NOT NULL,
    nationalite character varying(10) NOT NULL
);


ALTER TABLE public.nationalites OWNER TO lbrun;

--
-- TOC entry 471 (class 1259 OID 27192)
-- Name: liste_auteurs; Type: VIEW; Schema: public; Owner: lbrun
--

CREATE VIEW public.liste_auteurs AS
 SELECT auteurs.nom AS nom_auteur,
    auteurs.prenom AS prenom_auteur,
    nationalites.nationalite
   FROM public.auteurs,
    public.nationalites
  WHERE (auteurs.code_nationalite = nationalites.code);


ALTER TABLE public.liste_auteurs OWNER TO lbrun;

--
-- TOC entry 472 (class 1259 OID 27196)
-- Name: ouvrage; Type: TABLE; Schema: public; Owner: lbrun
--

CREATE TABLE public.ouvrage (
    code integer NOT NULL,
    nom text NOT NULL,
    parution date,
    sujet integer DEFAULT 1
);


ALTER TABLE public.ouvrage OWNER TO lbrun;

--
-- TOC entry 473 (class 1259 OID 27203)
-- Name: sujet; Type: TABLE; Schema: public; Owner: lbrun
--

CREATE TABLE public.sujet (
    code integer DEFAULT nextval(('sujet_code_sujet_seq'::text)::regclass) NOT NULL,
    nom text
);


ALTER TABLE public.sujet OWNER TO lbrun;

--
-- TOC entry 474 (class 1259 OID 27210)
-- Name: ouvrage par sujet; Type: VIEW; Schema: public; Owner: lbrun
--

CREATE VIEW public."ouvrage par sujet" AS
 SELECT substr(sujet.nom, 1, 11) AS substr,
    count(ouvrage.code) AS "Nb_Ouvrage"
   FROM public.sujet,
    public.ouvrage
  WHERE (ouvrage.sujet = sujet.code)
  GROUP BY sujet.nom
  ORDER BY sujet.nom;


ALTER TABLE public."ouvrage par sujet" OWNER TO lbrun;

--
-- TOC entry 475 (class 1259 OID 27214)
-- Name: personne; Type: TABLE; Schema: public; Owner: lbrun
--

CREATE TABLE public.personne (
    code_personne integer NOT NULL,
    adresse text,
    "CP" integer,
    ville character varying(10),
    telephone1 text,
    telephone2 text,
    mail character varying(50),
    nom character varying(25),
    prenom character varying(25)
);


ALTER TABLE public.personne OWNER TO lbrun;

--
-- TOC entry 476 (class 1259 OID 27220)
-- Name: sujet_code_sujet_seq; Type: SEQUENCE; Schema: public; Owner: lbrun
--

CREATE SEQUENCE public.sujet_code_sujet_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.sujet_code_sujet_seq OWNER TO lbrun;

--
-- TOC entry 5399 (class 0 OID 27160)
-- Dependencies: 464
-- Data for Name: auteurs; Type: TABLE DATA; Schema: public; Owner: lbrun
--

INSERT INTO public.auteurs VALUES (1, 'Brunner', 'John', '1934-09-24', 2);
INSERT INTO public.auteurs VALUES (2, 'Tiptree', 'James', NULL, NULL);
INSERT INTO public.auteurs VALUES (3, 'Conner', 'Mike', NULL, NULL);
INSERT INTO public.auteurs VALUES (4, 'Simmons', 'Dan', NULL, 3);
INSERT INTO public.auteurs VALUES (5, 'Keyes', 'Daniel', '1927-01-01', 3);
INSERT INTO public.auteurs VALUES (6, 'Barjavel', 'Rene', '1911-01-24', 1);
INSERT INTO public.auteurs VALUES (7, 'Werber', 'Bernard', '1961-01-01', 1);
INSERT INTO public.auteurs VALUES (8, 'Silverberg', 'Robert', '1935-01-01', 3);
INSERT INTO public.auteurs VALUES (9, 'Asimov', 'Isaac', '1920-01-01', 4);
INSERT INTO public.auteurs VALUES (10, 'Bear', 'Greg', NULL, 3);
INSERT INTO public.auteurs VALUES (11, 'Herbert', 'Frank', '1920-01-01', 3);
INSERT INTO public.auteurs VALUES (13, 'Spinrad', 'Norman', '1940-01-01', 3);
INSERT INTO public.auteurs VALUES (14, 'Cadigan', 'Pat', NULL, 3);
INSERT INTO public.auteurs VALUES (15, 'Gibson', 'William', '1948-01-01', 3);
INSERT INTO public.auteurs VALUES (16, 'Lehman', 'Serge', '1964-01-01', 1);
INSERT INTO public.auteurs VALUES (17, 'Robinson', 'Kim Stanle', NULL, 3);
INSERT INTO public.auteurs VALUES (18, 'Charnas', 'Suzy McKee', NULL, 3);
INSERT INTO public.auteurs VALUES (19, 'Hoyle', 'Fred', NULL, 2);
INSERT INTO public.auteurs VALUES (20, 'Villaret', 'Helene Bul', NULL, 1);
INSERT INTO public.auteurs VALUES (23, 'Rice', 'Anne', NULL, 3);
INSERT INTO public.auteurs VALUES (21, 'Clarke', 'Arthur C.', '1917-01-01', 2);
INSERT INTO public.auteurs VALUES (22, 'Gentry', 'Lee', NULL, NULL);
INSERT INTO public.auteurs VALUES (24, 'Benford', 'Gregory', '1941-01-01', 3);
INSERT INTO public.auteurs VALUES (27, 'Lovecraft', 'H.P.', '1890-01-01', 3);
INSERT INTO public.auteurs VALUES (26, 'Niven', 'Larry', NULL, 1);
INSERT INTO public.auteurs VALUES (28, 'Lem', 'Stanislas', NULL, NULL);
INSERT INTO public.auteurs VALUES (29, 'Cherryh', 'Carolyn J.', '1942-01-01', 3);
INSERT INTO public.auteurs VALUES (30, 'Brin', 'David', '1950-01-01', 3);
INSERT INTO public.auteurs VALUES (31, 'Heinlein', 'Robert', '1907-01-01', 3);
INSERT INTO public.auteurs VALUES (32, 'Hal', 'Clement', NULL, NULL);
INSERT INTO public.auteurs VALUES (33, 'Klein', 'Gerard', '1937-01-01', 1);
INSERT INTO public.auteurs VALUES (34, 'Jeury', 'Michel', '1937-01-01', 1);
INSERT INTO public.auteurs VALUES (35, 'Anderson', 'Poul', '1926-11-25', 6);
INSERT INTO public.auteurs VALUES (36, 'Buzzati', 'Dino', '1906-10-16', 7);
INSERT INTO public.auteurs VALUES (38, 'Huxley', 'Aldous', '1894-01-01', 3);
INSERT INTO public.auteurs VALUES (39, 'Williamson', 'Jack', '1908-01-01', 3);
INSERT INTO public.auteurs VALUES (40, 'Hailbum', 'Isidore', NULL, 3);
INSERT INTO public.auteurs VALUES (42, 'Moorcock', 'Michael', '1939-01-01', 2);
INSERT INTO public.auteurs VALUES (43, 'Casares', 'Adalfo Bjo', '1914-01-01', 8);
INSERT INTO public.auteurs VALUES (44, 'Henneberg', 'Charles', '1899-01-01', 1);
INSERT INTO public.auteurs VALUES (45, 'Suyin', 'Han', NULL, 2);
INSERT INTO public.auteurs VALUES (46, 'Haldeman', 'Joe', '1943-01-01', 3);
INSERT INTO public.auteurs VALUES (47, 'Genefort', 'Laurent', NULL, 1);
INSERT INTO public.auteurs VALUES (49, 'Bradley', 'Marion Zim', NULL, NULL);
INSERT INTO public.auteurs VALUES (50, 'Pouy', 'Jean-Berna', NULL, 1);
INSERT INTO public.auteurs VALUES (51, 'Matheson', 'Richard', '1926-01-01', 3);
INSERT INTO public.auteurs VALUES (52, 'Leiber', 'Fritz', '1910-01-01', 3);
INSERT INTO public.auteurs VALUES (53, 'Ligny', 'Jean-Marc', '1956-01-01', 1);
INSERT INTO public.auteurs VALUES (54, 'Jeter', 'K. W.', NULL, 3);
INSERT INTO public.auteurs VALUES (55, 'Telep', 'Peter', NULL, 3);
INSERT INTO public.auteurs VALUES (56, 'Sturgeon', 'Theodore', '1918-01-01', 3);
INSERT INTO public.auteurs VALUES (57, 'Tepper', 'Sheri S.', NULL, 3);
INSERT INTO public.auteurs VALUES (58, 'Bujold', 'Lois MCMas', '1949-01-01', 3);
INSERT INTO public.auteurs VALUES (59, 'Galouye', 'Daniel f.', '1920-01-01', 3);
INSERT INTO public.auteurs VALUES (60, 'Einstein', 'Albert', '1900-01-01', 9);
INSERT INTO public.auteurs VALUES (61, 'Farmer', 'Philip Jos', '1918-01-01', 3);
INSERT INTO public.auteurs VALUES (62, 'Dick', 'Philip K.', NULL, 3);
INSERT INTO public.auteurs VALUES (63, 'Dickson', 'Gordon R.', NULL, NULL);
INSERT INTO public.auteurs VALUES (64, 'Willis', 'Connie', NULL, 3);
INSERT INTO public.auteurs VALUES (65, 'Djian', 'Philippe', '1949-01-01', 1);
INSERT INTO public.auteurs VALUES (66, 'Kipling', 'Rudyard', '1865-01-01', 2);
INSERT INTO public.auteurs VALUES (67, 'Laussac', 'Colette', NULL, 1);
INSERT INTO public.auteurs VALUES (68, 'Yourcenar', 'Marguerite', '1903-01-01', 1);
INSERT INTO public.auteurs VALUES (69, 'Malzberg', 'Barry N.', NULL, NULL);
INSERT INTO public.auteurs VALUES (70, 'Reouven', 'rene', NULL, 1);
INSERT INTO public.auteurs VALUES (71, 'Wilie', 'Philip', '1900-01-01', 2);
INSERT INTO public.auteurs VALUES (72, 'Cooper', 'Edmund', '1926-04-30', 2);
INSERT INTO public.auteurs VALUES (73, 'Wihelm', 'Kate', NULL, 3);
INSERT INTO public.auteurs VALUES (74, 'Sargent', 'Pamela', NULL, 3);
INSERT INTO public.auteurs VALUES (75, 'Rosny Aine', 'J.H.', NULL, 1);
INSERT INTO public.auteurs VALUES (76, 'Sagan', 'Carl', NULL, 3);
INSERT INTO public.auteurs VALUES (77, 'Harness', 'Charles L.', '1915-01-01', 3);
INSERT INTO public.auteurs VALUES (78, 'Jourbet', 'Jean', '1928-01-01', 1);
INSERT INTO public.auteurs VALUES (79, 'Boccace', 'Jean', NULL, 1);
INSERT INTO public.auteurs VALUES (80, 'Bradbury', 'Ray', '1920-01-01', 3);
INSERT INTO public.auteurs VALUES (81, 'Carrossa', 'Jacob', NULL, 10);
INSERT INTO public.auteurs VALUES (82, 'Higon', 'Albert', '1934-01-01', 1);
INSERT INTO public.auteurs VALUES (83, 'Pelot', 'Pierre', '1945-01-01', 1);
INSERT INTO public.auteurs VALUES (84, 'Pirandello', 'Luigi', NULL, 7);
INSERT INTO public.auteurs VALUES (85, 'Christin', 'Pierre', NULL, 1);
INSERT INTO public.auteurs VALUES (86, 'Campbell', 'John W.', '1910-08-06', 3);
INSERT INTO public.auteurs VALUES (87, 'Brenon', 'Anne', NULL, 1);
INSERT INTO public.auteurs VALUES (88, 'Braun', 'Lilian Jac', NULL, 2);
INSERT INTO public.auteurs VALUES (89, 'Prejean', 'Soeur Hele', NULL, 3);
INSERT INTO public.auteurs VALUES (90, 'Ladurie', 'Le Roy', '1929-01-01', 1);
INSERT INTO public.auteurs VALUES (91, 'Simak', 'Cliford D.', '1904-03-09', 3);
INSERT INTO public.auteurs VALUES (92, 'Cousin', 'Philippe', NULL, 1);
INSERT INTO public.auteurs VALUES (93, 'Besher', 'Alexander', NULL, NULL);
INSERT INTO public.auteurs VALUES (94, 'Forward', 'Robert', NULL, 3);
INSERT INTO public.auteurs VALUES (95, 'Anthony', 'Piers', NULL, 2);
INSERT INTO public.auteurs VALUES (96, 'Goulart', 'Ron', '1933-01-01', 3);
INSERT INTO public.auteurs VALUES (97, 'Atwood', 'Margaret', NULL, 5);
INSERT INTO public.auteurs VALUES (98, 'Ray', 'Jean', '1887-01-01', 11);
INSERT INTO public.auteurs VALUES (100, 'Goursac', 'Olivier de', NULL, 1);
INSERT INTO public.auteurs VALUES (99, 'Frankel', 'Charles', NULL, 1);
INSERT INTO public.auteurs VALUES (101, 'Heidmann', 'Jean', NULL, 1);
INSERT INTO public.auteurs VALUES (102, 'Vidal-Madj', 'Alfred', NULL, 1);
INSERT INTO public.auteurs VALUES (103, 'Prantzoz', 'Nicolas', NULL, 1);
INSERT INTO public.auteurs VALUES (104, 'Reeves', 'Hubert', NULL, 1);
INSERT INTO public.auteurs VALUES (105, 'Coney', 'Michael', NULL, 2);
INSERT INTO public.auteurs VALUES (106, 'Wilson', 'Robert Cha', NULL, 3);
INSERT INTO public.auteurs VALUES (108, 'Strougatsk', 'Boris', '1933-01-01', 4);
INSERT INTO public.auteurs VALUES (107, 'Strougatsk', 'Arcadi', '1925-01-01', 4);
INSERT INTO public.auteurs VALUES (109, 'Swanwick', 'Michael', NULL, 3);
INSERT INTO public.auteurs VALUES (110, 'Hubert', 'Jean Pierr', NULL, 1);
INSERT INTO public.auteurs VALUES (111, 'Pohl', 'Frederik', NULL, 3);
INSERT INTO public.auteurs VALUES (112, 'Bayley', 'Barrington', NULL, NULL);
INSERT INTO public.auteurs VALUES (113, 'Bass', 'T. J.', NULL, 3);
INSERT INTO public.auteurs VALUES (114, 'Cowper', 'Richard', '1926-01-01', 2);
INSERT INTO public.auteurs VALUES (115, 'Sheffield', 'Charles', NULL, 3);
INSERT INTO public.auteurs VALUES (116, 'Paris', 'Clementine', NULL, 1);
INSERT INTO public.auteurs VALUES (117, 'Scott card', 'Orson', NULL, 3);
INSERT INTO public.auteurs VALUES (118, 'Foster', 'Michael A.', '1939-01-01', 3);
INSERT INTO public.auteurs VALUES (119, 'Geston', 'Mark S.', '1946-01-01', 1);
INSERT INTO public.auteurs VALUES (120, 'Reed', 'Robert', NULL, 2);
INSERT INTO public.auteurs VALUES (121, 'Harrison', 'Harry', NULL, 3);
INSERT INTO public.auteurs VALUES (122, 'Minsky', 'Marvin', NULL, 3);
INSERT INTO public.auteurs VALUES (154, 'Pratchett', 'Terry', NULL, 2);
INSERT INTO public.auteurs VALUES (124, 'Arnaud', 'C. J.', NULL, 1);
INSERT INTO public.auteurs VALUES (125, 'Stork', 'Christophe', NULL, NULL);
INSERT INTO public.auteurs VALUES (126, 'Walther', 'Daniel', NULL, 1);
INSERT INTO public.auteurs VALUES (127, 'Vandel', 'Jean Gasto', NULL, 1);
INSERT INTO public.auteurs VALUES (128, 'Limat', 'Maurice', NULL, 1);
INSERT INTO public.auteurs VALUES (129, 'Bessiere', 'Richard', NULL, 1);
INSERT INTO public.auteurs VALUES (130, 'Barbet', 'Pierre', NULL, 1);
INSERT INTO public.auteurs VALUES (131, 'Houssin', 'Joel', NULL, 1);
INSERT INTO public.auteurs VALUES (132, 'Mazarin', 'Jean', NULL, 1);
INSERT INTO public.auteurs VALUES (133, 'Scheer', 'K.-H.', NULL, 9);
INSERT INTO public.auteurs VALUES (134, 'Suragne', 'Pierre', NULL, 1);
INSERT INTO public.auteurs VALUES (135, 'Aldiss', 'Brian', NULL, 2);
INSERT INTO public.auteurs VALUES (136, 'Vinge', 'Vernor', NULL, 3);
INSERT INTO public.auteurs VALUES (137, 'Lean (Mac)', 'Alistair', NULL, 2);
INSERT INTO public.auteurs VALUES (138, 'Villaret', 'Bernard', NULL, 1);
INSERT INTO public.auteurs VALUES (139, 'Perochon', 'Ernest', NULL, 1);
INSERT INTO public.auteurs VALUES (140, 'Adams', 'Douglas', '1952-01-01', 2);
INSERT INTO public.auteurs VALUES (141, 'Sterling', 'Bruce', '1954-01-01', 3);
INSERT INTO public.auteurs VALUES (142, 'Baxter', 'Stephen', NULL, 2);
INSERT INTO public.auteurs VALUES (143, 'Chambon', 'Jacques', NULL, 1);
INSERT INTO public.auteurs VALUES (144, 'Varley', 'John', '1947-01-01', 3);
INSERT INTO public.auteurs VALUES (145, 'Ayerdhal', 'inconnu', '1959-01-01', 1);
INSERT INTO public.auteurs VALUES (25, 'Bordage', 'Pierre', '1955-01-01', 1);
INSERT INTO public.auteurs VALUES (146, 'Auley(Mc)', 'PaulJ.', '1955-01-01', 2);
INSERT INTO public.auteurs VALUES (147, 'Quay(Mc)', 'Mike', NULL, 3);
INSERT INTO public.auteurs VALUES (148, 'Lafferty', 'R.A', NULL, 3);
INSERT INTO public.auteurs VALUES (149, 'Roquebert', 'Michel', NULL, 1);
INSERT INTO public.auteurs VALUES (150, 'Bova', 'Ben', NULL, 3);
INSERT INTO public.auteurs VALUES (151, 'Merle', 'Robert', '1908-01-01', 1);
INSERT INTO public.auteurs VALUES (152, 'Barnes', 'John', NULL, 3);
INSERT INTO public.auteurs VALUES (153, 'Weigand', 'Jorg', NULL, 9);
INSERT INTO public.auteurs VALUES (123, 'Caroff', 'andre', NULL, 1);
INSERT INTO public.auteurs VALUES (155, 'Gaiman', 'Neil', NULL, 2);
INSERT INTO public.auteurs VALUES (156, 'Levin', 'Ira', '1929-01-01', 3);
INSERT INTO public.auteurs VALUES (157, 'Lenteric', 'Bernard', NULL, 1);
INSERT INTO public.auteurs VALUES (158, 'Orwell', 'George', '1903-01-01', 2);
INSERT INTO public.auteurs VALUES (159, 'Bogdanoff', 'Igor', NULL, 1);
INSERT INTO public.auteurs VALUES (160, 'Bogdanoff', 'Grichka', NULL, 1);
INSERT INTO public.auteurs VALUES (161, 'Wells', 'Herbert G.', '1866-01-01', 2);
INSERT INTO public.auteurs VALUES (162, 'Perrault', 'Gilles', '1931-01-01', 1);
INSERT INTO public.auteurs VALUES (12, 'Van Vogt', 'Alfred El.', '1912-01-01', 5);
INSERT INTO public.auteurs VALUES (163, 'St Moore', 'Adam', NULL, NULL);
INSERT INTO public.auteurs VALUES (164, 'Carrigan', 'Richard', NULL, 3);
INSERT INTO public.auteurs VALUES (165, 'Carrigan', 'Nancy', NULL, 3);
INSERT INTO public.auteurs VALUES (166, 'Ellison', 'Harlan', '1934-01-01', 3);
INSERT INTO public.auteurs VALUES (167, 'Bruss', 'B. R.', NULL, 3);
INSERT INTO public.auteurs VALUES (168, 'Curval', 'Philippe', '1929-01-01', 1);
INSERT INTO public.auteurs VALUES (169, 'Frisch', 'Karl Von', NULL, 9);
INSERT INTO public.auteurs VALUES (48, 'Andrevon', 'Jean-Pierr', NULL, 1);
INSERT INTO public.auteurs VALUES (41, 'Hamilton', 'Edouard', '1904-01-01', 3);
INSERT INTO public.auteurs VALUES (170, 'Burgess', 'Anthony', NULL, 2);
INSERT INTO public.auteurs VALUES (171, 'Biddulph', 'Steve', NULL, 12);
INSERT INTO public.auteurs VALUES (172, 'Goimard', 'Jacques', NULL, 1);
INSERT INTO public.auteurs VALUES (173, 'Watson', 'Ian', '1943-01-01', 2);
INSERT INTO public.auteurs VALUES (174, 'Truong', 'Jean-Miche', NULL, 1);
INSERT INTO public.auteurs VALUES (175, 'Martin', 'George R.R', NULL, 2);
INSERT INTO public.auteurs VALUES (176, 'Brussolo', 'Serge', NULL, 1);
INSERT INTO public.auteurs VALUES (177, 'Bouchard', 'Nicolas', '1962-01-01', 1);
INSERT INTO public.auteurs VALUES (178, 'Schroeder', 'Karl', NULL, 5);
INSERT INTO public.auteurs VALUES (179, 'Sadoul', 'Jacques', NULL, 1);
INSERT INTO public.auteurs VALUES (180, 'Ioakimidis', 'Demetre', NULL, 1);
INSERT INTO public.auteurs VALUES (181, 'Herbert', 'Brian', NULL, 3);
INSERT INTO public.auteurs VALUES (182, 'Anderson', 'Kevin J.', NULL, 3);
INSERT INTO public.auteurs VALUES (183, 'Clauzel', 'Robert', NULL, 1);
INSERT INTO public.auteurs VALUES (184, 'Grenier', 'Christian', NULL, 1);
INSERT INTO public.auteurs VALUES (185, 'Soulier', 'Jacky', NULL, 1);
INSERT INTO public.auteurs VALUES (186, 'Milesi', 'Raymond', NULL, 1);
INSERT INTO public.auteurs VALUES (187, 'Stephan', 'Bernard', NULL, 1);
INSERT INTO public.auteurs VALUES (188, 'Weiss', 'Jan', NULL, 13);
INSERT INTO public.auteurs VALUES (189, 'Boissieu', 'Jean', NULL, 1);
INSERT INTO public.auteurs VALUES (190, 'Guillet', 'Jean Pierr', '1953-01-01', 5);
INSERT INTO public.auteurs VALUES (191, 'Russel', 'Russel', NULL, 3);
INSERT INTO public.auteurs VALUES (192, 'Boulle', 'Pierre', '1912-01-01', 1);
INSERT INTO public.auteurs VALUES (193, 'Caffrey', 'Anne', NULL, 3);
INSERT INTO public.auteurs VALUES (194, 'Tolkien', 'John R. R.', '1892-01-01', 2);
INSERT INTO public.auteurs VALUES (195, 'Duncan', 'David', '1913-01-01', 3);
INSERT INTO public.auteurs VALUES (196, 'Guiot', 'Denis', '1948-01-01', 1);


--
-- TOC entry 5400 (class 0 OID 27164)
-- Dependencies: 465
-- Data for Name: ecrit_par; Type: TABLE DATA; Schema: public; Owner: lbrun
--

INSERT INTO public.ecrit_par VALUES (1, 1);
INSERT INTO public.ecrit_par VALUES (2, 1);
INSERT INTO public.ecrit_par VALUES (3, 1);
INSERT INTO public.ecrit_par VALUES (4, 1);
INSERT INTO public.ecrit_par VALUES (5, 1);
INSERT INTO public.ecrit_par VALUES (6, 1);
INSERT INTO public.ecrit_par VALUES (7, 1);
INSERT INTO public.ecrit_par VALUES (8, 1);
INSERT INTO public.ecrit_par VALUES (9, 1);
INSERT INTO public.ecrit_par VALUES (10, 1);
INSERT INTO public.ecrit_par VALUES (10, 2);
INSERT INTO public.ecrit_par VALUES (10, 3);
INSERT INTO public.ecrit_par VALUES (11, 1);
INSERT INTO public.ecrit_par VALUES (12, 1);
INSERT INTO public.ecrit_par VALUES (13, 1);
INSERT INTO public.ecrit_par VALUES (14, 1);
INSERT INTO public.ecrit_par VALUES (15, 1);
INSERT INTO public.ecrit_par VALUES (16, 1);
INSERT INTO public.ecrit_par VALUES (17, 1);
INSERT INTO public.ecrit_par VALUES (18, 1);
INSERT INTO public.ecrit_par VALUES (19, 1);
INSERT INTO public.ecrit_par VALUES (20, 1);
INSERT INTO public.ecrit_par VALUES (21, 1);
INSERT INTO public.ecrit_par VALUES (22, 1);
INSERT INTO public.ecrit_par VALUES (23, 1);
INSERT INTO public.ecrit_par VALUES (24, 1);
INSERT INTO public.ecrit_par VALUES (25, 1);
INSERT INTO public.ecrit_par VALUES (26, 4);
INSERT INTO public.ecrit_par VALUES (27, 4);
INSERT INTO public.ecrit_par VALUES (28, 4);
INSERT INTO public.ecrit_par VALUES (29, 4);
INSERT INTO public.ecrit_par VALUES (30, 4);
INSERT INTO public.ecrit_par VALUES (31, 4);
INSERT INTO public.ecrit_par VALUES (32, 4);
INSERT INTO public.ecrit_par VALUES (33, 4);
INSERT INTO public.ecrit_par VALUES (34, 4);
INSERT INTO public.ecrit_par VALUES (35, 4);
INSERT INTO public.ecrit_par VALUES (36, 5);
INSERT INTO public.ecrit_par VALUES (37, 6);
INSERT INTO public.ecrit_par VALUES (38, 6);
INSERT INTO public.ecrit_par VALUES (39, 6);
INSERT INTO public.ecrit_par VALUES (40, 6);
INSERT INTO public.ecrit_par VALUES (41, 6);
INSERT INTO public.ecrit_par VALUES (42, 6);
INSERT INTO public.ecrit_par VALUES (43, 7);
INSERT INTO public.ecrit_par VALUES (44, 7);
INSERT INTO public.ecrit_par VALUES (45, 7);
INSERT INTO public.ecrit_par VALUES (46, 7);
INSERT INTO public.ecrit_par VALUES (48, 7);
INSERT INTO public.ecrit_par VALUES (49, 8);
INSERT INTO public.ecrit_par VALUES (50, 8);
INSERT INTO public.ecrit_par VALUES (51, 8);
INSERT INTO public.ecrit_par VALUES (52, 8);
INSERT INTO public.ecrit_par VALUES (53, 8);
INSERT INTO public.ecrit_par VALUES (54, 8);
INSERT INTO public.ecrit_par VALUES (55, 8);
INSERT INTO public.ecrit_par VALUES (56, 8);
INSERT INTO public.ecrit_par VALUES (57, 8);
INSERT INTO public.ecrit_par VALUES (59, 8);
INSERT INTO public.ecrit_par VALUES (60, 9);
INSERT INTO public.ecrit_par VALUES (61, 9);
INSERT INTO public.ecrit_par VALUES (62, 9);
INSERT INTO public.ecrit_par VALUES (63, 9);
INSERT INTO public.ecrit_par VALUES (64, 9);
INSERT INTO public.ecrit_par VALUES (65, 9);
INSERT INTO public.ecrit_par VALUES (66, 9);
INSERT INTO public.ecrit_par VALUES (67, 9);
INSERT INTO public.ecrit_par VALUES (68, 9);
INSERT INTO public.ecrit_par VALUES (69, 9);
INSERT INTO public.ecrit_par VALUES (70, 9);
INSERT INTO public.ecrit_par VALUES (71, 9);
INSERT INTO public.ecrit_par VALUES (72, 10);
INSERT INTO public.ecrit_par VALUES (73, 10);
INSERT INTO public.ecrit_par VALUES (74, 10);
INSERT INTO public.ecrit_par VALUES (75, 10);
INSERT INTO public.ecrit_par VALUES (76, 11);
INSERT INTO public.ecrit_par VALUES (77, 11);
INSERT INTO public.ecrit_par VALUES (78, 11);
INSERT INTO public.ecrit_par VALUES (79, 11);
INSERT INTO public.ecrit_par VALUES (80, 11);
INSERT INTO public.ecrit_par VALUES (81, 11);
INSERT INTO public.ecrit_par VALUES (82, 11);
INSERT INTO public.ecrit_par VALUES (83, 11);
INSERT INTO public.ecrit_par VALUES (84, 11);
INSERT INTO public.ecrit_par VALUES (85, 12);
INSERT INTO public.ecrit_par VALUES (86, 12);
INSERT INTO public.ecrit_par VALUES (87, 12);
INSERT INTO public.ecrit_par VALUES (88, 12);
INSERT INTO public.ecrit_par VALUES (89, 12);
INSERT INTO public.ecrit_par VALUES (90, 12);
INSERT INTO public.ecrit_par VALUES (91, 12);
INSERT INTO public.ecrit_par VALUES (92, 13);
INSERT INTO public.ecrit_par VALUES (93, 13);
INSERT INTO public.ecrit_par VALUES (94, 14);
INSERT INTO public.ecrit_par VALUES (95, 14);
INSERT INTO public.ecrit_par VALUES (96, 15);
INSERT INTO public.ecrit_par VALUES (97, 15);
INSERT INTO public.ecrit_par VALUES (98, 16);
INSERT INTO public.ecrit_par VALUES (99, 16);
INSERT INTO public.ecrit_par VALUES (100, 16);
INSERT INTO public.ecrit_par VALUES (101, 16);
INSERT INTO public.ecrit_par VALUES (102, 17);
INSERT INTO public.ecrit_par VALUES (103, 17);
INSERT INTO public.ecrit_par VALUES (104, 17);
INSERT INTO public.ecrit_par VALUES (105, 18);
INSERT INTO public.ecrit_par VALUES (106, 19);
INSERT INTO public.ecrit_par VALUES (107, 20);
INSERT INTO public.ecrit_par VALUES (108, 21);
INSERT INTO public.ecrit_par VALUES (109, 21);
INSERT INTO public.ecrit_par VALUES (110, 21);
INSERT INTO public.ecrit_par VALUES (110, 22);
INSERT INTO public.ecrit_par VALUES (111, 21);
INSERT INTO public.ecrit_par VALUES (112, 21);
INSERT INTO public.ecrit_par VALUES (113, 23);
INSERT INTO public.ecrit_par VALUES (114, 23);
INSERT INTO public.ecrit_par VALUES (115, 23);
INSERT INTO public.ecrit_par VALUES (116, 23);
INSERT INTO public.ecrit_par VALUES (117, 23);
INSERT INTO public.ecrit_par VALUES (118, 23);
INSERT INTO public.ecrit_par VALUES (119, 23);
INSERT INTO public.ecrit_par VALUES (120, 24);
INSERT INTO public.ecrit_par VALUES (121, 24);
INSERT INTO public.ecrit_par VALUES (122, 24);
INSERT INTO public.ecrit_par VALUES (123, 24);
INSERT INTO public.ecrit_par VALUES (124, 25);
INSERT INTO public.ecrit_par VALUES (125, 25);
INSERT INTO public.ecrit_par VALUES (126, 25);
INSERT INTO public.ecrit_par VALUES (127, 25);
INSERT INTO public.ecrit_par VALUES (128, 25);
INSERT INTO public.ecrit_par VALUES (129, 25);
INSERT INTO public.ecrit_par VALUES (130, 25);
INSERT INTO public.ecrit_par VALUES (131, 1);
INSERT INTO public.ecrit_par VALUES (131, 9);
INSERT INTO public.ecrit_par VALUES (132, 27);
INSERT INTO public.ecrit_par VALUES (133, 26);
INSERT INTO public.ecrit_par VALUES (134, 28);
INSERT INTO public.ecrit_par VALUES (135, 29);
INSERT INTO public.ecrit_par VALUES (136, 29);
INSERT INTO public.ecrit_par VALUES (137, 29);
INSERT INTO public.ecrit_par VALUES (138, 29);
INSERT INTO public.ecrit_par VALUES (140, 29);
INSERT INTO public.ecrit_par VALUES (141, 29);
INSERT INTO public.ecrit_par VALUES (142, 29);
INSERT INTO public.ecrit_par VALUES (143, 29);
INSERT INTO public.ecrit_par VALUES (144, 29);
INSERT INTO public.ecrit_par VALUES (145, 29);
INSERT INTO public.ecrit_par VALUES (146, 29);
INSERT INTO public.ecrit_par VALUES (147, 29);
INSERT INTO public.ecrit_par VALUES (148, 29);
INSERT INTO public.ecrit_par VALUES (149, 29);
INSERT INTO public.ecrit_par VALUES (150, 29);
INSERT INTO public.ecrit_par VALUES (139, 29);
INSERT INTO public.ecrit_par VALUES (151, 30);
INSERT INTO public.ecrit_par VALUES (152, 30);
INSERT INTO public.ecrit_par VALUES (153, 30);
INSERT INTO public.ecrit_par VALUES (154, 30);
INSERT INTO public.ecrit_par VALUES (155, 30);
INSERT INTO public.ecrit_par VALUES (156, 30);
INSERT INTO public.ecrit_par VALUES (157, 30);
INSERT INTO public.ecrit_par VALUES (158, 30);
INSERT INTO public.ecrit_par VALUES (159, 30);
INSERT INTO public.ecrit_par VALUES (160, 30);
INSERT INTO public.ecrit_par VALUES (161, 30);
INSERT INTO public.ecrit_par VALUES (162, 45);
INSERT INTO public.ecrit_par VALUES (163, 45);
INSERT INTO public.ecrit_par VALUES (164, 45);
INSERT INTO public.ecrit_par VALUES (165, 45);
INSERT INTO public.ecrit_par VALUES (166, 45);
INSERT INTO public.ecrit_par VALUES (167, 45);
INSERT INTO public.ecrit_par VALUES (168, 1);
INSERT INTO public.ecrit_par VALUES (169, 11);
INSERT INTO public.ecrit_par VALUES (170, 11);
INSERT INTO public.ecrit_par VALUES (171, 39);
INSERT INTO public.ecrit_par VALUES (172, 13);
INSERT INTO public.ecrit_par VALUES (173, 38);
INSERT INTO public.ecrit_par VALUES (174, 36);
INSERT INTO public.ecrit_par VALUES (175, 35);
INSERT INTO public.ecrit_par VALUES (176, 34);
INSERT INTO public.ecrit_par VALUES (177, 33);
INSERT INTO public.ecrit_par VALUES (178, 32);
INSERT INTO public.ecrit_par VALUES (179, 31);
INSERT INTO public.ecrit_par VALUES (180, 44);
INSERT INTO public.ecrit_par VALUES (181, 43);
INSERT INTO public.ecrit_par VALUES (182, 42);
INSERT INTO public.ecrit_par VALUES (183, 41);
INSERT INTO public.ecrit_par VALUES (184, 40);
INSERT INTO public.ecrit_par VALUES (185, 46);
INSERT INTO public.ecrit_par VALUES (186, 47);
INSERT INTO public.ecrit_par VALUES (187, 48);
INSERT INTO public.ecrit_par VALUES (188, 48);
INSERT INTO public.ecrit_par VALUES (189, 48);
INSERT INTO public.ecrit_par VALUES (190, 49);
INSERT INTO public.ecrit_par VALUES (191, 49);
INSERT INTO public.ecrit_par VALUES (192, 49);
INSERT INTO public.ecrit_par VALUES (193, 50);
INSERT INTO public.ecrit_par VALUES (194, 33);
INSERT INTO public.ecrit_par VALUES (195, 51);
INSERT INTO public.ecrit_par VALUES (196, 51);
INSERT INTO public.ecrit_par VALUES (197, 52);
INSERT INTO public.ecrit_par VALUES (198, 53);
INSERT INTO public.ecrit_par VALUES (199, 54);
INSERT INTO public.ecrit_par VALUES (200, 55);
INSERT INTO public.ecrit_par VALUES (201, 1);
INSERT INTO public.ecrit_par VALUES (201, 13);
INSERT INTO public.ecrit_par VALUES (201, 11);
INSERT INTO public.ecrit_par VALUES (202, 56);
INSERT INTO public.ecrit_par VALUES (203, 57);
INSERT INTO public.ecrit_par VALUES (204, 58);
INSERT INTO public.ecrit_par VALUES (205, 54);
INSERT INTO public.ecrit_par VALUES (206, 59);
INSERT INTO public.ecrit_par VALUES (207, 59);
INSERT INTO public.ecrit_par VALUES (208, 60);
INSERT INTO public.ecrit_par VALUES (209, 61);
INSERT INTO public.ecrit_par VALUES (210, 61);
INSERT INTO public.ecrit_par VALUES (211, 62);
INSERT INTO public.ecrit_par VALUES (212, 63);
INSERT INTO public.ecrit_par VALUES (213, 64);
INSERT INTO public.ecrit_par VALUES (214, 65);
INSERT INTO public.ecrit_par VALUES (215, 66);
INSERT INTO public.ecrit_par VALUES (216, 67);
INSERT INTO public.ecrit_par VALUES (217, 68);
INSERT INTO public.ecrit_par VALUES (218, 69);
INSERT INTO public.ecrit_par VALUES (219, 70);
INSERT INTO public.ecrit_par VALUES (220, 71);
INSERT INTO public.ecrit_par VALUES (221, 72);
INSERT INTO public.ecrit_par VALUES (222, 73);
INSERT INTO public.ecrit_par VALUES (223, 74);
INSERT INTO public.ecrit_par VALUES (224, 75);
INSERT INTO public.ecrit_par VALUES (225, 76);
INSERT INTO public.ecrit_par VALUES (226, 77);
INSERT INTO public.ecrit_par VALUES (227, 78);
INSERT INTO public.ecrit_par VALUES (228, 36);
INSERT INTO public.ecrit_par VALUES (229, 36);
INSERT INTO public.ecrit_par VALUES (230, 79);
INSERT INTO public.ecrit_par VALUES (231, 80);
INSERT INTO public.ecrit_par VALUES (232, 81);
INSERT INTO public.ecrit_par VALUES (233, 82);
INSERT INTO public.ecrit_par VALUES (234, 83);
INSERT INTO public.ecrit_par VALUES (235, 84);
INSERT INTO public.ecrit_par VALUES (236, 85);
INSERT INTO public.ecrit_par VALUES (237, 86);
INSERT INTO public.ecrit_par VALUES (238, 87);
INSERT INTO public.ecrit_par VALUES (239, 88);
INSERT INTO public.ecrit_par VALUES (240, 89);
INSERT INTO public.ecrit_par VALUES (241, 90);
INSERT INTO public.ecrit_par VALUES (242, 91);
INSERT INTO public.ecrit_par VALUES (243, 92);
INSERT INTO public.ecrit_par VALUES (244, 93);
INSERT INTO public.ecrit_par VALUES (245, 94);
INSERT INTO public.ecrit_par VALUES (246, 95);
INSERT INTO public.ecrit_par VALUES (247, 95);
INSERT INTO public.ecrit_par VALUES (248, 96);
INSERT INTO public.ecrit_par VALUES (249, 97);
INSERT INTO public.ecrit_par VALUES (250, 98);
INSERT INTO public.ecrit_par VALUES (251, 99);
INSERT INTO public.ecrit_par VALUES (252, 100);
INSERT INTO public.ecrit_par VALUES (253, 52);
INSERT INTO public.ecrit_par VALUES (254, 31);
INSERT INTO public.ecrit_par VALUES (255, 73);
INSERT INTO public.ecrit_par VALUES (256, 62);
INSERT INTO public.ecrit_par VALUES (257, 101);
INSERT INTO public.ecrit_par VALUES (257, 102);
INSERT INTO public.ecrit_par VALUES (257, 103);
INSERT INTO public.ecrit_par VALUES (257, 104);
INSERT INTO public.ecrit_par VALUES (258, 105);
INSERT INTO public.ecrit_par VALUES (259, 106);
INSERT INTO public.ecrit_par VALUES (260, 107);
INSERT INTO public.ecrit_par VALUES (260, 108);
INSERT INTO public.ecrit_par VALUES (261, 109);
INSERT INTO public.ecrit_par VALUES (262, 110);
INSERT INTO public.ecrit_par VALUES (263, 111);
INSERT INTO public.ecrit_par VALUES (264, 112);
INSERT INTO public.ecrit_par VALUES (265, 113);
INSERT INTO public.ecrit_par VALUES (266, 114);
INSERT INTO public.ecrit_par VALUES (267, 115);
INSERT INTO public.ecrit_par VALUES (268, 116);
INSERT INTO public.ecrit_par VALUES (269, 117);
INSERT INTO public.ecrit_par VALUES (270, 117);
INSERT INTO public.ecrit_par VALUES (271, 117);
INSERT INTO public.ecrit_par VALUES (272, 117);
INSERT INTO public.ecrit_par VALUES (273, 117);
INSERT INTO public.ecrit_par VALUES (274, 117);
INSERT INTO public.ecrit_par VALUES (275, 117);
INSERT INTO public.ecrit_par VALUES (276, 117);
INSERT INTO public.ecrit_par VALUES (277, 117);
INSERT INTO public.ecrit_par VALUES (278, 29);
INSERT INTO public.ecrit_par VALUES (279, 29);
INSERT INTO public.ecrit_par VALUES (280, 40);
INSERT INTO public.ecrit_par VALUES (281, 118);
INSERT INTO public.ecrit_par VALUES (282, 119);
INSERT INTO public.ecrit_par VALUES (283, 120);
INSERT INTO public.ecrit_par VALUES (284, 121);
INSERT INTO public.ecrit_par VALUES (284, 122);
INSERT INTO public.ecrit_par VALUES (285, 123);
INSERT INTO public.ecrit_par VALUES (286, 123);
INSERT INTO public.ecrit_par VALUES (287, 8);
INSERT INTO public.ecrit_par VALUES (288, 108);
INSERT INTO public.ecrit_par VALUES (289, 108);
INSERT INTO public.ecrit_par VALUES (288, 107);
INSERT INTO public.ecrit_par VALUES (289, 107);
INSERT INTO public.ecrit_par VALUES (290, 1);
INSERT INTO public.ecrit_par VALUES (291, 35);
INSERT INTO public.ecrit_par VALUES (292, 35);
INSERT INTO public.ecrit_par VALUES (293, 35);
INSERT INTO public.ecrit_par VALUES (294, 124);
INSERT INTO public.ecrit_par VALUES (295, 124);
INSERT INTO public.ecrit_par VALUES (296, 124);
INSERT INTO public.ecrit_par VALUES (297, 125);
INSERT INTO public.ecrit_par VALUES (298, 125);
INSERT INTO public.ecrit_par VALUES (299, 34);
INSERT INTO public.ecrit_par VALUES (300, 134);
INSERT INTO public.ecrit_par VALUES (301, 133);
INSERT INTO public.ecrit_par VALUES (303, 131);
INSERT INTO public.ecrit_par VALUES (304, 131);
INSERT INTO public.ecrit_par VALUES (305, 130);
INSERT INTO public.ecrit_par VALUES (306, 129);
INSERT INTO public.ecrit_par VALUES (307, 128);
INSERT INTO public.ecrit_par VALUES (308, 127);
INSERT INTO public.ecrit_par VALUES (309, 126);
INSERT INTO public.ecrit_par VALUES (310, 126);
INSERT INTO public.ecrit_par VALUES (311, 135);
INSERT INTO public.ecrit_par VALUES (312, 135);
INSERT INTO public.ecrit_par VALUES (313, 135);
INSERT INTO public.ecrit_par VALUES (314, 136);
INSERT INTO public.ecrit_par VALUES (315, 137);
INSERT INTO public.ecrit_par VALUES (316, 30);
INSERT INTO public.ecrit_par VALUES (317, 35);
INSERT INTO public.ecrit_par VALUES (318, 21);
INSERT INTO public.ecrit_par VALUES (320, 29);
INSERT INTO public.ecrit_par VALUES (321, 21);
INSERT INTO public.ecrit_par VALUES (322, 139);
INSERT INTO public.ecrit_par VALUES (323, 17);
INSERT INTO public.ecrit_par VALUES (324, 140);
INSERT INTO public.ecrit_par VALUES (325, 141);
INSERT INTO public.ecrit_par VALUES (326, 141);
INSERT INTO public.ecrit_par VALUES (327, 25);
INSERT INTO public.ecrit_par VALUES (328, 142);
INSERT INTO public.ecrit_par VALUES (328, 21);
INSERT INTO public.ecrit_par VALUES (329, 140);
INSERT INTO public.ecrit_par VALUES (330, 51);
INSERT INTO public.ecrit_par VALUES (331, 8);
INSERT INTO public.ecrit_par VALUES (331, 143);
INSERT INTO public.ecrit_par VALUES (332, 17);
INSERT INTO public.ecrit_par VALUES (333, 12);
INSERT INTO public.ecrit_par VALUES (334, 22);
INSERT INTO public.ecrit_par VALUES (334, 21);
INSERT INTO public.ecrit_par VALUES (335, 144);
INSERT INTO public.ecrit_par VALUES (336, 145);
INSERT INTO public.ecrit_par VALUES (302, 132);
INSERT INTO public.ecrit_par VALUES (319, 138);
INSERT INTO public.ecrit_par VALUES (58, 8);
INSERT INTO public.ecrit_par VALUES (47, 7);
INSERT INTO public.ecrit_par VALUES (337, 25);
INSERT INTO public.ecrit_par VALUES (338, 25);
INSERT INTO public.ecrit_par VALUES (339, 25);
INSERT INTO public.ecrit_par VALUES (340, 25);
INSERT INTO public.ecrit_par VALUES (341, 25);
INSERT INTO public.ecrit_par VALUES (342, 25);
INSERT INTO public.ecrit_par VALUES (343, 146);
INSERT INTO public.ecrit_par VALUES (344, 140);
INSERT INTO public.ecrit_par VALUES (345, 11);
INSERT INTO public.ecrit_par VALUES (347, 21);
INSERT INTO public.ecrit_par VALUES (347, 147);
INSERT INTO public.ecrit_par VALUES (348, 11);
INSERT INTO public.ecrit_par VALUES (349, 146);
INSERT INTO public.ecrit_par VALUES (350, 148);
INSERT INTO public.ecrit_par VALUES (351, 149);
INSERT INTO public.ecrit_par VALUES (352, 61);
INSERT INTO public.ecrit_par VALUES (346, 30);
INSERT INTO public.ecrit_par VALUES (353, 21);
INSERT INTO public.ecrit_par VALUES (354, 15);
INSERT INTO public.ecrit_par VALUES (355, 61);
INSERT INTO public.ecrit_par VALUES (356, 1);
INSERT INTO public.ecrit_par VALUES (357, 150);
INSERT INTO public.ecrit_par VALUES (358, 151);
INSERT INTO public.ecrit_par VALUES (359, 151);
INSERT INTO public.ecrit_par VALUES (360, 152);
INSERT INTO public.ecrit_par VALUES (361, 10);
INSERT INTO public.ecrit_par VALUES (362, 4);
INSERT INTO public.ecrit_par VALUES (363, 152);
INSERT INTO public.ecrit_par VALUES (364, 7);
INSERT INTO public.ecrit_par VALUES (365, 153);
INSERT INTO public.ecrit_par VALUES (366, 25);
INSERT INTO public.ecrit_par VALUES (367, 117);
INSERT INTO public.ecrit_par VALUES (368, 25);
INSERT INTO public.ecrit_par VALUES (369, 117);
INSERT INTO public.ecrit_par VALUES (370, 154);
INSERT INTO public.ecrit_par VALUES (370, 155);
INSERT INTO public.ecrit_par VALUES (371, 8);
INSERT INTO public.ecrit_par VALUES (372, 56);
INSERT INTO public.ecrit_par VALUES (373, 8);
INSERT INTO public.ecrit_par VALUES (374, 111);
INSERT INTO public.ecrit_par VALUES (375, 8);
INSERT INTO public.ecrit_par VALUES (376, 156);
INSERT INTO public.ecrit_par VALUES (377, 156);
INSERT INTO public.ecrit_par VALUES (378, 157);
INSERT INTO public.ecrit_par VALUES (379, 61);
INSERT INTO public.ecrit_par VALUES (380, 158);
INSERT INTO public.ecrit_par VALUES (381, 21);
INSERT INTO public.ecrit_par VALUES (382, 159);
INSERT INTO public.ecrit_par VALUES (382, 160);
INSERT INTO public.ecrit_par VALUES (383, 8);
INSERT INTO public.ecrit_par VALUES (384, 127);
INSERT INTO public.ecrit_par VALUES (385, 91);
INSERT INTO public.ecrit_par VALUES (386, 161);
INSERT INTO public.ecrit_par VALUES (387, 162);
INSERT INTO public.ecrit_par VALUES (388, 12);
INSERT INTO public.ecrit_par VALUES (389, 62);
INSERT INTO public.ecrit_par VALUES (390, 163);
INSERT INTO public.ecrit_par VALUES (391, 164);
INSERT INTO public.ecrit_par VALUES (391, 165);
INSERT INTO public.ecrit_par VALUES (392, 166);
INSERT INTO public.ecrit_par VALUES (393, 167);
INSERT INTO public.ecrit_par VALUES (394, 168);
INSERT INTO public.ecrit_par VALUES (395, 169);
INSERT INTO public.ecrit_par VALUES (396, 127);
INSERT INTO public.ecrit_par VALUES (397, 166);
INSERT INTO public.ecrit_par VALUES (398, 48);
INSERT INTO public.ecrit_par VALUES (399, 41);
INSERT INTO public.ecrit_par VALUES (400, 158);
INSERT INTO public.ecrit_par VALUES (401, 35);
INSERT INTO public.ecrit_par VALUES (402, 111);
INSERT INTO public.ecrit_par VALUES (402, 39);
INSERT INTO public.ecrit_par VALUES (403, 9);
INSERT INTO public.ecrit_par VALUES (404, 10);
INSERT INTO public.ecrit_par VALUES (405, 170);
INSERT INTO public.ecrit_par VALUES (406, 117);
INSERT INTO public.ecrit_par VALUES (407, 171);
INSERT INTO public.ecrit_par VALUES (408, 25);
INSERT INTO public.ecrit_par VALUES (409, 172);
INSERT INTO public.ecrit_par VALUES (410, 4);
INSERT INTO public.ecrit_par VALUES (411, 159);
INSERT INTO public.ecrit_par VALUES (411, 160);
INSERT INTO public.ecrit_par VALUES (412, 173);
INSERT INTO public.ecrit_par VALUES (413, 174);
INSERT INTO public.ecrit_par VALUES (414, 175);
INSERT INTO public.ecrit_par VALUES (415, 26);
INSERT INTO public.ecrit_par VALUES (416, 176);
INSERT INTO public.ecrit_par VALUES (417, 7);
INSERT INTO public.ecrit_par VALUES (418, 177);
INSERT INTO public.ecrit_par VALUES (419, 178);
INSERT INTO public.ecrit_par VALUES (420, 178);
INSERT INTO public.ecrit_par VALUES (421, 179);
INSERT INTO public.ecrit_par VALUES (422, 180);
INSERT INTO public.ecrit_par VALUES (423, 111);
INSERT INTO public.ecrit_par VALUES (424, 180);
INSERT INTO public.ecrit_par VALUES (425, 180);
INSERT INTO public.ecrit_par VALUES (426, 180);
INSERT INTO public.ecrit_par VALUES (427, 180);
INSERT INTO public.ecrit_par VALUES (428, 180);
INSERT INTO public.ecrit_par VALUES (429, 180);
INSERT INTO public.ecrit_par VALUES (430, 138);
INSERT INTO public.ecrit_par VALUES (431, 126);
INSERT INTO public.ecrit_par VALUES (432, 138);
INSERT INTO public.ecrit_par VALUES (433, 48);
INSERT INTO public.ecrit_par VALUES (434, 61);
INSERT INTO public.ecrit_par VALUES (435, 181);
INSERT INTO public.ecrit_par VALUES (435, 182);
INSERT INTO public.ecrit_par VALUES (436, 6);
INSERT INTO public.ecrit_par VALUES (437, 183);
INSERT INTO public.ecrit_par VALUES (438, 184);
INSERT INTO public.ecrit_par VALUES (438, 185);
INSERT INTO public.ecrit_par VALUES (439, 186);
INSERT INTO public.ecrit_par VALUES (439, 187);
INSERT INTO public.ecrit_par VALUES (440, 188);
INSERT INTO public.ecrit_par VALUES (441, 189);
INSERT INTO public.ecrit_par VALUES (442, 190);
INSERT INTO public.ecrit_par VALUES (443, 191);
INSERT INTO public.ecrit_par VALUES (444, 10);
INSERT INTO public.ecrit_par VALUES (445, 117);
INSERT INTO public.ecrit_par VALUES (446, 140);
INSERT INTO public.ecrit_par VALUES (447, 168);
INSERT INTO public.ecrit_par VALUES (448, 192);
INSERT INTO public.ecrit_par VALUES (449, 114);
INSERT INTO public.ecrit_par VALUES (450, 39);
INSERT INTO public.ecrit_par VALUES (451, 39);
INSERT INTO public.ecrit_par VALUES (451, 111);
INSERT INTO public.ecrit_par VALUES (452, 193);
INSERT INTO public.ecrit_par VALUES (453, 150);
INSERT INTO public.ecrit_par VALUES (454, 194);
INSERT INTO public.ecrit_par VALUES (455, 194);
INSERT INTO public.ecrit_par VALUES (456, 194);
INSERT INTO public.ecrit_par VALUES (457, 4);
INSERT INTO public.ecrit_par VALUES (458, 6);
INSERT INTO public.ecrit_par VALUES (459, 9);
INSERT INTO public.ecrit_par VALUES (460, 10);
INSERT INTO public.ecrit_par VALUES (461, 10);
INSERT INTO public.ecrit_par VALUES (462, 7);
INSERT INTO public.ecrit_par VALUES (463, 8);
INSERT INTO public.ecrit_par VALUES (464, 195);
INSERT INTO public.ecrit_par VALUES (465, 110);
INSERT INTO public.ecrit_par VALUES (466, 23);
INSERT INTO public.ecrit_par VALUES (467, 196);


--
-- TOC entry 5401 (class 0 OID 27167)
-- Dependencies: 466
-- Data for Name: editeurs; Type: TABLE DATA; Schema: public; Owner: lbrun
--

INSERT INTO public.editeurs VALUES (1, 'Presses de la cite', '', NULL, 'Paris');
INSERT INTO public.editeurs VALUES (2, 'Denoel', '9 rue du cherche midi', 75006, 'Paris');
INSERT INTO public.editeurs VALUES (3, 'Le livre de poche', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (4, 'Humanoides associes', NULL, NULL, 'Paris');
INSERT INTO public.editeurs VALUES (6, 'Presses Pocket', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (7, 'Opta', '1 quai Conti', 75006, 'Paris');
INSERT INTO public.editeurs VALUES (8, 'Albin Michel', '22 rue Huyghens', 75014, 'Paris');
INSERT INTO public.editeurs VALUES (9, 'Seghers', NULL, NULL, 'Paris');
INSERT INTO public.editeurs VALUES (11, 'Gerard & C.', '', NULL, 'Verviers(B');
INSERT INTO public.editeurs VALUES (12, 'Robert Laffont', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (13, 'Calman Levy', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (14, 'Presses de la renaissance', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (16, 'Headline House', '79 Great Titchfield Street', NULL, 'London');
INSERT INTO public.editeurs VALUES (17, 'Mercure de France', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (5, 'Casterman', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (18, 'Flammarion', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (19, 'J.C. Lattes', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (21, 'Le club francais du livre', '8 rue de la paix', NULL, 'Paris');
INSERT INTO public.editeurs VALUES (22, 'Le courrier du livre', '21 rue de la seine', NULL, 'Paris');
INSERT INTO public.editeurs VALUES (23, 'L''atlante', '15 Rue des Veilles Douves', 44000, 'Nantes');
INSERT INTO public.editeurs VALUES (24, 'Scientifiques et literaires', '54 rue d''AUbervilliers', NULL, 'Paris');
INSERT INTO public.editeurs VALUES (25, 'Stock', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (26, 'Plon', NULL, NULL, 'Paris');
INSERT INTO public.editeurs VALUES (27, 'Le masque', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (28, 'Hachette', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (29, 'L''age d''homme', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (30, 'Gautier-Villars', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (31, 'Gallimard', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (32, 'Medium Poche', '11 rue de evres', NULL, 'Paris');
INSERT INTO public.editeurs VALUES (33, 'Les libertes francaises', '22 rue de conde', NULL, 'Paris');
INSERT INTO public.editeurs VALUES (34, '10/18', '12 avenue d''italie', 75627, 'Paris');
INSERT INTO public.editeurs VALUES (35, 'Seuil', '27 rue Jacob', NULL, 'Paris');
INSERT INTO public.editeurs VALUES (36, 'Larousse', '21 Rue de Montparnasse', 75283, 'Paris');
INSERT INTO public.editeurs VALUES (37, 'Fayard', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (38, 'Dominique Gueniot', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (39, 'Frontispice', NULL, NULL, 'Geneve');
INSERT INTO public.editeurs VALUES (40, 'Marabout', NULL, NULL, 'Paris');
INSERT INTO public.editeurs VALUES (41, 'Editions du Rocher', NULL, NULL, '');
INSERT INTO public.editeurs VALUES (42, 'Librio', NULL, NULL, 'Paris');
INSERT INTO public.editeurs VALUES (10, 'J''ai lu', '84, rue de Grenelle', 75007, 'Paris');
INSERT INTO public.editeurs VALUES (43, 'Loubatieres', '10bis boulevard de l europe', 31120, 'Portet sur');
INSERT INTO public.editeurs VALUES (44, 'Payot Rivages', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (45, 'Galaxies', 'BP 3687', 54097, 'Nancy');
INSERT INTO public.editeurs VALUES (46, 'Au diable Vauvert', 'La Laune', 30600, 'Vauvert');
INSERT INTO public.editeurs VALUES (47, 'Edition N 1/olivier orban', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (48, 'Champ libre', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (20, 'Fleuve Noir', '69 Bd Saint Marcel', NULL, 'Paris');
INSERT INTO public.editeurs VALUES (49, 'Editions du Masque', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (50, 'France Loisirs', '123 boul. de Grenelle', NULL, 'Paris');
INSERT INTO public.editeurs VALUES (51, 'Mnemos', '32 bd de Menilmontant', 75020, 'Paris');
INSERT INTO public.editeurs VALUES (15, 'Librairie des champs elyses', '17 Rue de Marignan', NULL, 'Paris');
INSERT INTO public.editeurs VALUES (0, '', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (52, 'Fernand Nathan', NULL, NULL, 'Paris');
INSERT INTO public.editeurs VALUES (53, 'La Farandole', '146, rue du Faubourg-Poissonni(c3)(a8)re', 75010, 'Paris');
INSERT INTO public.editeurs VALUES (54, 'Rencontre', NULL, NULL, NULL);
INSERT INTO public.editeurs VALUES (55, 'Menges', '22  rue Sebastien-Mercier', 75015, 'Paris');
INSERT INTO public.editeurs VALUES (56, 'A Lire', 'C.P 67, Succ. B. Qu(c3)(a9)bec Canada', 0, NULL);


--
-- TOC entry 5402 (class 0 OID 27173)
-- Dependencies: 467
-- Data for Name: emplacements; Type: TABLE DATA; Schema: public; Owner: lbrun
--

INSERT INTO public.emplacements VALUES (2, 'armoire 1, etagere 2');
INSERT INTO public.emplacements VALUES (1, 'armoire 2, etagere 2');
INSERT INTO public.emplacements VALUES (3, 'armoire 2, etagere 6');
INSERT INTO public.emplacements VALUES (4, 'armoire 5, etagere 6');
INSERT INTO public.emplacements VALUES (5, 'armoire 1, etagere 5');
INSERT INTO public.emplacements VALUES (6, 'armoire 8, etagere 4');
INSERT INTO public.emplacements VALUES (7, 'armoire 8, etagere 3');
INSERT INTO public.emplacements VALUES (9, 'armoire 4, etagere 2');
INSERT INTO public.emplacements VALUES (8, 'armoire 6, etagere 8');
INSERT INTO public.emplacements VALUES (11, 'armoire 7, etagere 3');
INSERT INTO public.emplacements VALUES (12, 'armoire 4, etagere 9');
INSERT INTO public.emplacements VALUES (13, 'armoire 4, etagere 7');
INSERT INTO public.emplacements VALUES (14, 'armoire 8, etagere 3');
INSERT INTO public.emplacements VALUES (15, 'armoire 5, etagere 2');
INSERT INTO public.emplacements VALUES (16, 'armoire 6, etagere 5');
INSERT INTO public.emplacements VALUES (10, 'armoire 3, etagere 7');
INSERT INTO public.emplacements VALUES (17, 'armoire 6, etagere 5');
INSERT INTO public.emplacements VALUES (18, 'armoire 8, etagere 8');
INSERT INTO public.emplacements VALUES (19, 'armoire 1, etagere 2');


--
-- TOC entry 5403 (class 0 OID 27180)
-- Dependencies: 468
-- Data for Name: emprunts; Type: TABLE DATA; Schema: public; Owner: lbrun
--



--
-- TOC entry 5404 (class 0 OID 27183)
-- Dependencies: 469
-- Data for Name: exemplaire; Type: TABLE DATA; Schema: public; Owner: lbrun
--

INSERT INTO public.exemplaire VALUES (309, 297, 39, 14, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (310, 298, 39, 14, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (311, 299, 39, 15, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (312, 300, 39, 15, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (313, 301, 39, 15, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (314, 302, 39, 15, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (315, 303, 39, 15, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (316, 304, 39, 15, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (317, 305, 39, 15, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (318, 306, 39, 15, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (319, 307, 39, 15, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (320, 308, 39, 15, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (321, 309, 39, 15, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (322, 310, 39, 15, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (30, 26, 8, 1, NULL, NULL);
INSERT INTO public.exemplaire VALUES (31, 27, 8, 1, NULL, NULL);
INSERT INTO public.exemplaire VALUES (326, 314, 23, 13, NULL, 4.57);
INSERT INTO public.exemplaire VALUES (36, 32, 16, 1, NULL, NULL);
INSERT INTO public.exemplaire VALUES (37, 33, 8, 1, NULL, NULL);
INSERT INTO public.exemplaire VALUES (328, 316, 10, 7, '2000-10-09', 2.29);
INSERT INTO public.exemplaire VALUES (39, 35, 12, 1, NULL, NULL);
INSERT INTO public.exemplaire VALUES (329, 317, 8, 11, '2000-01-10', 0.76);
INSERT INTO public.exemplaire VALUES (42, 37, 2, 1, NULL, NULL);
INSERT INTO public.exemplaire VALUES (43, 38, 2, 1, NULL, NULL);
INSERT INTO public.exemplaire VALUES (44, 39, 14, 1, NULL, NULL);
INSERT INTO public.exemplaire VALUES (45, 40, 2, 1, NULL, NULL);
INSERT INTO public.exemplaire VALUES (46, 41, 2, 1, NULL, NULL);
INSERT INTO public.exemplaire VALUES (47, 42, 17, 1, NULL, NULL);
INSERT INTO public.exemplaire VALUES (330, 318, 10, 5, '2000-10-01', 1.52);
INSERT INTO public.exemplaire VALUES (54, 49, 12, 3, NULL, NULL);
INSERT INTO public.exemplaire VALUES (55, 50, 12, 3, NULL, NULL);
INSERT INTO public.exemplaire VALUES (332, 320, 10, 7, '2000-01-10', 2.29);
INSERT INTO public.exemplaire VALUES (334, 322, 40, 11, '2000-01-10', 0.76);
INSERT INTO public.exemplaire VALUES (335, 323, 1, 5, '2000-09-15', 18.29);
INSERT INTO public.exemplaire VALUES (337, 325, 2, 16, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (338, 326, 2, 16, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (339, 327, 23, 6, '2000-11-25', 19.67);
INSERT INTO public.exemplaire VALUES (340, 328, 41, 9, '2000-12-23', 20.58);
INSERT INTO public.exemplaire VALUES (64, 59, 7, 3, NULL, NULL);
INSERT INTO public.exemplaire VALUES (67, 62, 2, 3, NULL, NULL);
INSERT INTO public.exemplaire VALUES (342, 330, 18, 10, '2000-12-31', 1.52);
INSERT INTO public.exemplaire VALUES (343, 331, 18, 11, '2001-01-01', 22.71);
INSERT INTO public.exemplaire VALUES (346, 334, 10, 9, '2001-10-03', 6.10);
INSERT INTO public.exemplaire VALUES (110, 105, 12, 2, NULL, 4.57);
INSERT INTO public.exemplaire VALUES (74, 69, 10, 3, NULL, NULL);
INSERT INTO public.exemplaire VALUES (348, 336, 10, 11, '2001-04-14', 4.57);
INSERT INTO public.exemplaire VALUES (77, 72, 12, 4, NULL, NULL);
INSERT INTO public.exemplaire VALUES (78, 73, 12, 4, NULL, NULL);
INSERT INTO public.exemplaire VALUES (79, 74, 12, 4, NULL, NULL);
INSERT INTO public.exemplaire VALUES (349, 337, 42, 6, '2001-04-20', 1.52);
INSERT INTO public.exemplaire VALUES (350, 338, 42, 6, '2000-04-20', 1.52);
INSERT INTO public.exemplaire VALUES (351, 339, 42, 6, '2000-04-20', 1.52);
INSERT INTO public.exemplaire VALUES (352, 340, 42, 6, '2000-04-20', 1.52);
INSERT INTO public.exemplaire VALUES (84, 79, 12, 4, NULL, NULL);
INSERT INTO public.exemplaire VALUES (353, 341, 42, 6, '2000-04-20', 1.52);
INSERT INTO public.exemplaire VALUES (86, 81, 12, 4, NULL, NULL);
INSERT INTO public.exemplaire VALUES (87, 82, 12, 4, NULL, NULL);
INSERT INTO public.exemplaire VALUES (88, 83, 12, 4, NULL, NULL);
INSERT INTO public.exemplaire VALUES (89, 84, 12, 4, NULL, NULL);
INSERT INTO public.exemplaire VALUES (354, 342, 42, 6, '2000-04-20', 1.52);
INSERT INTO public.exemplaire VALUES (357, 352, 10, 10, '2001-08-16', 1.52);
INSERT INTO public.exemplaire VALUES (358, 351, 43, 11, '2001-11-08', 4.57);
INSERT INTO public.exemplaire VALUES (359, 350, 13, 11, '2001-08-16', 3.05);
INSERT INTO public.exemplaire VALUES (361, 348, 19, 4, '2001-08-16', 2.29);
INSERT INTO public.exemplaire VALUES (362, 347, 10, 5, '2001-07-15', 7.10);
INSERT INTO public.exemplaire VALUES (102, 97, 10, 4, NULL, NULL);
INSERT INTO public.exemplaire VALUES (363, 346, 6, 7, '2001-07-15', 7.24);
INSERT INTO public.exemplaire VALUES (364, 345, 6, 4, '2001-08-16', 2.29);
INSERT INTO public.exemplaire VALUES (365, 353, 8, 9, NULL, 6.10);
INSERT INTO public.exemplaire VALUES (345, 332, 10, 11, '2001-10-03', 6.10);
INSERT INTO public.exemplaire VALUES (366, 354, 10, 4, '2001-08-16', 2.29);
INSERT INTO public.exemplaire VALUES (367, 355, 10, 10, '2001-08-20', 1.83);
INSERT INTO public.exemplaire VALUES (192, 185, 10, 11, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (113, 108, 10, 5, NULL, NULL);
INSERT INTO public.exemplaire VALUES (333, 321, 2, 9, '2000-01-10', 1.25);
INSERT INTO public.exemplaire VALUES (369, 357, 20, 5, '2001-04-10', 18.14);
INSERT INTO public.exemplaire VALUES (116, 111, 15, 5, NULL, NULL);
INSERT INTO public.exemplaire VALUES (370, 358, 31, 11, '2001-10-13', 7.62);
INSERT INTO public.exemplaire VALUES (118, 113, 6, 6, NULL, NULL);
INSERT INTO public.exemplaire VALUES (119, 114, 6, 6, NULL, NULL);
INSERT INTO public.exemplaire VALUES (120, 115, 6, 6, NULL, NULL);
INSERT INTO public.exemplaire VALUES (121, 116, 6, 6, NULL, NULL);
INSERT INTO public.exemplaire VALUES (122, 117, 6, 6, NULL, NULL);
INSERT INTO public.exemplaire VALUES (123, 118, 6, 6, NULL, NULL);
INSERT INTO public.exemplaire VALUES (124, 119, 6, 6, NULL, NULL);
INSERT INTO public.exemplaire VALUES (371, 359, 31, 11, '2001-11-03', 8.54);
INSERT INTO public.exemplaire VALUES (372, 360, 12, 11, '2001-11-03', 8.40);
INSERT INTO public.exemplaire VALUES (373, 361, 12, 4, '2001-03-11', 22.71);
INSERT INTO public.exemplaire VALUES (374, 362, 2, 1, '2001-08-12', 6.08);
INSERT INTO public.exemplaire VALUES (375, 363, 44, 11, '2001-08-12', 5.65);
INSERT INTO public.exemplaire VALUES (377, 365, 7, 11, '2001-12-30', 0.76);
INSERT INTO public.exemplaire VALUES (132, 127, 23, 6, NULL, NULL);
INSERT INTO public.exemplaire VALUES (133, 128, 23, 6, NULL, NULL);
INSERT INTO public.exemplaire VALUES (378, 366, 45, 11, '2002-05-01', 9.15);
INSERT INTO public.exemplaire VALUES (379, 367, 23, 12, '2002-02-01', 18.69);
INSERT INTO public.exemplaire VALUES (72, 67, 10, 3, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (76, 71, 1, 3, NULL, 6.71);
INSERT INTO public.exemplaire VALUES (80, 75, 12, 4, NULL, 9.15);
INSERT INTO public.exemplaire VALUES (81, 76, 19, 4, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (82, 77, 8, 4, NULL, 1.52);
INSERT INTO public.exemplaire VALUES (145, 140, 10, 7, NULL, NULL);
INSERT INTO public.exemplaire VALUES (83, 78, 10, 4, NULL, 5.34);
INSERT INTO public.exemplaire VALUES (85, 80, 9, 4, NULL, 1.52);
INSERT INTO public.exemplaire VALUES (148, 143, 10, 7, NULL, NULL);
INSERT INTO public.exemplaire VALUES (150, 145, 10, 7, NULL, NULL);
INSERT INTO public.exemplaire VALUES (151, 146, 10, 7, NULL, NULL);
INSERT INTO public.exemplaire VALUES (154, 149, 10, 7, NULL, NULL);
INSERT INTO public.exemplaire VALUES (156, 151, 3, 7, NULL, NULL);
INSERT INTO public.exemplaire VALUES (158, 153, 10, 7, NULL, NULL);
INSERT INTO public.exemplaire VALUES (159, 154, 10, 7, NULL, NULL);
INSERT INTO public.exemplaire VALUES (162, 156, 10, 7, NULL, NULL);
INSERT INTO public.exemplaire VALUES (163, 157, 10, 7, NULL, NULL);
INSERT INTO public.exemplaire VALUES (164, 158, 6, 7, NULL, NULL);
INSERT INTO public.exemplaire VALUES (165, 159, 6, 7, NULL, NULL);
INSERT INTO public.exemplaire VALUES (166, 160, 10, 7, NULL, NULL);
INSERT INTO public.exemplaire VALUES (167, 161, 10, 7, NULL, NULL);
INSERT INTO public.exemplaire VALUES (99, 94, 2, 4, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (100, 95, 2, 4, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (101, 96, 10, 4, NULL, 4.57);
INSERT INTO public.exemplaire VALUES (103, 98, 10, 5, NULL, 10.52);
INSERT INTO public.exemplaire VALUES (104, 99, 20, 5, NULL, 10.52);
INSERT INTO public.exemplaire VALUES (105, 100, 20, 5, NULL, 10.52);
INSERT INTO public.exemplaire VALUES (174, 168, 12, 9, NULL, NULL);
INSERT INTO public.exemplaire VALUES (175, 169, 12, 9, NULL, NULL);
INSERT INTO public.exemplaire VALUES (176, 170, 12, 9, NULL, NULL);
INSERT INTO public.exemplaire VALUES (177, 81, 12, 9, NULL, NULL);
INSERT INTO public.exemplaire VALUES (178, 171, 25, 9, NULL, NULL);
INSERT INTO public.exemplaire VALUES (179, 172, 12, 9, NULL, NULL);
INSERT INTO public.exemplaire VALUES (180, 173, 26, 9, NULL, NULL);
INSERT INTO public.exemplaire VALUES (181, 174, 12, 9, NULL, NULL);
INSERT INTO public.exemplaire VALUES (182, 175, 27, 9, NULL, NULL);
INSERT INTO public.exemplaire VALUES (184, 177, 12, 9, NULL, NULL);
INSERT INTO public.exemplaire VALUES (185, 178, 12, 9, NULL, NULL);
INSERT INTO public.exemplaire VALUES (187, 180, 28, 8, NULL, NULL);
INSERT INTO public.exemplaire VALUES (188, 181, 12, 8, NULL, NULL);
INSERT INTO public.exemplaire VALUES (189, 182, 29, 8, NULL, NULL);
INSERT INTO public.exemplaire VALUES (190, 183, 15, 8, NULL, NULL);
INSERT INTO public.exemplaire VALUES (191, 184, 8, 8, NULL, NULL);
INSERT INTO public.exemplaire VALUES (106, 101, 20, 5, NULL, 10.52);
INSERT INTO public.exemplaire VALUES (107, 102, 1, 5, NULL, 19.82);
INSERT INTO public.exemplaire VALUES (195, 188, 3, 10, NULL, NULL);
INSERT INTO public.exemplaire VALUES (108, 103, 1, 5, NULL, 19.82);
INSERT INTO public.exemplaire VALUES (109, 104, 1, 5, NULL, 19.82);
INSERT INTO public.exemplaire VALUES (198, 191, 3, 10, NULL, NULL);
INSERT INTO public.exemplaire VALUES (199, 192, 3, 10, NULL, NULL);
INSERT INTO public.exemplaire VALUES (111, 106, 21, 5, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (115, 110, 10, 5, NULL, 6.56);
INSERT INTO public.exemplaire VALUES (117, 112, 10, 5, NULL, 1.52);
INSERT INTO public.exemplaire VALUES (125, 120, 2, 6, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (126, 121, 2, 6, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (127, 122, 2, 6, NULL, 1.91);
INSERT INTO public.exemplaire VALUES (128, 123, 2, 6, NULL, 1.91);
INSERT INTO public.exemplaire VALUES (129, 124, 23, 6, NULL, 22.71);
INSERT INTO public.exemplaire VALUES (130, 125, 23, 6, NULL, 22.71);
INSERT INTO public.exemplaire VALUES (212, 202, 10, 10, NULL, NULL);
INSERT INTO public.exemplaire VALUES (131, 126, 23, 6, NULL, 22.71);
INSERT INTO public.exemplaire VALUES (134, 129, 10, 6, NULL, 13.57);
INSERT INTO public.exemplaire VALUES (135, 130, 23, 6, NULL, 21.19);
INSERT INTO public.exemplaire VALUES (140, 135, 10, 7, NULL, 1.52);
INSERT INTO public.exemplaire VALUES (141, 136, 7, 7, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (142, 137, 10, 7, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (143, 138, 10, 7, NULL, 2.44);
INSERT INTO public.exemplaire VALUES (144, 139, 10, 7, NULL, 4.57);
INSERT INTO public.exemplaire VALUES (146, 141, 10, 7, NULL, 6.10);
INSERT INTO public.exemplaire VALUES (147, 142, 10, 7, NULL, 6.10);
INSERT INTO public.exemplaire VALUES (225, 215, 17, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (149, 144, 10, 7, NULL, 6.56);
INSERT INTO public.exemplaire VALUES (152, 147, 10, 7, NULL, 2.59);
INSERT INTO public.exemplaire VALUES (230, 220, 7, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (153, 148, 10, 7, NULL, 2.44);
INSERT INTO public.exemplaire VALUES (155, 150, 10, 7, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (233, 223, 3, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (157, 152, 10, 7, NULL, 5.34);
INSERT INTO public.exemplaire VALUES (160, 155, 10, 7, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (236, 226, 7, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (161, 155, 10, 7, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (168, 162, 25, 8, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (239, 228, 3, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (240, 229, 3, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (241, 230, 33, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (242, 231, 31, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (169, 163, 25, 8, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (244, 233, 10, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (170, 164, 25, 8, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (246, 235, 31, 11, '1993-10-29', NULL);
INSERT INTO public.exemplaire VALUES (171, 165, 25, 8, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (172, 166, 25, 8, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (173, 167, 25, 8, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (193, 186, 20, 10, NULL, 6.40);
INSERT INTO public.exemplaire VALUES (194, 187, 2, 10, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (256, 245, 3, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (196, 189, 2, 10, NULL, 4.42);
INSERT INTO public.exemplaire VALUES (197, 190, 6, 10, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (200, 193, 23, 10, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (201, 194, 2, 10, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (202, 195, 2, 10, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (203, 196, 2, 10, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (263, 252, 36, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (207, 197, 6, 10, NULL, 1.52);
INSERT INTO public.exemplaire VALUES (208, 198, 2, 10, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (209, 199, 2, 10, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (210, 200, 10, 10, NULL, 4.63);
INSERT INTO public.exemplaire VALUES (214, 204, 10, 10, NULL, 6.10);
INSERT INTO public.exemplaire VALUES (270, 258, 3, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (271, 259, 10, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (215, 205, 10, 10, NULL, 4.34);
INSERT INTO public.exemplaire VALUES (216, 206, 2, 10, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (217, 207, 7, 10, NULL, 4.57);
INSERT INTO public.exemplaire VALUES (219, 209, 10, 10, NULL, 1.52);
INSERT INTO public.exemplaire VALUES (220, 210, 10, 10, NULL, 1.83);
INSERT INTO public.exemplaire VALUES (221, 211, 10, 10, NULL, 1.52);
INSERT INTO public.exemplaire VALUES (222, 212, 7, 10, NULL, 1.52);
INSERT INTO public.exemplaire VALUES (280, 268, 38, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (281, 269, 10, 12, NULL, NULL);
INSERT INTO public.exemplaire VALUES (224, 214, 10, 10, NULL, 4.49);
INSERT INTO public.exemplaire VALUES (285, 273, 23, 12, NULL, NULL);
INSERT INTO public.exemplaire VALUES (286, 274, 23, 12, NULL, NULL);
INSERT INTO public.exemplaire VALUES (287, 275, 23, 12, NULL, NULL);
INSERT INTO public.exemplaire VALUES (229, 219, 2, 11, NULL, 6.10);
INSERT INTO public.exemplaire VALUES (289, 277, 23, 12, NULL, NULL);
INSERT INTO public.exemplaire VALUES (290, 278, 7, 13, NULL, NULL);
INSERT INTO public.exemplaire VALUES (291, 279, 7, 13, NULL, NULL);
INSERT INTO public.exemplaire VALUES (292, 280, 7, 13, NULL, NULL);
INSERT INTO public.exemplaire VALUES (293, 281, 7, 13, NULL, NULL);
INSERT INTO public.exemplaire VALUES (294, 282, 7, 13, NULL, NULL);
INSERT INTO public.exemplaire VALUES (232, 222, 2, 11, NULL, 2.74);
INSERT INTO public.exemplaire VALUES (234, 224, 2, 11, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (235, 225, 6, 11, NULL, 6.10);
INSERT INTO public.exemplaire VALUES (238, 184, 8, 11, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (243, 232, 7, 11, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (245, 234, 10, 11, NULL, 2.74);
INSERT INTO public.exemplaire VALUES (247, 236, 12, 11, NULL, 4.57);
INSERT INTO public.exemplaire VALUES (253, 242, 10, 11, NULL, 1.83);
INSERT INTO public.exemplaire VALUES (254, 243, 2, 11, NULL, 2.74);
INSERT INTO public.exemplaire VALUES (255, 244, 1, 11, '2000-01-01', 18.10);
INSERT INTO public.exemplaire VALUES (257, 246, 23, 11, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (258, 247, 23, 11, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (259, 248, 7, 11, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (260, 249, 10, 11, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (261, 250, 10, 11, NULL, 1.52);
INSERT INTO public.exemplaire VALUES (262, 251, 35, 11, NULL, 20.58);
INSERT INTO public.exemplaire VALUES (265, 253, 12, 10, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (264, 196, 2, 10, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (266, 254, 10, 11, NULL, 4.57);
INSERT INTO public.exemplaire VALUES (267, 255, 2, 11, NULL, 2.74);
INSERT INTO public.exemplaire VALUES (268, 256, 10, 10, NULL, 4.57);
INSERT INTO public.exemplaire VALUES (218, 208, 30, 11, NULL, 3.66);
INSERT INTO public.exemplaire VALUES (272, 260, 2, 11, NULL, 2.59);
INSERT INTO public.exemplaire VALUES (273, 261, 2, 11, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (274, 262, 2, 11, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (275, 263, 10, 11, NULL, 4.57);
INSERT INTO public.exemplaire VALUES (276, 264, 15, 11, NULL, 1.83);
INSERT INTO public.exemplaire VALUES (327, 315, 26, 13, NULL, NULL);
INSERT INTO public.exemplaire VALUES (282, 270, 10, 12, NULL, 6.10);
INSERT INTO public.exemplaire VALUES (283, 271, 10, 12, NULL, 7.01);
INSERT INTO public.exemplaire VALUES (284, 272, 23, 12, NULL, 6.86);
INSERT INTO public.exemplaire VALUES (288, 276, 23, 12, NULL, 6.86);
INSERT INTO public.exemplaire VALUES (295, 283, 12, 13, NULL, 9.15);
INSERT INTO public.exemplaire VALUES (296, 284, 12, 13, NULL, 11.43);
INSERT INTO public.exemplaire VALUES (297, 285, 39, 14, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (298, 286, 39, 14, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (299, 287, 39, 14, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (300, 288, 39, 14, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (301, 289, 39, 14, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (302, 290, 39, 14, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (303, 291, 39, 14, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (304, 292, 39, 14, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (305, 293, 39, 14, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (306, 294, 39, 14, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (307, 295, 39, 14, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (308, 296, 39, 14, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (380, 368, 46, 6, '2002-02-01', 13.76);
INSERT INTO public.exemplaire VALUES (139, 134, 2, 11, NULL, 1.25);
INSERT INTO public.exemplaire VALUES (381, 369, 23, 12, '2002-02-01', 20.13);
INSERT INTO public.exemplaire VALUES (382, 370, 10, 11, '2001-04-20', 9.00);
INSERT INTO public.exemplaire VALUES (186, 179, 12, 8, NULL, NULL);
INSERT INTO public.exemplaire VALUES (183, 176, 12, 8, NULL, NULL);
INSERT INTO public.exemplaire VALUES (114, 109, 10, 9, NULL, NULL);
INSERT INTO public.exemplaire VALUES (137, 132, 10, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (32, 28, 8, 1, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (33, 29, 10, 1, NULL, 2.74);
INSERT INTO public.exemplaire VALUES (34, 30, 12, 1, NULL, 22.71);
INSERT INTO public.exemplaire VALUES (35, 31, 12, 1, NULL, 24.24);
INSERT INTO public.exemplaire VALUES (38, 34, 2, 1, NULL, 24.09);
INSERT INTO public.exemplaire VALUES (40, 36, 10, 1, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (57, 52, 10, 3, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (56, 51, 12, 3, NULL, 1.98);
INSERT INTO public.exemplaire VALUES (58, 53, 18, 3, NULL, 18.29);
INSERT INTO public.exemplaire VALUES (59, 54, 7, 3, NULL, 0.76);
INSERT INTO public.exemplaire VALUES (60, 55, 12, 3, NULL, 4.57);
INSERT INTO public.exemplaire VALUES (61, 56, 12, 3, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (62, 57, 7, 3, NULL, 1.52);
INSERT INTO public.exemplaire VALUES (63, 58, 7, 3, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (68, 63, 2, 3, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (69, 64, 2, 3, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (70, 65, 2, 3, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (71, 66, 10, 3, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (383, 371, 12, 3, '2001-04-20', 8.50);
INSERT INTO public.exemplaire VALUES (384, 372, 10, 10, '2002-04-20', NULL);
INSERT INTO public.exemplaire VALUES (213, 203, 10, 11, NULL, 2.59);
INSERT INTO public.exemplaire VALUES (385, 373, 12, 3, '2002-11-05', 0.50);
INSERT INTO public.exemplaire VALUES (386, 374, 13, 11, '2002-11-05', 0.50);
INSERT INTO public.exemplaire VALUES (390, 378, 47, 11, '2002-11-05', 0.50);
INSERT INTO public.exemplaire VALUES (389, 377, 10, 11, '2002-11-05', 0.50);
INSERT INTO public.exemplaire VALUES (388, 376, 10, 11, '2002-11-05', 0.50);
INSERT INTO public.exemplaire VALUES (387, 375, 12, 3, '2002-11-05', 0.50);
INSERT INTO public.exemplaire VALUES (391, 379, 10, 10, '2002-11-05', 0.50);
INSERT INTO public.exemplaire VALUES (392, 380, 48, 11, '2002-05-18', 0.50);
INSERT INTO public.exemplaire VALUES (393, 381, 10, 5, '2002-02-06', 0.20);
INSERT INTO public.exemplaire VALUES (394, 382, 10, 11, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (395, 383, 10, 3, '2002-02-06', 0.20);
INSERT INTO public.exemplaire VALUES (396, 384, 20, 15, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (397, 385, 10, 11, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (398, 386, 17, 11, '2002-06-30', 0.50);
INSERT INTO public.exemplaire VALUES (399, 387, 3, 11, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (401, 389, 10, 10, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (227, 217, 31, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (226, 216, 6, 11, NULL, NULL);
INSERT INTO public.exemplaire VALUES (402, 390, 20, 11, '2002-06-02', 0.50);
INSERT INTO public.exemplaire VALUES (403, 391, 8, 11, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (404, 392, 10, 11, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (405, 393, 20, 11, '2002-08-20', 0.50);
INSERT INTO public.exemplaire VALUES (406, 394, 10, 11, '2002-08-20', 0.50);
INSERT INTO public.exemplaire VALUES (407, 395, 10, 11, '2002-08-20', 0.50);
INSERT INTO public.exemplaire VALUES (408, 396, 20, 15, '2002-08-20', 0.50);
INSERT INTO public.exemplaire VALUES (409, 397, 10, 11, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (410, 398, 10, 10, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (411, 399, 15, 8, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (412, 400, 31, 11, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (413, 401, 10, 11, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (414, 402, 6, 11, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (90, 85, 10, 17, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (91, 86, 8, 17, NULL, 6.10);
INSERT INTO public.exemplaire VALUES (344, 333, 10, 17, '2001-10-03', 6.10);
INSERT INTO public.exemplaire VALUES (400, 388, 10, 17, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (92, 87, 10, 17, '1990-01-01', 2.44);
INSERT INTO public.exemplaire VALUES (93, 88, 10, 17, NULL, 2.44);
INSERT INTO public.exemplaire VALUES (94, 89, 10, 17, NULL, 1.98);
INSERT INTO public.exemplaire VALUES (95, 90, 10, 17, NULL, 1.83);
INSERT INTO public.exemplaire VALUES (96, 91, 2, 17, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (416, 404, 1, 4, '2002-10-19', 7.00);
INSERT INTO public.exemplaire VALUES (417, 405, 12, 17, '2000-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (418, 406, 23, 12, '2002-10-19', 19.50);
INSERT INTO public.exemplaire VALUES (419, 407, 40, 17, '2002-02-21', 6.90);
INSERT INTO public.exemplaire VALUES (420, 408, 23, 6, '2002-12-20', 19.50);
INSERT INTO public.exemplaire VALUES (323, 311, 3, 17, '2000-10-07', 3.81);
INSERT INTO public.exemplaire VALUES (324, 312, 3, 17, '2000-10-07', 3.81);
INSERT INTO public.exemplaire VALUES (325, 313, 3, 17, '2000-10-07', 3.81);
INSERT INTO public.exemplaire VALUES (279, 267, 12, 17, NULL, 5.34);
INSERT INTO public.exemplaire VALUES (231, 221, 10, 17, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (355, 343, 10, 17, '2000-04-20', 5.79);
INSERT INTO public.exemplaire VALUES (336, 324, 2, 17, '2000-09-15', 6.10);
INSERT INTO public.exemplaire VALUES (341, 329, 2, 17, '2001-05-01', 4.42);
INSERT INTO public.exemplaire VALUES (356, 344, 2, 17, '2001-07-24', 3.89);
INSERT INTO public.exemplaire VALUES (347, 335, 2, 17, '2001-04-14', 5.79);
INSERT INTO public.exemplaire VALUES (237, 227, 32, 17, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (228, 218, 7, 17, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (112, 107, 22, 18, NULL, 6.86);
INSERT INTO public.exemplaire VALUES (269, 257, 37, 18, NULL, 18.29);
INSERT INTO public.exemplaire VALUES (277, 265, 3, 18, NULL, 3.35);
INSERT INTO public.exemplaire VALUES (278, 266, 7, 18, NULL, NULL);
INSERT INTO public.exemplaire VALUES (248, 237, 12, 18, NULL, 4.57);
INSERT INTO public.exemplaire VALUES (249, 238, 31, 18, NULL, NULL);
INSERT INTO public.exemplaire VALUES (250, 239, 34, 18, NULL, NULL);
INSERT INTO public.exemplaire VALUES (251, 240, 6, 18, NULL, NULL);
INSERT INTO public.exemplaire VALUES (252, 241, 31, 18, NULL, NULL);
INSERT INTO public.exemplaire VALUES (360, 349, 10, 18, '2001-07-15', 6.95);
INSERT INTO public.exemplaire VALUES (421, 409, 6, 17, '2002-10-19', 10.00);
INSERT INTO public.exemplaire VALUES (422, 410, 41, 1, '2003-02-01', 21.00);
INSERT INTO public.exemplaire VALUES (423, 411, 28, 11, '2003-02-01', 0.00);
INSERT INTO public.exemplaire VALUES (97, 92, 2, 17, NULL, NULL);
INSERT INTO public.exemplaire VALUES (98, 93, 2, 17, NULL, NULL);
INSERT INTO public.exemplaire VALUES (424, 412, 13, 18, '2003-02-01', 0.00);
INSERT INTO public.exemplaire VALUES (425, 414, 49, 18, '2003-01-02', 0.00);
INSERT INTO public.exemplaire VALUES (426, 413, 50, 18, '2003-02-01', 0.00);
INSERT INTO public.exemplaire VALUES (428, 416, 2, 18, '2003-02-01', 0.00);
INSERT INTO public.exemplaire VALUES (430, 418, 51, 18, '2002-10-19', 16.77);
INSERT INTO public.exemplaire VALUES (431, 419, 2, 18, '2002-10-19', 21.00);
INSERT INTO public.exemplaire VALUES (432, 420, 2, 18, '2002-10-19', 21.00);
INSERT INTO public.exemplaire VALUES (433, 421, 42, 17, '2002-12-20', 6.60);
INSERT INTO public.exemplaire VALUES (434, 422, 3, 17, '2002-12-20', 0.00);
INSERT INTO public.exemplaire VALUES (435, 423, 15, 11, '2003-03-02', 1.50);
INSERT INTO public.exemplaire VALUES (436, 424, 3, 17, '2002-12-20', 0.00);
INSERT INTO public.exemplaire VALUES (437, 425, 3, 17, '2002-12-20', 0.00);
INSERT INTO public.exemplaire VALUES (438, 426, 3, 17, '2002-12-20', 0.00);
INSERT INTO public.exemplaire VALUES (439, 427, 3, 17, '2002-12-20', 0.00);
INSERT INTO public.exemplaire VALUES (440, 428, 3, 17, '2002-12-20', 0.00);
INSERT INTO public.exemplaire VALUES (441, 429, 3, 17, '2002-12-20', 0.00);
INSERT INTO public.exemplaire VALUES (443, 431, 6, 15, '2002-12-20', 0.00);
INSERT INTO public.exemplaire VALUES (331, 319, 40, 18, '2000-01-10', 0.76);
INSERT INTO public.exemplaire VALUES (442, 430, 52, 18, '2002-12-20', 0.00);
INSERT INTO public.exemplaire VALUES (444, 432, 2, 18, '2003-05-03', 3.00);
INSERT INTO public.exemplaire VALUES (445, 433, 2, 10, '2002-12-20', 0.00);
INSERT INTO public.exemplaire VALUES (446, 434, 8, 10, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (447, 435, 12, 9, '2003-05-20', 23.00);
INSERT INTO public.exemplaire VALUES (138, 133, 7, 18, NULL, NULL);
INSERT INTO public.exemplaire VALUES (427, 415, 7, 18, '2003-02-01', 0.00);
INSERT INTO public.exemplaire VALUES (223, 213, 10, 18, NULL, 7.62);
INSERT INTO public.exemplaire VALUES (448, 436, 2, 1, '2003-05-29', 0.50);
INSERT INTO public.exemplaire VALUES (449, 437, 20, 18, '2003-05-19', 0.50);
INSERT INTO public.exemplaire VALUES (450, 438, 53, 18, '2002-12-20', 0.00);
INSERT INTO public.exemplaire VALUES (451, 439, NULL, 18, '2002-12-20', 0.00);
INSERT INTO public.exemplaire VALUES (452, 440, 54, 18, '2002-12-20', 0.00);
INSERT INTO public.exemplaire VALUES (453, 441, 55, 18, '2002-12-20', 0.00);
INSERT INTO public.exemplaire VALUES (454, 442, 56, 18, '2003-07-24', 8.40);
INSERT INTO public.exemplaire VALUES (455, 443, 2, 18, '2003-08-15', 1.00);
INSERT INTO public.exemplaire VALUES (456, 444, 10, 4, '2003-08-15', 0.50);
INSERT INTO public.exemplaire VALUES (457, 445, 2, 12, '2003-08-15', 5.51);
INSERT INTO public.exemplaire VALUES (458, 446, 2, 17, '2003-08-15', 2.30);
INSERT INTO public.exemplaire VALUES (459, 447, 10, 11, '2003-01-07', 15.00);
INSERT INTO public.exemplaire VALUES (460, 448, 6, 18, '2003-01-07', 15.00);
INSERT INTO public.exemplaire VALUES (461, 449, 2, 18, '2003-08-15', 1.50);
INSERT INTO public.exemplaire VALUES (462, 450, 2, 11, '2003-08-15', 2.36);
INSERT INTO public.exemplaire VALUES (463, 451, 15, 11, '2003-08-15', 2.00);
INSERT INTO public.exemplaire VALUES (464, 452, 6, 18, '2003-08-15', 2.00);
INSERT INTO public.exemplaire VALUES (465, 453, 20, 5, '2003-10-29', 21.00);
INSERT INTO public.exemplaire VALUES (466, 454, 6, 18, '2003-02-11', 0.00);
INSERT INTO public.exemplaire VALUES (467, 455, 6, 18, '2003-02-11', 0.00);
INSERT INTO public.exemplaire VALUES (468, 456, 6, 18, '2003-02-11', 0.00);
INSERT INTO public.exemplaire VALUES (469, 457, 41, 1, '2003-10-25', 21.00);
INSERT INTO public.exemplaire VALUES (470, 458, 1, 1, '2003-01-08', 0.50);
INSERT INTO public.exemplaire VALUES (1, 1, 1, 19, NULL, 1.52);
INSERT INTO public.exemplaire VALUES (3, 3, 3, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (4, 4, 3, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (5, 5, 3, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (2, 2, 2, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (7, 7, 5, 19, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (24, 20, 12, 19, NULL, 1.52);
INSERT INTO public.exemplaire VALUES (21, 17, 1, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (8, 8, 6, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (26, 22, 13, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (25, 21, 6, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (28, 24, 15, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (17, 15, 9, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (10, 10, 7, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (6, 6, 4, 19, NULL, 4.57);
INSERT INTO public.exemplaire VALUES (18, 6, 10, 19, NULL, 1.52);
INSERT INTO public.exemplaire VALUES (11, 11, 7, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (12, 12, 7, 19, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (13, 13, 7, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (14, 14, 8, 19, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (15, 14, 8, 19, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (19, 16, 11, 19, NULL, 0.91);
INSERT INTO public.exemplaire VALUES (20, 16, 11, 19, NULL, 1.52);
INSERT INTO public.exemplaire VALUES (22, 18, 10, 19, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (23, 19, 10, 19, NULL, 2.29);
INSERT INTO public.exemplaire VALUES (27, 23, 14, 19, NULL, 1.52);
INSERT INTO public.exemplaire VALUES (29, 25, 8, 19, NULL, 3.81);
INSERT INTO public.exemplaire VALUES (136, 131, 24, 19, NULL, 3.05);
INSERT INTO public.exemplaire VALUES (368, 356, 12, 19, '2001-08-16', 2.29);
INSERT INTO public.exemplaire VALUES (9, 9, 6, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (16, 9, 6, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (211, 201, 3, 17, NULL, 6.10);
INSERT INTO public.exemplaire VALUES (471, 459, 8, 3, '2003-01-08', 0.50);
INSERT INTO public.exemplaire VALUES (65, 60, 10, 0, NULL, 1.98);
INSERT INTO public.exemplaire VALUES (66, 61, 10, 3, NULL, NULL);
INSERT INTO public.exemplaire VALUES (73, 68, 7, 3, NULL, 0.99);
INSERT INTO public.exemplaire VALUES (75, 70, 10, 3, NULL, 0.00);
INSERT INTO public.exemplaire VALUES (415, 403, 10, 3, '2002-02-06', 0.50);
INSERT INTO public.exemplaire VALUES (429, 417, 8, 19, '2002-10-19', 0.00);
INSERT INTO public.exemplaire VALUES (376, 364, 8, 19, '2001-12-20', 21.19);
INSERT INTO public.exemplaire VALUES (48, 43, 8, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (49, 44, 8, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (50, 45, 8, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (51, 46, 8, 19, NULL, NULL);
INSERT INTO public.exemplaire VALUES (52, 47, 8, 19, '2000-01-07', 5.95);
INSERT INTO public.exemplaire VALUES (53, 48, 8, 19, '2000-01-07', 20.58);
INSERT INTO public.exemplaire VALUES (472, 460, 12, 4, '2003-06-12', 21.57);
INSERT INTO public.exemplaire VALUES (473, 461, 12, 4, '2003-06-12', 23.00);
INSERT INTO public.exemplaire VALUES (474, 462, 3, 19, '2003-12-27', 6.95);
INSERT INTO public.exemplaire VALUES (475, 463, 3, 3, '2003-12-26', 5.7);
INSERT INTO public.exemplaire VALUES (476, 464, 2, 17, '2003-12-31', 2.3);
INSERT INTO public.exemplaire VALUES (477, 465, 2, 11, '2003-12-31', 2.3);
INSERT INTO public.exemplaire VALUES (478, 466, 26, 6, '2004-01-24', NULL);
INSERT INTO public.exemplaire VALUES (479, 185, 10, 11, '2003-12-31', 2.3);
INSERT INTO public.exemplaire VALUES (480, 467, 2, 18, '2003-12-31', 2.3);


--
-- TOC entry 5405 (class 0 OID 27189)
-- Dependencies: 470
-- Data for Name: nationalites; Type: TABLE DATA; Schema: public; Owner: lbrun
--

INSERT INTO public.nationalites VALUES (1, 'Francaise');
INSERT INTO public.nationalites VALUES (2, 'Anglaise');
INSERT INTO public.nationalites VALUES (3, 'Americaine');
INSERT INTO public.nationalites VALUES (4, 'Russe');
INSERT INTO public.nationalites VALUES (5, 'Canadienne');
INSERT INTO public.nationalites VALUES (6, 'suedoise');
INSERT INTO public.nationalites VALUES (7, 'Italienne');
INSERT INTO public.nationalites VALUES (8, 'Argentin');
INSERT INTO public.nationalites VALUES (11, 'Belge');
INSERT INTO public.nationalites VALUES (10, 'Neerlandai');
INSERT INTO public.nationalites VALUES (9, 'Allemande');
INSERT INTO public.nationalites VALUES (12, 'Australien');
INSERT INTO public.nationalites VALUES (13, 'Tcheque');


--
-- TOC entry 5406 (class 0 OID 27196)
-- Dependencies: 472
-- Data for Name: ouvrage; Type: TABLE DATA; Schema: public; Owner: lbrun
--

INSERT INTO public.ouvrage VALUES (1, 'Les anges de l ombre', NULL, 1);
INSERT INTO public.ouvrage VALUES (3, 'Les dramaturges de yan', NULL, 1);
INSERT INTO public.ouvrage VALUES (4, 'Eclipse Totale', NULL, 1);
INSERT INTO public.ouvrage VALUES (5, 'Le creuset du temps', NULL, 1);
INSERT INTO public.ouvrage VALUES (8, 'Le livre d or de la science fiction : John Brunner)', '1979-01-01', 1);
INSERT INTO public.ouvrage VALUES (7, 'Les productions du temps', '1978-01-01', 1);
INSERT INTO public.ouvrage VALUES (10, 'Fiction (Brunner Tiptree, Conner)', '1985-01-01', 1);
INSERT INTO public.ouvrage VALUES (12, 'A perte de temps', '1984-01-01', 1);
INSERT INTO public.ouvrage VALUES (11, 'Les dissidents d azrael', '1985-01-01', 1);
INSERT INTO public.ouvrage VALUES (9, 'Les chimeres de l ombre', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (15, 'Le Jeu de la possession', '1980-01-01', 1);
INSERT INTO public.ouvrage VALUES (6, 'La planete folie', '1977-01-01', 1);
INSERT INTO public.ouvrage VALUES (16, 'La conquete du chaos', '1973-01-01', 1);
INSERT INTO public.ouvrage VALUES (17, 'Alertez la terre', '1985-01-01', 1);
INSERT INTO public.ouvrage VALUES (18, 'Le troupeau Aveugle (1/2)', '1975-01-01', 1);
INSERT INTO public.ouvrage VALUES (19, 'Le troupeau Aveugle (2/2)', '1975-01-01', 1);
INSERT INTO public.ouvrage VALUES (20, 'Le long labeur du temps', '1970-01-01', 1);
INSERT INTO public.ouvrage VALUES (21, 'Noire est la couleur', '1984-01-01', 1);
INSERT INTO public.ouvrage VALUES (22, 'La ville est un echiquier', '1973-01-01', 1);
INSERT INTO public.ouvrage VALUES (2, 'L orbite dechiquetee', NULL, 1);
INSERT INTO public.ouvrage VALUES (24, 'A l ecoute des etoiles', '1979-01-01', 1);
INSERT INTO public.ouvrage VALUES (25, 'Double, DOuble', '1981-01-01', 1);
INSERT INTO public.ouvrage VALUES (26, 'Les Feux de L Eden', '1996-01-01', 1);
INSERT INTO public.ouvrage VALUES (27, 'L Homme nu', '1994-01-01', 1);
INSERT INTO public.ouvrage VALUES (28, 'L Amour, la mort', '1995-01-01', 1);
INSERT INTO public.ouvrage VALUES (29, 'Le champ de Kali', '1989-01-01', 1);
INSERT INTO public.ouvrage VALUES (30, 'Endymion', '1996-01-01', 1);
INSERT INTO public.ouvrage VALUES (31, 'L Eveil d Endymion', '1998-01-01', 1);
INSERT INTO public.ouvrage VALUES (32, 'Children of the night', '1992-01-01', 1);
INSERT INTO public.ouvrage VALUES (35, 'Hyperions', '1991-01-01', 1);
INSERT INTO public.ouvrage VALUES (33, 'Les fils des tenebres', '1994-01-01', 1);
INSERT INTO public.ouvrage VALUES (36, 'Des fleurs pour Algermon', '1972-01-01', 1);
INSERT INTO public.ouvrage VALUES (37, 'Le voyageur imprudent', '1958-01-01', 1);
INSERT INTO public.ouvrage VALUES (40, 'La tempete', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (42, 'La peau de Cesar', '1985-01-01', 1);
INSERT INTO public.ouvrage VALUES (43, 'La revolution des fourmis', '1996-01-01', 1);
INSERT INTO public.ouvrage VALUES (44, 'Les fourmis', '1991-01-01', 1);
INSERT INTO public.ouvrage VALUES (45, 'Le jour des fourmis', '1992-01-01', 1);
INSERT INTO public.ouvrage VALUES (46, 'Les Thanatonautes', '1994-01-01', 1);
INSERT INTO public.ouvrage VALUES (47, 'Le pere de nos peres', '1998-01-01', 1);
INSERT INTO public.ouvrage VALUES (49, 'A la fin de l hiver', '1989-01-01', 1);
INSERT INTO public.ouvrage VALUES (50, 'La reine du printemps', '1990-01-01', 1);
INSERT INTO public.ouvrage VALUES (51, 'Jusqu aux portes de la vie', '1990-01-01', 1);
INSERT INTO public.ouvrage VALUES (52, 'Les ailes de la nuit', '1975-01-01', 1);
INSERT INTO public.ouvrage VALUES (53, 'Le grand silence', '1999-01-01', 1);
INSERT INTO public.ouvrage VALUES (54, 'L homme dans le labyrinthe', '1970-01-01', 1);
INSERT INTO public.ouvrage VALUES (55, 'Les monades urbaines', '1974-01-01', 1);
INSERT INTO public.ouvrage VALUES (56, 'Tom O Bedlam', '1986-01-01', 1);
INSERT INTO public.ouvrage VALUES (57, 'Le livre des cranes', '1975-01-01', 1);
INSERT INTO public.ouvrage VALUES (58, 'L Homme programme', '1976-01-01', 1);
INSERT INTO public.ouvrage VALUES (59, 'Le fils de l homme', '1971-01-01', 1);
INSERT INTO public.ouvrage VALUES (60, 'Cailloux dans le ciel', '1974-01-01', 1);
INSERT INTO public.ouvrage VALUES (62, 'Fondation foudroyee', '1983-01-01', 1);
INSERT INTO public.ouvrage VALUES (63, 'Fondation et empire', '1966-01-01', 1);
INSERT INTO public.ouvrage VALUES (64, 'Seconde Fondation', '1966-01-01', 1);
INSERT INTO public.ouvrage VALUES (65, 'fondation', '1966-01-01', 1);
INSERT INTO public.ouvrage VALUES (66, 'Les robots et l empire (1/2)', '1986-01-01', 1);
INSERT INTO public.ouvrage VALUES (67, 'Les robots et l empire (2/2)', '1986-01-01', 1);
INSERT INTO public.ouvrage VALUES (68, 'Les courants de l espace', '1974-01-01', 1);
INSERT INTO public.ouvrage VALUES (69, 'Les cavernes d acier', '1956-01-01', 1);
INSERT INTO public.ouvrage VALUES (70, 'Tyrann', '1973-01-01', 1);
INSERT INTO public.ouvrage VALUES (72, 'Eternite', '1989-01-01', 1);
INSERT INTO public.ouvrage VALUES (73, 'La reine des Anges', '1993-01-01', 1);
INSERT INTO public.ouvrage VALUES (74, 'Eon', '1989-01-01', 1);
INSERT INTO public.ouvrage VALUES (75, 'Heritage', '1997-01-01', 1);
INSERT INTO public.ouvrage VALUES (77, 'Le monstre sous la mer', '1972-01-01', 1);
INSERT INTO public.ouvrage VALUES (78, 'La ruche d Hellstrom', '1977-01-01', 1);
INSERT INTO public.ouvrage VALUES (80, 'Le preneur d ames', '1981-01-01', 1);
INSERT INTO public.ouvrage VALUES (83, 'Dosadi', '1979-01-01', 1);
INSERT INTO public.ouvrage VALUES (85, 'Createur d univers', '1959-01-01', 1);
INSERT INTO public.ouvrage VALUES (86, 'Le colosse anarchique', '1979-01-01', 1);
INSERT INTO public.ouvrage VALUES (87, 'Le livre de ptath', '1961-01-01', 1);
INSERT INTO public.ouvrage VALUES (88, 'L homme multiplie', '1976-01-01', 1);
INSERT INTO public.ouvrage VALUES (89, 'La machine ultime', '1983-01-01', 1);
INSERT INTO public.ouvrage VALUES (90, 'L''ete indien d''une paire de lunettes', '1980-01-01', 1);
INSERT INTO public.ouvrage VALUES (91, 'la cite du grand juge', '1958-01-01', 1);
INSERT INTO public.ouvrage VALUES (93, 'Le printemps russe (2/2)', '1992-01-01', 1);
INSERT INTO public.ouvrage VALUES (92, 'Le printemps russe (1/2)', '1992-01-01', 1);
INSERT INTO public.ouvrage VALUES (94, 'Les syntheretiques (1/2)', '1993-01-01', 1);
INSERT INTO public.ouvrage VALUES (95, 'Les syntheretiques (2/2)', '1993-01-01', 1);
INSERT INTO public.ouvrage VALUES (98, 'Aucune etoile aussi lointaine', '1998-01-01', 1);
INSERT INTO public.ouvrage VALUES (99, 'F.A.U.S.T.', '1996-01-01', 8);
INSERT INTO public.ouvrage VALUES (100, 'Tonnerre Lointain', '1997-01-01', 8);
INSERT INTO public.ouvrage VALUES (101, 'Les defenseurs', '1996-01-01', 8);
INSERT INTO public.ouvrage VALUES (102, 'Mars la rouge', '1994-01-01', 2);
INSERT INTO public.ouvrage VALUES (103, 'Mars la verte', '1995-01-01', 2);
INSERT INTO public.ouvrage VALUES (104, 'Mars la bleu', '1996-01-01', 2);
INSERT INTO public.ouvrage VALUES (105, 'un vampire ordinaire', '1982-01-01', 10);
INSERT INTO public.ouvrage VALUES (106, 'La nue de l''apocalypse', '1962-01-01', 2);
INSERT INTO public.ouvrage VALUES (61, 'Face aux feux du soleil', '1970-01-01', 1);
INSERT INTO public.ouvrage VALUES (71, 'L aube de Fondation', '1993-01-01', 1);
INSERT INTO public.ouvrage VALUES (84, 'Dune/le messi de dune', '1972-01-01', 1);
INSERT INTO public.ouvrage VALUES (79, 'La mort blanche', '1983-01-01', 8);
INSERT INTO public.ouvrage VALUES (39, 'Les chemins de Katmandou', '1969-01-01', 11);
INSERT INTO public.ouvrage VALUES (41, 'La faim du Tigre', '1966-01-01', 12);
INSERT INTO public.ouvrage VALUES (107, 'Introduction a la semantique generale de Korzybski', '1973-01-01', 12);
INSERT INTO public.ouvrage VALUES (108, '2061: Odyssee trois', '1989-01-01', 1);
INSERT INTO public.ouvrage VALUES (109, '3001: L''odyssee finale', '1997-01-01', 1);
INSERT INTO public.ouvrage VALUES (110, 'RAMA II', '1992-01-01', 1);
INSERT INTO public.ouvrage VALUES (111, 'Lumiere cendree', '1975-01-01', 1);
INSERT INTO public.ouvrage VALUES (112, 'Les enfants d''Icare', '1978-01-01', 1);
INSERT INTO public.ouvrage VALUES (113, 'La momie', '1992-01-01', 7);
INSERT INTO public.ouvrage VALUES (114, 'Memnoch le demon', '1997-01-01', 7);
INSERT INTO public.ouvrage VALUES (115, 'Entretien avec un vampire', '1978-01-01', 7);
INSERT INTO public.ouvrage VALUES (116, 'Lestat le vampire', '1988-01-01', 7);
INSERT INTO public.ouvrage VALUES (117, 'Le voleur de corps', '1994-01-01', 7);
INSERT INTO public.ouvrage VALUES (118, 'La reine des Damnes', '1990-01-01', 7);
INSERT INTO public.ouvrage VALUES (119, 'Le lien malefique', '1992-01-01', 7);
INSERT INTO public.ouvrage VALUES (120, 'Un paysage du temps (1/2)', '1980-01-01', 1);
INSERT INTO public.ouvrage VALUES (121, 'Un paysage du temps (2/2)', '1981-01-01', 1);
INSERT INTO public.ouvrage VALUES (122, 'a travers la mer des soleils (1/2)', '1985-01-01', 1);
INSERT INTO public.ouvrage VALUES (123, 'a travers la mer des soleils (2/2)', '1985-01-01', 1);
INSERT INTO public.ouvrage VALUES (124, 'Les guerriers du silence', '1993-01-01', 1);
INSERT INTO public.ouvrage VALUES (125, 'Terra Mater', '1994-01-01', 1);
INSERT INTO public.ouvrage VALUES (126, 'La citadelle hyponeros', '1995-01-01', 1);
INSERT INTO public.ouvrage VALUES (127, 'WANG Les aigles d''Orient', '1997-01-01', 1);
INSERT INTO public.ouvrage VALUES (128, 'WANG Les portes d''Occident', '1996-01-01', 1);
INSERT INTO public.ouvrage VALUES (130, 'Abzalon', '1998-01-01', 1);
INSERT INTO public.ouvrage VALUES (129, 'Les fables de l''Humpur', '1999-01-01', 4);
INSERT INTO public.ouvrage VALUES (132, 'Dragon', '1969-01-01', 4);
INSERT INTO public.ouvrage VALUES (133, 'L''anneau-Monde', '1973-01-01', 1);
INSERT INTO public.ouvrage VALUES (134, 'Solaris', '1966-01-01', 1);
INSERT INTO public.ouvrage VALUES (135, 'L''opera de l''espace', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (136, 'Port Eternite', '1985-01-01', 1);
INSERT INTO public.ouvrage VALUES (137, 'Les etalombres', '1997-01-01', 1);
INSERT INTO public.ouvrage VALUES (138, 'Les seigneurs de l''Hydre', '1983-01-01', 1);
INSERT INTO public.ouvrage VALUES (139, 'L''epope de chanur', '1986-01-01', 3);
INSERT INTO public.ouvrage VALUES (140, 'Chanur', '1983-01-01', 3);
INSERT INTO public.ouvrage VALUES (141, 'Cyteen (1/2)', '1990-01-01', 1);
INSERT INTO public.ouvrage VALUES (142, 'Cyteen (2/2)', '1990-01-01', 1);
INSERT INTO public.ouvrage VALUES (143, 'Le retour de Chanur', '1989-01-01', 3);
INSERT INTO public.ouvrage VALUES (144, 'Les chants du neant', '1996-01-01', 1);
INSERT INTO public.ouvrage VALUES (145, 'Forteresse des etoiles', '1992-01-01', 1);
INSERT INTO public.ouvrage VALUES (146, 'Les legions de l''enfer', '1990-01-01', 4);
INSERT INTO public.ouvrage VALUES (147, 'L''oeuf du coucou', '1988-01-01', 3);
INSERT INTO public.ouvrage VALUES (148, 'Hestia', '1981-01-01', 3);
INSERT INTO public.ouvrage VALUES (149, 'Chasseur de mondes', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (150, 'Les adieux du soleil', '1982-01-01', 4);
INSERT INTO public.ouvrage VALUES (151, 'Jusqu''au coeur du soleil', '1995-01-01', 1);
INSERT INTO public.ouvrage VALUES (152, 'Maree stellaire', '1986-01-01', 1);
INSERT INTO public.ouvrage VALUES (153, 'Redemption 5 : Le grand defi', '1999-01-01', 1);
INSERT INTO public.ouvrage VALUES (154, 'Redemption 1 : Le monde de l''exil', '1997-01-01', 1);
INSERT INTO public.ouvrage VALUES (155, 'Redemption 2 : Le monde de l''oubli', '1997-01-01', 1);
INSERT INTO public.ouvrage VALUES (156, 'Redemption 3 : Le chemin des bannis', '1998-01-01', 1);
INSERT INTO public.ouvrage VALUES (157, 'Redemption 4 : Les rives de l''infini', '1998-01-01', 1);
INSERT INTO public.ouvrage VALUES (158, 'Terre 1 : La chose au coeur du monde', '1992-01-01', 1);
INSERT INTO public.ouvrage VALUES (159, 'Terre 2 : Message de l''univers', '1992-01-01', 1);
INSERT INTO public.ouvrage VALUES (160, 'Elevation 1', '1989-01-01', 1);
INSERT INTO public.ouvrage VALUES (161, 'Elevation 2', '1989-01-01', 1);
INSERT INTO public.ouvrage VALUES (162, 'La montagne est jeune(1/2)', '1959-01-01', 13);
INSERT INTO public.ouvrage VALUES (163, 'La montagne est jeune (2/2)', '1959-01-01', 13);
INSERT INTO public.ouvrage VALUES (164, 'Un ete sans oiseaux', '1968-01-01', 13);
INSERT INTO public.ouvrage VALUES (165, 'Amour d''hiver', '1962-01-01', 13);
INSERT INTO public.ouvrage VALUES (166, 'L''arbre blesse', '1966-01-01', 13);
INSERT INTO public.ouvrage VALUES (167, 'Ton ombre est la mienne', '1963-01-01', 13);
INSERT INTO public.ouvrage VALUES (168, 'Tous a Zanzibar', '1972-01-01', 1);
INSERT INTO public.ouvrage VALUES (169, 'Dune', '1970-01-01', 1);
INSERT INTO public.ouvrage VALUES (81, 'L''etoile et le fouet', '1973-01-01', 1);
INSERT INTO public.ouvrage VALUES (82, 'L''empreur dieu de dune', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (76, 'Et l''homme crea un dieu', '1979-01-01', 1);
INSERT INTO public.ouvrage VALUES (170, 'Le messie de dune', '1972-01-01', 1);
INSERT INTO public.ouvrage VALUES (171, 'Les humanoides', '1971-01-01', 1);
INSERT INTO public.ouvrage VALUES (172, 'Jack Barron et l''eternite', '1971-01-01', 1);
INSERT INTO public.ouvrage VALUES (173, 'Le meilleur des mondes', '1976-01-01', 1);
INSERT INTO public.ouvrage VALUES (174, 'L''image de pierre', '1961-01-01', 1);
INSERT INTO public.ouvrage VALUES (176, 'Le temps incertain', '1973-01-01', 1);
INSERT INTO public.ouvrage VALUES (177, 'Les seigneurs de la guerre', '1971-01-01', 1);
INSERT INTO public.ouvrage VALUES (178, 'Question de poids', '1970-01-01', 2);
INSERT INTO public.ouvrage VALUES (179, 'En terre etrangere', '1970-01-01', 1);
INSERT INTO public.ouvrage VALUES (180, 'Les dieux verts', '1961-01-01', 1);
INSERT INTO public.ouvrage VALUES (181, 'L''invention de Morel', '1973-01-01', 1);
INSERT INTO public.ouvrage VALUES (182, 'Voici L''homme', '1971-01-01', 1);
INSERT INTO public.ouvrage VALUES (183, 'La vallee magique', '1974-01-01', 1);
INSERT INTO public.ouvrage VALUES (185, 'La guerre eternelle', '1974-01-01', 1);
INSERT INTO public.ouvrage VALUES (186, 'Arago', '1983-01-01', 1);
INSERT INTO public.ouvrage VALUES (187, 'neutron', '1981-01-01', 1);
INSERT INTO public.ouvrage VALUES (188, 'La trace des reves', '1995-01-01', 1);
INSERT INTO public.ouvrage VALUES (189, 'Le temps des grandes chasses', '1973-01-01', 1);
INSERT INTO public.ouvrage VALUES (190, 'Projet Jason', '1990-01-01', 3);
INSERT INTO public.ouvrage VALUES (191, 'Les dames du lac', '1986-01-01', 3);
INSERT INTO public.ouvrage VALUES (192, 'Les brumes d''Avalon', '1987-01-01', 3);
INSERT INTO public.ouvrage VALUES (193, 'Le bienheureux', '1994-01-01', 1);
INSERT INTO public.ouvrage VALUES (194, 'le temps n''a pas d''odeur', '1963-01-01', 1);
INSERT INTO public.ouvrage VALUES (38, 'Le diable l emporte', '1959-01-01', 1);
INSERT INTO public.ouvrage VALUES (34, 'L''echiquier du mal', '1992-01-01', 1);
INSERT INTO public.ouvrage VALUES (48, 'L''empire des anges', '2000-01-01', 1);
INSERT INTO public.ouvrage VALUES (13, 'L''empire interstellaire (2/2)', '1984-01-01', 1);
INSERT INTO public.ouvrage VALUES (23, 'L''envers du temps', '1977-01-01', 1);
INSERT INTO public.ouvrage VALUES (14, 'L''Ere des miracles', '1977-01-01', 1);
INSERT INTO public.ouvrage VALUES (195, 'L''homme qui retrecit', '1971-01-01', 4);
INSERT INTO public.ouvrage VALUES (197, 'Demain les loups', '1966-01-01', 1);
INSERT INTO public.ouvrage VALUES (198, 'Biofeedback', '1979-01-01', 1);
INSERT INTO public.ouvrage VALUES (199, 'Le marteau de verre', '1986-01-01', 1);
INSERT INTO public.ouvrage VALUES (200, 'space 2063', '1997-01-01', 1);
INSERT INTO public.ouvrage VALUES (201, 'Histoires de l''an 2000', '1985-01-01', 1);
INSERT INTO public.ouvrage VALUES (202, 'les plus qu''humains', '1956-01-01', 4);
INSERT INTO public.ouvrage VALUES (203, 'Un monde de femmes', '1990-01-01', 3);
INSERT INTO public.ouvrage VALUES (204, 'Barrayar', '1993-01-01', 3);
INSERT INTO public.ouvrage VALUES (205, 'Horizon vertical', '1990-01-01', 1);
INSERT INTO public.ouvrage VALUES (206, 'Le monde aveugle', '1963-01-01', 1);
INSERT INTO public.ouvrage VALUES (207, 'L''homme infini', '1975-01-01', 1);
INSERT INTO public.ouvrage VALUES (208, 'LA relativite', '1956-01-01', 12);
INSERT INTO public.ouvrage VALUES (209, 'Le Fleuve de l''eternite le monde du fleuve', '1979-01-01', 1);
INSERT INTO public.ouvrage VALUES (210, 'Ose', '1970-01-01', 3);
INSERT INTO public.ouvrage VALUES (211, 'Blade runner', '1976-01-01', 1);
INSERT INTO public.ouvrage VALUES (212, 'Pour quelle guerre...', '1965-01-01', 1);
INSERT INTO public.ouvrage VALUES (213, 'Le grand livre', '1994-01-01', 1);
INSERT INTO public.ouvrage VALUES (214, 'Maudit manege', '1986-01-01', 13);
INSERT INTO public.ouvrage VALUES (215, 'L''homme qui voulut etre roi', '1901-01-01', 13);
INSERT INTO public.ouvrage VALUES (216, 'Le dernier bucher', '1995-01-01', 14);
INSERT INTO public.ouvrage VALUES (217, 'L''oeuvre au noir', '1968-01-01', 13);
INSERT INTO public.ouvrage VALUES (218, 'L''univers est a nous', '1976-01-01', 1);
INSERT INTO public.ouvrage VALUES (219, 'Les survenants', '1996-01-01', 4);
INSERT INTO public.ouvrage VALUES (220, 'La fin du reve', '1976-01-01', 1);
INSERT INTO public.ouvrage VALUES (221, 'Pygmalion 2113', '1959-01-01', 1);
INSERT INTO public.ouvrage VALUES (222, 'hier, les oiseaux', '1977-01-01', 1);
INSERT INTO public.ouvrage VALUES (223, 'Le rivage des femmes', '1989-01-01', 1);
INSERT INTO public.ouvrage VALUES (224, 'La mort dela terre', '1958-01-01', 1);
INSERT INTO public.ouvrage VALUES (225, 'Contact', '1986-01-01', 1);
INSERT INTO public.ouvrage VALUES (226, 'La rose', '1975-01-01', 1);
INSERT INTO public.ouvrage VALUES (227, 'Les enfants de Noe', '1987-01-01', 1);
INSERT INTO public.ouvrage VALUES (184, 'Le tsadik aux sept miracles', '1973-01-01', 1);
INSERT INTO public.ouvrage VALUES (228, 'Le desert des tartares', '1949-01-01', 13);
INSERT INTO public.ouvrage VALUES (229, 'le K', '1967-01-01', 15);
INSERT INTO public.ouvrage VALUES (230, 'Nouvelles de Jean Boccace', NULL, 15);
INSERT INTO public.ouvrage VALUES (231, 'Fahrenheit 451', '1955-01-01', 1);
INSERT INTO public.ouvrage VALUES (232, 'Le champion des hommes nus', '1984-01-01', 1);
INSERT INTO public.ouvrage VALUES (233, 'le jour des voies', '1977-01-01', 1);
INSERT INTO public.ouvrage VALUES (234, 'Parabellum tango', '1980-01-01', 1);
INSERT INTO public.ouvrage VALUES (235, 'Six personnages en quete d''auteur La volupte de l''honneur', '1977-01-01', 16);
INSERT INTO public.ouvrage VALUES (236, 'Les predateurs enjolives', '1976-01-01', 1);
INSERT INTO public.ouvrage VALUES (237, 'Le ciel est mort', '1992-01-01', 15);
INSERT INTO public.ouvrage VALUES (238, 'Les cathares Pauvres du christ ou Apotres de Satan', '1997-01-01', 14);
INSERT INTO public.ouvrage VALUES (239, 'Le chatqui sniffait de la colle', '1992-01-01', 13);
INSERT INTO public.ouvrage VALUES (240, 'La derniere marche', '1996-01-01', 13);
INSERT INTO public.ouvrage VALUES (241, 'Montaillou, village occitan', '1982-01-01', 14);
INSERT INTO public.ouvrage VALUES (242, 'Dans le torrent des siecles', '1973-01-01', 1);
INSERT INTO public.ouvrage VALUES (244, 'Mir', '2000-01-01', 1);
INSERT INTO public.ouvrage VALUES (243, 'Mange ma mort', '1983-01-01', 15);
INSERT INTO public.ouvrage VALUES (245, 'Le vol de la libellule', '1986-01-01', 2);
INSERT INTO public.ouvrage VALUES (246, 'Constellations Premiere epoque', '1990-01-01', 1);
INSERT INTO public.ouvrage VALUES (247, 'Constellations deuxieme epoque', '1990-01-01', 1);
INSERT INTO public.ouvrage VALUES (248, 'Heil Hibbler !', '1984-01-01', 1);
INSERT INTO public.ouvrage VALUES (250, 'Malpertuis', '1943-01-01', 7);
INSERT INTO public.ouvrage VALUES (251, 'La vie sur Mars', '1999-01-01', 17);
INSERT INTO public.ouvrage VALUES (252, 'A la conquete de Mars', '2000-01-01', 17);
INSERT INTO public.ouvrage VALUES (196, 'Je suis une legende', '1955-01-01', 9);
INSERT INTO public.ouvrage VALUES (253, 'Le vagabond', '1969-01-01', 1);
INSERT INTO public.ouvrage VALUES (249, 'La servante ecarlate', '1987-01-01', 1);
INSERT INTO public.ouvrage VALUES (254, 'Etoiles, garde-a-vous !', '1974-01-01', 1);
INSERT INTO public.ouvrage VALUES (255, 'Le village', '1978-01-01', 1);
INSERT INTO public.ouvrage VALUES (256, 'Le maitre du haut chateau', '1970-01-01', 1);
INSERT INTO public.ouvrage VALUES (257, 'Sommes-nous seuls dans l''univers ?', '2000-01-01', 17);
INSERT INTO public.ouvrage VALUES (258, 'La locomotive a vapeur celeste', '1985-01-01', 3);
INSERT INTO public.ouvrage VALUES (259, 'Les fils du vent', '1994-01-01', 3);
INSERT INTO public.ouvrage VALUES (260, 'Stalker', '1981-01-01', 1);
INSERT INTO public.ouvrage VALUES (261, 'Les fleurs du vide', '1988-01-01', 6);
INSERT INTO public.ouvrage VALUES (262, 'Les faiseurs d''orages', '1984-01-01', 1);
INSERT INTO public.ouvrage VALUES (263, 'La grande Porte', '1978-01-01', 1);
INSERT INTO public.ouvrage VALUES (264, 'Les planetes meurent aussi', '1974-01-01', 1);
INSERT INTO public.ouvrage VALUES (265, 'Humanite et demie', '1975-01-01', 1);
INSERT INTO public.ouvrage VALUES (266, 'Les cavernes du sommeil', '1985-01-01', 1);
INSERT INTO public.ouvrage VALUES (267, 'La toile entre les mondes', '1984-01-01', 2);
INSERT INTO public.ouvrage VALUES (268, 'Un parfum dans la tourmente', '1994-01-01', 13);
INSERT INTO public.ouvrage VALUES (269, 'La strategie ender', '1994-01-01', 1);
INSERT INTO public.ouvrage VALUES (270, 'La voix des morts', '1995-01-01', 1);
INSERT INTO public.ouvrage VALUES (271, 'Xenocide', '1993-01-01', 1);
INSERT INTO public.ouvrage VALUES (272, 'Terre des origines l''exode', '1996-01-01', 1);
INSERT INTO public.ouvrage VALUES (273, 'Terre des origines Basilica', '1995-01-01', 1);
INSERT INTO public.ouvrage VALUES (274, 'Terre des origines Le general', '1995-01-01', 1);
INSERT INTO public.ouvrage VALUES (275, 'Terre des origines Les Terriens', '1997-01-01', 1);
INSERT INTO public.ouvrage VALUES (276, 'Terre des Origines Le retour', '1996-01-01', 1);
INSERT INTO public.ouvrage VALUES (277, 'La geste Valois Jason Valois', '1994-01-01', 1);
INSERT INTO public.ouvrage VALUES (278, 'Soleil Mort Kesrith', '1983-01-01', 1);
INSERT INTO public.ouvrage VALUES (279, 'Soleil Mort Kutath', '1983-01-01', 1);
INSERT INTO public.ouvrage VALUES (280, 'Destination Cauchemar', '1984-01-01', 1);
INSERT INTO public.ouvrage VALUES (281, 'Les joueurs de Zan', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (282, 'Les seigneurs du navire-etoile/Hors de la bouche du dragon', '1980-01-01', 1);
INSERT INTO public.ouvrage VALUES (283, 'La voie terrestre', '1994-01-01', 1);
INSERT INTO public.ouvrage VALUES (284, 'Le probleme de Turing', '1994-01-01', 1);
INSERT INTO public.ouvrage VALUES (285, 'La saga des rouges (1/2)', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (286, 'La saga des rouges (2/2)', '1984-01-01', 1);
INSERT INTO public.ouvrage VALUES (287, 'Au temps pour l''espace', '1984-01-01', 1);
INSERT INTO public.ouvrage VALUES (288, 'L''arc en ciel lointain', '1984-01-01', 1);
INSERT INTO public.ouvrage VALUES (289, 'Le scarabe dans la fourmiliere', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (290, 'Le passager de la nuit', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (291, 'La troisieme race', '1960-01-01', 1);
INSERT INTO public.ouvrage VALUES (175, 'Barriere Mentale', '1984-01-01', 1);
INSERT INTO public.ouvrage VALUES (292, 'Le dernier champs des sirenes (1/2)', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (293, 'Le dernier champs des sirenes (2/2)', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (294, 'La compagnie des glaces', '1980-01-01', 1);
INSERT INTO public.ouvrage VALUES (295, 'Le peuple des glaces', '1981-01-01', 1);
INSERT INTO public.ouvrage VALUES (296, 'Le sanctuaire des glaces', '1981-01-01', 1);
INSERT INTO public.ouvrage VALUES (297, 'Les petites femmes vertes', '1981-01-01', 1);
INSERT INTO public.ouvrage VALUES (298, 'Dis qu''a tu fais toi que voila', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (299, 'La planete du jugement Goer de la terre', '1981-01-01', 1);
INSERT INTO public.ouvrage VALUES (300, 'Mais si les papillons trichent', '1974-01-01', 1);
INSERT INTO public.ouvrage VALUES (301, 'Arbitrage martien', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (302, 'Nausicaa', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (303, 'Masques de clown', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (304, 'blue', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (305, 'L''empreur d''eridan', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (306, 'Les survivants de l''au-dela', '1982-01-01', 4);
INSERT INTO public.ouvrage VALUES (307, 'Le mecanicosmos', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (308, 'Les voix de l''univers', '1956-01-01', 1);
INSERT INTO public.ouvrage VALUES (309, 'Le destin de Swa', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (310, 'Le livre de Swa', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (312, 'Helliconia, l''ete', '1986-01-01', 1);
INSERT INTO public.ouvrage VALUES (313, 'L''hiver d''Helliconia', '1988-01-01', 1);
INSERT INTO public.ouvrage VALUES (314, 'La captive du temps perdu', '1996-01-01', 1);
INSERT INTO public.ouvrage VALUES (315, 'H.M.S. Ulysses', '1971-01-01', 13);
INSERT INTO public.ouvrage VALUES (311, 'Le printemps d''Helliconia', '1984-01-01', 1);
INSERT INTO public.ouvrage VALUES (316, 'Le facteur', '1987-01-01', 1);
INSERT INTO public.ouvrage VALUES (317, 'Le hors le monde', '1973-01-01', 1);
INSERT INTO public.ouvrage VALUES (318, 'Rendez vous avec Rama', '1975-01-01', 1);
INSERT INTO public.ouvrage VALUES (319, 'Mort au champ d''etoiles', '1970-01-01', 1);
INSERT INTO public.ouvrage VALUES (320, 'La vengeance de Chanur', '1987-01-01', 3);
INSERT INTO public.ouvrage VALUES (321, 'La cite et les astres', '1960-01-01', 1);
INSERT INTO public.ouvrage VALUES (322, 'Les hommes frenetiques', '1925-01-01', 1);
INSERT INTO public.ouvrage VALUES (323, 'Les Martiens', '2000-01-01', 2);
INSERT INTO public.ouvrage VALUES (324, 'Le guide Galactique', '1979-01-01', 1);
INSERT INTO public.ouvrage VALUES (325, 'Les mailles du reseau/1', '1990-01-01', 6);
INSERT INTO public.ouvrage VALUES (326, 'Les mailles du reseau/2', '1990-01-01', 6);
INSERT INTO public.ouvrage VALUES (327, 'Orcheron', '2000-01-01', 1);
INSERT INTO public.ouvrage VALUES (328, 'Lumiere des jours enfuis', '2000-01-01', 1);
INSERT INTO public.ouvrage VALUES (329, 'Le Dernier Restaurant avant la fin du monde', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (330, 'La maison enragee', '1999-01-01', 1);
INSERT INTO public.ouvrage VALUES (331, 'Destination 3001', '2000-01-01', 1);
INSERT INTO public.ouvrage VALUES (332, 'Le rivage oublie', '1986-01-01', 1);
INSERT INTO public.ouvrage VALUES (333, 'A la poursuite des Slans', '1954-01-01', 1);
INSERT INTO public.ouvrage VALUES (334, 'Les jardins de RAMA', '1994-01-01', 1);
INSERT INTO public.ouvrage VALUES (336, 'Cybione', '1992-01-01', 1);
INSERT INTO public.ouvrage VALUES (335, 'Persistance de la vision', '1979-01-01', 15);
INSERT INTO public.ouvrage VALUES (340, 'Les derniers hommes 4 (Les chemins du secret)', '2000-01-01', 1);
INSERT INTO public.ouvrage VALUES (339, 'Les derniers hommes 3 (Les legions de l Apocalypse)', '2000-01-01', 1);
INSERT INTO public.ouvrage VALUES (338, 'Les derniers hommes 2 (Le cinquieme ange)', '2000-01-01', 1);
INSERT INTO public.ouvrage VALUES (337, 'Les derniers hommes 1 (Le peuble de l eau)', '2000-01-01', 1);
INSERT INTO public.ouvrage VALUES (341, 'Les derniers hommes 5 (Les douze tribus)', '2000-01-01', 1);
INSERT INTO public.ouvrage VALUES (342, 'Les derniers hommes 6 (Le dernier jugement)', '2000-01-01', 1);
INSERT INTO public.ouvrage VALUES (131, 'satelite N 10', '1962-01-07', 15);
INSERT INTO public.ouvrage VALUES (343, 'Feerie', '1999-01-01', 1);
INSERT INTO public.ouvrage VALUES (344, 'Salut, et encore merci pour le poisson', '1994-01-01', 1);
INSERT INTO public.ouvrage VALUES (345, 'Destination vide', '1981-01-01', 1);
INSERT INTO public.ouvrage VALUES (347, '10 sur l echelle de Richter', '1999-01-01', 1);
INSERT INTO public.ouvrage VALUES (348, 'La barriere Santaroga', '1979-01-01', 1);
INSERT INTO public.ouvrage VALUES (349, 'La lumiere des astres', '2000-01-01', 1);
INSERT INTO public.ouvrage VALUES (350, 'Le maitre du passe', '1972-01-01', 1);
INSERT INTO public.ouvrage VALUES (351, 'La religion cathare', '1997-01-01', 12);
INSERT INTO public.ouvrage VALUES (346, 'La jeune fille et les clones', '1997-01-01', 1);
INSERT INTO public.ouvrage VALUES (353, 'Terre, planete imperiale', '1977-01-01', 1);
INSERT INTO public.ouvrage VALUES (354, 'Mona Lisa s eclate', '1990-01-01', 6);
INSERT INTO public.ouvrage VALUES (96, 'Neuromancien', '1985-01-01', 6);
INSERT INTO public.ouvrage VALUES (97, 'Idoru', '1998-01-01', 6);
INSERT INTO public.ouvrage VALUES (355, 'La nuit de la lumiere', '1978-01-01', 1);
INSERT INTO public.ouvrage VALUES (352, 'Les amants etrangers', '1968-01-01', 1);
INSERT INTO public.ouvrage VALUES (368, 'L evangile du serpent', '2001-01-01', 13);
INSERT INTO public.ouvrage VALUES (356, 'A l ouest du temps', '1978-01-01', 1);
INSERT INTO public.ouvrage VALUES (357, 'Mars', '2001-01-01', 2);
INSERT INTO public.ouvrage VALUES (358, 'Un animal doue de Raison', '1967-01-01', 8);
INSERT INTO public.ouvrage VALUES (359, 'Malevil', '1972-01-01', 8);
INSERT INTO public.ouvrage VALUES (360, 'La mere des tempetes', '1994-01-01', 8);
INSERT INTO public.ouvrage VALUES (361, 'L envol de Mars', '1995-01-01', 1);
INSERT INTO public.ouvrage VALUES (362, 'Le styx coule a l envers', '1997-01-01', 15);
INSERT INTO public.ouvrage VALUES (363, 'Passerelles pour l infini', '1999-01-01', 1);
INSERT INTO public.ouvrage VALUES (364, 'L ultime secret', '2001-01-01', 1);
INSERT INTO public.ouvrage VALUES (365, 'Demain L allemagne', '1978-01-01', 15);
INSERT INTO public.ouvrage VALUES (366, 'Galaxies numero 21', '2001-01-06', 15);
INSERT INTO public.ouvrage VALUES (367, 'La strategie de l ombre', '2001-01-01', 1);
INSERT INTO public.ouvrage VALUES (369, 'Enchantement', '2000-01-01', 3);
INSERT INTO public.ouvrage VALUES (370, 'De bons Presages', '1995-01-01', 3);
INSERT INTO public.ouvrage VALUES (371, 'Le chateau de lord Valentin', '1980-01-01', 3);
INSERT INTO public.ouvrage VALUES (372, 'Cristal qui songe', '1950-01-01', 4);
INSERT INTO public.ouvrage VALUES (373, 'L oreille Interne', '1975-01-01', 1);
INSERT INTO public.ouvrage VALUES (374, 'Homme plus', '1977-01-01', 1);
INSERT INTO public.ouvrage VALUES (375, 'Revivre encore', '1984-01-01', 1);
INSERT INTO public.ouvrage VALUES (376, 'Un bonheur insoutenable', '1971-01-01', 1);
INSERT INTO public.ouvrage VALUES (377, 'Les femmes de Stepford', '1974-01-01', 1);
INSERT INTO public.ouvrage VALUES (378, 'La nuit des enfants rois', '1981-01-01', 4);
INSERT INTO public.ouvrage VALUES (379, 'L Univers a l envers', '1968-01-01', 1);
INSERT INTO public.ouvrage VALUES (380, 'La ferme des animaux', '1947-01-01', 12);
INSERT INTO public.ouvrage VALUES (381, '2001 L odyssee de l espace', '1968-01-01', 1);
INSERT INTO public.ouvrage VALUES (382, 'La machine fantome', '1985-01-01', 15);
INSERT INTO public.ouvrage VALUES (383, 'Les deportes du cambrien', '1978-01-01', 1);
INSERT INTO public.ouvrage VALUES (384, 'Fuite dans l inconnu', '1954-01-01', 1);
INSERT INTO public.ouvrage VALUES (385, 'Demain les chiens', '1953-01-01', 1);
INSERT INTO public.ouvrage VALUES (386, 'La guerre des mondes', '1950-01-01', 1);
INSERT INTO public.ouvrage VALUES (387, 'Le pull over Rouge', '1978-01-01', 12);
INSERT INTO public.ouvrage VALUES (388, 'Les monstres', '1974-01-01', 15);
INSERT INTO public.ouvrage VALUES (389, 'Loterie Solaire', '1968-01-01', 1);
INSERT INTO public.ouvrage VALUES (390, 'La memoire de l archipel', '1980-01-01', 1);
INSERT INTO public.ouvrage VALUES (391, 'Les etoiles sirenes', '1973-01-01', 1);
INSERT INTO public.ouvrage VALUES (392, 'Dangereuses visions I', '1975-01-01', 15);
INSERT INTO public.ouvrage VALUES (393, 'Le mur de la lumiere', '1962-01-01', 1);
INSERT INTO public.ouvrage VALUES (394, 'Le ressac de l espace', '1975-01-01', 1);
INSERT INTO public.ouvrage VALUES (395, 'Vie et moeurs des abeilles', '1955-01-01', 18);
INSERT INTO public.ouvrage VALUES (396, 'Frontiere du vide', '1953-01-01', 1);
INSERT INTO public.ouvrage VALUES (397, 'Dangereuses visions II', '1976-01-01', 15);
INSERT INTO public.ouvrage VALUES (398, 'chauchemar...cauchemar', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (399, 'La ville sous globe', '1952-01-01', 1);
INSERT INTO public.ouvrage VALUES (400, '1984', '1950-01-01', 8);
INSERT INTO public.ouvrage VALUES (401, 'La patrouille du temps', '1960-01-01', 1);
INSERT INTO public.ouvrage VALUES (402, 'L etoile sauvage', '1980-01-01', 1);
INSERT INTO public.ouvrage VALUES (403, 'Un defile de robots', '1967-01-01', 1);
INSERT INTO public.ouvrage VALUES (404, 'Fondation et chaos', '1999-01-01', 1);
INSERT INTO public.ouvrage VALUES (405, 'L Orange Mecanique', '1972-01-01', 8);
INSERT INTO public.ouvrage VALUES (406, 'L ombre de l Hegemon', '2002-01-01', 1);
INSERT INTO public.ouvrage VALUES (407, 'Le secret des enfants heureux', '2002-01-01', 12);
INSERT INTO public.ouvrage VALUES (408, 'Griots celestes (qui vient du bruit)', '2002-01-01', 1);
INSERT INTO public.ouvrage VALUES (409, 'Critique de la science Fiction', '2002-01-01', 12);
INSERT INTO public.ouvrage VALUES (410, 'L Epee de Darwin', '2002-01-01', 7);
INSERT INTO public.ouvrage VALUES (411, 'La memoire double', '1985-01-01', 1);
INSERT INTO public.ouvrage VALUES (412, 'L enchassement', '1974-01-01', 1);
INSERT INTO public.ouvrage VALUES (413, 'Reproduction interdite', '1989-01-01', 1);
INSERT INTO public.ouvrage VALUES (414, 'L agonie de la lumiere', '1977-01-01', 1);
INSERT INTO public.ouvrage VALUES (415, 'Le monde des Pravvs', '1974-01-01', 1);
INSERT INTO public.ouvrage VALUES (416, 'Vue en coupe d une ville malade', '1980-01-01', 15);
INSERT INTO public.ouvrage VALUES (417, 'L arbre des possibles', '2002-01-01', 15);
INSERT INTO public.ouvrage VALUES (418, 'Le reveil d Ymir', '2001-01-01', 1);
INSERT INTO public.ouvrage VALUES (419, 'Ventus (1/2)', '2002-01-01', 1);
INSERT INTO public.ouvrage VALUES (420, 'Ventus (2/2)', '2002-01-01', 1);
INSERT INTO public.ouvrage VALUES (421, 'La science fiction francaise', '2002-01-01', 15);
INSERT INTO public.ouvrage VALUES (422, 'Histoires de cosmonautes', '1974-01-01', 15);
INSERT INTO public.ouvrage VALUES (423, 'L ere du satisficateur', '1976-01-01', 1);
INSERT INTO public.ouvrage VALUES (424, 'Histoires de Planetes', '1975-01-01', 15);
INSERT INTO public.ouvrage VALUES (425, 'Histoires de demain', '1974-01-01', 15);
INSERT INTO public.ouvrage VALUES (426, 'Histoires de surhommes', '1983-01-01', 15);
INSERT INTO public.ouvrage VALUES (427, 'Histoires de pouvoirs', '1975-01-01', 15);
INSERT INTO public.ouvrage VALUES (428, 'Histoires a rebours', '1976-01-01', 15);
INSERT INTO public.ouvrage VALUES (429, 'Histoires de mutants', '1974-01-01', 15);
INSERT INTO public.ouvrage VALUES (430, 'Pas d avenir pour les sapiens', '1980-01-01', 15);
INSERT INTO public.ouvrage VALUES (431, 'Science-fiction allemande', '1980-01-01', 15);
INSERT INTO public.ouvrage VALUES (432, 'Deux soleils pour artuby', '1971-01-01', 1);
INSERT INTO public.ouvrage VALUES (433, 'L oreille contre les murs', '1980-01-01', 15);
INSERT INTO public.ouvrage VALUES (434, 'Hadon, fils de l antique Opar', '1976-01-01', 3);
INSERT INTO public.ouvrage VALUES (435, 'La guerre des machines (Dune, la genese 1)', '2002-01-01', 1);
INSERT INTO public.ouvrage VALUES (436, 'Ravage', '1943-01-01', 1);
INSERT INTO public.ouvrage VALUES (437, 'La terre, echec et mat...', '1976-01-01', 4);
INSERT INTO public.ouvrage VALUES (438, 'La science fiction ? J aime !', '1980-01-01', 12);
INSERT INTO public.ouvrage VALUES (439, 'L individu (SF et pouvoir)', NULL, 15);
INSERT INTO public.ouvrage VALUES (440, 'La maison aux mille etages', '1970-01-01', 1);
INSERT INTO public.ouvrage VALUES (441, 'Le seigneur des Baux', '1981-01-01', 14);
INSERT INTO public.ouvrage VALUES (442, 'La cage de Londres', '2003-01-01', 1);
INSERT INTO public.ouvrage VALUES (443, 'Guerre aux invisibles', '1970-01-01', 1);
INSERT INTO public.ouvrage VALUES (444, 'La musique du sang', '1985-01-01', 1);
INSERT INTO public.ouvrage VALUES (445, 'Les maitres chanteurs', '1982-01-01', 1);
INSERT INTO public.ouvrage VALUES (446, 'La vie, l univers et le reste', '1983-01-01', 1);
INSERT INTO public.ouvrage VALUES (447, 'Blanc comme l ombre', '2003-01-01', 1);
INSERT INTO public.ouvrage VALUES (448, 'La planete des singes', '1963-01-01', 1);
INSERT INTO public.ouvrage VALUES (449, 'Les gardiens', '1978-01-01', 15);
INSERT INTO public.ouvrage VALUES (450, 'plus noir que vous ne pensez', '1972-01-01', 1);
INSERT INTO public.ouvrage VALUES (451, 'L enfant des etoiles', '1976-01-01', 1);
INSERT INTO public.ouvrage VALUES (452, 'Le bond vers l infini', '1991-01-01', 4);
INSERT INTO public.ouvrage VALUES (453, 'Retour sur mars', '1999-01-01', 1);
INSERT INTO public.ouvrage VALUES (454, 'Le seigneur des anneaux (La communaute de l anneau)', '1972-01-01', 3);
INSERT INTO public.ouvrage VALUES (455, 'Le seigneur des anneaux (Les deux tours)', '1972-01-01', 3);
INSERT INTO public.ouvrage VALUES (456, 'Le seigneur des anneaux (Le retour du roi)', '1973-01-01', 3);
INSERT INTO public.ouvrage VALUES (457, 'Les chiens de l hiver', '2003-01-01', 4);
INSERT INTO public.ouvrage VALUES (458, 'La nuit des temps', '1968-01-01', 1);
INSERT INTO public.ouvrage VALUES (459, 'Le voyage fantastique', '1972-01-01', 1);
INSERT INTO public.ouvrage VALUES (460, 'L echelle de Darwin', '2001-01-01', 1);
INSERT INTO public.ouvrage VALUES (461, 'Les enfants de Darwin', '2003-01-01', 1);
INSERT INTO public.ouvrage VALUES (462, 'Le livre secret des fourmis', '1993-01-01', 1);
INSERT INTO public.ouvrage VALUES (463, 'La tour de verre', '1970-01-01', 1);
INSERT INTO public.ouvrage VALUES (464, 'Le rasoir d occam', '1957-01-01', 1);
INSERT INTO public.ouvrage VALUES (465, 'Le champ du reveur', '1983-01-01', 1);
INSERT INTO public.ouvrage VALUES (466, 'Vittorio le vampire', '1999-01-01', 9);
INSERT INTO public.ouvrage VALUES (467, 'Pardonnez nous vos enfances', '1978-01-01', 15);


--
-- TOC entry 5408 (class 0 OID 27214)
-- Dependencies: 475
-- Data for Name: personne; Type: TABLE DATA; Schema: public; Owner: lbrun
--



--
-- TOC entry 5407 (class 0 OID 27203)
-- Dependencies: 473
-- Data for Name: sujet; Type: TABLE DATA; Schema: public; Owner: lbrun
--

INSERT INTO public.sujet VALUES (1, 'Science-Fiction');
INSERT INTO public.sujet VALUES (2, 'Hard Science Fiction');
INSERT INTO public.sujet VALUES (3, 'Fantazy');
INSERT INTO public.sujet VALUES (4, 'Fantastique');
INSERT INTO public.sujet VALUES (5, 'Horreur');
INSERT INTO public.sujet VALUES (6, 'Cyberpunk');
INSERT INTO public.sujet VALUES (7, 'Terreur');
INSERT INTO public.sujet VALUES (8, 'Science-Fiction (proche)');
INSERT INTO public.sujet VALUES (9, 'Fantastique-Vampires');
INSERT INTO public.sujet VALUES (10, 'Science-Fiction-Vampires');
INSERT INTO public.sujet VALUES (11, 'Aventures');
INSERT INTO public.sujet VALUES (12, 'Philosophie-Reflexion');
INSERT INTO public.sujet VALUES (13, 'Roman');
INSERT INTO public.sujet VALUES (14, 'Histoire');
INSERT INTO public.sujet VALUES (15, 'Recueil de Nouvelles');
INSERT INTO public.sujet VALUES (16, 'Theatre');
INSERT INTO public.sujet VALUES (17, 'Astronomie');
INSERT INTO public.sujet VALUES (18, 'Sciences');


--
-- TOC entry 5418 (class 0 OID 0)
-- Dependencies: 476
-- Name: sujet_code_sujet_seq; Type: SEQUENCE SET; Schema: public; Owner: lbrun
--

SELECT pg_catalog.setval('public.sujet_code_sujet_seq', 1, false);


--
-- TOC entry 5249 (class 2606 OID 27647)
-- Name: auteurs auteurs_pkey; Type: CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.auteurs
    ADD CONSTRAINT auteurs_pkey PRIMARY KEY (code);


--
-- TOC entry 5251 (class 2606 OID 27649)
-- Name: ecrit_par ecrit_par_pkey; Type: CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.ecrit_par
    ADD CONSTRAINT ecrit_par_pkey PRIMARY KEY (code_ouvrage, code_auteur);


--
-- TOC entry 5253 (class 2606 OID 27651)
-- Name: editeurs editeurs_pkey; Type: CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.editeurs
    ADD CONSTRAINT editeurs_pkey PRIMARY KEY (code);


--
-- TOC entry 5255 (class 2606 OID 27653)
-- Name: emplacements emplacements_pkey; Type: CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.emplacements
    ADD CONSTRAINT emplacements_pkey PRIMARY KEY (code);


--
-- TOC entry 5257 (class 2606 OID 27655)
-- Name: emprunts emprunts_pkey; Type: CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.emprunts
    ADD CONSTRAINT emprunts_pkey PRIMARY KEY (code_personne, code_exemplaire);


--
-- TOC entry 5259 (class 2606 OID 27657)
-- Name: exemplaire exemplaire_pkey; Type: CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT exemplaire_pkey PRIMARY KEY (code);


--
-- TOC entry 5261 (class 2606 OID 27659)
-- Name: nationalites nationalites_pkey; Type: CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.nationalites
    ADD CONSTRAINT nationalites_pkey PRIMARY KEY (code);


--
-- TOC entry 5263 (class 2606 OID 27661)
-- Name: ouvrage ouvrage_pkey; Type: CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.ouvrage
    ADD CONSTRAINT ouvrage_pkey PRIMARY KEY (code);


--
-- TOC entry 5267 (class 2606 OID 27663)
-- Name: personne personne_pkey; Type: CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.personne
    ADD CONSTRAINT personne_pkey PRIMARY KEY (code_personne);


--
-- TOC entry 5265 (class 2606 OID 27665)
-- Name: sujet sujet_pkey; Type: CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.sujet
    ADD CONSTRAINT sujet_pkey PRIMARY KEY (code);


--
-- TOC entry 5268 (class 2606 OID 27974)
-- Name: auteurs auteurs_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.auteurs
    ADD CONSTRAINT auteurs_fkey FOREIGN KEY (code_nationalite) REFERENCES public.nationalites(code);


--
-- TOC entry 5269 (class 2606 OID 27979)
-- Name: ecrit_par ecrit_par_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.ecrit_par
    ADD CONSTRAINT ecrit_par_fkey1 FOREIGN KEY (code_ouvrage) REFERENCES public.ouvrage(code);


--
-- TOC entry 5270 (class 2606 OID 27984)
-- Name: ecrit_par ecrit_par_fkey2; Type: FK CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.ecrit_par
    ADD CONSTRAINT ecrit_par_fkey2 FOREIGN KEY (code_auteur) REFERENCES public.auteurs(code);


--
-- TOC entry 5271 (class 2606 OID 27989)
-- Name: emprunts emprunt_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.emprunts
    ADD CONSTRAINT emprunt_fkey1 FOREIGN KEY (code_personne) REFERENCES public.personne(code_personne);


--
-- TOC entry 5272 (class 2606 OID 27994)
-- Name: emprunts emprunt_fkey2; Type: FK CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.emprunts
    ADD CONSTRAINT emprunt_fkey2 FOREIGN KEY (code_exemplaire) REFERENCES public.exemplaire(code);


--
-- TOC entry 5273 (class 2606 OID 27999)
-- Name: exemplaire exemplaire_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT exemplaire_fkey1 FOREIGN KEY (code_ouvrage) REFERENCES public.ouvrage(code);


--
-- TOC entry 5274 (class 2606 OID 28004)
-- Name: exemplaire exemplaire_fkey2; Type: FK CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.exemplaire
    ADD CONSTRAINT exemplaire_fkey2 FOREIGN KEY (code_editeur) REFERENCES public.editeurs(code);


--
-- TOC entry 5275 (class 2606 OID 28009)
-- Name: ouvrage ouvrage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbrun
--

ALTER TABLE ONLY public.ouvrage
    ADD CONSTRAINT ouvrage_fkey FOREIGN KEY (sujet) REFERENCES public.sujet(code);


-- Completed on 2024-02-08 17:10:32

--
-- PostgreSQL database dump complete
--