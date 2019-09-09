--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

DROP INDEX public.index_user_auths_on_uid;
DROP INDEX public.index_canvas_site_mailing_lists_on_canvas_site_id;
DROP INDEX public.mailing_list_membership_index;
ALTER TABLE ONLY public.user_roles DROP CONSTRAINT user_roles_pkey;
ALTER TABLE ONLY public.user_auths DROP CONSTRAINT user_auths_pkey;
DROP INDEX public.index_oec_course_codes_on_dept_name_and_catalog_id;
DROP INDEX public.index_oec_course_codes_on_dept_code;
ALTER TABLE ONLY public.oec_course_codes DROP CONSTRAINT oec_course_codes_pkey;
ALTER TABLE ONLY public.canvas_site_mailing_lists DROP CONSTRAINT canvas_site_mailing_lists_pkey;
ALTER TABLE ONLY public.canvas_site_mailing_list_members DROP CONSTRAINT canvas_site_mailing_list_members_pkey;
ALTER TABLE public.user_roles ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.user_auths ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.oec_course_codes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.canvas_site_mailing_lists ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.canvas_site_mailing_list_members ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.user_roles_id_seq;
DROP TABLE public.user_roles;
DROP SEQUENCE public.user_auths_id_seq;
DROP TABLE public.user_auths;
DROP SEQUENCE public.oec_course_codes_id_seq;
DROP TABLE public.oec_course_codes;
DROP SEQUENCE public.canvas_site_mailing_lists_id_seq;
DROP TABLE public.canvas_site_mailing_lists;
DROP SEQUENCE public.canvas_site_mailing_list_members_id_seq;
DROP TABLE public.canvas_site_mailing_list_members;
SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: canvas_site_mailing_list_members; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE canvas_site_mailing_list_members (
  id integer NOT NULL,
  mailing_list_id integer NOT NULL,
  first_name character varying(255),
  last_name character varying(255),
  email_address character varying(255) NOT NULL,
  can_send boolean DEFAULT false NOT NULL,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);

--
-- Name: canvas_site_mailing_list_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE canvas_site_mailing_list_members_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: canvas_site_mailing_list_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE canvas_site_mailing_list_members_id_seq OWNED BY canvas_site_mailing_list_members.id;

--
-- Name: canvas_site_mailing_lists; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE canvas_site_mailing_lists (
  id integer NOT NULL,
  canvas_site_id character varying(255),
  canvas_site_name character varying(255),
  list_name character varying(255),
  state character varying(255),
  populated_at timestamp without time zone,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  members_count integer,
  populate_add_errors integer,
  populate_remove_errors integer,
  type character varying(255)
);

--
-- Name: canvas_site_mailing_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE canvas_site_mailing_lists_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;

--
-- Name: canvas_site_mailing_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE canvas_site_mailing_lists_id_seq OWNED BY canvas_site_mailing_lists.id;


--
-- Name: oec_course_codes; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE oec_course_codes (
    id integer NOT NULL,
    dept_name character varying(255) NOT NULL,
    catalog_id character varying(255) NOT NULL,
    dept_code character varying(255) NOT NULL,
    include_in_oec boolean NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: oec_course_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE oec_course_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oec_course_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE oec_course_codes_id_seq OWNED BY oec_course_codes.id;


--
-- Name: user_auths; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE user_auths (
    id integer NOT NULL,
    uid character varying(255) NOT NULL,
    is_superuser boolean DEFAULT false NOT NULL,
    active boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_author boolean DEFAULT false NOT NULL,
    is_viewer boolean DEFAULT false NOT NULL
);


--
-- Name: user_auths_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_auths_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_auths_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_auths_id_seq OWNED BY user_auths.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE user_roles (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255)
);


--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_roles_id_seq OWNED BY user_roles.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY canvas_site_mailing_list_members ALTER COLUMN id SET DEFAULT nextval('canvas_site_mailing_list_members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY canvas_site_mailing_lists ALTER COLUMN id SET DEFAULT nextval('canvas_site_mailing_lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY oec_course_codes ALTER COLUMN id SET DEFAULT nextval('oec_course_codes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_auths ALTER COLUMN id SET DEFAULT nextval('user_auths_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_roles ALTER COLUMN id SET DEFAULT nextval('user_roles_id_seq'::regclass);

--
-- Data for Name: oec_course_codes; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO oec_course_codes VALUES (1, 'A,RESEC', '', 'MBARC', true, '2015-08-13 23:26:35.356', '2015-08-13 23:26:35.356');
INSERT INTO oec_course_codes VALUES (2, 'AEROSPC', '', 'QLROT', true, '2015-08-13 23:26:35.38', '2015-08-13 23:26:35.38');
INSERT INTO oec_course_codes VALUES (3, 'AFRICAM', '', 'SAAMS', true, '2015-08-13 23:26:35.388', '2015-08-13 23:26:35.388');
INSERT INTO oec_course_codes VALUES (4, 'AFRKANS', '', 'HZGER', true, '2015-08-13 23:26:35.399', '2015-08-13 23:26:35.399');
INSERT INTO oec_course_codes VALUES (5, 'AGR CHM', '', 'MEPMB', true, '2015-08-13 23:26:35.408', '2015-08-13 23:26:35.408');
INSERT INTO oec_course_codes VALUES (6, 'AHMA', '', 'HTAHN', false, '2015-08-13 23:26:35.417', '2015-08-13 23:26:35.417');
INSERT INTO oec_course_codes VALUES (7, 'ALTAIC', '', 'HGEAL', true, '2015-08-13 23:26:35.426', '2015-08-13 23:26:35.426');
INSERT INTO oec_course_codes VALUES (8, 'AMERSTD', '', 'QHUIS', true, '2015-08-13 23:26:35.433', '2015-08-13 23:26:35.433');
INSERT INTO oec_course_codes VALUES (9, 'ANTHRO', '', 'SZANT', true, '2015-08-13 23:26:35.444', '2015-08-13 23:26:35.444');
INSERT INTO oec_course_codes VALUES (10, 'ARABIC', '', 'HNNES', false, '2015-08-13 23:26:35.452', '2015-08-13 23:26:35.452');
INSERT INTO oec_course_codes VALUES (11, 'ARCH', '', 'DBARC', false, '2015-08-13 23:26:35.461', '2015-08-13 23:26:35.461');
INSERT INTO oec_course_codes VALUES (12, 'ART', '', 'LQAPR', false, '2015-08-13 23:26:35.471', '2015-08-13 23:26:35.471');
INSERT INTO oec_course_codes VALUES (13, 'ARMENI', '', 'LTSLL', true, '2015-08-13 23:26:35.482', '2015-08-13 23:26:35.482');
INSERT INTO oec_course_codes VALUES (14, 'ASAMST', '', 'SBETH', true, '2015-08-13 23:26:35.49', '2015-08-13 23:26:35.49');
INSERT INTO oec_course_codes VALUES (15, 'ASIANST', '', 'QIIAS', true, '2015-08-13 23:26:35.498', '2015-08-13 23:26:35.498');
INSERT INTO oec_course_codes VALUES (16, 'AST', '', 'EDDNO', true, '2015-08-13 23:26:35.506', '2015-08-13 23:26:35.506');
INSERT INTO oec_course_codes VALUES (17, 'ASTRON', '', 'PAAST', true, '2015-08-13 23:26:35.513', '2015-08-13 23:26:35.513');
INSERT INTO oec_course_codes VALUES (18, 'BANGLA', '', 'HVSSA', false, '2015-08-13 23:26:35.52', '2015-08-13 23:26:35.52');
INSERT INTO oec_course_codes VALUES (19, 'BIO ENG', '', 'EFBIO', true, '2015-08-13 23:26:35.528', '2015-08-13 23:26:35.528');
INSERT INTO oec_course_codes VALUES (20, 'BIOLOGY', '1A', 'IMMCB', true, '2015-08-13 23:26:35.534', '2015-08-13 23:26:35.534');
INSERT INTO oec_course_codes VALUES (21, 'BIOLOGY', '1AL', 'IMMCB', true, '2015-08-13 23:26:35.542', '2015-08-13 23:26:35.542');
INSERT INTO oec_course_codes VALUES (22, 'BIOLOGY', '1B', 'IBIBI', true, '2015-08-13 23:26:35.55', '2015-08-13 23:26:35.55');
INSERT INTO oec_course_codes VALUES (23, 'BIOLOGY', '1BL', 'IBIBI', true, '2015-08-13 23:26:35.558', '2015-08-13 23:26:35.558');
INSERT INTO oec_course_codes VALUES (24, 'BIOPHY', '', 'IQBBB', false, '2015-08-13 23:26:35.565', '2015-08-13 23:26:35.565');
INSERT INTO oec_course_codes VALUES (25, 'BOSCRSR', '', 'LTSLL', true, '2015-08-13 23:26:35.573', '2015-08-13 23:26:35.573');
INSERT INTO oec_course_codes VALUES (26, 'BUDDSTD', '', 'HGEAL', true, '2015-08-13 23:26:35.596', '2015-08-13 23:26:35.596');
INSERT INTO oec_course_codes VALUES (27, 'BULGARI', '', 'LTSLL', true, '2015-08-13 23:26:35.608', '2015-08-13 23:26:35.608');
INSERT INTO oec_course_codes VALUES (28, 'BUS ADM', '', 'BAHSB', false, '2015-08-13 23:26:35.619', '2015-08-13 23:26:35.619');
INSERT INTO oec_course_codes VALUES (29, 'CATALAN', '', 'LPSPP', true, '2015-08-13 23:26:35.629', '2015-08-13 23:26:35.629');
INSERT INTO oec_course_codes VALUES (30, 'CELTIC', '', 'CELTIC', true, '2015-08-13 23:26:35.64', '2015-08-13 23:26:35.64');
INSERT INTO oec_course_codes VALUES (31, 'CHEM', '', 'CCHEM', true, '2015-08-13 23:26:35.648', '2015-08-13 23:26:35.648');
INSERT INTO oec_course_codes VALUES (32, 'CHICANO', '', 'SBETH', true, '2015-08-13 23:26:35.655', '2015-08-13 23:26:35.655');
INSERT INTO oec_course_codes VALUES (33, 'CHINESE', '', 'HGEAL', true, '2015-08-13 23:26:35.664', '2015-08-13 23:26:35.664');
INSERT INTO oec_course_codes VALUES (34, 'CHM ENG', '', 'CEEEG', false, '2015-08-13 23:26:35.671', '2015-08-13 23:26:35.671');
INSERT INTO oec_course_codes VALUES (35, 'CIV ENG', '', 'EGCEE', true, '2015-08-13 23:26:35.684', '2015-08-13 23:26:35.684');
INSERT INTO oec_course_codes VALUES (36, 'CLASSIC', '', 'LSCLA', false, '2015-08-13 23:26:35.695', '2015-08-13 23:26:35.695');
INSERT INTO oec_course_codes VALUES (37, 'CMPBIO', '', 'BMCCB', true, '2015-08-13 23:26:35.704', '2015-08-13 23:26:35.704');
INSERT INTO oec_course_codes VALUES (38, 'COG SCI', '', 'QIIAS', true, '2015-08-13 23:26:35.711', '2015-08-13 23:26:35.711');
INSERT INTO oec_course_codes VALUES (39, 'COLWRIT', '', 'QKCWP', true, '2015-08-13 23:26:35.719', '2015-08-13 23:26:35.719');
INSERT INTO oec_course_codes VALUES (40, 'COM LIT', '', 'HLCOM', true, '2015-08-13 23:26:35.726', '2015-08-13 23:26:35.726');
INSERT INTO oec_course_codes VALUES (41, 'COMPBIO', '', 'OLGDD', true, '2015-08-13 23:26:35.733', '2015-08-13 23:26:35.733');
INSERT INTO oec_course_codes VALUES (42, 'COMPSCI', '', 'EHEEC', true, '2015-08-13 23:26:35.74', '2015-08-13 23:26:35.74');
INSERT INTO oec_course_codes VALUES (43, 'CRIT TH', '', 'CRTHE', false, '2015-08-13 23:26:35.749', '2015-08-13 23:26:35.749');
INSERT INTO oec_course_codes VALUES (44, 'CRWRIT', '', 'HENGL', true, '2015-08-13 23:26:35.756', '2015-08-13 23:26:35.756');
INSERT INTO oec_course_codes VALUES (45, 'CUNEIF', '', 'HNNES', false, '2015-08-13 23:26:35.766', '2015-08-13 23:26:35.766');
INSERT INTO oec_course_codes VALUES (46, 'CY PLAN', '', 'DCCRP', false, '2015-08-13 23:26:35.773', '2015-08-13 23:26:35.773');
INSERT INTO oec_course_codes VALUES (47, 'CZECH', '', 'LTSLL', true, '2015-08-13 23:26:35.781', '2015-08-13 23:26:35.781');
INSERT INTO oec_course_codes VALUES (48, 'DANISH', '', 'HSCAN', true, '2015-08-13 23:26:35.797', '2015-08-13 23:26:35.797');
INSERT INTO oec_course_codes VALUES (49, 'DATASCI', '', 'MMIMS', true, '2015-08-13 23:26:35.805', '2015-08-13 23:26:35.805');
INSERT INTO oec_course_codes VALUES (50, 'DEMOG', '', 'SDDEM', false, '2015-08-13 23:26:35.811', '2015-08-13 23:26:35.811');
INSERT INTO oec_course_codes VALUES (51, 'DES INV', '', 'EDDNO', true, '2015-08-13 23:26:35.817', '2015-08-13 23:26:35.817');
INSERT INTO oec_course_codes VALUES (52, 'DEV ENG', '', 'EGCEE', true, '2015-08-13 23:26:35.825', '2015-08-13 23:26:35.825');
INSERT INTO oec_course_codes VALUES (53, 'DEV STD', '', 'QIIAS', true, '2015-08-13 23:26:35.833', '2015-08-13 23:26:35.833');
INSERT INTO oec_course_codes VALUES (54, 'DEVP', '', 'MANRD', true, '2015-08-13 23:26:35.841', '2015-08-13 23:26:35.841');
INSERT INTO oec_course_codes VALUES (55, 'DUTCH', '', 'HZGER', true, '2015-08-13 23:26:35.847', '2015-08-13 23:26:35.847');
INSERT INTO oec_course_codes VALUES (56, 'EA LANG', '', 'HGEAL', true, '2015-08-13 23:26:35.855', '2015-08-13 23:26:35.855');
INSERT INTO oec_course_codes VALUES (57, 'EAEURST', '', 'LTSLL', true, '2015-08-13 23:26:35.863', '2015-08-13 23:26:35.863');
INSERT INTO oec_course_codes VALUES (58, 'ECON', '', 'SECON', true, '2015-08-13 23:26:35.878', '2015-08-13 23:26:35.878');
INSERT INTO oec_course_codes VALUES (59, 'EDUC', '', 'EAEDU', false, '2015-08-13 23:26:35.887', '2015-08-13 23:26:35.887');
INSERT INTO oec_course_codes VALUES (60, 'EECS', '', 'EHEEC', true, '2015-08-13 23:26:35.894', '2015-08-13 23:26:35.894');
INSERT INTO oec_course_codes VALUES (61, 'EGYPT', '', 'HNNES', false, '2015-08-13 23:26:35.903', '2015-08-13 23:26:35.903');
INSERT INTO oec_course_codes VALUES (62, 'EL ENG', '', 'EHEEC', true, '2015-08-13 23:26:35.916', '2015-08-13 23:26:35.916');
INSERT INTO oec_course_codes VALUES (63, 'ENE,RES', '', 'MGERG', true, '2015-08-13 23:26:35.934', '2015-08-13 23:26:35.934');
INSERT INTO oec_course_codes VALUES (64, 'ENGIN', '', 'EDDNO', true, '2015-08-13 23:26:35.944', '2015-08-13 23:26:35.944');
INSERT INTO oec_course_codes VALUES (65, 'ENGLISH', '', 'HENGL', false, '2015-08-13 23:26:35.949', '2015-08-13 23:26:35.949');
INSERT INTO oec_course_codes VALUES (66, 'ENV DES', '', 'DACED', false, '2015-08-13 23:26:35.954', '2015-08-13 23:26:35.954');
INSERT INTO oec_course_codes VALUES (67, 'ENV SCI', '', 'MCESP', true, '2015-08-13 23:26:35.96', '2015-08-13 23:26:35.96');
INSERT INTO oec_course_codes VALUES (68, 'ENVECON', '', 'MBARC', true, '2015-08-13 23:26:35.965', '2015-08-13 23:26:35.965');
INSERT INTO oec_course_codes VALUES (69, 'EPS', '', 'PGEGE', true, '2015-08-13 23:26:35.97', '2015-08-13 23:26:35.97');
INSERT INTO oec_course_codes VALUES (70, 'ESPM', '', 'MCESP', true, '2015-08-13 23:26:35.974', '2015-08-13 23:26:35.974');
INSERT INTO oec_course_codes VALUES (71, 'ETH GRP', '', 'SBETH', true, '2015-08-13 23:26:35.98', '2015-08-13 23:26:35.98');
INSERT INTO oec_course_codes VALUES (72, 'ETH STD', '', 'SBETH', true, '2015-08-13 23:26:35.985', '2015-08-13 23:26:35.985');
INSERT INTO oec_course_codes VALUES (73, 'EURA ST', '', 'LTSLL', true, '2015-08-13 23:26:35.99', '2015-08-13 23:26:35.99');
INSERT INTO oec_course_codes VALUES (74, 'EUST', '', 'LTSLL', true, '2015-08-13 23:26:35.994', '2015-08-13 23:26:35.994');
INSERT INTO oec_course_codes VALUES (75, 'EWMBA', '', 'BAHSB', false, '2015-08-13 23:26:36', '2015-08-13 23:26:36');
INSERT INTO oec_course_codes VALUES (76, 'FILIPN', '', 'HVSSA', false, '2015-08-13 23:26:36.005', '2015-08-13 23:26:36.005');
INSERT INTO oec_course_codes VALUES (77, 'FILM', '', 'HUFLM', false, '2015-08-13 23:26:36.01', '2015-08-13 23:26:36.01');
INSERT INTO oec_course_codes VALUES (78, 'FINNISH', '', 'HSCAN', true, '2015-08-13 23:26:36.015', '2015-08-13 23:26:36.015');
INSERT INTO oec_course_codes VALUES (79, 'FOLKLOR', '', 'SZANT', false, '2015-08-13 23:26:36.02', '2015-08-13 23:26:36.02');
INSERT INTO oec_course_codes VALUES (80, 'FRENCH', '', 'HFREN', true, '2015-08-13 23:26:36.025', '2015-08-13 23:26:36.025');
INSERT INTO oec_course_codes VALUES (81, 'GEOG', '', 'SGEOG', true, '2015-08-13 23:26:36.03', '2015-08-13 23:26:36.03');
INSERT INTO oec_course_codes VALUES (82, 'GERMAN', '', 'HZGER', true, '2015-08-13 23:26:36.036', '2015-08-13 23:26:36.036');
INSERT INTO oec_course_codes VALUES (83, 'GMS', '', 'BUGMS', false, '2015-08-13 23:26:36.04', '2015-08-13 23:26:36.04');
INSERT INTO oec_course_codes VALUES (84, 'GPP', '', 'QIIAS', true, '2015-08-13 23:26:36.045', '2015-08-13 23:26:36.045');
INSERT INTO oec_course_codes VALUES (85, 'GREEK', '', 'LSCLA', false, '2015-08-13 23:26:36.051', '2015-08-13 23:26:36.051');
INSERT INTO oec_course_codes VALUES (86, 'GSPDP', '', 'OLGDD', true, '2015-08-13 23:26:36.055', '2015-08-13 23:26:36.055');
INSERT INTO oec_course_codes VALUES (87, 'GWS', '', 'SWOME', true, '2015-08-13 23:26:36.06', '2015-08-13 23:26:36.06');
INSERT INTO oec_course_codes VALUES (88, 'HEBREW', '', 'HNNES', false, '2015-08-13 23:26:36.065', '2015-08-13 23:26:36.065');
INSERT INTO oec_course_codes VALUES (89, 'HIN-URD', '', 'HVSSA', false, '2015-08-13 23:26:36.07', '2015-08-13 23:26:36.07');
INSERT INTO oec_course_codes VALUES (90, 'HISTART', '', 'HARTH', false, '2015-08-13 23:26:36.075', '2015-08-13 23:26:36.075');
INSERT INTO oec_course_codes VALUES (91, 'HISTORY', '', 'SHIST', true, '2015-08-13 23:26:36.079', '2015-08-13 23:26:36.079');
INSERT INTO oec_course_codes VALUES (92, 'HMEDSCI', '', 'CPACA', true, '2015-08-13 23:26:36.084', '2015-08-13 23:26:36.084');
INSERT INTO oec_course_codes VALUES (93, 'HUNGARI', '', 'LTSLL', true, '2015-08-13 23:26:36.089', '2015-08-13 23:26:36.089');
INSERT INTO oec_course_codes VALUES (94, 'IAS', '', 'QIIAS', true, '2015-08-13 23:26:36.094', '2015-08-13 23:26:36.094');
INSERT INTO oec_course_codes VALUES (95, 'ICELAND', '', 'HSCAN', true, '2015-08-13 23:26:36.099', '2015-08-13 23:26:36.099');
INSERT INTO oec_course_codes VALUES (96, 'ILA', '', 'LPSPP', true, '2015-08-13 23:26:36.103', '2015-08-13 23:26:36.103');
INSERT INTO oec_course_codes VALUES (97, 'IND ENG', '', 'EIIEO', true, '2015-08-13 23:26:36.108', '2015-08-13 23:26:36.108');
INSERT INTO oec_course_codes VALUES (98, 'INFO', '', 'MMIMS', true, '2015-08-13 23:26:36.113', '2015-08-13 23:26:36.113');
INSERT INTO oec_course_codes VALUES (99, 'INTEGBI', '', 'IBIBI', true, '2015-08-13 23:26:36.118', '2015-08-13 23:26:36.118');
INSERT INTO oec_course_codes VALUES (100, 'IRANIAN', '', 'HNNES', false, '2015-08-13 23:26:36.123', '2015-08-13 23:26:36.123');
INSERT INTO oec_course_codes VALUES (101, 'ISF', '', 'ISF', true, '2015-08-13 23:26:36.127', '2015-08-13 23:26:36.127');
INSERT INTO oec_course_codes VALUES (102, 'ITALIAN', '', 'HITAL', true, '2015-08-13 23:26:36.132', '2015-08-13 23:26:36.132');
INSERT INTO oec_course_codes VALUES (103, 'JAPAN', '', 'HGEAL', true, '2015-08-13 23:26:36.139', '2015-08-13 23:26:36.139');
INSERT INTO oec_course_codes VALUES (104, 'JEWISH', '', 'KDCJS', false, '2015-08-13 23:26:36.143', '2015-08-13 23:26:36.143');
INSERT INTO oec_course_codes VALUES (105, 'JOURN', '', 'DJOUR', true, '2015-08-13 23:26:36.148', '2015-08-13 23:26:36.148');
INSERT INTO oec_course_codes VALUES (106, 'KHMER', '', 'HVSSA', false, '2015-08-13 23:26:36.152', '2015-08-13 23:26:36.152');
INSERT INTO oec_course_codes VALUES (107, 'KOREAN', '', 'HGEAL', true, '2015-08-13 23:26:36.157', '2015-08-13 23:26:36.157');
INSERT INTO oec_course_codes VALUES (108, 'L & S', '', 'QHUIS', true, '2015-08-13 23:26:36.16', '2015-08-13 23:26:36.16');
INSERT INTO oec_course_codes VALUES (109, 'LAN PRO', '', 'OLGDD', true, '2015-08-13 23:26:36.164', '2015-08-13 23:26:36.164');
INSERT INTO oec_course_codes VALUES (110, 'LATAMST', '', 'QIIAS', true, '2015-08-13 23:26:36.169', '2015-08-13 23:26:36.169');
INSERT INTO oec_course_codes VALUES (111, 'LATIN', '', 'LSCLA', false, '2015-08-13 23:26:36.174', '2015-08-13 23:26:36.174');
INSERT INTO oec_course_codes VALUES (112, 'LAW', '', 'CLLAW', false, '2015-08-13 23:26:36.178', '2015-08-13 23:26:36.178');
INSERT INTO oec_course_codes VALUES (113, 'LD ARCH', '', 'DFLAE', false, '2015-08-13 23:26:36.183', '2015-08-13 23:26:36.183');
INSERT INTO oec_course_codes VALUES (114, 'LEGALST', '', 'LEGALST', true, '2015-08-13 23:26:36.187', '2015-08-13 23:26:36.187');
INSERT INTO oec_course_codes VALUES (115, 'LGBT', '', 'SWOME', true, '2015-08-13 23:26:36.192', '2015-08-13 23:26:36.192');
INSERT INTO oec_course_codes VALUES (116, 'LINGUIS', '', 'SLING', true, '2015-08-13 23:26:36.199', '2015-08-13 23:26:36.199');
INSERT INTO oec_course_codes VALUES (117, 'M E STU', '', 'QIIAS', true, '2015-08-13 23:26:36.203', '2015-08-13 23:26:36.203');
INSERT INTO oec_course_codes VALUES (118, 'MALAY/I', '', 'HVSSA', false, '2015-08-13 23:26:36.207', '2015-08-13 23:26:36.207');
INSERT INTO oec_course_codes VALUES (119, 'MAT SCI', '', 'EJMSM', true, '2015-08-13 23:26:36.211', '2015-08-13 23:26:36.211');
INSERT INTO oec_course_codes VALUES (120, 'MATH', '', 'PMATH', true, '2015-08-13 23:26:36.215', '2015-08-13 23:26:36.215');
INSERT INTO oec_course_codes VALUES (121, 'MBA', '', 'BAHSB', false, '2015-08-13 23:26:36.22', '2015-08-13 23:26:36.22');
INSERT INTO oec_course_codes VALUES (122, 'MCELLBI', '', 'IMMCB', true, '2015-08-13 23:26:36.224', '2015-08-13 23:26:36.224');
INSERT INTO oec_course_codes VALUES (123, 'MEC ENG', '', 'EKMEG', true, '2015-08-13 23:26:36.228', '2015-08-13 23:26:36.228');
INSERT INTO oec_course_codes VALUES (124, 'MED ST', '', 'HPMED', false, '2015-08-13 23:26:36.235', '2015-08-13 23:26:36.235');
INSERT INTO oec_course_codes VALUES (125, 'MEDIAST', '', 'MEDIAST', true, '2015-08-13 23:26:36.239', '2015-08-13 23:26:36.239');
INSERT INTO oec_course_codes VALUES (126, 'MFE', '', 'BAHSB', false, '2015-08-13 23:26:36.243', '2015-08-13 23:26:36.243');
INSERT INTO oec_course_codes VALUES (127, 'MIL AFF', '', 'QLROT', true, '2015-08-13 23:26:36.247', '2015-08-13 23:26:36.247');
INSERT INTO oec_course_codes VALUES (128, 'MIL SCI', '', 'QLROT', true, '2015-08-13 23:26:36.251', '2015-08-13 23:26:36.251');
INSERT INTO oec_course_codes VALUES (129, 'MONGOLN', '', 'HGEAL', true, '2015-08-13 23:26:36.256', '2015-08-13 23:26:36.256');
INSERT INTO oec_course_codes VALUES (130, 'MUSIC', '', 'HMUSC', true, '2015-08-13 23:26:36.261', '2015-08-13 23:26:36.261');
INSERT INTO oec_course_codes VALUES (131, 'NAT RES', '', 'MANRD', true, '2015-08-13 23:26:36.265', '2015-08-13 23:26:36.265');
INSERT INTO oec_course_codes VALUES (132, 'NATAMST', '', 'SBETH', true, '2015-08-13 23:26:36.269', '2015-08-13 23:26:36.269');
INSERT INTO oec_course_codes VALUES (133, 'NAV SCI', '', 'QLROT', true, '2015-08-13 23:26:36.273', '2015-08-13 23:26:36.273');
INSERT INTO oec_course_codes VALUES (134, 'NE STUD', '', 'HNNES', false, '2015-08-13 23:26:36.278', '2015-08-13 23:26:36.278');
INSERT INTO oec_course_codes VALUES (135, 'NEUROSC', '', 'EUNEU', true, '2015-08-13 23:26:36.282', '2015-08-13 23:26:36.282');
INSERT INTO oec_course_codes VALUES (136, 'NORWEGN', '', 'HSCAN', true, '2015-08-13 23:26:36.286', '2015-08-13 23:26:36.286');
INSERT INTO oec_course_codes VALUES (137, 'NSE', '', 'EDDNO', true, '2015-08-13 23:26:36.29', '2015-08-13 23:26:36.29');
INSERT INTO oec_course_codes VALUES (138, 'NUC ENG', '', 'ELNUC', true, '2015-08-13 23:26:36.294', '2015-08-13 23:26:36.294');
INSERT INTO oec_course_codes VALUES (139, 'NUSCTX', '', 'MDNST', true, '2015-08-13 23:26:36.297', '2015-08-13 23:26:36.297');
INSERT INTO oec_course_codes VALUES (140, 'NWMEDIA', '', 'BTCNM', true, '2015-08-13 23:26:36.302', '2015-08-13 23:26:36.302');
INSERT INTO oec_course_codes VALUES (141, 'OPTOM', '', 'BOOPT', false, '2015-08-13 23:26:36.307', '2015-08-13 23:26:36.307');
INSERT INTO oec_course_codes VALUES (142, 'PACS', '', 'QIIAS', true, '2015-08-13 23:26:36.311', '2015-08-13 23:26:36.311');
INSERT INTO oec_course_codes VALUES (143, 'PB HLTH', '', 'CPACA', true, '2015-08-13 23:26:36.315', '2015-08-13 23:26:36.315');
INSERT INTO oec_course_codes VALUES (144, 'PERSIAN', '', 'HNNES', false, '2015-08-13 23:26:36.319', '2015-08-13 23:26:36.319');
INSERT INTO oec_course_codes VALUES (145, 'PHDBA', '', 'BAHSB', false, '2015-08-13 23:26:36.323', '2015-08-13 23:26:36.323');
INSERT INTO oec_course_codes VALUES (146, 'PHILOS', '', 'HCPHI', false, '2015-08-13 23:26:36.327', '2015-08-13 23:26:36.327');
INSERT INTO oec_course_codes VALUES (147, 'PHYS ED', '', 'IPPEP', true, '2015-08-13 23:26:36.331', '2015-08-13 23:26:36.331');
INSERT INTO oec_course_codes VALUES (148, 'PHYSICS', '', 'PHYSI', true, '2015-08-13 23:26:36.335', '2015-08-13 23:26:36.335');
INSERT INTO oec_course_codes VALUES (149, 'PLANTBI', '', 'MEPMB', true, '2015-08-13 23:26:36.339', '2015-08-13 23:26:36.339');
INSERT INTO oec_course_codes VALUES (150, 'POL SCI', '', 'SPOLS', true, '2015-08-13 23:26:36.344', '2015-08-13 23:26:36.344');
INSERT INTO oec_course_codes VALUES (151, 'POLECON', '', 'QIIAS', true, '2015-08-13 23:26:36.35', '2015-08-13 23:26:36.35');
INSERT INTO oec_course_codes VALUES (152, 'POLISH', '', 'LTSLL', true, '2015-08-13 23:26:36.355', '2015-08-13 23:26:36.355');
INSERT INTO oec_course_codes VALUES (153, 'PORTUG', '', 'LPSPP', true, '2015-08-13 23:26:36.359', '2015-08-13 23:26:36.359');
INSERT INTO oec_course_codes VALUES (154, 'PSYCH', '', 'SYPSY', true, '2015-08-13 23:26:36.363', '2015-08-13 23:26:36.363');
INSERT INTO oec_course_codes VALUES (155, 'PUB POL', '', 'CFPPR', false, '2015-08-13 23:26:36.367', '2015-08-13 23:26:36.367');
INSERT INTO oec_course_codes VALUES (156, 'PUNJABI', '', 'HVSSA', false, '2015-08-13 23:26:36.371', '2015-08-13 23:26:36.371');
INSERT INTO oec_course_codes VALUES (157, 'RELIGST', '', 'QHUIS', true, '2015-08-13 23:26:36.375', '2015-08-13 23:26:36.375');
INSERT INTO oec_course_codes VALUES (158, 'RHETOR', '', 'HRHET', false, '2015-08-13 23:26:36.379', '2015-08-13 23:26:36.379');
INSERT INTO oec_course_codes VALUES (159, 'ROMANI', '', 'LTSLL', true, '2015-08-13 23:26:36.383', '2015-08-13 23:26:36.383');
INSERT INTO oec_course_codes VALUES (160, 'RUSSIAN', '', 'LTSLL', true, '2015-08-13 23:26:36.387', '2015-08-13 23:26:36.387');
INSERT INTO oec_course_codes VALUES (161, 'S ASIAN', '', 'HVSSA', false, '2015-08-13 23:26:36.392', '2015-08-13 23:26:36.392');
INSERT INTO oec_course_codes VALUES (162, 'S,SEASN', '', 'HVSSA', false, '2015-08-13 23:26:36.396', '2015-08-13 23:26:36.396');
INSERT INTO oec_course_codes VALUES (163, 'SANSKR', '', 'HVSSA', false, '2015-08-13 23:26:36.401', '2015-08-13 23:26:36.401');
INSERT INTO oec_course_codes VALUES (164, 'SCANDIN', '', 'HSCAN', true, '2015-08-13 23:26:36.405', '2015-08-13 23:26:36.405');
INSERT INTO oec_course_codes VALUES (165, 'SCMATHE', '', 'EAEDU', false, '2015-08-13 23:26:36.409', '2015-08-13 23:26:36.409');
INSERT INTO oec_course_codes VALUES (166, 'SEASIAN', '', 'HVSSA', false, '2015-08-13 23:26:36.413', '2015-08-13 23:26:36.413');
INSERT INTO oec_course_codes VALUES (167, 'SEMITIC', '', 'HNNES', false, '2015-08-13 23:26:36.417', '2015-08-13 23:26:36.417');
INSERT INTO oec_course_codes VALUES (168, 'SLAVIC', '', 'LTSLL', true, '2015-08-13 23:26:36.421', '2015-08-13 23:26:36.421');
INSERT INTO oec_course_codes VALUES (169, 'SOC WEL', '', 'CSDEP', true, '2015-08-13 23:26:36.425', '2015-08-13 23:26:36.425');
INSERT INTO oec_course_codes VALUES (170, 'SOCIOL', '', 'SISOC', false, '2015-08-13 23:26:36.429', '2015-08-13 23:26:36.429');
INSERT INTO oec_course_codes VALUES (171, 'SPANISH', '', 'LPSPP', true, '2015-08-13 23:26:36.433', '2015-08-13 23:26:36.433');
INSERT INTO oec_course_codes VALUES (172, 'STAT', '', 'PSTAT', true, '2015-08-13 23:26:36.437', '2015-08-13 23:26:36.437');
INSERT INTO oec_course_codes VALUES (173, 'STS', '', 'JYHST', false, '2015-08-13 23:26:36.441', '2015-08-13 23:26:36.441');
INSERT INTO oec_course_codes VALUES (174, 'SWEDISH', '', 'HSCAN', true, '2015-08-13 23:26:36.446', '2015-08-13 23:26:36.446');
INSERT INTO oec_course_codes VALUES (175, 'TAGALG', '', 'HVSSA', false, '2015-08-13 23:26:36.45', '2015-08-13 23:26:36.45');
INSERT INTO oec_course_codes VALUES (176, 'TAMIL', '', 'HVSSA', false, '2015-08-13 23:26:36.454', '2015-08-13 23:26:36.454');
INSERT INTO oec_course_codes VALUES (177, 'TELUGU', '', 'HVSSA', false, '2015-08-13 23:26:36.458', '2015-08-13 23:26:36.458');
INSERT INTO oec_course_codes VALUES (178, 'THAI', '', 'HVSSA', false, '2015-08-13 23:26:36.462', '2015-08-13 23:26:36.462');
INSERT INTO oec_course_codes VALUES (179, 'THEATER', '', 'HDRAM', true, '2015-08-13 23:26:36.465', '2015-08-13 23:26:36.465');
INSERT INTO oec_course_codes VALUES (180, 'TIBETAN', '', 'HGEAL', true, '2015-08-13 23:26:36.469', '2015-08-13 23:26:36.469');
INSERT INTO oec_course_codes VALUES (181, 'TURKISH', '', 'HNNES', false, '2015-08-13 23:26:36.473', '2015-08-13 23:26:36.473');
INSERT INTO oec_course_codes VALUES (182, 'UGBA', '', 'BAHSB', false, '2015-08-13 23:26:36.477', '2015-08-13 23:26:36.477');
INSERT INTO oec_course_codes VALUES (183, 'UGIS', '', 'QHUIS', true, '2015-08-13 23:26:36.482', '2015-08-13 23:26:36.482');
INSERT INTO oec_course_codes VALUES (184, 'VIETNMS', '', 'HVSSA', false, '2015-08-13 23:26:36.486', '2015-08-13 23:26:36.486');
INSERT INTO oec_course_codes VALUES (185, 'VIS SCI', '', 'BOOPT', false, '2015-08-13 23:26:36.49', '2015-08-13 23:26:36.49');
INSERT INTO oec_course_codes VALUES (186, 'VIS STD', '', 'DBARC', false, '2015-08-13 23:26:36.494', '2015-08-13 23:26:36.494');
INSERT INTO oec_course_codes VALUES (187, 'XMBA', '', 'BAHSB', false, '2015-08-13 23:26:36.498', '2015-08-13 23:26:36.498');
INSERT INTO oec_course_codes VALUES (188, 'YIDDISH', '', 'HZGER', true, '2015-08-13 23:26:36.502', '2015-08-13 23:26:36.502');
INSERT INTO oec_course_codes VALUES (189, 'FSSEM', '', 'FSSEM', true, '2017-05-19 17:40:36.502', '2017-05-19 17:40:36.502');
INSERT INTO oec_course_codes VALUES (190, 'GLOBAL', '', 'QIIAS', true, '2017-08-10 17:40:36.502', '2017-08-10 17:40:36.502');
INSERT INTO oec_course_codes VALUES (191, 'BIC', '', 'QHUIS', true, '2017-09-27 23:26:36.16', '2017-09-27 23:26:36.16');
INSERT INTO oec_course_codes VALUES (192, 'EDUC', '130', 'CALTEACH', true, '2018-04-03 23:26:36.16', '2018-04-03 23:26:36.16');
INSERT INTO oec_course_codes VALUES (193, 'EDUC', '131AC', 'CALTEACH', true, '2018-04-03 23:26:36.16', '2018-04-03 23:26:36.16');
INSERT INTO oec_course_codes VALUES (194, 'HISTORY', '138T', 'CALTEACH', true, '2018-04-03 23:26:36.16', '2018-04-03 23:26:36.16');
INSERT INTO oec_course_codes VALUES (195, 'HISTORY', '180T', 'CALTEACH', true, '2018-04-03 23:26:36.16', '2018-04-03 23:26:36.16');
INSERT INTO oec_course_codes VALUES (196, 'HISTORY', '182AT', 'CALTEACH', true, '2018-04-03 23:26:36.16', '2018-04-03 23:26:36.16');
INSERT INTO oec_course_codes VALUES (197, 'UGIS', '187', 'CALTEACH', true, '2018-04-03 23:26:36.16', '2018-04-03 23:26:36.16');
INSERT INTO oec_course_codes VALUES (198, 'UGIS', '188', 'CALTEACH', true, '2018-04-03 23:26:36.16', '2018-04-03 23:26:36.16');
INSERT INTO oec_course_codes VALUES (199, 'UGIS', '303', 'CALTEACH', true, '2018-04-03 23:26:36.16', '2018-04-03 23:26:36.16');
INSERT INTO oec_course_codes VALUES (200, 'UGIS', '82', 'CALTEACH', true, '2018-04-03 23:26:36.16', '2018-04-03 23:26:36.16');
INSERT INTO oec_course_codes VALUES (201, 'CALTEACH', '', 'CALTEACH', true, '2018-04-03 23:26:36.16', '2018-04-03 23:26:36.16');
INSERT INTO oec_course_codes VALUES (202, 'CYBER', '', 'MMIMS', true, '2018-09-24 23:26:36.16', '2018-09-24 23:26:36.16');
INSERT INTO oec_course_codes VALUES (203, 'UGIS', '189', 'CALTEACH', true, '2019-09-09 23:26:36.16', '2019-09-09 23:26:36.16');

--
-- Name: oec_course_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('oec_course_codes_id_seq', 238, true);

--
-- Data for Name: user_auths; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO user_auths VALUES (2, '53791', true, true, '2017-03-02 17:06:18.281', '2017-03-02 17:06:18.281', false, false);
INSERT INTO user_auths VALUES (3, '95509', true, true, '2017-03-02 17:06:18.296', '2013-03-04 17:06:18.296', false, false);
INSERT INTO user_auths VALUES (4, '177473', true, true, '2017-03-02 17:06:18.328', '2013-03-04 17:06:18.328', false, false);

--
-- Name: user_auths_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('user_auths_id_seq', 4, true);


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO user_roles VALUES (1, 'Student', 'student');
INSERT INTO user_roles VALUES (2, 'Staff', 'staff');
INSERT INTO user_roles VALUES (3, 'Faculty', 'faculty');


--
-- Name: user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('user_roles_id_seq', 3, true);


--
-- Name: canvas_site_mailing_list_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY canvas_site_mailing_list_members
  ADD CONSTRAINT canvas_site_mailing_list_members_pkey PRIMARY KEY (id);


--
-- Name: canvas_site_mailing_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY canvas_site_mailing_lists
  ADD CONSTRAINT canvas_site_mailing_lists_pkey PRIMARY KEY (id);

--
-- Name: oec_course_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY oec_course_codes
    ADD CONSTRAINT oec_course_codes_pkey PRIMARY KEY (id);


--
-- Name: user_auths_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY user_auths
    ADD CONSTRAINT user_auths_pkey PRIMARY KEY (id);


--
-- Name: user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: index_canvas_site_mailing_lists_on_canvas_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_canvas_site_mailing_lists_on_canvas_site_id ON canvas_site_mailing_lists USING btree (canvas_site_id);


--
-- Name: index_oec_course_codes_on_dept_code; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_oec_course_codes_on_dept_code ON oec_course_codes USING btree (dept_code);


--
-- Name: index_oec_course_codes_on_dept_name_and_catalog_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_oec_course_codes_on_dept_name_and_catalog_id ON oec_course_codes USING btree (dept_name, catalog_id);


--
-- Name: index_user_auths_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_user_auths_on_uid ON user_auths USING btree (uid);


--
-- Name: mailing_list_membership_index; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX mailing_list_membership_index ON canvas_site_mailing_list_members USING btree (mailing_list_id, email_address);


--
-- PostgreSQL database dump complete
--

