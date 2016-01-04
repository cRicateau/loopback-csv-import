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


CREATE TABLE accesstoken (
    id character varying(1024) NOT NULL,
    ttl integer,
    created timestamp with time zone,
    userid integer
);


CREATE TABLE account (
    firstname character varying(1024),
    lastname character varying(1024),
    servicename character varying(1024),
    country character varying(1024),
    active boolean,
    realm character varying(1024),
    username character varying(1024),
    password character varying(1024) NOT NULL,
    credentials character varying(1024),
    challenges character varying(1024),
    email character varying(1024) NOT NULL,
    emailverified boolean,
    verificationtoken character varying(1024),
    status character varying(1024),
    created timestamp with time zone,
    lastupdated timestamp with time zone,
    id integer NOT NULL
);


CREATE SEQUENCE account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE account_id_seq OWNED BY account.id;


--
-- Name: acl; Type: TABLE; Schema: public; Owner: test; Tablespace: 
--

CREATE TABLE acl (
    model character varying(1024),
    property character varying(1024),
    accesstype character varying(1024),
    permission character varying(1024),
    principaltype character varying(1024),
    principalid character varying(1024),
    id integer NOT NULL
);


CREATE SEQUENCE acl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE acl_id_seq OWNED BY acl.id;


--
-- Name: role; Type: TABLE; Schema: public; Owner: test; Tablespace: 
--

CREATE TABLE role (
    id integer NOT NULL,
    name character varying(1024) NOT NULL,
    description character varying(1024),
    created timestamp with time zone,
    modified timestamp with time zone
);


--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

CREATE SEQUENCE role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: test
--


--
-- Name: rolemapping; Type: TABLE; Schema: public; Owner: test; Tablespace: 
--

CREATE TABLE rolemapping (
    id integer NOT NULL,
    principaltype character varying(1024),
    principalid character varying(1024),
    roleid integer
);


--
-- Name: rolemapping_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

CREATE SEQUENCE rolemapping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rolemapping_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: test
--

ALTER SEQUENCE rolemapping_id_seq OWNED BY rolemapping.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: test; Tablespace: 
--

CREATE TABLE "user" (
    realm character varying(1024),
    username character varying(1024),
    password character varying(1024) NOT NULL,
    credentials character varying(1024),
    challenges character varying(1024),
    email character varying(1024) NOT NULL,
    emailverified boolean,
    verificationtoken character varying(1024),
    status character varying(1024),
    created timestamp with time zone,
    lastupdated timestamp with time zone,
    id integer NOT NULL
);


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: test
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: test
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: test
--

ALTER TABLE ONLY account ALTER COLUMN id SET DEFAULT nextval('account_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: test
--

ALTER TABLE ONLY acl ALTER COLUMN id SET DEFAULT nextval('acl_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: test
--

ALTER TABLE ONLY role ALTER COLUMN id SET DEFAULT nextval('role_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: test
--

ALTER TABLE ONLY rolemapping ALTER COLUMN id SET DEFAULT nextval('rolemapping_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: test
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- Name: accesstoken_pkey; Type: CONSTRAINT; Schema: public; Owner: test; Tablespace: 
--

ALTER TABLE ONLY accesstoken
    ADD CONSTRAINT accesstoken_pkey PRIMARY KEY (id);


--
-- Name: account_pkey; Type: CONSTRAINT; Schema: public; Owner: test; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: acl_pkey; Type: CONSTRAINT; Schema: public; Owner: test; Tablespace: 
--

ALTER TABLE ONLY acl
    ADD CONSTRAINT acl_pkey PRIMARY KEY (id);


--
-- Name: role_pkey; Type: CONSTRAINT; Schema: public; Owner: test; Tablespace: 
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: rolemapping_pkey; Type: CONSTRAINT; Schema: public; Owner: test; Tablespace: 
--

ALTER TABLE ONLY rolemapping
    ADD CONSTRAINT rolemapping_pkey PRIMARY KEY (id);


--
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: test; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

