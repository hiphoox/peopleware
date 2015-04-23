--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: files; Type: TABLE; Schema: public; Owner: peopleware; Tablespace:
--

CREATE TABLE files (
    id integer NOT NULL,
    file_name character varying(100),
    file_size integer,
    content_type character varying(100),
    content bytea,
    profile_id integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE files OWNER TO peopleware;

--
-- Name: files_id_seq; Type: SEQUENCE; Schema: public; Owner: peopleware
--

CREATE SEQUENCE files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE files_id_seq OWNER TO peopleware;

--
-- Name: files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peopleware
--

ALTER SEQUENCE files_id_seq OWNED BY files.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: peopleware; Tablespace:
--

CREATE TABLE profiles (
    id integer NOT NULL,
    name character varying(40),
    last_name character varying(40),
    second_surname character varying(40),
    last_salary integer,
    "position" character varying(50),
    resume character varying(12000),
    keywords character varying(500),
    email character varying(50),
    tel character varying(15),
    cel character varying(15),
    state character varying(20),
    contract_schema character varying(30),
    cv_file_name character varying(255),
    residence character varying(15),
    travel character varying(15),
    english_level character varying(15),
    user_id integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE profiles OWNER TO peopleware;

--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: peopleware
--

CREATE SEQUENCE profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE profiles_id_seq OWNER TO peopleware;

--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peopleware
--

ALTER SEQUENCE profiles_id_seq OWNED BY profiles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: peopleware; Tablespace:
--

CREATE TABLE schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


ALTER TABLE schema_migrations OWNER TO peopleware;

--
-- Name: users; Type: TABLE; Schema: public; Owner: peopleware; Tablespace:
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(40),
    last_name character varying(40),
    second_surname character varying(40),
    reset_token character varying(255),
    password character varying(255),
    email character varying(255),
    confirmed boolean DEFAULT false,
    is_staff boolean DEFAULT false,
    is_active boolean DEFAULT false,
    is_superuser boolean DEFAULT false,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE users OWNER TO peopleware;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: peopleware
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO peopleware;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peopleware
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peopleware
--

ALTER TABLE ONLY files ALTER COLUMN id SET DEFAULT nextval('files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peopleware
--

ALTER TABLE ONLY profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peopleware
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: files_pkey; Type: CONSTRAINT; Schema: public; Owner: peopleware; Tablespace:
--

ALTER TABLE ONLY files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: peopleware; Tablespace:
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: peopleware; Tablespace:
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: peopleware; Tablespace:
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: files_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: peopleware
--

ALTER TABLE ONLY files
    ADD CONSTRAINT files_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES profiles(id);


--
-- Name: profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: peopleware
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: peopleware
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM peopleware;
GRANT ALL ON SCHEMA public TO peopleware;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

