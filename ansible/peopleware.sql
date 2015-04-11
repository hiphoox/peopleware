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
-- Name: profiles; Type: TABLE; Schema: public; Owner: peopleware; Tablespace: 
--

CREATE TABLE profiles (
    id integer NOT NULL,
    name character varying(40),
    last_name character varying(40),
    second_surname character varying(40),
    last_salary character varying(20),
    "position" character varying(50),
    resume character varying(5000),
    keywords character varying(500),
    email character varying(50),
    tel character varying(10),
    cel character varying(10),
    state character varying(20),
    contracting_schema character varying(30),
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
    username character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    password character varying(255),
    email character varying(255),
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

ALTER TABLE ONLY profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peopleware
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


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
-- Name: public; Type: ACL; Schema: -; Owner: peopleware
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM peopleware;
GRANT ALL ON SCHEMA public TO peopleware;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--
