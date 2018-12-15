--
-- PostgreSQL database dump
--

-- Dumped from database version 11.1
-- Dumped by pg_dump version 11.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: platedb; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA platedb;


ALTER SCHEMA platedb OWNER TO postgres;

--
-- Name: SCHEMA platedb; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA platedb IS 'standard public schema';


--
-- Name: fibertype; Type: TYPE; Schema: platedb; Owner: postgres
--

CREATE TYPE platedb.fibertype AS ENUM (
    'GUIDE',
    'ACQUIRE',
    'TRITIUM'
);


ALTER TYPE platedb.fibertype OWNER TO postgres;

--
-- Name: expmjd(integer); Type: FUNCTION; Schema: platedb; Owner: postgres
--

CREATE FUNCTION platedb.expmjd(exposurepk integer) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT (start_time/86400)::int FROM platedb.exposure WHERE pk=exposurepk;
$$;


ALTER FUNCTION platedb.expmjd(exposurepk integer) OWNER TO postgres;

--
-- Name: pc_chartoint(character varying); Type: FUNCTION; Schema: platedb; Owner: postgres
--

CREATE FUNCTION platedb.pc_chartoint(chartoconvert character varying) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT CASE WHEN trim($1) SIMILAR TO '[0-9]+' 
        THEN CAST(trim($1) AS integer) 
    ELSE NULL END;

$_$;


ALTER FUNCTION platedb.pc_chartoint(chartoconvert character varying) OWNER TO postgres;

--
-- Name: plateid2pk(integer); Type: FUNCTION; Schema: platedb; Owner: postgres
--

CREATE FUNCTION platedb.plateid2pk(plateid integer) RETURNS bigint
    LANGUAGE sql STABLE
    AS $_$SELECT pk FROM platedb.plate WHERE plate_id=$1$_$;


ALTER FUNCTION platedb.plateid2pk(plateid integer) OWNER TO postgres;

--
-- Name: FUNCTION plateid2pk(plateid integer); Type: COMMENT; Schema: platedb; Owner: postgres
--

COMMENT ON FUNCTION platedb.plateid2pk(plateid integer) IS 'Function to convert a plate_id to the corresponding plate.pk value.';


--
-- Name: q3c_ellipse_join(double precision, double precision, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: platedb; Owner: postgres
--

CREATE FUNCTION platedb.q3c_ellipse_join(leftra double precision, leftdec double precision, rightra double precision, rightdec double precision, majoraxis double precision, axisratio double precision, pa double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT (((q3c_ang2ipix($3,$4)>=(q3c_ellipse_nearby_it($1,$2,$5,$6,$7,0))) AND (q3c_ang2ipix($3,$4)<=(q3c_ellipse_nearby_it($1,$2,$5,$6,$7,1))))
    OR ((q3c_ang2ipix($3,$4)>=(q3c_ellipse_nearby_it($1,$2,$5,$6,$7,2))) AND (q3c_ang2ipix($3,$4)<=(q3c_ellipse_nearby_it($1,$2,$5,$6,$7,3))))
    OR ((q3c_ang2ipix($3,$4)>=(q3c_ellipse_nearby_it($1,$2,$5,$6,$7,4))) AND (q3c_ang2ipix($3,$4)<=(q3c_ellipse_nearby_it($1,$2,$5,$6,$7,5))))
    OR ((q3c_ang2ipix($3,$4)>=(q3c_ellipse_nearby_it($1,$2,$5,$6,$7,6))) AND (q3c_ang2ipix($3,$4)<=(q3c_ellipse_nearby_it($1,$2,$5,$6,$7,7))))) 
    AND q3c_in_ellipse($3,$4,$1,$2,$5,$6,$7)
$_$;


ALTER FUNCTION platedb.q3c_ellipse_join(leftra double precision, leftdec double precision, rightra double precision, rightdec double precision, majoraxis double precision, axisratio double precision, pa double precision) OWNER TO postgres;

--
-- Name: q3c_ellipse_query(double precision, double precision, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: platedb; Owner: postgres
--

CREATE FUNCTION platedb.q3c_ellipse_query(ra_col double precision, dec_col double precision, ra_ell double precision, dec_ell double precision, majax double precision, axis_ratio double precision, pa double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT (
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,0,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,1,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,2,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,3,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,4,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,5,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,6,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,7,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,8,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,9,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,10,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,11,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,12,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,13,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,14,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,15,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,16,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,17,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,18,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,19,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,20,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,21,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,22,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,23,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,24,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,25,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,26,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,27,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,28,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,29,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,30,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,31,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,32,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,33,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,34,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,35,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,36,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,37,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,38,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,39,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,40,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,41,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,42,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,43,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,44,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,45,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,46,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,47,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,48,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,49,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,50,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,51,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,52,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,53,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,54,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,55,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,56,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,57,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,58,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,59,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,60,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,61,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,62,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,63,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,64,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,65,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,66,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,67,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,68,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,69,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,70,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,71,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,72,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,73,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,74,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,75,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,76,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,77,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,78,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,79,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,80,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,81,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,82,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,83,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,84,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,85,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,86,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,87,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,88,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,89,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,90,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,91,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,92,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,93,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,94,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,95,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,96,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,97,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,98,1) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,99,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,0,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,1,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,2,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,3,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,4,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,5,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,6,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,7,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,8,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,9,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,10,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,11,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,12,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,13,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,14,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,15,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,16,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,17,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,18,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,19,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,20,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,21,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,22,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,23,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,24,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,25,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,26,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,27,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,28,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,29,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,30,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,31,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,32,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,33,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,34,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,35,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,36,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,37,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,38,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,39,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,40,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,41,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,42,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,43,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,44,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,45,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,46,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,47,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,48,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,49,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,50,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,51,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,52,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,53,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,54,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,55,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,56,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,57,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,58,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,59,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,60,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,61,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,62,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,63,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,64,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,65,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,66,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,67,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,68,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,69,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,70,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,71,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,72,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,73,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,74,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,75,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,76,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,77,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,78,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,79,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,80,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,81,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,82,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,83,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,84,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,85,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,86,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,87,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,88,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,89,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,90,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,91,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,92,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,93,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,94,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,95,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,96,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,97,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_ellipse_query_it($3,$4,$5,$6,$7,98,0) AND q3c_ang2ipix($1,$2)<q3c_ellipse_query_it($3,$4,$5,$6,$7,99,0)) 
)
AND q3c_in_ellipse($1,$2,$3,$4,$5,$6,$7)
$_$;


ALTER FUNCTION platedb.q3c_ellipse_query(ra_col double precision, dec_col double precision, ra_ell double precision, dec_ell double precision, majax double precision, axis_ratio double precision, pa double precision) OWNER TO postgres;

--
-- Name: q3c_ipixcenter(double precision, double precision, integer); Type: FUNCTION; Schema: platedb; Owner: postgres
--

CREATE FUNCTION platedb.q3c_ipixcenter(ra double precision, decl double precision, integer) RETURNS bigint
    LANGUAGE sql
    AS $_$SELECT ((q3c_ang2ipix($1,$2))>>((2*$3))<<((2*$3))) +
			((1::bigint)<<(2*($3-1))) -1$_$;


ALTER FUNCTION platedb.q3c_ipixcenter(ra double precision, decl double precision, integer) OWNER TO postgres;

--
-- Name: q3c_join(double precision, double precision, real, real, double precision); Type: FUNCTION; Schema: platedb; Owner: postgres
--

CREATE FUNCTION platedb.q3c_join(leftra double precision, leftdec double precision, rightra real, rightdec real, radius double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT (((q3c_ang2ipix($3,$4)>=(q3c_nearby_it($1,$2,$5,0))) AND (q3c_ang2ipix($3,$4)<=(q3c_nearby_it($1,$2,$5,1))))
    OR ((q3c_ang2ipix($3,$4)>=(q3c_nearby_it($1,$2,$5,2))) AND (q3c_ang2ipix($3,$4)<=(q3c_nearby_it($1,$2,$5,3))))
    OR ((q3c_ang2ipix($3,$4)>=(q3c_nearby_it($1,$2,$5,4))) AND (q3c_ang2ipix($3,$4)<=(q3c_nearby_it($1,$2,$5,5))))
    OR ((q3c_ang2ipix($3,$4)>=(q3c_nearby_it($1,$2,$5,6))) AND (q3c_ang2ipix($3,$4)<=(q3c_nearby_it($1,$2,$5,7))))) 
    AND q3c_sindist($1,$2,$3,$4)<POW(SIN(RADIANS($5)/2),2)
$_$;


ALTER FUNCTION platedb.q3c_join(leftra double precision, leftdec double precision, rightra real, rightdec real, radius double precision) OWNER TO postgres;

--
-- Name: q3c_join(double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: platedb; Owner: postgres
--

CREATE FUNCTION platedb.q3c_join(leftra double precision, leftdec double precision, rightra double precision, rightdec double precision, radius double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT (((q3c_ang2ipix($3,$4)>=(q3c_nearby_it($1,$2,$5,0))) AND (q3c_ang2ipix($3,$4)<=(q3c_nearby_it($1,$2,$5,1))))
    OR ((q3c_ang2ipix($3,$4)>=(q3c_nearby_it($1,$2,$5,2))) AND (q3c_ang2ipix($3,$4)<=(q3c_nearby_it($1,$2,$5,3))))
    OR ((q3c_ang2ipix($3,$4)>=(q3c_nearby_it($1,$2,$5,4))) AND (q3c_ang2ipix($3,$4)<=(q3c_nearby_it($1,$2,$5,5))))
    OR ((q3c_ang2ipix($3,$4)>=(q3c_nearby_it($1,$2,$5,6))) AND (q3c_ang2ipix($3,$4)<=(q3c_nearby_it($1,$2,$5,7))))) 
    AND q3c_sindist($1,$2,$3,$4)<POW(SIN(RADIANS($5)/2),2)
$_$;


ALTER FUNCTION platedb.q3c_join(leftra double precision, leftdec double precision, rightra double precision, rightdec double precision, radius double precision) OWNER TO postgres;

--
-- Name: q3c_join(double precision, double precision, double precision, double precision, bigint, double precision); Type: FUNCTION; Schema: platedb; Owner: postgres
--

CREATE FUNCTION platedb.q3c_join(double precision, double precision, double precision, double precision, bigint, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT ((($5>=(q3c_nearby_it($1,$2,$6,0))) AND ($5<=(q3c_nearby_it($1,$2,$6,1))))
    OR (($5>=(q3c_nearby_it($1,$2,$6,2))) AND ($5<=(q3c_nearby_it($1,$2,$6,3))))
    OR (($5>=(q3c_nearby_it($1,$2,$6,4))) AND ($5<=(q3c_nearby_it($1,$2,$6,5))))
    OR (($5>=(q3c_nearby_it($1,$2,$6,6))) AND ($5<=(q3c_nearby_it($1,$2,$6,7))))) 
    AND q3c_sindist($1,$2,$3,$4)<POW(SIN(RADIANS($6)/2),2)
$_$;


ALTER FUNCTION platedb.q3c_join(double precision, double precision, double precision, double precision, bigint, double precision) OWNER TO postgres;

--
-- Name: q3c_poly_query(real, real, double precision[]); Type: FUNCTION; Schema: platedb; Owner: postgres
--

CREATE FUNCTION platedb.q3c_poly_query(real, real, double precision[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT (
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,0,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,1,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,2,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,3,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,4,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,5,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,6,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,7,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,8,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,9,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,10,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,11,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,12,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,13,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,14,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,15,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,16,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,17,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,18,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,19,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,20,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,21,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,22,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,23,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,24,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,25,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,26,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,27,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,28,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,29,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,30,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,31,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,32,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,33,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,34,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,35,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,36,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,37,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,38,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,39,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,40,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,41,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,42,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,43,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,44,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,45,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,46,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,47,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,48,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,49,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,50,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,51,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,52,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,53,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,54,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,55,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,56,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,57,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,58,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,59,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,60,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,61,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,62,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,63,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,64,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,65,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,66,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,67,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,68,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,69,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,70,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,71,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,72,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,73,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,74,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,75,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,76,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,77,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,78,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,79,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,80,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,81,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,82,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,83,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,84,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,85,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,86,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,87,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,88,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,89,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,0,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,1,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,2,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,3,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,4,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,5,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,6,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,7,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,8,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,9,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,10,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,11,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,12,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,13,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,14,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,15,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,16,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,17,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,18,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,19,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,20,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,21,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,22,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,23,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,24,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,25,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,26,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,27,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,28,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,29,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,30,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,31,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,32,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,33,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,34,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,35,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,36,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,37,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,38,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,39,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,40,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,41,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,42,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,43,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,44,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,45,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,46,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,47,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,48,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,49,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,50,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,51,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,52,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,53,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,54,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,55,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,56,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,57,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,58,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,59,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,60,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,61,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,62,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,63,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,64,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,65,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,66,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,67,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,68,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,69,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,70,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,71,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,72,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,73,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,74,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,75,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,76,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,77,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,78,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,79,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,80,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,81,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,82,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,83,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,84,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,85,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,86,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,87,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,88,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,89,0)) 
)
AND  q3c_in_poly($1,$2,$3);
$_$;


ALTER FUNCTION platedb.q3c_poly_query(real, real, double precision[]) OWNER TO postgres;

--
-- Name: q3c_poly_query(double precision, double precision, double precision[]); Type: FUNCTION; Schema: platedb; Owner: postgres
--

CREATE FUNCTION platedb.q3c_poly_query(double precision, double precision, double precision[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT (
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,0,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,1,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,2,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,3,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,4,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,5,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,6,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,7,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,8,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,9,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,10,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,11,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,12,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,13,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,14,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,15,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,16,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,17,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,18,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,19,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,20,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,21,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,22,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,23,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,24,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,25,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,26,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,27,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,28,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,29,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,30,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,31,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,32,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,33,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,34,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,35,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,36,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,37,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,38,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,39,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,40,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,41,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,42,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,43,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,44,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,45,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,46,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,47,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,48,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,49,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,50,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,51,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,52,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,53,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,54,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,55,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,56,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,57,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,58,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,59,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,60,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,61,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,62,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,63,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,64,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,65,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,66,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,67,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,68,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,69,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,70,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,71,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,72,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,73,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,74,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,75,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,76,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,77,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,78,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,79,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,80,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,81,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,82,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,83,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,84,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,85,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,86,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,87,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,88,1) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,89,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,0,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,1,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,2,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,3,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,4,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,5,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,6,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,7,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,8,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,9,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,10,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,11,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,12,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,13,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,14,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,15,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,16,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,17,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,18,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,19,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,20,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,21,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,22,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,23,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,24,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,25,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,26,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,27,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,28,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,29,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,30,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,31,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,32,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,33,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,34,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,35,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,36,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,37,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,38,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,39,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,40,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,41,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,42,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,43,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,44,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,45,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,46,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,47,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,48,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,49,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,50,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,51,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,52,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,53,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,54,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,55,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,56,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,57,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,58,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,59,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,60,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,61,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,62,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,63,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,64,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,65,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,66,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,67,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,68,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,69,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,70,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,71,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,72,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,73,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,74,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,75,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,76,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,77,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,78,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,79,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,80,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,81,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,82,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,83,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,84,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,85,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,86,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,87,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_poly_query_it($3,88,0) AND q3c_ang2ipix($1,$2)<q3c_poly_query_it($3,89,0)) 
)
AND  q3c_in_poly($1,$2,$3);
$_$;


ALTER FUNCTION platedb.q3c_poly_query(double precision, double precision, double precision[]) OWNER TO postgres;

--
-- Name: q3c_radial_query(real, real, double precision, double precision, double precision); Type: FUNCTION; Schema: platedb; Owner: postgres
--

CREATE FUNCTION platedb.q3c_radial_query(real, real, double precision, double precision, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT ((
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,0,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,1,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,2,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,3,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,4,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,5,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,6,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,7,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,8,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,9,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,10,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,11,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,12,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,13,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,14,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,15,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,16,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,17,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,18,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,19,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,20,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,21,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,22,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,23,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,24,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,25,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,26,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,27,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,28,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,29,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,30,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,31,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,32,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,33,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,34,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,35,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,36,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,37,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,38,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,39,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,40,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,41,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,42,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,43,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,44,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,45,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,46,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,47,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,48,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,49,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,50,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,51,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,52,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,53,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,54,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,55,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,56,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,57,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,58,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,59,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,60,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,61,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,62,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,63,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,64,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,65,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,66,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,67,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,68,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,69,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,70,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,71,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,72,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,73,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,74,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,75,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,76,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,77,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,78,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,79,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,80,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,81,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,82,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,83,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,84,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,85,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,86,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,87,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,88,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,89,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,90,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,91,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,92,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,93,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,94,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,95,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,96,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,97,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,98,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,99,1)) 
) OR (
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,0,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,1,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,2,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,3,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,4,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,5,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,6,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,7,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,8,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,9,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,10,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,11,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,12,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,13,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,14,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,15,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,16,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,17,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,18,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,19,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,20,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,21,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,22,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,23,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,24,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,25,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,26,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,27,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,28,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,29,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,30,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,31,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,32,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,33,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,34,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,35,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,36,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,37,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,38,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,39,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,40,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,41,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,42,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,43,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,44,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,45,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,46,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,47,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,48,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,49,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,50,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,51,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,52,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,53,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,54,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,55,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,56,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,57,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,58,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,59,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,60,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,61,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,62,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,63,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,64,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,65,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,66,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,67,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,68,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,69,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,70,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,71,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,72,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,73,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,74,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,75,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,76,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,77,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,78,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,79,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,80,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,81,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,82,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,83,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,84,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,85,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,86,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,87,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,88,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,89,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,90,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,91,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,92,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,93,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,94,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,95,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,96,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,97,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,98,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,99,0)) 
)
 AND q3c_sindist($1,$2,$3,$4)<POW(SIN(RADIANS($5)/2),2)
)
$_$;


ALTER FUNCTION platedb.q3c_radial_query(real, real, double precision, double precision, double precision) OWNER TO postgres;

--
-- Name: q3c_radial_query(double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: platedb; Owner: postgres
--

CREATE FUNCTION platedb.q3c_radial_query(double precision, double precision, double precision, double precision, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT ((
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,0,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,1,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,2,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,3,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,4,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,5,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,6,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,7,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,8,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,9,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,10,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,11,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,12,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,13,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,14,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,15,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,16,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,17,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,18,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,19,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,20,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,21,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,22,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,23,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,24,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,25,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,26,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,27,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,28,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,29,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,30,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,31,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,32,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,33,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,34,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,35,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,36,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,37,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,38,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,39,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,40,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,41,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,42,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,43,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,44,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,45,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,46,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,47,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,48,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,49,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,50,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,51,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,52,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,53,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,54,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,55,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,56,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,57,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,58,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,59,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,60,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,61,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,62,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,63,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,64,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,65,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,66,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,67,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,68,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,69,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,70,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,71,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,72,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,73,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,74,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,75,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,76,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,77,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,78,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,79,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,80,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,81,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,82,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,83,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,84,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,85,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,86,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,87,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,88,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,89,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,90,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,91,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,92,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,93,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,94,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,95,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,96,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,97,1)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,98,1) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,99,1)) 
) OR (
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,0,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,1,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,2,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,3,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,4,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,5,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,6,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,7,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,8,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,9,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,10,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,11,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,12,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,13,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,14,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,15,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,16,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,17,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,18,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,19,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,20,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,21,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,22,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,23,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,24,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,25,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,26,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,27,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,28,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,29,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,30,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,31,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,32,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,33,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,34,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,35,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,36,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,37,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,38,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,39,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,40,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,41,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,42,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,43,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,44,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,45,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,46,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,47,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,48,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,49,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,50,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,51,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,52,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,53,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,54,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,55,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,56,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,57,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,58,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,59,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,60,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,61,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,62,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,63,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,64,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,65,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,66,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,67,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,68,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,69,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,70,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,71,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,72,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,73,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,74,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,75,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,76,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,77,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,78,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,79,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,80,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,81,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,82,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,83,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,84,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,85,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,86,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,87,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,88,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,89,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,90,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,91,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,92,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,93,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,94,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,95,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,96,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,97,0)) OR
(q3c_ang2ipix($1,$2)>=q3c_radial_query_it($3,$4,$5,98,0) AND q3c_ang2ipix($1,$2)<q3c_radial_query_it($3,$4,$5,99,0)) 
)
 AND q3c_sindist($1,$2,$3,$4)<POW(SIN(RADIANS($5)/2),2)
)
$_$;


ALTER FUNCTION platedb.q3c_radial_query(double precision, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- Name: q3c_radial_query(bigint, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: platedb; Owner: postgres
--

CREATE FUNCTION platedb.q3c_radial_query(bigint, double precision, double precision, double precision, double precision, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT ((
($1>=q3c_radial_query_it($4,$5,$6,0,1) AND $1<q3c_radial_query_it($4,$5,$6,1,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,2,1) AND $1<q3c_radial_query_it($4,$5,$6,3,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,4,1) AND $1<q3c_radial_query_it($4,$5,$6,5,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,6,1) AND $1<q3c_radial_query_it($4,$5,$6,7,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,8,1) AND $1<q3c_radial_query_it($4,$5,$6,9,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,10,1) AND $1<q3c_radial_query_it($4,$5,$6,11,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,12,1) AND $1<q3c_radial_query_it($4,$5,$6,13,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,14,1) AND $1<q3c_radial_query_it($4,$5,$6,15,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,16,1) AND $1<q3c_radial_query_it($4,$5,$6,17,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,18,1) AND $1<q3c_radial_query_it($4,$5,$6,19,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,20,1) AND $1<q3c_radial_query_it($4,$5,$6,21,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,22,1) AND $1<q3c_radial_query_it($4,$5,$6,23,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,24,1) AND $1<q3c_radial_query_it($4,$5,$6,25,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,26,1) AND $1<q3c_radial_query_it($4,$5,$6,27,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,28,1) AND $1<q3c_radial_query_it($4,$5,$6,29,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,30,1) AND $1<q3c_radial_query_it($4,$5,$6,31,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,32,1) AND $1<q3c_radial_query_it($4,$5,$6,33,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,34,1) AND $1<q3c_radial_query_it($4,$5,$6,35,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,36,1) AND $1<q3c_radial_query_it($4,$5,$6,37,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,38,1) AND $1<q3c_radial_query_it($4,$5,$6,39,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,40,1) AND $1<q3c_radial_query_it($4,$5,$6,41,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,42,1) AND $1<q3c_radial_query_it($4,$5,$6,43,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,44,1) AND $1<q3c_radial_query_it($4,$5,$6,45,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,46,1) AND $1<q3c_radial_query_it($4,$5,$6,47,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,48,1) AND $1<q3c_radial_query_it($4,$5,$6,49,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,50,1) AND $1<q3c_radial_query_it($4,$5,$6,51,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,52,1) AND $1<q3c_radial_query_it($4,$5,$6,53,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,54,1) AND $1<q3c_radial_query_it($4,$5,$6,55,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,56,1) AND $1<q3c_radial_query_it($4,$5,$6,57,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,58,1) AND $1<q3c_radial_query_it($4,$5,$6,59,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,60,1) AND $1<q3c_radial_query_it($4,$5,$6,61,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,62,1) AND $1<q3c_radial_query_it($4,$5,$6,63,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,64,1) AND $1<q3c_radial_query_it($4,$5,$6,65,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,66,1) AND $1<q3c_radial_query_it($4,$5,$6,67,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,68,1) AND $1<q3c_radial_query_it($4,$5,$6,69,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,70,1) AND $1<q3c_radial_query_it($4,$5,$6,71,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,72,1) AND $1<q3c_radial_query_it($4,$5,$6,73,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,74,1) AND $1<q3c_radial_query_it($4,$5,$6,75,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,76,1) AND $1<q3c_radial_query_it($4,$5,$6,77,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,78,1) AND $1<q3c_radial_query_it($4,$5,$6,79,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,80,1) AND $1<q3c_radial_query_it($4,$5,$6,81,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,82,1) AND $1<q3c_radial_query_it($4,$5,$6,83,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,84,1) AND $1<q3c_radial_query_it($4,$5,$6,85,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,86,1) AND $1<q3c_radial_query_it($4,$5,$6,87,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,88,1) AND $1<q3c_radial_query_it($4,$5,$6,89,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,90,1) AND $1<q3c_radial_query_it($4,$5,$6,91,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,92,1) AND $1<q3c_radial_query_it($4,$5,$6,93,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,94,1) AND $1<q3c_radial_query_it($4,$5,$6,95,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,96,1) AND $1<q3c_radial_query_it($4,$5,$6,97,1)) OR
($1>=q3c_radial_query_it($4,$5,$6,98,1) AND $1<q3c_radial_query_it($4,$5,$6,99,1)) 
) OR (
($1>=q3c_radial_query_it($4,$5,$6,0,0) AND $1<q3c_radial_query_it($4,$5,$6,1,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,2,0) AND $1<q3c_radial_query_it($4,$5,$6,3,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,4,0) AND $1<q3c_radial_query_it($4,$5,$6,5,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,6,0) AND $1<q3c_radial_query_it($4,$5,$6,7,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,8,0) AND $1<q3c_radial_query_it($4,$5,$6,9,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,10,0) AND $1<q3c_radial_query_it($4,$5,$6,11,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,12,0) AND $1<q3c_radial_query_it($4,$5,$6,13,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,14,0) AND $1<q3c_radial_query_it($4,$5,$6,15,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,16,0) AND $1<q3c_radial_query_it($4,$5,$6,17,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,18,0) AND $1<q3c_radial_query_it($4,$5,$6,19,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,20,0) AND $1<q3c_radial_query_it($4,$5,$6,21,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,22,0) AND $1<q3c_radial_query_it($4,$5,$6,23,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,24,0) AND $1<q3c_radial_query_it($4,$5,$6,25,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,26,0) AND $1<q3c_radial_query_it($4,$5,$6,27,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,28,0) AND $1<q3c_radial_query_it($4,$5,$6,29,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,30,0) AND $1<q3c_radial_query_it($4,$5,$6,31,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,32,0) AND $1<q3c_radial_query_it($4,$5,$6,33,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,34,0) AND $1<q3c_radial_query_it($4,$5,$6,35,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,36,0) AND $1<q3c_radial_query_it($4,$5,$6,37,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,38,0) AND $1<q3c_radial_query_it($4,$5,$6,39,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,40,0) AND $1<q3c_radial_query_it($4,$5,$6,41,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,42,0) AND $1<q3c_radial_query_it($4,$5,$6,43,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,44,0) AND $1<q3c_radial_query_it($4,$5,$6,45,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,46,0) AND $1<q3c_radial_query_it($4,$5,$6,47,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,48,0) AND $1<q3c_radial_query_it($4,$5,$6,49,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,50,0) AND $1<q3c_radial_query_it($4,$5,$6,51,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,52,0) AND $1<q3c_radial_query_it($4,$5,$6,53,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,54,0) AND $1<q3c_radial_query_it($4,$5,$6,55,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,56,0) AND $1<q3c_radial_query_it($4,$5,$6,57,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,58,0) AND $1<q3c_radial_query_it($4,$5,$6,59,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,60,0) AND $1<q3c_radial_query_it($4,$5,$6,61,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,62,0) AND $1<q3c_radial_query_it($4,$5,$6,63,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,64,0) AND $1<q3c_radial_query_it($4,$5,$6,65,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,66,0) AND $1<q3c_radial_query_it($4,$5,$6,67,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,68,0) AND $1<q3c_radial_query_it($4,$5,$6,69,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,70,0) AND $1<q3c_radial_query_it($4,$5,$6,71,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,72,0) AND $1<q3c_radial_query_it($4,$5,$6,73,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,74,0) AND $1<q3c_radial_query_it($4,$5,$6,75,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,76,0) AND $1<q3c_radial_query_it($4,$5,$6,77,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,78,0) AND $1<q3c_radial_query_it($4,$5,$6,79,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,80,0) AND $1<q3c_radial_query_it($4,$5,$6,81,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,82,0) AND $1<q3c_radial_query_it($4,$5,$6,83,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,84,0) AND $1<q3c_radial_query_it($4,$5,$6,85,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,86,0) AND $1<q3c_radial_query_it($4,$5,$6,87,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,88,0) AND $1<q3c_radial_query_it($4,$5,$6,89,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,90,0) AND $1<q3c_radial_query_it($4,$5,$6,91,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,92,0) AND $1<q3c_radial_query_it($4,$5,$6,93,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,94,0) AND $1<q3c_radial_query_it($4,$5,$6,95,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,96,0) AND $1<q3c_radial_query_it($4,$5,$6,97,0)) OR
($1>=q3c_radial_query_it($4,$5,$6,98,0) AND $1<q3c_radial_query_it($4,$5,$6,99,0)) 
)
 AND q3c_sindist($2,$3,$4,$5)<POW(SIN(RADIANS($6)/2),2)
)
$_$;


ALTER FUNCTION platedb.q3c_radial_query(bigint, double precision, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- Name: active_plugging_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.active_plugging_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.active_plugging_pk_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_plugging; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.active_plugging (
    pk integer DEFAULT nextval('platedb.active_plugging_pk_seq'::regclass) NOT NULL,
    plugging_pk integer NOT NULL
);


ALTER TABLE platedb.active_plugging OWNER TO postgres;

--
-- Name: apogee_threshold; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.apogee_threshold (
    pk integer NOT NULL
);


ALTER TABLE platedb.apogee_threshold OWNER TO postgres;

--
-- Name: apogee_threshold_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.apogee_threshold_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.apogee_threshold_pk_seq OWNER TO postgres;

--
-- Name: apogee_threshold_pk_seq; Type: SEQUENCE OWNED BY; Schema: platedb; Owner: postgres
--

ALTER SEQUENCE platedb.apogee_threshold_pk_seq OWNED BY platedb.apogee_threshold.pk;


--
-- Name: boss_plugging_info_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.boss_plugging_info_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.boss_plugging_info_seq OWNER TO postgres;

--
-- Name: boss_plugging_info; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.boss_plugging_info (
    pk integer DEFAULT nextval('platedb.boss_plugging_info_seq'::regclass) NOT NULL,
    first_dr text,
    plugging_pk integer NOT NULL
);


ALTER TABLE platedb.boss_plugging_info OWNER TO postgres;

--
-- Name: boss_sn2_threshold_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.boss_sn2_threshold_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.boss_sn2_threshold_seq OWNER TO postgres;

--
-- Name: boss_sn2_threshold; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.boss_sn2_threshold (
    pk integer DEFAULT nextval('platedb.boss_sn2_threshold_seq'::regclass) NOT NULL,
    camera_pk integer NOT NULL,
    sn2_threshold numeric NOT NULL,
    min_exposures integer,
    sn2_min numeric,
    version integer
);


ALTER TABLE platedb.boss_sn2_threshold OWNER TO postgres;

--
-- Name: camera_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.camera_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.camera_seq OWNER TO postgres;

--
-- Name: camera; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.camera (
    pk integer DEFAULT nextval('platedb.camera_seq'::regclass) NOT NULL,
    instrument_pk integer,
    label text
);


ALTER TABLE platedb.camera OWNER TO postgres;

--
-- Name: camera_frame_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.camera_frame_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.camera_frame_pk_seq OWNER TO postgres;

--
-- Name: camera_frame; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.camera_frame (
    pk integer DEFAULT nextval('platedb.camera_frame_pk_seq'::regclass) NOT NULL,
    sn2 numeric,
    camera_pk integer NOT NULL,
    comment text,
    exposure_pk integer NOT NULL
);


ALTER TABLE platedb.camera_frame OWNER TO postgres;

--
-- Name: cartridge_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.cartridge_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.cartridge_seq OWNER TO postgres;

--
-- Name: cartridge; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.cartridge (
    pk integer DEFAULT nextval('platedb.cartridge_seq'::regclass) NOT NULL,
    number smallint,
    broken_fibers text,
    guide_fiber_throughput numeric,
    online boolean DEFAULT true NOT NULL
);


ALTER TABLE platedb.cartridge OWNER TO postgres;

--
-- Name: cartridge_detail_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.cartridge_detail_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.cartridge_detail_seq OWNER TO postgres;

--
-- Name: cartridge_to_survey; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.cartridge_to_survey (
    cartridge_pk integer NOT NULL,
    survey_pk integer NOT NULL
);


ALTER TABLE platedb.cartridge_to_survey OWNER TO postgres;

--
-- Name: cmm_meas; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.cmm_meas (
    pk integer NOT NULL,
    plate_pk bigint,
    cmmfilename text,
    date date,
    fitoffsetx numeric,
    fitoffsety numeric,
    fitrot numeric,
    fitscale numeric,
    fitqpmag numeric,
    fitqpang numeric
);


ALTER TABLE platedb.cmm_meas OWNER TO postgres;

--
-- Name: cmm_meas_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.cmm_meas_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.cmm_meas_pk_seq OWNER TO postgres;

--
-- Name: cmm_meas_pk_seq; Type: SEQUENCE OWNED BY; Schema: platedb; Owner: postgres
--

ALTER SEQUENCE platedb.cmm_meas_pk_seq OWNED BY platedb.cmm_meas.pk;


--
-- Name: constants; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.constants (
    name character varying NOT NULL,
    value character varying
);


ALTER TABLE platedb.constants OWNER TO postgres;

--
-- Name: TABLE constants; Type: COMMENT; Schema: platedb; Owner: postgres
--

COMMENT ON TABLE platedb.constants IS 'Constants describing the system, e.g. the gcamFiberInfo file loaded into the gprobe table';


--
-- Name: design_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.design_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.design_pk_seq OWNER TO postgres;

--
-- Name: design; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.design (
    pk bigint DEFAULT nextval('platedb.design_pk_seq'::regclass) NOT NULL,
    comment text
);


ALTER TABLE platedb.design OWNER TO postgres;

--
-- Name: design_field_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.design_field_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.design_field_seq OWNER TO postgres;

--
-- Name: design_field; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.design_field (
    pk bigint DEFAULT nextval('platedb.design_field_seq'::regclass) NOT NULL,
    label text NOT NULL
);


ALTER TABLE platedb.design_field OWNER TO postgres;

--
-- Name: design_values_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.design_values_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.design_values_pk_seq OWNER TO postgres;

--
-- Name: design_value; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.design_value (
    pk bigint DEFAULT nextval('platedb.design_values_pk_seq'::regclass) NOT NULL,
    design_pk bigint,
    design_field_pk bigint,
    value text
);


ALTER TABLE platedb.design_value OWNER TO postgres;

--
-- Name: definition_view; Type: VIEW; Schema: platedb; Owner: postgres
--

CREATE VIEW platedb.definition_view AS
 SELECT d.pk AS design_id,
    df.label AS field,
    dv.value
   FROM ((platedb.design d
     JOIN platedb.design_value dv ON ((d.pk = dv.design_pk)))
     JOIN platedb.design_field df ON ((dv.design_field_pk = df.pk)));


ALTER TABLE platedb.definition_view OWNER TO postgres;

--
-- Name: plate_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plate_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plate_pk_seq OWNER TO postgres;

--
-- Name: plate; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate (
    pk bigint DEFAULT nextval('platedb.plate_pk_seq'::regclass) NOT NULL,
    plate_id integer NOT NULL,
    design_pk bigint,
    location_id bigint,
    comment text,
    plate_location_pk integer DEFAULT 0 NOT NULL,
    temperature numeric,
    epoch numeric,
    rerun text,
    plate_run_pk integer,
    tile_id smallint,
    name text,
    chunk text,
    tile_pk integer,
    plate_completion_status_pk integer DEFAULT 0,
    current_survey_mode_pk integer
);


ALTER TABLE platedb.plate OWNER TO postgres;

--
-- Name: plate_pointing_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plate_pointing_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plate_pointing_seq OWNER TO postgres;

--
-- Name: plate_pointing; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate_pointing (
    pk integer DEFAULT nextval('platedb.plate_pointing_seq'::regclass) NOT NULL,
    hour_angle numeric,
    plate_pk integer,
    pointing_pk integer,
    pointing_name "char" NOT NULL,
    priority smallint DEFAULT 2 NOT NULL,
    ha_observable_min numeric,
    ha_observable_max numeric
);


ALTER TABLE platedb.plate_pointing OWNER TO postgres;

--
-- Name: pointing_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.pointing_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.pointing_seq OWNER TO postgres;

--
-- Name: pointing; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.pointing (
    pk bigint DEFAULT nextval('platedb.pointing_seq'::regclass) NOT NULL,
    design_pk bigint NOT NULL,
    center_ra numeric,
    center_dec numeric,
    pointing_no integer
);


ALTER TABLE platedb.pointing OWNER TO postgres;

--
-- Name: designview; Type: VIEW; Schema: platedb; Owner: postgres
--

CREATE VIEW platedb.designview AS
 SELECT design.pk AS design_pk,
    pointing.center_ra,
    pointing.center_dec,
    plate_pointing.hour_angle,
    plate.plate_id,
    pointing.pointing_no AS no,
    plate_pointing.pointing_name AS name
   FROM (((platedb.design
     JOIN platedb.pointing ON ((design.pk = pointing.design_pk)))
     JOIN platedb.plate_pointing ON ((pointing.pk = plate_pointing.pointing_pk)))
     JOIN platedb.plate ON ((plate.pk = plate_pointing.plate_pk)))
  ORDER BY design.pk, pointing.pointing_no;


ALTER TABLE platedb.designview OWNER TO postgres;

--
-- Name: exposure_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.exposure_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.exposure_seq OWNER TO postgres;

--
-- Name: exposure; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.exposure (
    pk integer DEFAULT nextval('platedb.exposure_seq'::regclass) NOT NULL,
    observation_pk integer,
    exposure_no integer,
    survey_pk integer,
    camera_pk integer,
    comment text,
    exposure_status_pk smallint DEFAULT 1 NOT NULL,
    exposure_flavor_pk smallint,
    start_time numeric,
    exposure_time numeric,
    survey_mode_pk integer
);


ALTER TABLE platedb.exposure OWNER TO postgres;

--
-- Name: exposure_flavor; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.exposure_flavor (
    pk smallint NOT NULL,
    label text NOT NULL
);


ALTER TABLE platedb.exposure_flavor OWNER TO postgres;

--
-- Name: exposure_flavor_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.exposure_flavor_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.exposure_flavor_pk_seq OWNER TO postgres;

--
-- Name: exposure_header_keyword; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.exposure_header_keyword (
    pk integer NOT NULL,
    label text NOT NULL
);


ALTER TABLE platedb.exposure_header_keyword OWNER TO postgres;

--
-- Name: exposure_header_keyword_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.exposure_header_keyword_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.exposure_header_keyword_pk_seq OWNER TO postgres;

--
-- Name: exposure_header_keyword_pk_seq; Type: SEQUENCE OWNED BY; Schema: platedb; Owner: postgres
--

ALTER SEQUENCE platedb.exposure_header_keyword_pk_seq OWNED BY platedb.exposure_header_keyword.pk;


--
-- Name: exposure_header_value; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.exposure_header_value (
    pk integer NOT NULL,
    value text NOT NULL,
    comment text,
    index smallint NOT NULL,
    exposure_pk integer NOT NULL,
    exposure_header_keyword_pk integer NOT NULL
);


ALTER TABLE platedb.exposure_header_value OWNER TO postgres;

--
-- Name: exposure_header_value_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.exposure_header_value_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.exposure_header_value_pk_seq OWNER TO postgres;

--
-- Name: exposure_header_value_pk_seq; Type: SEQUENCE OWNED BY; Schema: platedb; Owner: postgres
--

ALTER SEQUENCE platedb.exposure_header_value_pk_seq OWNED BY platedb.exposure_header_value.pk;


--
-- Name: exposure_status; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.exposure_status (
    pk smallint NOT NULL,
    label text NOT NULL
);


ALTER TABLE platedb.exposure_status OWNER TO postgres;

--
-- Name: fiber; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.fiber (
    pk integer NOT NULL,
    fiber_id integer NOT NULL,
    pl_plugmap_m_pk integer NOT NULL,
    plate_hole_pk integer NOT NULL
);


ALTER TABLE platedb.fiber OWNER TO postgres;

--
-- Name: fiber_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.fiber_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.fiber_pk_seq OWNER TO postgres;

--
-- Name: fiber_pk_seq; Type: SEQUENCE OWNED BY; Schema: platedb; Owner: postgres
--

ALTER SEQUENCE platedb.fiber_pk_seq OWNED BY platedb.fiber.pk;


--
-- Name: gprobe_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.gprobe_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.gprobe_seq OWNER TO postgres;

--
-- Name: gprobe; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.gprobe (
    pk integer DEFAULT nextval('platedb.gprobe_seq'::regclass) NOT NULL,
    cartridge_pk integer,
    "exists" integer,
    gprobe_id integer,
    x_center numeric,
    y_center numeric,
    radius numeric,
    rotation numeric,
    x_ferrule_offset numeric,
    y_ferrule_offset numeric,
    focus_offset numeric,
    fiber_type platedb.fibertype DEFAULT 'GUIDE'::platedb.fibertype NOT NULL
);


ALTER TABLE platedb.gprobe OWNER TO postgres;

--
-- Name: hole_meas; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.hole_meas (
    pk integer NOT NULL,
    plate_hole_pk bigint,
    cmm_meas_pk bigint,
    nomdia numeric,
    diaerr numeric,
    nomx numeric,
    nomy numeric,
    measx numeric,
    measy numeric,
    residx numeric,
    residy numeric,
    residr numeric,
    qpresidx numeric,
    qpresidy numeric,
    qpresidr numeric
);


ALTER TABLE platedb.hole_meas OWNER TO postgres;

--
-- Name: hole_meas_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.hole_meas_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.hole_meas_pk_seq OWNER TO postgres;

--
-- Name: hole_meas_pk_seq; Type: SEQUENCE OWNED BY; Schema: platedb; Owner: postgres
--

ALTER SEQUENCE platedb.hole_meas_pk_seq OWNED BY platedb.hole_meas.pk;


--
-- Name: instrument_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.instrument_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.instrument_pk_seq OWNER TO postgres;

--
-- Name: instrument; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.instrument (
    pk integer DEFAULT nextval('platedb.instrument_pk_seq'::regclass) NOT NULL,
    label text,
    short_label text
);


ALTER TABLE platedb.instrument OWNER TO postgres;

--
-- Name: object_type; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.object_type (
    pk integer NOT NULL,
    label text NOT NULL
);


ALTER TABLE platedb.object_type OWNER TO postgres;

--
-- Name: object_type_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.object_type_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.object_type_pk_seq OWNER TO postgres;

--
-- Name: object_type_pk_seq; Type: SEQUENCE OWNED BY; Schema: platedb; Owner: postgres
--

ALTER SEQUENCE platedb.object_type_pk_seq OWNED BY platedb.object_type.pk;


--
-- Name: observation_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.observation_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.observation_pk_seq OWNER TO postgres;

--
-- Name: observation; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.observation (
    pk bigint DEFAULT nextval('platedb.observation_pk_seq'::regclass) NOT NULL,
    plate_pointing_pk bigint,
    mjd numeric,
    plugging_pk integer,
    comment text,
    observation_status_pk integer DEFAULT 1 NOT NULL
);


ALTER TABLE platedb.observation OWNER TO postgres;

--
-- Name: observation_status_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.observation_status_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.observation_status_pk_seq OWNER TO postgres;

--
-- Name: observation_status; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.observation_status (
    pk integer DEFAULT nextval('platedb.observation_status_pk_seq'::regclass) NOT NULL,
    label text NOT NULL
);


ALTER TABLE platedb.observation_status OWNER TO postgres;

--
-- Name: observation_to_observation_status_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.observation_to_observation_status_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.observation_to_observation_status_pk_seq OWNER TO postgres;

--
-- Name: pl_plugmap_m_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.pl_plugmap_m_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.pl_plugmap_m_seq OWNER TO postgres;

--
-- Name: pl_plugmap_m; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.pl_plugmap_m (
    pk integer DEFAULT nextval('platedb.pl_plugmap_m_seq'::regclass) NOT NULL,
    plugging_pk integer,
    file text,
    md5_checksum text,
    filename text,
    fscan_id integer,
    dirname text,
    checked_in boolean DEFAULT false,
    fscan_mjd integer,
    pointing_name character(1)
);


ALTER TABLE platedb.pl_plugmap_m OWNER TO postgres;

--
-- Name: plate_completion_status; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate_completion_status (
    pk integer NOT NULL,
    label text
);


ALTER TABLE platedb.plate_completion_status OWNER TO postgres;

--
-- Name: plate_completion_status_history; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate_completion_status_history (
    pk integer NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    plate_pk integer NOT NULL,
    plate_completion_status_pk integer NOT NULL,
    comment text NOT NULL,
    first_name text,
    last_name text
);


ALTER TABLE platedb.plate_completion_status_history OWNER TO postgres;

--
-- Name: plate_completion_status_history_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plate_completion_status_history_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plate_completion_status_history_pk_seq OWNER TO postgres;

--
-- Name: plate_completion_status_history_pk_seq; Type: SEQUENCE OWNED BY; Schema: platedb; Owner: postgres
--

ALTER SEQUENCE platedb.plate_completion_status_history_pk_seq OWNED BY platedb.plate_completion_status_history.pk;


--
-- Name: plate_completion_status_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plate_completion_status_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plate_completion_status_pk_seq OWNER TO postgres;

--
-- Name: plate_completion_status_pk_seq; Type: SEQUENCE OWNED BY; Schema: platedb; Owner: postgres
--

ALTER SEQUENCE platedb.plate_completion_status_pk_seq OWNED BY platedb.plate_completion_status.pk;


--
-- Name: plate_hole; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate_hole (
    pk integer NOT NULL,
    plate_holes_file_pk integer,
    xfocal numeric,
    yfocal numeric,
    pointing_number smallint,
    plate_hole_type_pk integer,
    object_type_pk integer,
    catalog_object_pk integer,
    tmass_h numeric,
    apogee_target1 integer,
    apogee_target2 integer,
    tmass_j numeric,
    tmass_k numeric
);


ALTER TABLE platedb.plate_hole OWNER TO postgres;

--
-- Name: plate_hole_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plate_hole_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plate_hole_pk_seq OWNER TO postgres;

--
-- Name: plate_hole_pk_seq; Type: SEQUENCE OWNED BY; Schema: platedb; Owner: postgres
--

ALTER SEQUENCE platedb.plate_hole_pk_seq OWNED BY platedb.plate_hole.pk;


--
-- Name: plate_hole_type; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate_hole_type (
    pk integer NOT NULL,
    label text NOT NULL
);


ALTER TABLE platedb.plate_hole_type OWNER TO postgres;

--
-- Name: plate_hole_type_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plate_hole_type_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plate_hole_type_pk_seq OWNER TO postgres;

--
-- Name: plate_hole_type_pk_seq; Type: SEQUENCE OWNED BY; Schema: platedb; Owner: postgres
--

ALTER SEQUENCE platedb.plate_hole_type_pk_seq OWNED BY platedb.plate_hole_type.pk;


--
-- Name: plate_holes_file; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate_holes_file (
    pk integer NOT NULL,
    filename text NOT NULL,
    plate_pk integer NOT NULL
);


ALTER TABLE platedb.plate_holes_file OWNER TO postgres;

--
-- Name: plate_holes_file_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plate_holes_file_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plate_holes_file_pk_seq OWNER TO postgres;

--
-- Name: plate_holes_file_pk_seq; Type: SEQUENCE OWNED BY; Schema: platedb; Owner: postgres
--

ALTER SEQUENCE platedb.plate_holes_file_pk_seq OWNED BY platedb.plate_holes_file.pk;


--
-- Name: plate_input_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plate_input_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plate_input_pk_seq OWNER TO postgres;

--
-- Name: plate_input; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate_input (
    pk bigint DEFAULT nextval('platedb.plate_input_pk_seq'::regclass) NOT NULL,
    design_pk bigint,
    input_number integer,
    filepath text,
    priority integer,
    comment text,
    md5_checksum text
);


ALTER TABLE platedb.plate_input OWNER TO postgres;

--
-- Name: plate_location_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plate_location_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plate_location_pk_seq OWNER TO postgres;

--
-- Name: plate_location; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate_location (
    pk integer DEFAULT nextval('platedb.plate_location_pk_seq'::regclass) NOT NULL,
    label text NOT NULL
);


ALTER TABLE platedb.plate_location OWNER TO postgres;

--
-- Name: pointing_to_pointing_status_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.pointing_to_pointing_status_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.pointing_to_pointing_status_pk_seq OWNER TO postgres;

--
-- Name: plate_pointing_to_pointing_status; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate_pointing_to_pointing_status (
    pk bigint DEFAULT nextval('platedb.pointing_to_pointing_status_pk_seq'::regclass) NOT NULL,
    plate_pointing_pk bigint,
    pointing_status_pk integer
);


ALTER TABLE platedb.plate_pointing_to_pointing_status OWNER TO postgres;

--
-- Name: plate_run_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plate_run_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plate_run_pk_seq OWNER TO postgres;

--
-- Name: plate_run; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate_run (
    pk bigint DEFAULT nextval('platedb.plate_run_pk_seq'::regclass) NOT NULL,
    label text,
    year smallint
);


ALTER TABLE platedb.plate_run OWNER TO postgres;

--
-- Name: plate_run_to_design; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate_run_to_design (
    pk bigint NOT NULL,
    plate_run_pk bigint,
    design_pk bigint
);


ALTER TABLE platedb.plate_run_to_design OWNER TO postgres;

--
-- Name: plate_status_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plate_status_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plate_status_pk_seq OWNER TO postgres;

--
-- Name: plate_status; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate_status (
    pk integer DEFAULT nextval('platedb.plate_status_pk_seq'::regclass) NOT NULL,
    label text
);


ALTER TABLE platedb.plate_status OWNER TO postgres;

--
-- Name: plate_to_instrument_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plate_to_instrument_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plate_to_instrument_pk_seq OWNER TO postgres;

--
-- Name: plate_to_instrument; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate_to_instrument (
    pk bigint DEFAULT nextval('platedb.plate_to_instrument_pk_seq'::regclass) NOT NULL,
    plate_pk bigint,
    instrument_pk integer
);


ALTER TABLE platedb.plate_to_instrument OWNER TO postgres;

--
-- Name: plate_to_plate_status_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plate_to_plate_status_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plate_to_plate_status_pk_seq OWNER TO postgres;

--
-- Name: plate_to_plate_status; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate_to_plate_status (
    pk bigint DEFAULT nextval('platedb.plate_to_plate_status_pk_seq'::regclass) NOT NULL,
    plate_status_pk integer,
    plate_pk bigint
);


ALTER TABLE platedb.plate_to_plate_status OWNER TO postgres;

--
-- Name: plate_to_survey_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plate_to_survey_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plate_to_survey_seq OWNER TO postgres;

--
-- Name: plate_to_survey; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plate_to_survey (
    pk integer DEFAULT nextval('platedb.plate_to_survey_seq'::regclass) NOT NULL,
    plate_pk integer,
    survey_pk integer
);


ALTER TABLE platedb.plate_to_survey OWNER TO postgres;

--
-- Name: plateview; Type: VIEW; Schema: platedb; Owner: postgres
--

CREATE VIEW platedb.plateview AS
 SELECT plate.pk,
    plate_run.label AS platerun,
    design.pk AS design
   FROM ((platedb.plate
     JOIN platedb.plate_run ON ((plate.plate_run_pk = plate_run.pk)))
     JOIN platedb.design ON ((plate.design_pk = design.pk)))
 LIMIT 20;


ALTER TABLE platedb.plateview OWNER TO postgres;

--
-- Name: plugging_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plugging_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plugging_seq OWNER TO postgres;

--
-- Name: plugging; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plugging (
    pk integer DEFAULT nextval('platedb.plugging_seq'::regclass) NOT NULL,
    plate_pk integer NOT NULL,
    cartridge_pk integer,
    name text,
    fscan_id integer,
    fscan_mjd integer,
    plugging_status_pk smallint DEFAULT 0 NOT NULL
);


ALTER TABLE platedb.plugging OWNER TO postgres;

--
-- Name: plugging_status_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plugging_status_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plugging_status_pk_seq OWNER TO postgres;

--
-- Name: plugging_status; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plugging_status (
    pk smallint DEFAULT nextval('platedb.plugging_status_pk_seq'::regclass) NOT NULL,
    label text NOT NULL
);


ALTER TABLE platedb.plugging_status OWNER TO postgres;

--
-- Name: plugging_to_boss_sn2_threshold; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plugging_to_boss_sn2_threshold (
    plugging_pk integer NOT NULL,
    boss_sn2_threshold_version integer NOT NULL
);


ALTER TABLE platedb.plugging_to_boss_sn2_threshold OWNER TO postgres;

--
-- Name: plugging_to_instrument_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.plugging_to_instrument_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.plugging_to_instrument_seq OWNER TO postgres;

--
-- Name: plugging_to_instrument; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.plugging_to_instrument (
    pk integer DEFAULT nextval('platedb.plugging_to_instrument_seq'::regclass) NOT NULL,
    plugging_pk integer,
    instrument_pk integer
);


ALTER TABLE platedb.plugging_to_instrument OWNER TO postgres;

--
-- Name: plugmap_view; Type: VIEW; Schema: platedb; Owner: postgres
--

CREATE VIEW platedb.plugmap_view AS
 SELECT pl_plugmap_m.pk,
    pl_plugmap_m.plugging_pk,
    pl_plugmap_m.fscan_mjd,
    pl_plugmap_m.fscan_id,
    pl_plugmap_m.pointing_name,
    pl_plugmap_m.filename,
    pl_plugmap_m.checked_in
   FROM platedb.pl_plugmap_m
  ORDER BY pl_plugmap_m.fscan_mjd, pl_plugmap_m.filename, pl_plugmap_m.pointing_name;


ALTER TABLE platedb.plugmap_view OWNER TO postgres;

--
-- Name: pointing_status_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.pointing_status_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.pointing_status_pk_seq OWNER TO postgres;

--
-- Name: pointing_status; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.pointing_status (
    pk integer DEFAULT nextval('platedb.pointing_status_pk_seq'::regclass) NOT NULL,
    label text
);


ALTER TABLE platedb.pointing_status OWNER TO postgres;

--
-- Name: pointing_view; Type: VIEW; Schema: platedb; Owner: postgres
--

CREATE VIEW platedb.pointing_view AS
 SELECT pointing.design_pk,
    pointing.center_ra,
    pointing.center_dec,
    plate_pointing.hour_angle,
    plate_pointing.plate_pk,
    plate_pointing.pointing_pk,
    plate_pointing.pointing_name
   FROM ((platedb.pointing
     JOIN platedb.plate_pointing ON ((plate_pointing.pointing_pk = pointing.pk)))
     JOIN platedb.plate ON ((plate.pk = plate_pointing.plate_pk)))
  WHERE (pointing.design_pk = 684)
  ORDER BY pointing.design_pk, plate.plate_id, plate_pointing.pointing_name;


ALTER TABLE platedb.pointing_view OWNER TO postgres;

--
-- Name: pointing_view2; Type: VIEW; Schema: platedb; Owner: postgres
--

CREATE VIEW platedb.pointing_view2 AS
 SELECT plate.pk AS plate_pk,
    plate_run.label AS platerun,
    plate.plate_id,
    plate_pointing.pointing_name AS pointing,
    plate_pointing.priority,
    design.pk AS design_pk,
    pointing.pk AS pointing_pk,
    plate_pointing.pk AS plate_pointing_pk
   FROM ((((platedb.pointing
     JOIN platedb.design ON ((design.pk = pointing.design_pk)))
     JOIN platedb.plate ON ((plate.design_pk = design.pk)))
     JOIN platedb.plate_pointing ON ((plate_pointing.pk = pointing.pk)))
     JOIN platedb.plate_run ON ((plate_run.pk = plate.plate_run_pk)))
  WHERE (plate.plate_id = 3511)
  ORDER BY plate.plate_id, plate_pointing.pointing_name;


ALTER TABLE platedb.pointing_view2 OWNER TO postgres;

--
-- Name: prof_meas_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.prof_meas_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.prof_meas_seq OWNER TO postgres;

--
-- Name: prof_measurement; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.prof_measurement (
    pk integer DEFAULT nextval('platedb.prof_meas_seq'::regclass) NOT NULL,
    number smallint NOT NULL,
    r1 numeric,
    r2 numeric,
    r3 numeric,
    r4 numeric,
    r5 numeric,
    profilometry_pk integer NOT NULL,
    "timestamp" timestamp without time zone
);


ALTER TABLE platedb.prof_measurement OWNER TO postgres;

--
-- Name: prof_tolerances_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.prof_tolerances_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.prof_tolerances_seq OWNER TO postgres;

--
-- Name: prof_tolerances; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.prof_tolerances (
    pk integer DEFAULT nextval('platedb.prof_tolerances_seq'::regclass) NOT NULL,
    survey_pk integer NOT NULL,
    r1_low numeric NOT NULL,
    r1_high numeric NOT NULL,
    r2_low numeric NOT NULL,
    r2_high numeric NOT NULL,
    r3_low numeric NOT NULL,
    r3_high numeric NOT NULL,
    r4_low numeric NOT NULL,
    r4_high numeric NOT NULL,
    r5_low numeric NOT NULL,
    r5_high numeric NOT NULL,
    version smallint NOT NULL
);


ALTER TABLE platedb.prof_tolerances OWNER TO postgres;

--
-- Name: profilometry_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.profilometry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.profilometry_seq OWNER TO postgres;

--
-- Name: profilometry; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.profilometry (
    pk integer DEFAULT nextval('platedb.profilometry_seq'::regclass) NOT NULL,
    comment text,
    prof_tolerances_pk integer NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    plugging_pk integer NOT NULL
);


ALTER TABLE platedb.profilometry OWNER TO postgres;

--
-- Name: survey_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.survey_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.survey_pk_seq OWNER TO postgres;

--
-- Name: survey; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.survey (
    pk integer DEFAULT nextval('platedb.survey_pk_seq'::regclass) NOT NULL,
    label text,
    plateplan_name text NOT NULL
);


ALTER TABLE platedb.survey OWNER TO postgres;

--
-- Name: TABLE survey; Type: COMMENT; Schema: platedb; Owner: postgres
--

COMMENT ON TABLE platedb.survey IS 'plateplan_name - matches "survey" field in platePlans.par file
label - user displayed name (e.g. web interface)';


--
-- Name: survey_mode; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.survey_mode (
    pk integer NOT NULL,
    label text,
    definition_label text
);


ALTER TABLE platedb.survey_mode OWNER TO postgres;

--
-- Name: TABLE survey_mode; Type: COMMENT; Schema: platedb; Owner: postgres
--

COMMENT ON TABLE platedb.survey_mode IS 'Possible values: "APOGEE lead", "MaNGA dither", "MaNGA stare"';


--
-- Name: survey_mode_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.survey_mode_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.survey_mode_pk_seq OWNER TO postgres;

--
-- Name: survey_mode_pk_seq; Type: SEQUENCE OWNED BY; Schema: platedb; Owner: postgres
--

ALTER SEQUENCE platedb.survey_mode_pk_seq OWNED BY platedb.survey_mode.pk;


--
-- Name: test_table_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.test_table_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.test_table_seq OWNER TO postgres;

--
-- Name: test; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.test (
    pk integer DEFAULT nextval('platedb.test_table_seq'::regclass) NOT NULL,
    label text
);


ALTER TABLE platedb.test OWNER TO postgres;

--
-- Name: tile_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.tile_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.tile_seq OWNER TO postgres;

--
-- Name: tile; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.tile (
    pk integer DEFAULT nextval('platedb.tile_seq'::regclass) NOT NULL,
    tile_status_pk integer DEFAULT 0 NOT NULL,
    id integer
);


ALTER TABLE platedb.tile OWNER TO postgres;

--
-- Name: tile_status_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.tile_status_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.tile_status_seq OWNER TO postgres;

--
-- Name: tile_status; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.tile_status (
    pk integer DEFAULT nextval('platedb.tile_status_seq'::regclass) NOT NULL,
    label text NOT NULL
);


ALTER TABLE platedb.tile_status OWNER TO postgres;

--
-- Name: tile_status_history; Type: TABLE; Schema: platedb; Owner: postgres
--

CREATE TABLE platedb.tile_status_history (
    pk integer NOT NULL,
    tile_pk integer NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    tile_status_pk integer NOT NULL,
    comment text NOT NULL,
    first_name text,
    last_name text
);


ALTER TABLE platedb.tile_status_history OWNER TO postgres;

--
-- Name: tile_status_history_pk_seq; Type: SEQUENCE; Schema: platedb; Owner: postgres
--

CREATE SEQUENCE platedb.tile_status_history_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE platedb.tile_status_history_pk_seq OWNER TO postgres;

--
-- Name: tile_status_history_pk_seq; Type: SEQUENCE OWNED BY; Schema: platedb; Owner: postgres
--

ALTER SEQUENCE platedb.tile_status_history_pk_seq OWNED BY platedb.tile_status_history.pk;


--
-- Name: apogee_threshold pk; Type: DEFAULT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.apogee_threshold ALTER COLUMN pk SET DEFAULT nextval('platedb.apogee_threshold_pk_seq'::regclass);


--
-- Name: cmm_meas pk; Type: DEFAULT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.cmm_meas ALTER COLUMN pk SET DEFAULT nextval('platedb.cmm_meas_pk_seq'::regclass);


--
-- Name: exposure_header_keyword pk; Type: DEFAULT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure_header_keyword ALTER COLUMN pk SET DEFAULT nextval('platedb.exposure_header_keyword_pk_seq'::regclass);


--
-- Name: exposure_header_value pk; Type: DEFAULT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure_header_value ALTER COLUMN pk SET DEFAULT nextval('platedb.exposure_header_value_pk_seq'::regclass);


--
-- Name: fiber pk; Type: DEFAULT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.fiber ALTER COLUMN pk SET DEFAULT nextval('platedb.fiber_pk_seq'::regclass);


--
-- Name: hole_meas pk; Type: DEFAULT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.hole_meas ALTER COLUMN pk SET DEFAULT nextval('platedb.hole_meas_pk_seq'::regclass);


--
-- Name: object_type pk; Type: DEFAULT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.object_type ALTER COLUMN pk SET DEFAULT nextval('platedb.object_type_pk_seq'::regclass);


--
-- Name: plate_completion_status pk; Type: DEFAULT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_completion_status ALTER COLUMN pk SET DEFAULT nextval('platedb.plate_completion_status_pk_seq'::regclass);


--
-- Name: plate_completion_status_history pk; Type: DEFAULT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_completion_status_history ALTER COLUMN pk SET DEFAULT nextval('platedb.plate_completion_status_history_pk_seq'::regclass);


--
-- Name: plate_hole pk; Type: DEFAULT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_hole ALTER COLUMN pk SET DEFAULT nextval('platedb.plate_hole_pk_seq'::regclass);


--
-- Name: plate_hole_type pk; Type: DEFAULT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_hole_type ALTER COLUMN pk SET DEFAULT nextval('platedb.plate_hole_type_pk_seq'::regclass);


--
-- Name: plate_holes_file pk; Type: DEFAULT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_holes_file ALTER COLUMN pk SET DEFAULT nextval('platedb.plate_holes_file_pk_seq'::regclass);


--
-- Name: survey_mode pk; Type: DEFAULT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.survey_mode ALTER COLUMN pk SET DEFAULT nextval('platedb.survey_mode_pk_seq'::regclass);


--
-- Name: tile_status_history pk; Type: DEFAULT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.tile_status_history ALTER COLUMN pk SET DEFAULT nextval('platedb.tile_status_history_pk_seq'::regclass);


--
-- Name: active_plugging active_plugging_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.active_plugging
    ADD CONSTRAINT active_plugging_pk PRIMARY KEY (pk);


--
-- Name: apogee_threshold apogee_threshold_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.apogee_threshold
    ADD CONSTRAINT apogee_threshold_pk PRIMARY KEY (pk);


--
-- Name: boss_plugging_info boss_plugging_info_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.boss_plugging_info
    ADD CONSTRAINT boss_plugging_info_pk PRIMARY KEY (pk);


--
-- Name: boss_sn2_threshold boss_sn2_threshold_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.boss_sn2_threshold
    ADD CONSTRAINT boss_sn2_threshold_pk PRIMARY KEY (pk);


--
-- Name: camera_frame camera_frame_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.camera_frame
    ADD CONSTRAINT camera_frame_pk PRIMARY KEY (pk);


--
-- Name: camera camera_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.camera
    ADD CONSTRAINT camera_pk PRIMARY KEY (pk);


--
-- Name: cartridge cartridge_number_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.cartridge
    ADD CONSTRAINT cartridge_number_uniq UNIQUE (number);


--
-- Name: cartridge cartridge_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.cartridge
    ADD CONSTRAINT cartridge_pk PRIMARY KEY (pk);


--
-- Name: cartridge_to_survey cartridge_to_survey_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.cartridge_to_survey
    ADD CONSTRAINT cartridge_to_survey_pk PRIMARY KEY (cartridge_pk, survey_pk);


--
-- Name: cmm_meas cmm_meas_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.cmm_meas
    ADD CONSTRAINT cmm_meas_pk PRIMARY KEY (pk);


--
-- Name: constants constants_name_key; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.constants
    ADD CONSTRAINT constants_name_key UNIQUE (name);


--
-- Name: constants constants_pkey; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.constants
    ADD CONSTRAINT constants_pkey PRIMARY KEY (name);


--
-- Name: design_field design_field_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.design_field
    ADD CONSTRAINT design_field_pk PRIMARY KEY (pk);


--
-- Name: design_value design_fields_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.design_value
    ADD CONSTRAINT design_fields_uniq UNIQUE (design_pk, design_field_pk);


--
-- Name: design design_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.design
    ADD CONSTRAINT design_pk PRIMARY KEY (pk);


--
-- Name: design_value design_values_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.design_value
    ADD CONSTRAINT design_values_pk PRIMARY KEY (pk);


--
-- Name: exposure_flavor exposure_flavor_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure_flavor
    ADD CONSTRAINT exposure_flavor_pk PRIMARY KEY (pk);


--
-- Name: exposure_header_keyword exposure_header_keyword_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure_header_keyword
    ADD CONSTRAINT exposure_header_keyword_pk PRIMARY KEY (pk);


--
-- Name: exposure_header_value exposure_header_value_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure_header_value
    ADD CONSTRAINT exposure_header_value_pk PRIMARY KEY (pk);


--
-- Name: exposure exposure_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure
    ADD CONSTRAINT exposure_pk PRIMARY KEY (pk);


--
-- Name: exposure_status exposure_status_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure_status
    ADD CONSTRAINT exposure_status_pk PRIMARY KEY (pk);


--
-- Name: fiber fiber_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.fiber
    ADD CONSTRAINT fiber_pk PRIMARY KEY (pk);


--
-- Name: gprobe gproke_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.gprobe
    ADD CONSTRAINT gproke_pk PRIMARY KEY (pk);


--
-- Name: hole_meas hole_meas_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.hole_meas
    ADD CONSTRAINT hole_meas_pk PRIMARY KEY (pk);


--
-- Name: instrument instrument_label_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.instrument
    ADD CONSTRAINT instrument_label_uniq UNIQUE (label);


--
-- Name: instrument instrument_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.instrument
    ADD CONSTRAINT instrument_pk PRIMARY KEY (pk);


--
-- Name: design_field label_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.design_field
    ADD CONSTRAINT label_uniq UNIQUE (label);


--
-- Name: object_type object_type_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.object_type
    ADD CONSTRAINT object_type_pk PRIMARY KEY (pk);


--
-- Name: observation observation_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.observation
    ADD CONSTRAINT observation_pk PRIMARY KEY (pk);


--
-- Name: observation_status observation_status_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.observation_status
    ADD CONSTRAINT observation_status_pk PRIMARY KEY (pk);


--
-- Name: plate_completion_status_history plate_completion_status_history_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_completion_status_history
    ADD CONSTRAINT plate_completion_status_history_pk PRIMARY KEY (pk);


--
-- Name: plate_completion_status plate_completion_status_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_completion_status
    ADD CONSTRAINT plate_completion_status_pk PRIMARY KEY (pk);


--
-- Name: plate_hole plate_hole_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_hole
    ADD CONSTRAINT plate_hole_pk PRIMARY KEY (pk);


--
-- Name: plate_hole_type plate_hole_type_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_hole_type
    ADD CONSTRAINT plate_hole_type_pk PRIMARY KEY (pk);


--
-- Name: plate_holes_file plate_holes_file_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_holes_file
    ADD CONSTRAINT plate_holes_file_pk PRIMARY KEY (pk);


--
-- Name: plate plate_id_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate
    ADD CONSTRAINT plate_id_uniq UNIQUE (plate_id);


--
-- Name: plate_input plate_input_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_input
    ADD CONSTRAINT plate_input_pk PRIMARY KEY (pk);


--
-- Name: plate_location plate_location_label_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_location
    ADD CONSTRAINT plate_location_label_uniq UNIQUE (label);


--
-- Name: plate_location plate_location_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_location
    ADD CONSTRAINT plate_location_pk PRIMARY KEY (pk);


--
-- Name: plate plate_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate
    ADD CONSTRAINT plate_pk PRIMARY KEY (pk);


--
-- Name: plate_pointing plate_pointing_name_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_pointing
    ADD CONSTRAINT plate_pointing_name_uniq UNIQUE (plate_pk, pointing_name);


--
-- Name: plate_pointing plate_pointing_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_pointing
    ADD CONSTRAINT plate_pointing_pk PRIMARY KEY (pk);


--
-- Name: plate_pointing_to_pointing_status plate_pointing_to_pointing_status_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_pointing_to_pointing_status
    ADD CONSTRAINT plate_pointing_to_pointing_status_pk PRIMARY KEY (pk);


--
-- Name: plate_pointing_to_pointing_status plate_pointing_to_pointing_status_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_pointing_to_pointing_status
    ADD CONSTRAINT plate_pointing_to_pointing_status_uniq UNIQUE (plate_pointing_pk, pointing_status_pk);


--
-- Name: plate_run plate_run_label_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_run
    ADD CONSTRAINT plate_run_label_uniq UNIQUE (label);


--
-- Name: plate_run plate_run_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_run
    ADD CONSTRAINT plate_run_pk PRIMARY KEY (pk);


--
-- Name: plate_run_to_design plate_run_to_design_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_run_to_design
    ADD CONSTRAINT plate_run_to_design_pk PRIMARY KEY (pk);


--
-- Name: plate_run_to_design plate_run_to_design_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_run_to_design
    ADD CONSTRAINT plate_run_to_design_uniq UNIQUE (plate_run_pk, design_pk);


--
-- Name: plate_status plate_satus_label_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_status
    ADD CONSTRAINT plate_satus_label_uniq UNIQUE (label);


--
-- Name: plate_status plate_status_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_status
    ADD CONSTRAINT plate_status_pk PRIMARY KEY (pk);


--
-- Name: plate_to_survey plate_survey_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_to_survey
    ADD CONSTRAINT plate_survey_uniq UNIQUE (plate_pk, survey_pk);


--
-- Name: plate_to_instrument plate_to_instrument_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_to_instrument
    ADD CONSTRAINT plate_to_instrument_pk PRIMARY KEY (pk);


--
-- Name: plate_to_instrument plate_to_instrument_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_to_instrument
    ADD CONSTRAINT plate_to_instrument_uniq UNIQUE (plate_pk, instrument_pk);


--
-- Name: plate_to_plate_status plate_to_plate_status_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_to_plate_status
    ADD CONSTRAINT plate_to_plate_status_pk PRIMARY KEY (pk);


--
-- Name: plate_to_plate_status plate_to_plate_status_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_to_plate_status
    ADD CONSTRAINT plate_to_plate_status_uniq UNIQUE (plate_status_pk, plate_pk);


--
-- Name: plate_to_survey plate_to_survey_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_to_survey
    ADD CONSTRAINT plate_to_survey_pk PRIMARY KEY (pk);


--
-- Name: survey_mode platedb_survey_mode_label_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.survey_mode
    ADD CONSTRAINT platedb_survey_mode_label_uniq UNIQUE (label);


--
-- Name: survey_mode platedb_survey_mode_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.survey_mode
    ADD CONSTRAINT platedb_survey_mode_pk PRIMARY KEY (pk);


--
-- Name: pl_plugmap_m plplugmap_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.pl_plugmap_m
    ADD CONSTRAINT plplugmap_pk PRIMARY KEY (pk);


--
-- Name: plugging plugging_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plugging
    ADD CONSTRAINT plugging_pk PRIMARY KEY (pk);


--
-- Name: active_plugging plugging_pk_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.active_plugging
    ADD CONSTRAINT plugging_pk_uniq UNIQUE (plugging_pk);


--
-- Name: plugging_status plugging_status_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plugging_status
    ADD CONSTRAINT plugging_status_pk PRIMARY KEY (pk);


--
-- Name: plugging_to_boss_sn2_threshold plugging_to_boss_sn2_threshold_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plugging_to_boss_sn2_threshold
    ADD CONSTRAINT plugging_to_boss_sn2_threshold_pk PRIMARY KEY (plugging_pk, boss_sn2_threshold_version);


--
-- Name: plugging_to_instrument plugging_to_instrument_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plugging_to_instrument
    ADD CONSTRAINT plugging_to_instrument_pk PRIMARY KEY (pk);


--
-- Name: plugging_to_instrument plugging_to_instrument_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plugging_to_instrument
    ADD CONSTRAINT plugging_to_instrument_uniq UNIQUE (plugging_pk, instrument_pk);


--
-- Name: pointing pointing_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.pointing
    ADD CONSTRAINT pointing_pk PRIMARY KEY (pk);


--
-- Name: pointing_status pointing_status_label_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.pointing_status
    ADD CONSTRAINT pointing_status_label_uniq UNIQUE (label);


--
-- Name: pointing_status pointing_status_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.pointing_status
    ADD CONSTRAINT pointing_status_pk PRIMARY KEY (pk);


--
-- Name: prof_measurement prof_measurement_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.prof_measurement
    ADD CONSTRAINT prof_measurement_pk PRIMARY KEY (pk);


--
-- Name: prof_tolerances prof_tolerances_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.prof_tolerances
    ADD CONSTRAINT prof_tolerances_pk PRIMARY KEY (pk);


--
-- Name: profilometry profilometry_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.profilometry
    ADD CONSTRAINT profilometry_pk PRIMARY KEY (pk);


--
-- Name: exposure survey_exposure_no_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure
    ADD CONSTRAINT survey_exposure_no_uniq UNIQUE (survey_pk, exposure_no);


--
-- Name: survey survey_label_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.survey
    ADD CONSTRAINT survey_label_uniq UNIQUE (label);


--
-- Name: survey survey_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.survey
    ADD CONSTRAINT survey_pk PRIMARY KEY (pk);


--
-- Name: test test_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.test
    ADD CONSTRAINT test_pk PRIMARY KEY (pk);


--
-- Name: tile tile_id_uniq; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.tile
    ADD CONSTRAINT tile_id_uniq UNIQUE (id);


--
-- Name: tile tile_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.tile
    ADD CONSTRAINT tile_pk PRIMARY KEY (pk);


--
-- Name: tile_status_history tile_status_history_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.tile_status_history
    ADD CONSTRAINT tile_status_history_pk PRIMARY KEY (pk);


--
-- Name: tile_status tile_status_pk; Type: CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.tile_status
    ADD CONSTRAINT tile_status_pk PRIMARY KEY (pk);


--
-- Name: exposure_flavor_pk_idx; Type: INDEX; Schema: platedb; Owner: postgres
--

CREATE INDEX exposure_flavor_pk_idx ON platedb.exposure USING btree (exposure_flavor_pk);


--
-- Name: exposure_observation_pk_idx; Type: INDEX; Schema: platedb; Owner: postgres
--

CREATE INDEX exposure_observation_pk_idx ON platedb.exposure USING btree (observation_pk);


--
-- Name: exposure_survey_pk_idx; Type: INDEX; Schema: platedb; Owner: postgres
--

CREATE INDEX exposure_survey_pk_idx ON platedb.exposure USING btree (survey_pk);


--
-- Name: observation_plate_pointing_pk_idx; Type: INDEX; Schema: platedb; Owner: postgres
--

CREATE INDEX observation_plate_pointing_pk_idx ON platedb.observation USING btree (plate_pointing_pk);


--
-- Name: plate_current_survey_mode_pk_idx; Type: INDEX; Schema: platedb; Owner: postgres
--

CREATE INDEX plate_current_survey_mode_pk_idx ON platedb.plate USING btree (current_survey_mode_pk);


--
-- Name: plate_hole_catalog_object_index; Type: INDEX; Schema: platedb; Owner: postgres
--

CREATE INDEX plate_hole_catalog_object_index ON platedb.plate_hole USING btree (catalog_object_pk);


--
-- Name: plate_pointing_plate_pk_idx; Type: INDEX; Schema: platedb; Owner: postgres
--

CREATE INDEX plate_pointing_plate_pk_idx ON platedb.plate_pointing USING btree (plate_pk);


--
-- Name: plate_pointing_pointing_pk_idx; Type: INDEX; Schema: platedb; Owner: postgres
--

CREATE INDEX plate_pointing_pointing_pk_idx ON platedb.plate_pointing USING btree (pointing_pk);


--
-- Name: plate_to_survey_plate_pk_idx; Type: INDEX; Schema: platedb; Owner: postgres
--

CREATE INDEX plate_to_survey_plate_pk_idx ON platedb.plate_to_survey USING btree (plate_pk);


--
-- Name: plate_to_survey_survey_pk_idx; Type: INDEX; Schema: platedb; Owner: postgres
--

CREATE INDEX plate_to_survey_survey_pk_idx ON platedb.plate_to_survey USING btree (survey_pk);


--
-- Name: exposure camera_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure
    ADD CONSTRAINT camera_fk FOREIGN KEY (camera_pk) REFERENCES platedb.camera(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: boss_sn2_threshold camera_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.boss_sn2_threshold
    ADD CONSTRAINT camera_fk FOREIGN KEY (camera_pk) REFERENCES platedb.camera(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: camera_frame camera_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.camera_frame
    ADD CONSTRAINT camera_fk FOREIGN KEY (camera_pk) REFERENCES platedb.camera(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plugging cartridge_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plugging
    ADD CONSTRAINT cartridge_fk FOREIGN KEY (cartridge_pk) REFERENCES platedb.cartridge(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gprobe cartridge_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.gprobe
    ADD CONSTRAINT cartridge_fk FOREIGN KEY (cartridge_pk) REFERENCES platedb.cartridge(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cartridge_to_survey cartridge_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.cartridge_to_survey
    ADD CONSTRAINT cartridge_fk FOREIGN KEY (cartridge_pk) REFERENCES platedb.cartridge(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: hole_meas cmm_meas_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.hole_meas
    ADD CONSTRAINT cmm_meas_fk FOREIGN KEY (cmm_meas_pk) REFERENCES platedb.cmm_meas(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plate current_survey_mode_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate
    ADD CONSTRAINT current_survey_mode_fk FOREIGN KEY (current_survey_mode_pk) REFERENCES platedb.survey_mode(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: design_value design_field_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.design_value
    ADD CONSTRAINT design_field_fk FOREIGN KEY (design_field_pk) REFERENCES platedb.design_field(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plate design_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate
    ADD CONSTRAINT design_fk FOREIGN KEY (design_pk) REFERENCES platedb.design(pk) ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
-- Name: design_value design_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.design_value
    ADD CONSTRAINT design_fk FOREIGN KEY (design_pk) REFERENCES platedb.design(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plate_input design_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_input
    ADD CONSTRAINT design_fk FOREIGN KEY (design_pk) REFERENCES platedb.design(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: pointing design_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.pointing
    ADD CONSTRAINT design_fk FOREIGN KEY (design_pk) REFERENCES platedb.design(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: camera_frame exposure_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.camera_frame
    ADD CONSTRAINT exposure_fk FOREIGN KEY (exposure_pk) REFERENCES platedb.exposure(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: exposure_header_value exposure_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure_header_value
    ADD CONSTRAINT exposure_fk FOREIGN KEY (exposure_pk) REFERENCES platedb.exposure(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: exposure exposure_flavor_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure
    ADD CONSTRAINT exposure_flavor_fk FOREIGN KEY (exposure_flavor_pk) REFERENCES platedb.exposure_flavor(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: exposure_header_value exposure_header_keyword_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure_header_value
    ADD CONSTRAINT exposure_header_keyword_fk FOREIGN KEY (exposure_header_keyword_pk) REFERENCES platedb.exposure_header_keyword(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: exposure exposure_status_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure
    ADD CONSTRAINT exposure_status_fk FOREIGN KEY (exposure_status_pk) REFERENCES platedb.exposure_status(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plate_to_instrument instrument_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_to_instrument
    ADD CONSTRAINT instrument_fk FOREIGN KEY (instrument_pk) REFERENCES platedb.instrument(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: camera instrument_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.camera
    ADD CONSTRAINT instrument_fk FOREIGN KEY (instrument_pk) REFERENCES platedb.instrument(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plugging_to_instrument instrument_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plugging_to_instrument
    ADD CONSTRAINT instrument_fk FOREIGN KEY (instrument_pk) REFERENCES platedb.instrument(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plate_hole object_type_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_hole
    ADD CONSTRAINT object_type_fk FOREIGN KEY (object_type_pk) REFERENCES platedb.object_type(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: exposure observation_pk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure
    ADD CONSTRAINT observation_pk FOREIGN KEY (observation_pk) REFERENCES platedb.observation(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: observation observation_status_pk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.observation
    ADD CONSTRAINT observation_status_pk FOREIGN KEY (observation_status_pk) REFERENCES platedb.observation_status(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fiber pl_plugmap_m_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.fiber
    ADD CONSTRAINT pl_plugmap_m_fk FOREIGN KEY (pl_plugmap_m_pk) REFERENCES platedb.pl_plugmap_m(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plate_completion_status_history plate_completion_status_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_completion_status_history
    ADD CONSTRAINT plate_completion_status_fk FOREIGN KEY (plate_completion_status_pk) REFERENCES platedb.plate_completion_status(pk) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: plate plate_completion_status_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate
    ADD CONSTRAINT plate_completion_status_fk FOREIGN KEY (plate_completion_status_pk) REFERENCES platedb.plate_completion_status(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plate_to_instrument plate_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_to_instrument
    ADD CONSTRAINT plate_fk FOREIGN KEY (plate_pk) REFERENCES platedb.plate(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plate_to_plate_status plate_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_to_plate_status
    ADD CONSTRAINT plate_fk FOREIGN KEY (plate_pk) REFERENCES platedb.plate(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plugging plate_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plugging
    ADD CONSTRAINT plate_fk FOREIGN KEY (plate_pk) REFERENCES platedb.plate(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plate_pointing plate_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_pointing
    ADD CONSTRAINT plate_fk FOREIGN KEY (plate_pk) REFERENCES platedb.plate(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plate_to_survey plate_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_to_survey
    ADD CONSTRAINT plate_fk FOREIGN KEY (plate_pk) REFERENCES platedb.plate(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plate_completion_status_history plate_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_completion_status_history
    ADD CONSTRAINT plate_fk FOREIGN KEY (plate_pk) REFERENCES platedb.plate(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plate_holes_file plate_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_holes_file
    ADD CONSTRAINT plate_fk FOREIGN KEY (plate_pk) REFERENCES platedb.plate(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cmm_meas plate_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.cmm_meas
    ADD CONSTRAINT plate_fk FOREIGN KEY (plate_pk) REFERENCES platedb.plate(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fiber plate_hole_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.fiber
    ADD CONSTRAINT plate_hole_fk FOREIGN KEY (plate_hole_pk) REFERENCES platedb.plate_hole(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hole_meas plate_hole_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.hole_meas
    ADD CONSTRAINT plate_hole_fk FOREIGN KEY (plate_hole_pk) REFERENCES platedb.plate_hole(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plate_hole plate_hole_type_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_hole
    ADD CONSTRAINT plate_hole_type_fk FOREIGN KEY (plate_hole_type_pk) REFERENCES platedb.plate_hole_type(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plate_hole plate_holes_file_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_hole
    ADD CONSTRAINT plate_holes_file_fk FOREIGN KEY (plate_holes_file_pk) REFERENCES platedb.plate_holes_file(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plate plate_location_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate
    ADD CONSTRAINT plate_location_fk FOREIGN KEY (plate_location_pk) REFERENCES platedb.plate_location(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: observation plate_pointing_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.observation
    ADD CONSTRAINT plate_pointing_fk FOREIGN KEY (plate_pointing_pk) REFERENCES platedb.plate_pointing(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plate_pointing_to_pointing_status plate_pointing_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_pointing_to_pointing_status
    ADD CONSTRAINT plate_pointing_fk FOREIGN KEY (plate_pointing_pk) REFERENCES platedb.plate_pointing(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plate plate_run_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate
    ADD CONSTRAINT plate_run_fk FOREIGN KEY (plate_run_pk) REFERENCES platedb.plate_run(pk);


--
-- Name: plate_to_plate_status plate_status_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_to_plate_status
    ADD CONSTRAINT plate_status_fk FOREIGN KEY (plate_status_pk) REFERENCES platedb.plate_status(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: observation plugging_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.observation
    ADD CONSTRAINT plugging_fk FOREIGN KEY (plugging_pk) REFERENCES platedb.plugging(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: pl_plugmap_m plugging_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.pl_plugmap_m
    ADD CONSTRAINT plugging_fk FOREIGN KEY (plugging_pk) REFERENCES platedb.plugging(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plugging_to_instrument plugging_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plugging_to_instrument
    ADD CONSTRAINT plugging_fk FOREIGN KEY (plugging_pk) REFERENCES platedb.plugging(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: active_plugging plugging_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.active_plugging
    ADD CONSTRAINT plugging_fk FOREIGN KEY (plugging_pk) REFERENCES platedb.plugging(pk) ON DELETE RESTRICT;


--
-- Name: boss_plugging_info plugging_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.boss_plugging_info
    ADD CONSTRAINT plugging_fk FOREIGN KEY (plugging_pk) REFERENCES platedb.plugging(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: profilometry plugging_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.profilometry
    ADD CONSTRAINT plugging_fk FOREIGN KEY (plugging_pk) REFERENCES platedb.plugging(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plugging plugging_status_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plugging
    ADD CONSTRAINT plugging_status_fk FOREIGN KEY (plugging_status_pk) REFERENCES platedb.plugging_status(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plate_pointing pointing_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_pointing
    ADD CONSTRAINT pointing_fk FOREIGN KEY (pointing_pk) REFERENCES platedb.pointing(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plate_pointing_to_pointing_status pointing_status_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_pointing_to_pointing_status
    ADD CONSTRAINT pointing_status_fk FOREIGN KEY (pointing_status_pk) REFERENCES platedb.plate_status(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: profilometry prof_tolerances_pk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.profilometry
    ADD CONSTRAINT prof_tolerances_pk FOREIGN KEY (prof_tolerances_pk) REFERENCES platedb.prof_tolerances(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: prof_measurement profilometry_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.prof_measurement
    ADD CONSTRAINT profilometry_fk FOREIGN KEY (profilometry_pk) REFERENCES platedb.profilometry(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: exposure survey_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure
    ADD CONSTRAINT survey_fk FOREIGN KEY (survey_pk) REFERENCES platedb.survey(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plate_to_survey survey_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate_to_survey
    ADD CONSTRAINT survey_fk FOREIGN KEY (survey_pk) REFERENCES platedb.survey(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: prof_tolerances survey_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.prof_tolerances
    ADD CONSTRAINT survey_fk FOREIGN KEY (survey_pk) REFERENCES platedb.survey(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cartridge_to_survey survey_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.cartridge_to_survey
    ADD CONSTRAINT survey_fk FOREIGN KEY (survey_pk) REFERENCES platedb.survey(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: exposure survey_mode_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.exposure
    ADD CONSTRAINT survey_mode_fk FOREIGN KEY (survey_mode_pk) REFERENCES platedb.survey_mode(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: tile_status_history tile_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.tile_status_history
    ADD CONSTRAINT tile_fk FOREIGN KEY (tile_pk) REFERENCES platedb.tile(pk) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plate tile_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.plate
    ADD CONSTRAINT tile_fk FOREIGN KEY (tile_pk) REFERENCES platedb.tile(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: tile tile_status_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.tile
    ADD CONSTRAINT tile_status_fk FOREIGN KEY (tile_status_pk) REFERENCES platedb.tile_status(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: tile_status_history tile_status_fk; Type: FK CONSTRAINT; Schema: platedb; Owner: postgres
--

ALTER TABLE ONLY platedb.tile_status_history
    ADD CONSTRAINT tile_status_fk FOREIGN KEY (tile_status_pk) REFERENCES platedb.tile_status(pk) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: SCHEMA platedb; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA platedb TO sdssdb;
GRANT ALL ON SCHEMA platedb TO sdssdb_admin;


--
-- Name: FUNCTION expmjd(exposurepk integer); Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON FUNCTION platedb.expmjd(exposurepk integer) TO sdssdb;
GRANT ALL ON FUNCTION platedb.expmjd(exposurepk integer) TO sdssdb_admin;


--
-- Name: FUNCTION pc_chartoint(chartoconvert character varying); Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON FUNCTION platedb.pc_chartoint(chartoconvert character varying) TO sdssdb;
GRANT ALL ON FUNCTION platedb.pc_chartoint(chartoconvert character varying) TO sdssdb_admin;


--
-- Name: FUNCTION plateid2pk(plateid integer); Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON FUNCTION platedb.plateid2pk(plateid integer) TO sdssdb;
GRANT ALL ON FUNCTION platedb.plateid2pk(plateid integer) TO sdssdb_admin;


--
-- Name: FUNCTION q3c_ellipse_join(leftra double precision, leftdec double precision, rightra double precision, rightdec double precision, majoraxis double precision, axisratio double precision, pa double precision); Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON FUNCTION platedb.q3c_ellipse_join(leftra double precision, leftdec double precision, rightra double precision, rightdec double precision, majoraxis double precision, axisratio double precision, pa double precision) TO sdssdb;
GRANT ALL ON FUNCTION platedb.q3c_ellipse_join(leftra double precision, leftdec double precision, rightra double precision, rightdec double precision, majoraxis double precision, axisratio double precision, pa double precision) TO sdssdb_admin;


--
-- Name: FUNCTION q3c_ellipse_query(ra_col double precision, dec_col double precision, ra_ell double precision, dec_ell double precision, majax double precision, axis_ratio double precision, pa double precision); Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON FUNCTION platedb.q3c_ellipse_query(ra_col double precision, dec_col double precision, ra_ell double precision, dec_ell double precision, majax double precision, axis_ratio double precision, pa double precision) TO sdssdb;
GRANT ALL ON FUNCTION platedb.q3c_ellipse_query(ra_col double precision, dec_col double precision, ra_ell double precision, dec_ell double precision, majax double precision, axis_ratio double precision, pa double precision) TO sdssdb_admin;


--
-- Name: FUNCTION q3c_ipixcenter(ra double precision, decl double precision, integer); Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON FUNCTION platedb.q3c_ipixcenter(ra double precision, decl double precision, integer) TO sdssdb;
GRANT ALL ON FUNCTION platedb.q3c_ipixcenter(ra double precision, decl double precision, integer) TO sdssdb_admin;


--
-- Name: FUNCTION q3c_join(leftra double precision, leftdec double precision, rightra real, rightdec real, radius double precision); Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON FUNCTION platedb.q3c_join(leftra double precision, leftdec double precision, rightra real, rightdec real, radius double precision) TO sdssdb;
GRANT ALL ON FUNCTION platedb.q3c_join(leftra double precision, leftdec double precision, rightra real, rightdec real, radius double precision) TO sdssdb_admin;


--
-- Name: FUNCTION q3c_join(leftra double precision, leftdec double precision, rightra double precision, rightdec double precision, radius double precision); Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON FUNCTION platedb.q3c_join(leftra double precision, leftdec double precision, rightra double precision, rightdec double precision, radius double precision) TO sdssdb;
GRANT ALL ON FUNCTION platedb.q3c_join(leftra double precision, leftdec double precision, rightra double precision, rightdec double precision, radius double precision) TO sdssdb_admin;


--
-- Name: FUNCTION q3c_join(double precision, double precision, double precision, double precision, bigint, double precision); Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON FUNCTION platedb.q3c_join(double precision, double precision, double precision, double precision, bigint, double precision) TO sdssdb;
GRANT ALL ON FUNCTION platedb.q3c_join(double precision, double precision, double precision, double precision, bigint, double precision) TO sdssdb_admin;


--
-- Name: FUNCTION q3c_poly_query(real, real, double precision[]); Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON FUNCTION platedb.q3c_poly_query(real, real, double precision[]) TO sdssdb;
GRANT ALL ON FUNCTION platedb.q3c_poly_query(real, real, double precision[]) TO sdssdb_admin;


--
-- Name: FUNCTION q3c_poly_query(double precision, double precision, double precision[]); Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON FUNCTION platedb.q3c_poly_query(double precision, double precision, double precision[]) TO sdssdb;
GRANT ALL ON FUNCTION platedb.q3c_poly_query(double precision, double precision, double precision[]) TO sdssdb_admin;


--
-- Name: FUNCTION q3c_radial_query(real, real, double precision, double precision, double precision); Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON FUNCTION platedb.q3c_radial_query(real, real, double precision, double precision, double precision) TO sdssdb;
GRANT ALL ON FUNCTION platedb.q3c_radial_query(real, real, double precision, double precision, double precision) TO sdssdb_admin;


--
-- Name: FUNCTION q3c_radial_query(double precision, double precision, double precision, double precision, double precision); Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON FUNCTION platedb.q3c_radial_query(double precision, double precision, double precision, double precision, double precision) TO sdssdb;
GRANT ALL ON FUNCTION platedb.q3c_radial_query(double precision, double precision, double precision, double precision, double precision) TO sdssdb_admin;


--
-- Name: FUNCTION q3c_radial_query(bigint, double precision, double precision, double precision, double precision, double precision); Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON FUNCTION platedb.q3c_radial_query(bigint, double precision, double precision, double precision, double precision, double precision) TO sdssdb;
GRANT ALL ON FUNCTION platedb.q3c_radial_query(bigint, double precision, double precision, double precision, double precision, double precision) TO sdssdb_admin;


--
-- Name: SEQUENCE active_plugging_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.active_plugging_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.active_plugging_pk_seq TO sdssdb;


--
-- Name: TABLE active_plugging; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.active_plugging TO sdssdb;
GRANT ALL ON TABLE platedb.active_plugging TO sdssdb_admin;


--
-- Name: TABLE apogee_threshold; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.apogee_threshold TO sdssdb;
GRANT ALL ON TABLE platedb.apogee_threshold TO sdssdb_admin;


--
-- Name: SEQUENCE apogee_threshold_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.apogee_threshold_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.apogee_threshold_pk_seq TO sdssdb;


--
-- Name: SEQUENCE boss_plugging_info_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.boss_plugging_info_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.boss_plugging_info_seq TO sdssdb;


--
-- Name: TABLE boss_plugging_info; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.boss_plugging_info TO sdssdb;
GRANT ALL ON TABLE platedb.boss_plugging_info TO sdssdb_admin;


--
-- Name: SEQUENCE boss_sn2_threshold_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.boss_sn2_threshold_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.boss_sn2_threshold_seq TO sdssdb;


--
-- Name: TABLE boss_sn2_threshold; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.boss_sn2_threshold TO sdssdb;
GRANT ALL ON TABLE platedb.boss_sn2_threshold TO sdssdb_admin;


--
-- Name: SEQUENCE camera_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.camera_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.camera_seq TO sdssdb;


--
-- Name: TABLE camera; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.camera TO sdssdb;
GRANT ALL ON TABLE platedb.camera TO sdssdb_admin;


--
-- Name: SEQUENCE camera_frame_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.camera_frame_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.camera_frame_pk_seq TO sdssdb;


--
-- Name: TABLE camera_frame; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.camera_frame TO sdssdb;
GRANT ALL ON TABLE platedb.camera_frame TO sdssdb_admin;


--
-- Name: SEQUENCE cartridge_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.cartridge_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.cartridge_seq TO sdssdb;


--
-- Name: TABLE cartridge; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.cartridge TO sdssdb;
GRANT ALL ON TABLE platedb.cartridge TO sdssdb_admin;


--
-- Name: SEQUENCE cartridge_detail_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.cartridge_detail_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.cartridge_detail_seq TO sdssdb;


--
-- Name: TABLE cartridge_to_survey; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON TABLE platedb.cartridge_to_survey TO sdssdb_admin;
GRANT SELECT ON TABLE platedb.cartridge_to_survey TO sdssdb;


--
-- Name: TABLE cmm_meas; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON TABLE platedb.cmm_meas TO sdssdb_admin;
GRANT SELECT ON TABLE platedb.cmm_meas TO sdssdb;


--
-- Name: SEQUENCE cmm_meas_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.cmm_meas_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.cmm_meas_pk_seq TO sdssdb;


--
-- Name: TABLE constants; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.constants TO sdssdb;
GRANT ALL ON TABLE platedb.constants TO sdssdb_admin;


--
-- Name: SEQUENCE design_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.design_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.design_pk_seq TO sdssdb;


--
-- Name: TABLE design; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.design TO sdssdb;
GRANT ALL ON TABLE platedb.design TO sdssdb_admin;


--
-- Name: SEQUENCE design_field_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.design_field_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.design_field_seq TO sdssdb;


--
-- Name: TABLE design_field; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.design_field TO sdssdb;
GRANT ALL ON TABLE platedb.design_field TO sdssdb_admin;


--
-- Name: SEQUENCE design_values_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.design_values_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.design_values_pk_seq TO sdssdb;


--
-- Name: TABLE design_value; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.design_value TO sdssdb;
GRANT ALL ON TABLE platedb.design_value TO sdssdb_admin;


--
-- Name: TABLE definition_view; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.definition_view TO sdssdb;
GRANT ALL ON TABLE platedb.definition_view TO sdssdb_admin;


--
-- Name: SEQUENCE plate_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plate_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plate_pk_seq TO sdssdb;


--
-- Name: TABLE plate; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate TO sdssdb;
GRANT ALL ON TABLE platedb.plate TO sdssdb_admin;


--
-- Name: SEQUENCE plate_pointing_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plate_pointing_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plate_pointing_seq TO sdssdb;


--
-- Name: TABLE plate_pointing; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate_pointing TO sdssdb;
GRANT ALL ON TABLE platedb.plate_pointing TO sdssdb_admin;


--
-- Name: SEQUENCE pointing_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.pointing_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.pointing_seq TO sdssdb;


--
-- Name: TABLE pointing; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.pointing TO sdssdb;
GRANT ALL ON TABLE platedb.pointing TO sdssdb_admin;


--
-- Name: TABLE designview; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.designview TO sdssdb;
GRANT ALL ON TABLE platedb.designview TO sdssdb_admin;


--
-- Name: SEQUENCE exposure_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.exposure_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.exposure_seq TO sdssdb;


--
-- Name: TABLE exposure; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.exposure TO sdssdb;
GRANT ALL ON TABLE platedb.exposure TO sdssdb_admin;


--
-- Name: TABLE exposure_flavor; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.exposure_flavor TO sdssdb;
GRANT ALL ON TABLE platedb.exposure_flavor TO sdssdb_admin;


--
-- Name: SEQUENCE exposure_flavor_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.exposure_flavor_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.exposure_flavor_pk_seq TO sdssdb;


--
-- Name: TABLE exposure_header_keyword; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.exposure_header_keyword TO sdssdb;
GRANT ALL ON TABLE platedb.exposure_header_keyword TO sdssdb_admin;


--
-- Name: SEQUENCE exposure_header_keyword_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.exposure_header_keyword_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.exposure_header_keyword_pk_seq TO sdssdb;


--
-- Name: TABLE exposure_header_value; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.exposure_header_value TO sdssdb;
GRANT ALL ON TABLE platedb.exposure_header_value TO sdssdb_admin;


--
-- Name: SEQUENCE exposure_header_value_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.exposure_header_value_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.exposure_header_value_pk_seq TO sdssdb;


--
-- Name: TABLE exposure_status; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.exposure_status TO sdssdb;
GRANT ALL ON TABLE platedb.exposure_status TO sdssdb_admin;


--
-- Name: TABLE fiber; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.fiber TO sdssdb;
GRANT ALL ON TABLE platedb.fiber TO sdssdb_admin;


--
-- Name: SEQUENCE fiber_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.fiber_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.fiber_pk_seq TO sdssdb;


--
-- Name: SEQUENCE gprobe_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.gprobe_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.gprobe_seq TO sdssdb;


--
-- Name: TABLE gprobe; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.gprobe TO sdssdb;
GRANT ALL ON TABLE platedb.gprobe TO sdssdb_admin;


--
-- Name: TABLE hole_meas; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON TABLE platedb.hole_meas TO sdssdb_admin;
GRANT SELECT ON TABLE platedb.hole_meas TO sdssdb;


--
-- Name: SEQUENCE hole_meas_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.hole_meas_pk_seq TO sdssdb_admin;
GRANT SELECT ON SEQUENCE platedb.hole_meas_pk_seq TO sdssdb;


--
-- Name: SEQUENCE instrument_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.instrument_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.instrument_pk_seq TO sdssdb;


--
-- Name: TABLE instrument; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.instrument TO sdssdb;
GRANT ALL ON TABLE platedb.instrument TO sdssdb_admin;


--
-- Name: TABLE object_type; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.object_type TO sdssdb;
GRANT ALL ON TABLE platedb.object_type TO sdssdb_admin;


--
-- Name: SEQUENCE object_type_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.object_type_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.object_type_pk_seq TO sdssdb;


--
-- Name: SEQUENCE observation_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.observation_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.observation_pk_seq TO sdssdb;


--
-- Name: TABLE observation; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.observation TO sdssdb;
GRANT ALL ON TABLE platedb.observation TO sdssdb_admin;


--
-- Name: SEQUENCE observation_status_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.observation_status_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.observation_status_pk_seq TO sdssdb;


--
-- Name: TABLE observation_status; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.observation_status TO sdssdb;
GRANT ALL ON TABLE platedb.observation_status TO sdssdb_admin;


--
-- Name: SEQUENCE observation_to_observation_status_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.observation_to_observation_status_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.observation_to_observation_status_pk_seq TO sdssdb;


--
-- Name: SEQUENCE pl_plugmap_m_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.pl_plugmap_m_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.pl_plugmap_m_seq TO sdssdb;


--
-- Name: TABLE pl_plugmap_m; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.pl_plugmap_m TO sdssdb;
GRANT ALL ON TABLE platedb.pl_plugmap_m TO sdssdb_admin;


--
-- Name: TABLE plate_completion_status; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate_completion_status TO sdssdb;
GRANT ALL ON TABLE platedb.plate_completion_status TO sdssdb_admin;


--
-- Name: TABLE plate_completion_status_history; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate_completion_status_history TO sdssdb;
GRANT ALL ON TABLE platedb.plate_completion_status_history TO sdssdb_admin;


--
-- Name: SEQUENCE plate_completion_status_history_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plate_completion_status_history_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plate_completion_status_history_pk_seq TO sdssdb;


--
-- Name: SEQUENCE plate_completion_status_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plate_completion_status_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plate_completion_status_pk_seq TO sdssdb;


--
-- Name: TABLE plate_hole; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate_hole TO sdssdb;
GRANT ALL ON TABLE platedb.plate_hole TO sdssdb_admin;


--
-- Name: SEQUENCE plate_hole_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plate_hole_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plate_hole_pk_seq TO sdssdb;


--
-- Name: TABLE plate_hole_type; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate_hole_type TO sdssdb;
GRANT ALL ON TABLE platedb.plate_hole_type TO sdssdb_admin;


--
-- Name: SEQUENCE plate_hole_type_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plate_hole_type_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plate_hole_type_pk_seq TO sdssdb;


--
-- Name: TABLE plate_holes_file; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate_holes_file TO sdssdb;
GRANT ALL ON TABLE platedb.plate_holes_file TO sdssdb_admin;


--
-- Name: SEQUENCE plate_holes_file_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plate_holes_file_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plate_holes_file_pk_seq TO sdssdb;


--
-- Name: SEQUENCE plate_input_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plate_input_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plate_input_pk_seq TO sdssdb;


--
-- Name: TABLE plate_input; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate_input TO sdssdb;
GRANT ALL ON TABLE platedb.plate_input TO sdssdb_admin;


--
-- Name: SEQUENCE plate_location_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plate_location_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plate_location_pk_seq TO sdssdb;


--
-- Name: TABLE plate_location; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate_location TO sdssdb;
GRANT ALL ON TABLE platedb.plate_location TO sdssdb_admin;


--
-- Name: SEQUENCE pointing_to_pointing_status_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.pointing_to_pointing_status_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.pointing_to_pointing_status_pk_seq TO sdssdb;


--
-- Name: TABLE plate_pointing_to_pointing_status; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate_pointing_to_pointing_status TO sdssdb;
GRANT ALL ON TABLE platedb.plate_pointing_to_pointing_status TO sdssdb_admin;


--
-- Name: SEQUENCE plate_run_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plate_run_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plate_run_pk_seq TO sdssdb;


--
-- Name: TABLE plate_run; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate_run TO sdssdb;
GRANT ALL ON TABLE platedb.plate_run TO sdssdb_admin;


--
-- Name: TABLE plate_run_to_design; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate_run_to_design TO sdssdb;
GRANT ALL ON TABLE platedb.plate_run_to_design TO sdssdb_admin;


--
-- Name: SEQUENCE plate_status_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plate_status_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plate_status_pk_seq TO sdssdb;


--
-- Name: TABLE plate_status; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate_status TO sdssdb;
GRANT ALL ON TABLE platedb.plate_status TO sdssdb_admin;


--
-- Name: SEQUENCE plate_to_instrument_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plate_to_instrument_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plate_to_instrument_pk_seq TO sdssdb;


--
-- Name: TABLE plate_to_instrument; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate_to_instrument TO sdssdb;
GRANT ALL ON TABLE platedb.plate_to_instrument TO sdssdb_admin;


--
-- Name: SEQUENCE plate_to_plate_status_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plate_to_plate_status_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plate_to_plate_status_pk_seq TO sdssdb;


--
-- Name: TABLE plate_to_plate_status; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate_to_plate_status TO sdssdb;
GRANT ALL ON TABLE platedb.plate_to_plate_status TO sdssdb_admin;


--
-- Name: SEQUENCE plate_to_survey_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plate_to_survey_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plate_to_survey_seq TO sdssdb;


--
-- Name: TABLE plate_to_survey; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plate_to_survey TO sdssdb;
GRANT ALL ON TABLE platedb.plate_to_survey TO sdssdb_admin;


--
-- Name: TABLE plateview; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plateview TO sdssdb;
GRANT ALL ON TABLE platedb.plateview TO sdssdb_admin;


--
-- Name: SEQUENCE plugging_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plugging_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plugging_seq TO sdssdb;


--
-- Name: TABLE plugging; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plugging TO sdssdb;
GRANT ALL ON TABLE platedb.plugging TO sdssdb_admin;


--
-- Name: SEQUENCE plugging_status_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plugging_status_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plugging_status_pk_seq TO sdssdb;


--
-- Name: TABLE plugging_status; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plugging_status TO sdssdb;
GRANT ALL ON TABLE platedb.plugging_status TO sdssdb_admin;


--
-- Name: TABLE plugging_to_boss_sn2_threshold; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plugging_to_boss_sn2_threshold TO sdssdb;
GRANT ALL ON TABLE platedb.plugging_to_boss_sn2_threshold TO sdssdb_admin;


--
-- Name: SEQUENCE plugging_to_instrument_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.plugging_to_instrument_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.plugging_to_instrument_seq TO sdssdb;


--
-- Name: TABLE plugging_to_instrument; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plugging_to_instrument TO sdssdb;
GRANT ALL ON TABLE platedb.plugging_to_instrument TO sdssdb_admin;


--
-- Name: TABLE plugmap_view; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.plugmap_view TO sdssdb;
GRANT ALL ON TABLE platedb.plugmap_view TO sdssdb_admin;


--
-- Name: SEQUENCE pointing_status_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.pointing_status_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.pointing_status_pk_seq TO sdssdb;


--
-- Name: TABLE pointing_status; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.pointing_status TO sdssdb;
GRANT ALL ON TABLE platedb.pointing_status TO sdssdb_admin;


--
-- Name: TABLE pointing_view; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.pointing_view TO sdssdb;
GRANT ALL ON TABLE platedb.pointing_view TO sdssdb_admin;


--
-- Name: TABLE pointing_view2; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.pointing_view2 TO sdssdb;
GRANT ALL ON TABLE platedb.pointing_view2 TO sdssdb_admin;


--
-- Name: SEQUENCE prof_meas_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.prof_meas_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.prof_meas_seq TO sdssdb;


--
-- Name: TABLE prof_measurement; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.prof_measurement TO sdssdb;
GRANT ALL ON TABLE platedb.prof_measurement TO sdssdb_admin;


--
-- Name: SEQUENCE prof_tolerances_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.prof_tolerances_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.prof_tolerances_seq TO sdssdb;


--
-- Name: TABLE prof_tolerances; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.prof_tolerances TO sdssdb;
GRANT ALL ON TABLE platedb.prof_tolerances TO sdssdb_admin;


--
-- Name: SEQUENCE profilometry_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.profilometry_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.profilometry_seq TO sdssdb;


--
-- Name: TABLE profilometry; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.profilometry TO sdssdb;
GRANT ALL ON TABLE platedb.profilometry TO sdssdb_admin;


--
-- Name: SEQUENCE survey_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.survey_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.survey_pk_seq TO sdssdb;


--
-- Name: TABLE survey; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.survey TO sdssdb;
GRANT ALL ON TABLE platedb.survey TO sdssdb_admin;


--
-- Name: TABLE survey_mode; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON TABLE platedb.survey_mode TO sdssdb_admin;
GRANT SELECT ON TABLE platedb.survey_mode TO sdssdb;


--
-- Name: SEQUENCE survey_mode_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.survey_mode_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.survey_mode_pk_seq TO sdssdb;


--
-- Name: SEQUENCE test_table_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.test_table_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.test_table_seq TO sdssdb;


--
-- Name: TABLE test; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.test TO sdssdb;
GRANT ALL ON TABLE platedb.test TO sdssdb_admin;


--
-- Name: SEQUENCE tile_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.tile_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.tile_seq TO sdssdb;


--
-- Name: TABLE tile; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.tile TO sdssdb;
GRANT ALL ON TABLE platedb.tile TO sdssdb_admin;


--
-- Name: SEQUENCE tile_status_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.tile_status_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.tile_status_seq TO sdssdb;


--
-- Name: TABLE tile_status; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.tile_status TO sdssdb;
GRANT ALL ON TABLE platedb.tile_status TO sdssdb_admin;


--
-- Name: TABLE tile_status_history; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT SELECT ON TABLE platedb.tile_status_history TO sdssdb;
GRANT ALL ON TABLE platedb.tile_status_history TO sdssdb_admin;


--
-- Name: SEQUENCE tile_status_history_pk_seq; Type: ACL; Schema: platedb; Owner: postgres
--

GRANT ALL ON SEQUENCE platedb.tile_status_history_pk_seq TO sdssdb_admin;
GRANT SELECT,USAGE ON SEQUENCE platedb.tile_status_history_pk_seq TO sdssdb;


--
-- PostgreSQL database dump complete
--

