--
-- PostgreSQL database dump
--

\restrict C3ibRdHX7KQAcq8xzMte6gDgQyNCqFcuK33yazKaAHiR8hJnKLMg9iWp0O1SJI4

-- Dumped from database version 16.14 (Debian 16.14-1.pgdg13+1)
-- Dumped by pg_dump version 16.14 (Debian 16.14-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: expense_shares; Type: TABLE; Schema: public; Owner: docker
--

CREATE TABLE public.expense_shares (
    expense_id integer NOT NULL,
    user_id integer NOT NULL,
    share_amount numeric(12,2) NOT NULL
);


ALTER TABLE public.expense_shares OWNER TO docker;

--
-- Name: expenses; Type: TABLE; Schema: public; Owner: docker
--

CREATE TABLE public.expenses (
    id integer NOT NULL,
    group_id integer NOT NULL,
    paid_by integer NOT NULL,
    description character varying(200) NOT NULL,
    category character varying(20) DEFAULT 'general'::character varying NOT NULL,
    amount numeric(12,2) NOT NULL,
    expense_date date DEFAULT CURRENT_DATE NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.expenses OWNER TO docker;

--
-- Name: expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: docker
--

CREATE SEQUENCE public.expenses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.expenses_id_seq OWNER TO docker;

--
-- Name: expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: docker
--

ALTER SEQUENCE public.expenses_id_seq OWNED BY public.expenses.id;


--
-- Name: group_members; Type: TABLE; Schema: public; Owner: docker
--

CREATE TABLE public.group_members (
    group_id integer NOT NULL,
    user_id integer NOT NULL,
    joined_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.group_members OWNER TO docker;

--
-- Name: groups; Type: TABLE; Schema: public; Owner: docker
--

CREATE TABLE public.groups (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    category character varying(20) DEFAULT 'general'::character varying NOT NULL,
    currency character(3) DEFAULT 'USD'::bpchar NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.groups OWNER TO docker;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: docker
--

CREATE SEQUENCE public.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.groups_id_seq OWNER TO docker;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: docker
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: docker
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    group_id integer NOT NULL,
    from_user_id integer NOT NULL,
    to_user_id integer NOT NULL,
    amount numeric(12,2) NOT NULL,
    note character varying(200),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.payments OWNER TO docker;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: docker
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_id_seq OWNER TO docker;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: docker
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: docker
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(255) NOT NULL,
    password text NOT NULL,
    full_name character varying(100),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO docker;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: docker
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO docker;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: docker
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: expenses id; Type: DEFAULT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.expenses ALTER COLUMN id SET DEFAULT nextval('public.expenses_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: expense_shares; Type: TABLE DATA; Schema: public; Owner: docker
--

COPY public.expense_shares (expense_id, user_id, share_amount) FROM stdin;
1	43	50.00
1	134	50.00
1	148	50.00
1	171	50.00
2	43	125.00
2	134	125.00
2	148	125.00
2	171	125.00
3	43	5.00
3	134	5.00
3	148	5.00
3	171	5.00
4	43	5.00
4	134	5.00
4	148	5.00
5	25	10.00
5	163	10.00
5	171	10.00
\.


--
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: docker
--

COPY public.expenses (id, group_id, paid_by, description, category, amount, expense_date, created_at) FROM stdin;
1	2	171	Plane tickets	transport	200.00	2026-06-02	2026-06-12 14:55:32.445604+00
2	2	43	Apartament	accommodation	500.00	2026-06-09	2026-06-12 14:57:07.76831+00
3	2	148	Early breakfast	food	20.00	2026-06-10	2026-06-12 15:00:32.781313+00
4	2	171	Souvenirs	other	15.00	2026-06-11	2026-06-12 15:02:07.78388+00
5	3	171	Drinks	food	30.00	2026-06-12	2026-06-12 15:04:33.024608+00
\.


--
-- Data for Name: group_members; Type: TABLE DATA; Schema: public; Owner: docker
--

COPY public.group_members (group_id, user_id, joined_at) FROM stdin;
1	1	2026-05-30 13:14:10.40997+00
1	22	2026-05-30 13:14:10.40997+00
1	137	2026-05-30 13:14:10.40997+00
1	138	2026-05-30 13:14:10.40997+00
1	148	2026-05-30 13:14:10.40997+00
1	111	2026-05-30 13:14:10.40997+00
2	171	2026-06-12 14:54:24.406015+00
2	134	2026-06-12 14:54:24.406015+00
2	43	2026-06-12 14:54:24.406015+00
2	148	2026-06-12 14:54:24.406015+00
3	171	2026-06-12 15:04:09.445799+00
3	163	2026-06-12 15:04:09.445799+00
3	25	2026-06-12 15:04:09.445799+00
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: docker
--

COPY public.groups (id, name, category, currency, created_by, created_at) FROM stdin;
1	big group	general	PLN	1	2026-05-30 13:14:10.40997+00
2	Trip to Italy	travel	EUR	171	2026-06-12 14:54:24.406015+00
3	Night out	general	EUR	171	2026-06-12 15:04:09.445799+00
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: docker
--

COPY public.payments (id, group_id, from_user_id, to_user_id, amount, note, created_at) FROM stdin;
1	3	163	171	10.00	\N	2026-06-12 15:15:11.793132+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: docker
--

COPY public.users (id, username, email, password, full_name, is_active, created_at, updated_at) FROM stdin;
1	testuser	test@example.com	$2y$10$kvrzzYMXPUOU.4ji8Us9LeLCux8JTrFyvuYKHMq8Kj6/CyuQtUiy.	Test User	t	2026-05-16 15:34:08.06974+00	2026-05-16 15:34:08.06974+00
2	jamessmith	james.smith@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	James Smith	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
3	oliverjohnson	oliver.johnson@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Oliver Johnson	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
4	williamwilliams	william.williams@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	William Williams	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
5	liambrown	liam.brown@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Liam Brown	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
6	noahjones	noah.jones@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Noah Jones	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
7	ethanmiller	ethan.miller@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Ethan Miller	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
8	masondavis	mason.davis@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Mason Davis	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
9	loganwilson	logan.wilson@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Logan Wilson	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
10	lucastaylor	lucas.taylor@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Lucas Taylor	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
11	benjaminanderson	benjamin.anderson@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Benjamin Anderson	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
12	emmathomas	emma.thomas@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Emma Thomas	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
13	oliviajackson	olivia.jackson@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Olivia Jackson	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
14	avawhite	ava.white@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Ava White	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
15	isabellaharris	isabella.harris@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Isabella Harris	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
16	sophiamartin	sophia.martin@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Sophia Martin	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
17	miathompson	mia.thompson@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Mia Thompson	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
18	charlottegarcia	charlotte.garcia@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Charlotte Garcia	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
19	ameliamartinez	amelia.martinez@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Amelia Martinez	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
20	harperrobinson	harper.robinson@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Harper Robinson	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
21	evelynclark	evelyn.clark@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Evelyn Clark	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
22	abigailrodriguez	abigail.rodriguez@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Abigail Rodriguez	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
23	emilylewis	emily.lewis@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Emily Lewis	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
24	elizabethlee	elizabeth.lee@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Elizabeth Lee	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
25	sofiawalker	sofia.walker@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Sofia Walker	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
26	madisonhall	madison.hall@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Madison Hall	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
27	averyallen	avery.allen@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Avery Allen	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
28	ellayoung	ella.young@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Ella Young	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
29	scarlettking	scarlett.king@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Scarlett King	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
30	gracewright	grace.wright@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Grace Wright	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
31	chloescott	chloe.scott@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Chloe Scott	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
32	victoriatorres	victoria.torres@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Victoria Torres	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
33	rileynguyen	riley.nguyen@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Riley Nguyen	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
34	ariahill	aria.hill@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Aria Hill	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
35	lilyflores	lily.flores@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Lily Flores	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
36	auroragreen	aurora.green@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Aurora Green	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
37	zoeyadams	zoey.adams@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Zoey Adams	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
38	penelopenelson	penelope.nelson@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Penelope Nelson	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
39	laylabaker	layla.baker@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Layla Baker	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
40	noracarter	nora.carter@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Nora Carter	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
41	lunamitchell	luna.mitchell@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Luna Mitchell	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
42	elijahperez	elijah.perez@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Elijah Perez	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
43	alexanderroberts	alexander.roberts@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Alexander Roberts	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
44	henryturner	henry.turner@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Henry Turner	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
45	sebastianphillips	sebastian.phillips@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Sebastian Phillips	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
46	jackcampbell	jack.campbell@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Jack Campbell	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
47	aidenparker	aiden.parker@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Aiden Parker	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
48	owenevans	owen.evans@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Owen Evans	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
49	samueledwards	samuel.edwards@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Samuel Edwards	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
50	danielcollins	daniel.collins@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Daniel Collins	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
51	matthewstewart	matthew.stewart@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Matthew Stewart	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
52	michaelmorris	michael.morris@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Michael Morris	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
53	davidsanchez	david.sanchez@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	David Sanchez	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
54	josephmurphy	joseph.murphy@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Joseph Murphy	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
55	andrewcook	andrew.cook@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Andrew Cook	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
56	johnrogers	john.rogers@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	John Rogers	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
57	ryanmorgan	ryan.morgan@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Ryan Morgan	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
58	nathanpeterson	nathan.peterson@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Nathan Peterson	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
59	dylancooper	dylan.cooper@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Dylan Cooper	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
60	tylerreed	tyler.reed@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Tyler Reed	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
61	calebmorris	caleb.morris@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Caleb Morris	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
62	hannahbailey	hannah.bailey@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Hannah Bailey	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
63	natalierivera	natalie.rivera@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Natalie Rivera	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
64	samanthacoleman	samantha.coleman@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Samantha Coleman	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
65	racheljenkins	rachel.jenkins@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Rachel Jenkins	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
66	meganperry	megan.perry@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Megan Perry	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
67	katherinelong	katherine.long@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Katherine Long	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
68	laurenpatterson	lauren.patterson@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Lauren Patterson	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
69	sarahwatson	sarah.watson@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Sarah Watson	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
70	jessicabrooks	jessica.brooks@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Jessica Brooks	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
71	jenniferkelley	jennifer.kelley@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Jennifer Kelley	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
72	zacharyward	zachary.ward@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Zachary Ward	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
73	briannavarro	brian.navarro@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Brian Navarro	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
74	stephenramirez	stephen.ramirez@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Stephen Ramirez	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
75	kevinhughes	kevin.hughes@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Kevin Hughes	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
76	georgeprice	george.price@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	George Price	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
77	brandonfoster	brandon.foster@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Brandon Foster	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
78	justinsanders	justin.sanders@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Justin Sanders	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
79	nicholasross	nicholas.ross@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Nicholas Ross	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
80	anthonymorales	anthony.morales@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Anthony Morales	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
81	jonathangray	jonathan.gray@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Jonathan Gray	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
82	austinwatkins	austin.watkins@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Austin Watkins	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
83	cameronmendoza	cameron.mendoza@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Cameron Mendoza	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
84	adrianoliver	adrian.oliver@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Adrian Oliver	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
85	cooperchavez	cooper.chavez@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Cooper Chavez	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
86	huntercampbell	hunter.campbell2@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Hunter Campbell	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
87	christianromero	christian.romero@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Christian Romero	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
88	coltonhenderson	colton.henderson@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Colton Henderson	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
89	connerpatterson	conner.patterson2@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Conner Patterson	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
90	dominicdavis	dominic.davis2@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Dominic Davis	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
91	eastonflores	easton.flores2@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Easton Flores	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
92	finnleysmith	finnley.smith@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Finnley Smith	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
93	graysonbrown	grayson.brown@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Grayson Brown	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
94	harrisonjones	harrison.jones@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Harrison Jones	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
95	isaacgarcia	isaac.garcia@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Isaac Garcia	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
96	jaxsonmiller	jaxson.miller@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Jaxson Miller	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
97	kaydencooper	kayden.cooper@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Kayden Cooper	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
98	landonross	landon.ross@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Landon Ross	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
99	lincolnbell	lincoln.bell@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Lincoln Bell	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
100	maddoxmurphy	maddox.murphy@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Maddox Murphy	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
101	maxwellgordon	maxwell.gordon@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Maxwell Gordon	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
102	miles.ramos	miles.ramos@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Miles Ramos	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
103	nolanhansen	nolan.hansen@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Nolan Hansen	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
104	paxtonwood	paxton.wood@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Paxton Wood	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
105	quincyporter	quincy.porter@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Quincy Porter	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
106	reidjenkins	reid.jenkins2@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Reid Jenkins	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
107	riverstone	river.stone@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	River Stone	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
108	roman.black	roman.black@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Roman Black	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
109	roxanneoliver	roxanne.oliver@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Roxanne Oliver	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
110	ruthcole	ruth.cole@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Ruth Cole	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
111	ryanbarnes	ryan.barnes@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Ryan Barnes	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
112	sabrinacross	sabrina.cross@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Sabrina Cross	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
113	sierrapowell	sierra.powell@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Sierra Powell	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
114	skylarchan	skylar.chan@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Skylar Chan	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
115	solomonhunt	solomon.hunt@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Solomon Hunt	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
116	stellareid	stella.reid@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Stella Reid	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
117	sylviashaw	sylvia.shaw@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Sylvia Shaw	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
118	teodorholm	teodor.holm@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Teodor Holm	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
119	teresabush	teresa.bush@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Teresa Bush	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
120	tristanfisher	tristan.fisher@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Tristan Fisher	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
121	tundenash	tunde.nash@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Tunde Nash	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
122	valentinafox	valentina.fox@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Valentina Fox	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
123	veronicaholt	veronica.holt@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Veronica Holt	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
124	wesleyflynn	wesley.flynn@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Wesley Flynn	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
125	wyattmalone	wyatt.malone@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Wyatt Malone	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
126	xeniaray	xenia.ray@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Xenia Ray	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
127	yolandavega	yolanda.vega@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Yolanda Vega	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
128	zacharymanning	zachary.manning@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Zachary Manning	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
129	alicemoore	alice.moore@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Alice Moore	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
130	allenfields	allen.fields@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Allen Fields	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
131	amirabenson	amira.benson@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Amira Benson	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
132	andresortega	andres.ortega@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Andres Ortega	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
133	angelacastro	angela.castro@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Angela Castro	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
134	annaunderwood	anna.underwood@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Anna Underwood	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
135	anniekelly	annie.kelly@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Annie Kelly	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
136	arianastone	ariana.stone@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Ariana Stone	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
137	arthurtownsend	arthur.townsend@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Arthur Townsend	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
138	ashleybryan	ashley.bryan@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Ashley Bryan	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
139	bellaosborne	bella.osborne@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Bella Osborne	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
140	benedictcrowe	benedict.crowe@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Benedict Crowe	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
141	bertramboyd	bertram.boyd@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Bertram Boyd	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
142	biancahawkins	bianca.hawkins@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Bianca Hawkins	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
143	blakehardy	blake.hardy@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Blake Hardy	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
144	bridgetweaver	bridget.weaver@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Bridget Weaver	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
145	brittanygraves	brittany.graves@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Brittany Graves	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
146	brooksholman	brooks.holman@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Brooks Holman	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
147	brucewebb	bruce.webb@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Bruce Webb	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
148	brysonbarrett	bryson.barrett@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Bryson Barrett	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
149	cadejordan	cade.jordan@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Cade Jordan	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
150	calvinbeck	calvin.beck@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Calvin Beck	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
151	candacehall	candace.hall2@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Candace Hall	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
152	carlosvazquez	carlos.vazquez@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Carlos Vazquez	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
153	carolinagilbert	carolina.gilbert@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Carolina Gilbert	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
154	celinelucas	celine.lucas@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Celine Lucas	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
155	chanelwatson	chanel.watson@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Chanel Watson	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
156	charlesgrant	charles.grant@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Charles Grant	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
157	clarissaolsen	clarissa.olsen@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Clarissa Olsen	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
158	claudiapratt	claudia.pratt@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Claudia Pratt	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
159	codypayne	cody.payne@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Cody Payne	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
160	connorblake	connor.blake@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Connor Blake	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
161	coreyschultz	corey.schultz@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Corey Schultz	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
162	courtneyflowers	courtney.flowers@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Courtney Flowers	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
163	craigwalsh	craig.walsh@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Craig Walsh	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
164	crystalvaughn	crystal.vaughn@outlook.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Crystal Vaughn	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
165	curtispatton	curtis.patton@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Curtis Patton	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
166	cyruscaldwell	cyrus.caldwell@hotmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Cyrus Caldwell	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
167	daisymoss	daisy.moss@proton.me	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Daisy Moss	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
168	dakotajames	dakota.james@gmail.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Dakota James	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
169	dariuspope	darius.pope@yahoo.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Darius Pope	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
170	dashiellcrane	dashiell.crane@icloud.com	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Dashiell Crane	t	2026-05-30 12:44:03.771927+00	2026-05-30 12:44:03.771927+00
171	bwalczyk	bwalczyk@example.com	$2y$10$sQIJ2sUUDUqSpYfaMJ3TmukmPXNag6loss8zJC9UEKv3j/X.huomO	Bartosz Walczyk	t	2026-06-12 14:52:28.397258+00	2026-06-12 14:52:28.397258+00
\.


--
-- Name: expenses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: docker
--

SELECT pg_catalog.setval('public.expenses_id_seq', 5, true);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: docker
--

SELECT pg_catalog.setval('public.groups_id_seq', 3, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: docker
--

SELECT pg_catalog.setval('public.payments_id_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: docker
--

SELECT pg_catalog.setval('public.users_id_seq', 171, true);


--
-- Name: expense_shares expense_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.expense_shares
    ADD CONSTRAINT expense_shares_pkey PRIMARY KEY (expense_id, user_id);


--
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (id);


--
-- Name: group_members group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_pkey PRIMARY KEY (group_id, user_id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: expense_shares expense_shares_expense_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.expense_shares
    ADD CONSTRAINT expense_shares_expense_id_fkey FOREIGN KEY (expense_id) REFERENCES public.expenses(id) ON DELETE CASCADE;


--
-- Name: expense_shares expense_shares_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.expense_shares
    ADD CONSTRAINT expense_shares_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: expenses expenses_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- Name: expenses expenses_paid_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_paid_by_fkey FOREIGN KEY (paid_by) REFERENCES public.users(id);


--
-- Name: group_members group_members_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- Name: group_members group_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: groups groups_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: payments payments_from_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_from_user_id_fkey FOREIGN KEY (from_user_id) REFERENCES public.users(id);


--
-- Name: payments payments_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- Name: payments payments_to_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: docker
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_to_user_id_fkey FOREIGN KEY (to_user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict C3ibRdHX7KQAcq8xzMte6gDgQyNCqFcuK33yazKaAHiR8hJnKLMg9iWp0O1SJI4

