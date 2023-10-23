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

--
-- Name: collapse_ranges(integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.collapse_ranges(all_results integer[]) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $$
          DECLARE
            x int;
            last_member int;
            current_range int[];
            final_string text;
            result_size int := array_upper(all_results, 1);
            iter int := 0;
          BEGIN
            FOREACH x IN ARRAY all_results 
            LOOP
            
              if current_range is null then
                current_range := array_append(current_range, x);
              else 
                if (x = last_member + 1) then -- if it is the increment of the previous, add to range
                  current_range := array_append(current_range, x);
                else -- next element is non-consecutive
                  if array_upper(current_range,1) > 1 then -- if the previous element ended a range, add it 
                    final_string := concat(final_string, current_range[array_lower(current_range, 1)], ' - ', current_range[array_upper(current_range, 1)]);
                  else
                    final_string := concat(final_string, current_range[array_upper(current_range, 1)]);
                  end if;
                  final_string := concat(final_string, ', ');
                  current_range := '{}';
                  current_range := array_append(current_range, x);
                end if;
              end if;
              last_member := x;
              iter := iter + 1;
              if iter = result_size then -- last entry
                if array_upper(current_range,1) > 1 then -- if the previous element ended a range, add it 
                  final_string := concat(final_string, current_range[array_lower(current_range, 1)], ' - ', current_range[array_upper(current_range, 1)]);
                else
                  final_string := concat(final_string, x);
                end if;
              end if;

            END LOOP;
            return final_string;
          END;
        $$;


--
-- Name: wrap_string(character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.wrap_string(orig_text character varying, max_chunk_length integer DEFAULT 50) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    wrapped_array     VARCHAR[] := '{}';
    wrapped_string    VARCHAR;
    orig_length       INTEGER;
    chunk             VARCHAR;
    iIndex            INTEGER;
    iPos              INTEGER;
BEGIN
  -- max_chunk_length: Max width of each line before wrap
  orig_length := LENGTH(orig_text);

  IF (orig_length <= max_chunk_length) THEN
    -- The string can be returned as-is
    wrapped_string := orig_text;
  ELSE
    -- The string needs to be sliced into chunks of lengths of max_chunk_length
    iPos := 1;
    iIndex := 0;
    WHILE iPos <= orig_length LOOP
      iIndex := iIndex + 1;
      chunk := substring(orig_text, iPos, max_chunk_length);
      -- Each chunk is added into an array
      wrapped_array := array_append(wrapped_array, chunk);
      iPos := iPos + max_chunk_length;
    END LOOP;
      -- Combine array into final wrapped string
      -- Line break is used in JasperReport field with HTML styling
      -- to enforce width:
      wrapped_string := array_to_string(wrapped_array, '<br>');
  END IF;

  RETURN wrapped_string;
END $$;


SET default_tablespace = '';

--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_keys (
    id integer NOT NULL,
    token text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying
);


--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.api_keys_id_seq OWNED BY public.api_keys.id;


--
-- Name: app_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_categories (
    id integer NOT NULL,
    name character varying
);


--
-- Name: app_categories_apps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_categories_apps (
    id integer NOT NULL,
    app_id integer,
    app_category_id integer,
    name character varying
);


--
-- Name: app_categories_apps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_categories_apps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_categories_apps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_categories_apps_id_seq OWNED BY public.app_categories_apps.id;


--
-- Name: app_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_categories_id_seq OWNED BY public.app_categories.id;


--
-- Name: app_runs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_runs (
    id integer NOT NULL,
    started_at timestamp without time zone,
    stopped_at timestamp without time zone,
    app_id integer,
    config text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    state character varying,
    workspace_id integer,
    hidden boolean DEFAULT false
);


--
-- Name: app_runs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_runs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_runs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_runs_id_seq OWNED BY public.app_runs.id;


--
-- Name: apps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.apps (
    id integer NOT NULL,
    name character varying,
    description text,
    rating double precision,
    symbol character varying,
    hidden boolean DEFAULT false
);


--
-- Name: apps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.apps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: apps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.apps_id_seq OWNED BY public.apps.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: async_callbacks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.async_callbacks (
    id integer NOT NULL,
    uuid character varying NOT NULL,
    "timestamp" integer NOT NULL,
    listener_uri character varying,
    target_host character varying,
    target_port character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: async_callbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.async_callbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: async_callbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.async_callbacks_id_seq OWNED BY public.async_callbacks.id;


--
-- Name: automatic_exploitation_match_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.automatic_exploitation_match_results (
    id integer NOT NULL,
    match_id integer,
    run_id integer,
    state character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: automatic_exploitation_match_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.automatic_exploitation_match_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: automatic_exploitation_match_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.automatic_exploitation_match_results_id_seq OWNED BY public.automatic_exploitation_match_results.id;


--
-- Name: automatic_exploitation_match_sets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.automatic_exploitation_match_sets (
    id integer NOT NULL,
    workspace_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: automatic_exploitation_match_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.automatic_exploitation_match_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: automatic_exploitation_match_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.automatic_exploitation_match_sets_id_seq OWNED BY public.automatic_exploitation_match_sets.id;


--
-- Name: automatic_exploitation_matches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.automatic_exploitation_matches (
    id integer NOT NULL,
    module_detail_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    match_set_id integer,
    nexpose_data_exploit_id integer,
    matchable_type character varying,
    matchable_id integer,
    module_fullname text
);


--
-- Name: automatic_exploitation_matches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.automatic_exploitation_matches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: automatic_exploitation_matches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.automatic_exploitation_matches_id_seq OWNED BY public.automatic_exploitation_matches.id;


--
-- Name: automatic_exploitation_runs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.automatic_exploitation_runs (
    id integer NOT NULL,
    workspace_id integer,
    user_id integer,
    match_set_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    state character varying
);


--
-- Name: automatic_exploitation_runs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.automatic_exploitation_runs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: automatic_exploitation_runs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.automatic_exploitation_runs_id_seq OWNED BY public.automatic_exploitation_runs.id;


--
-- Name: banner_message_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.banner_message_users (
    id integer NOT NULL,
    banner_message_id integer,
    user_id integer,
    read boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: banner_message_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.banner_message_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: banner_message_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.banner_message_users_id_seq OWNED BY public.banner_message_users.id;


--
-- Name: banner_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.banner_messages (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    admin boolean
);


--
-- Name: banner_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.banner_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: banner_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.banner_messages_id_seq OWNED BY public.banner_messages.id;


--
-- Name: brute_force_guess_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.brute_force_guess_attempts (
    id integer NOT NULL,
    brute_force_run_id integer NOT NULL,
    brute_force_guess_core_id integer NOT NULL,
    service_id integer NOT NULL,
    attempted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status character varying DEFAULT 'Untried'::character varying,
    session_id integer,
    login_id integer
);


--
-- Name: brute_force_guess_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.brute_force_guess_attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: brute_force_guess_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.brute_force_guess_attempts_id_seq OWNED BY public.brute_force_guess_attempts.id;


--
-- Name: brute_force_guess_cores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.brute_force_guess_cores (
    id integer NOT NULL,
    private_id integer,
    public_id integer,
    realm_id integer,
    workspace_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: brute_force_guess_cores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.brute_force_guess_cores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: brute_force_guess_cores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.brute_force_guess_cores_id_seq OWNED BY public.brute_force_guess_cores.id;


--
-- Name: brute_force_reuse_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.brute_force_reuse_attempts (
    id integer NOT NULL,
    brute_force_run_id integer NOT NULL,
    metasploit_credential_core_id integer NOT NULL,
    service_id integer NOT NULL,
    attempted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status character varying DEFAULT 'Untried'::character varying
);


--
-- Name: brute_force_reuse_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.brute_force_reuse_attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: brute_force_reuse_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.brute_force_reuse_attempts_id_seq OWNED BY public.brute_force_reuse_attempts.id;


--
-- Name: brute_force_reuse_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.brute_force_reuse_groups (
    id integer NOT NULL,
    name character varying NOT NULL,
    workspace_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: brute_force_reuse_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.brute_force_reuse_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: brute_force_reuse_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.brute_force_reuse_groups_id_seq OWNED BY public.brute_force_reuse_groups.id;


--
-- Name: brute_force_reuse_groups_metasploit_credential_cores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.brute_force_reuse_groups_metasploit_credential_cores (
    brute_force_reuse_group_id integer NOT NULL,
    metasploit_credential_core_id integer NOT NULL
);


--
-- Name: brute_force_runs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.brute_force_runs (
    id integer NOT NULL,
    config text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    task_id integer
);


--
-- Name: brute_force_runs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.brute_force_runs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: brute_force_runs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.brute_force_runs_id_seq OWNED BY public.brute_force_runs.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    host_id integer,
    created_at timestamp without time zone,
    ua_string character varying(1024) NOT NULL,
    ua_name character varying(64),
    ua_ver character varying(32),
    updated_at timestamp without time zone
);


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: credential_cores_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.credential_cores_tasks (
    core_id integer,
    task_id integer
);


--
-- Name: credential_logins_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.credential_logins_tasks (
    login_id integer,
    task_id integer
);


--
-- Name: creds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.creds (
    id integer NOT NULL,
    service_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "user" character varying(2048),
    pass character varying(4096),
    active boolean DEFAULT true,
    proof character varying(4096),
    ptype character varying(256),
    source_id integer,
    source_type character varying
);


--
-- Name: creds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.creds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: creds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.creds_id_seq OWNED BY public.creds.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0,
    attempts integer DEFAULT 0,
    handler text,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying,
    queue character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delayed_jobs_id_seq OWNED BY public.delayed_jobs.id;


--
-- Name: egadz_result_ranges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.egadz_result_ranges (
    id integer NOT NULL,
    task_id integer,
    target_host character varying,
    start_port integer,
    end_port integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    state character varying
);


--
-- Name: egadz_result_ranges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.egadz_result_ranges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: egadz_result_ranges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.egadz_result_ranges_id_seq OWNED BY public.egadz_result_ranges.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id integer NOT NULL,
    workspace_id integer,
    host_id integer,
    created_at timestamp without time zone,
    name character varying,
    updated_at timestamp without time zone,
    critical boolean,
    seen boolean,
    username character varying,
    info text,
    module_rhost text,
    module_name text
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: exploit_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exploit_attempts (
    id integer NOT NULL,
    host_id integer,
    service_id integer,
    vuln_id integer,
    attempted_at timestamp without time zone,
    exploited boolean,
    fail_reason character varying,
    username character varying,
    module text,
    session_id integer,
    loot_id integer,
    port integer,
    proto character varying,
    fail_detail text
);


--
-- Name: exploit_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exploit_attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exploit_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exploit_attempts_id_seq OWNED BY public.exploit_attempts.id;


--
-- Name: exploited_hosts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exploited_hosts (
    id integer NOT NULL,
    host_id integer NOT NULL,
    service_id integer,
    session_uuid character varying(8),
    name character varying(2048),
    payload character varying(2048),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: exploited_hosts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exploited_hosts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exploited_hosts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exploited_hosts_id_seq OWNED BY public.exploited_hosts.id;


--
-- Name: exports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exports (
    id integer NOT NULL,
    workspace_id integer NOT NULL,
    created_by character varying,
    export_type character varying,
    name character varying,
    state character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    file_path character varying(1024),
    mask_credentials boolean DEFAULT false,
    completed_at timestamp without time zone,
    included_addresses text,
    excluded_addresses text,
    started_at timestamp without time zone
);


--
-- Name: exports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exports_id_seq OWNED BY public.exports.id;


--
-- Name: generated_payloads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.generated_payloads (
    id integer NOT NULL,
    state character varying,
    file character varying,
    options text,
    workspace_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    generator_error character varying,
    payload_class character varying
);


--
-- Name: generated_payloads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.generated_payloads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: generated_payloads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.generated_payloads_id_seq OWNED BY public.generated_payloads.id;


--
-- Name: host_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.host_details (
    id integer NOT NULL,
    host_id integer,
    nx_console_id integer,
    nx_device_id integer,
    src character varying,
    nx_site_name character varying,
    nx_site_importance character varying,
    nx_scan_template character varying,
    nx_risk_score double precision
);


--
-- Name: host_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.host_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: host_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.host_details_id_seq OWNED BY public.host_details.id;


--
-- Name: hosts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hosts (
    id integer NOT NULL,
    created_at timestamp without time zone,
    address inet NOT NULL,
    mac character varying,
    comm character varying,
    name character varying,
    state character varying,
    os_name character varying,
    os_flavor character varying,
    os_sp character varying,
    os_lang character varying,
    arch character varying,
    workspace_id integer NOT NULL,
    updated_at timestamp without time zone,
    purpose text,
    info character varying(65536),
    comments text,
    scope text,
    virtual_host text,
    note_count integer DEFAULT 0,
    vuln_count integer DEFAULT 0,
    service_count integer DEFAULT 0,
    host_detail_count integer DEFAULT 0,
    exploit_attempt_count integer DEFAULT 0,
    cred_count integer DEFAULT 0,
    history_count integer DEFAULT 0,
    detected_arch character varying,
    os_family character varying
);


--
-- Name: hosts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hosts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hosts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hosts_id_seq OWNED BY public.hosts.id;


--
-- Name: hosts_nexpose_data_assets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hosts_nexpose_data_assets (
    host_id integer,
    nexpose_data_asset_id integer
);


--
-- Name: hosts_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hosts_tags (
    host_id integer,
    tag_id integer,
    id integer NOT NULL
);


--
-- Name: hosts_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hosts_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hosts_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hosts_tags_id_seq OWNED BY public.hosts_tags.id;


--
-- Name: known_ports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.known_ports (
    id integer NOT NULL,
    port integer NOT NULL,
    proto character varying DEFAULT 'tcp'::character varying NOT NULL,
    name character varying NOT NULL,
    info text
);


--
-- Name: known_ports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.known_ports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: known_ports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.known_ports_id_seq OWNED BY public.known_ports.id;


--
-- Name: listeners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.listeners (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    workspace_id integer DEFAULT 1 NOT NULL,
    task_id integer,
    enabled boolean DEFAULT true,
    owner text,
    payload text,
    address text,
    port integer,
    options bytea,
    macro text
);


--
-- Name: listeners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.listeners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: listeners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.listeners_id_seq OWNED BY public.listeners.id;


--
-- Name: loots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.loots (
    id integer NOT NULL,
    workspace_id integer DEFAULT 1 NOT NULL,
    host_id integer,
    service_id integer,
    ltype character varying(512),
    path character varying(1024),
    data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    content_type character varying,
    name text,
    info text,
    module_run_id integer
);


--
-- Name: loots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.loots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: loots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.loots_id_seq OWNED BY public.loots.id;


--
-- Name: macros; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.macros (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    owner text,
    name text,
    description text,
    actions bytea,
    prefs bytea
);


--
-- Name: macros_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.macros_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: macros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.macros_id_seq OWNED BY public.macros.id;


--
-- Name: metasploit_credential_core_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metasploit_credential_core_tags (
    id integer NOT NULL,
    core_id integer NOT NULL,
    tag_id integer NOT NULL
);


--
-- Name: metasploit_credential_core_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metasploit_credential_core_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metasploit_credential_core_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metasploit_credential_core_tags_id_seq OWNED BY public.metasploit_credential_core_tags.id;


--
-- Name: metasploit_credential_cores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metasploit_credential_cores (
    id integer NOT NULL,
    origin_type character varying NOT NULL,
    origin_id integer NOT NULL,
    private_id integer,
    public_id integer,
    realm_id integer,
    workspace_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    logins_count integer DEFAULT 0
);


--
-- Name: metasploit_credential_cores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metasploit_credential_cores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metasploit_credential_cores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metasploit_credential_cores_id_seq OWNED BY public.metasploit_credential_cores.id;


--
-- Name: metasploit_credential_login_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metasploit_credential_login_tags (
    id integer NOT NULL,
    login_id integer NOT NULL,
    tag_id integer NOT NULL
);


--
-- Name: metasploit_credential_login_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metasploit_credential_login_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metasploit_credential_login_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metasploit_credential_login_tags_id_seq OWNED BY public.metasploit_credential_login_tags.id;


--
-- Name: metasploit_credential_logins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metasploit_credential_logins (
    id integer NOT NULL,
    core_id integer NOT NULL,
    service_id integer NOT NULL,
    access_level character varying,
    status character varying NOT NULL,
    last_attempted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: metasploit_credential_logins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metasploit_credential_logins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metasploit_credential_logins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metasploit_credential_logins_id_seq OWNED BY public.metasploit_credential_logins.id;


--
-- Name: metasploit_credential_origin_cracked_passwords; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metasploit_credential_origin_cracked_passwords (
    id integer NOT NULL,
    metasploit_credential_core_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: metasploit_credential_origin_cracked_passwords_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metasploit_credential_origin_cracked_passwords_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metasploit_credential_origin_cracked_passwords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metasploit_credential_origin_cracked_passwords_id_seq OWNED BY public.metasploit_credential_origin_cracked_passwords.id;


--
-- Name: metasploit_credential_origin_imports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metasploit_credential_origin_imports (
    id integer NOT NULL,
    filename text NOT NULL,
    task_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: metasploit_credential_origin_imports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metasploit_credential_origin_imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metasploit_credential_origin_imports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metasploit_credential_origin_imports_id_seq OWNED BY public.metasploit_credential_origin_imports.id;


--
-- Name: metasploit_credential_origin_manuals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metasploit_credential_origin_manuals (
    id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: metasploit_credential_origin_manuals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metasploit_credential_origin_manuals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metasploit_credential_origin_manuals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metasploit_credential_origin_manuals_id_seq OWNED BY public.metasploit_credential_origin_manuals.id;


--
-- Name: metasploit_credential_origin_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metasploit_credential_origin_services (
    id integer NOT NULL,
    service_id integer NOT NULL,
    module_full_name text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: metasploit_credential_origin_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metasploit_credential_origin_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metasploit_credential_origin_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metasploit_credential_origin_services_id_seq OWNED BY public.metasploit_credential_origin_services.id;


--
-- Name: metasploit_credential_origin_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metasploit_credential_origin_sessions (
    id integer NOT NULL,
    post_reference_name text NOT NULL,
    session_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: metasploit_credential_origin_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metasploit_credential_origin_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metasploit_credential_origin_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metasploit_credential_origin_sessions_id_seq OWNED BY public.metasploit_credential_origin_sessions.id;


--
-- Name: metasploit_credential_privates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metasploit_credential_privates (
    id integer NOT NULL,
    type character varying NOT NULL,
    data text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    jtr_format character varying
);


--
-- Name: metasploit_credential_privates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metasploit_credential_privates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metasploit_credential_privates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metasploit_credential_privates_id_seq OWNED BY public.metasploit_credential_privates.id;


--
-- Name: metasploit_credential_publics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metasploit_credential_publics (
    id integer NOT NULL,
    username character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying NOT NULL
);


--
-- Name: metasploit_credential_publics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metasploit_credential_publics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metasploit_credential_publics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metasploit_credential_publics_id_seq OWNED BY public.metasploit_credential_publics.id;


--
-- Name: metasploit_credential_realms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metasploit_credential_realms (
    id integer NOT NULL,
    key character varying NOT NULL,
    value character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: metasploit_credential_realms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metasploit_credential_realms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metasploit_credential_realms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metasploit_credential_realms_id_seq OWNED BY public.metasploit_credential_realms.id;


--
-- Name: mm_domino_edges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mm_domino_edges (
    id integer NOT NULL,
    dest_node_id integer NOT NULL,
    login_id integer NOT NULL,
    run_id integer NOT NULL,
    source_node_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mm_domino_edges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mm_domino_edges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mm_domino_edges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mm_domino_edges_id_seq OWNED BY public.mm_domino_edges.id;


--
-- Name: mm_domino_nodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mm_domino_nodes (
    id integer NOT NULL,
    run_id integer NOT NULL,
    host_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    high_value boolean DEFAULT false,
    captured_creds_count integer DEFAULT 0,
    depth integer DEFAULT 0
);


--
-- Name: mm_domino_nodes_cores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mm_domino_nodes_cores (
    id integer NOT NULL,
    node_id integer NOT NULL,
    core_id integer NOT NULL
);


--
-- Name: mm_domino_nodes_cores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mm_domino_nodes_cores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mm_domino_nodes_cores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mm_domino_nodes_cores_id_seq OWNED BY public.mm_domino_nodes_cores.id;


--
-- Name: mm_domino_nodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mm_domino_nodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mm_domino_nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mm_domino_nodes_id_seq OWNED BY public.mm_domino_nodes.id;


--
-- Name: mod_refs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mod_refs (
    id integer NOT NULL,
    module character varying(1024),
    mtype character varying(128),
    ref text
);


--
-- Name: mod_refs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mod_refs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mod_refs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mod_refs_id_seq OWNED BY public.mod_refs.id;


--
-- Name: module_actions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.module_actions (
    id integer NOT NULL,
    detail_id integer,
    name text
);


--
-- Name: module_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.module_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: module_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.module_actions_id_seq OWNED BY public.module_actions.id;


--
-- Name: module_archs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.module_archs (
    id integer NOT NULL,
    detail_id integer,
    name text
);


--
-- Name: module_archs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.module_archs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: module_archs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.module_archs_id_seq OWNED BY public.module_archs.id;


--
-- Name: module_authors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.module_authors (
    id integer NOT NULL,
    detail_id integer,
    name text,
    email text
);


--
-- Name: module_authors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.module_authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: module_authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.module_authors_id_seq OWNED BY public.module_authors.id;


--
-- Name: module_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.module_details (
    id integer NOT NULL,
    mtime timestamp without time zone,
    file text,
    mtype character varying,
    refname text,
    fullname text,
    name text,
    rank integer,
    description text,
    license character varying,
    privileged boolean,
    disclosure_date timestamp without time zone,
    default_target integer,
    default_action text,
    stance character varying,
    ready boolean
);


--
-- Name: module_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.module_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: module_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.module_details_id_seq OWNED BY public.module_details.id;


--
-- Name: module_mixins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.module_mixins (
    id integer NOT NULL,
    detail_id integer,
    name text
);


--
-- Name: module_mixins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.module_mixins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: module_mixins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.module_mixins_id_seq OWNED BY public.module_mixins.id;


--
-- Name: module_platforms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.module_platforms (
    id integer NOT NULL,
    detail_id integer,
    name text
);


--
-- Name: module_platforms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.module_platforms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: module_platforms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.module_platforms_id_seq OWNED BY public.module_platforms.id;


--
-- Name: module_refs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.module_refs (
    id integer NOT NULL,
    detail_id integer,
    name text
);


--
-- Name: module_refs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.module_refs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: module_refs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.module_refs_id_seq OWNED BY public.module_refs.id;


--
-- Name: module_runs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.module_runs (
    id integer NOT NULL,
    attempted_at timestamp without time zone,
    fail_detail text,
    fail_reason character varying,
    module_fullname text,
    port integer,
    proto character varying,
    session_id integer,
    status character varying,
    trackable_id integer,
    trackable_type character varying,
    user_id integer,
    username character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: module_runs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.module_runs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: module_runs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.module_runs_id_seq OWNED BY public.module_runs.id;


--
-- Name: module_targets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.module_targets (
    id integer NOT NULL,
    detail_id integer,
    index integer,
    name text
);


--
-- Name: module_targets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.module_targets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: module_targets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.module_targets_id_seq OWNED BY public.module_targets.id;


--
-- Name: nexpose_consoles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_consoles (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    enabled boolean DEFAULT true,
    owner text,
    address text,
    port integer DEFAULT 3780,
    username text,
    password text,
    status text,
    version text,
    cert text,
    cached_sites bytea,
    name text
);


--
-- Name: nexpose_consoles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nexpose_consoles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nexpose_consoles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nexpose_consoles_id_seq OWNED BY public.nexpose_consoles.id;


--
-- Name: nexpose_data_assets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_data_assets (
    id integer NOT NULL,
    asset_id text NOT NULL,
    url text,
    host_names text,
    os_name text,
    mac_addresses text,
    last_scan_date timestamp without time zone,
    next_scan_date timestamp without time zone,
    last_scan_id text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: nexpose_data_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nexpose_data_assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nexpose_data_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nexpose_data_assets_id_seq OWNED BY public.nexpose_data_assets.id;


--
-- Name: nexpose_data_assets_sites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_data_assets_sites (
    nexpose_data_asset_id integer,
    nexpose_data_site_id integer
);


--
-- Name: nexpose_data_exploits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_data_exploits (
    id integer NOT NULL,
    nexpose_exploit_id text,
    skill_level text,
    description text,
    source_key text,
    source text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: nexpose_data_exploits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nexpose_data_exploits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nexpose_data_exploits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nexpose_data_exploits_id_seq OWNED BY public.nexpose_data_exploits.id;


--
-- Name: nexpose_data_exploits_vulnerability_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_data_exploits_vulnerability_definitions (
    exploit_id integer,
    vulnerability_definition_id integer
);


--
-- Name: nexpose_data_import_runs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_data_import_runs (
    id integer NOT NULL,
    user_id integer,
    workspace_id integer,
    state text,
    nx_console_id integer,
    metasploitable_only boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    import_state text,
    latest_scan_only boolean DEFAULT false,
    new_scan boolean
);


--
-- Name: nexpose_data_import_runs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nexpose_data_import_runs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nexpose_data_import_runs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nexpose_data_import_runs_id_seq OWNED BY public.nexpose_data_import_runs.id;


--
-- Name: nexpose_data_ip_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_data_ip_addresses (
    id integer NOT NULL,
    nexpose_data_asset_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    address inet
);


--
-- Name: nexpose_data_ip_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nexpose_data_ip_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nexpose_data_ip_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nexpose_data_ip_addresses_id_seq OWNED BY public.nexpose_data_ip_addresses.id;


--
-- Name: nexpose_data_scan_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_data_scan_templates (
    id integer NOT NULL,
    nx_console_id integer NOT NULL,
    scan_template_id text NOT NULL,
    name text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: nexpose_data_scan_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nexpose_data_scan_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nexpose_data_scan_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nexpose_data_scan_templates_id_seq OWNED BY public.nexpose_data_scan_templates.id;


--
-- Name: nexpose_data_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_data_services (
    id integer NOT NULL,
    nexpose_data_asset_id integer,
    port integer,
    proto character varying,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: nexpose_data_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nexpose_data_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nexpose_data_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nexpose_data_services_id_seq OWNED BY public.nexpose_data_services.id;


--
-- Name: nexpose_data_sites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_data_sites (
    id integer NOT NULL,
    nexpose_data_import_run_id integer NOT NULL,
    site_id text NOT NULL,
    name text,
    description text,
    importance text,
    type text,
    last_scan_date timestamp without time zone,
    next_scan_date timestamp without time zone,
    last_scan_id text,
    summary text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: nexpose_data_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nexpose_data_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nexpose_data_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nexpose_data_sites_id_seq OWNED BY public.nexpose_data_sites.id;


--
-- Name: nexpose_data_vulnerabilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_data_vulnerabilities (
    id integer NOT NULL,
    nexpose_data_vulnerability_definition_id integer NOT NULL,
    vulnerability_id text NOT NULL,
    title text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: nexpose_data_vulnerabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nexpose_data_vulnerabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nexpose_data_vulnerabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nexpose_data_vulnerabilities_id_seq OWNED BY public.nexpose_data_vulnerabilities.id;


--
-- Name: nexpose_data_vulnerability_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_data_vulnerability_definitions (
    id integer NOT NULL,
    vulnerability_definition_id text,
    title text,
    description text,
    date_published date,
    severity_score integer,
    severity text,
    pci_severity_score text,
    pci_status text,
    riskscore numeric,
    cvss_vector text,
    cvss_access_vector_id text,
    cvss_access_complexity_id text,
    cvss_authentication_id text,
    cvss_confidentiality_impact_id text,
    cvss_integrity_impact_id text,
    cvss_availability_impact_id text,
    cvss_score numeric,
    cvss_exploit_score numeric,
    cvss_impact_score numeric,
    denial_of_service boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: nexpose_data_vulnerability_definitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nexpose_data_vulnerability_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nexpose_data_vulnerability_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nexpose_data_vulnerability_definitions_id_seq OWNED BY public.nexpose_data_vulnerability_definitions.id;


--
-- Name: nexpose_data_vulnerability_instances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_data_vulnerability_instances (
    id integer NOT NULL,
    vulnerability_id text,
    asset_id text,
    nexpose_data_vulnerability_id integer,
    nexpose_data_asset_id integer,
    scan_id text,
    date date,
    status text,
    proof text,
    key text,
    service text,
    port integer,
    protocol text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    asset_ip_address inet
);


--
-- Name: nexpose_data_vulnerability_instances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nexpose_data_vulnerability_instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nexpose_data_vulnerability_instances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nexpose_data_vulnerability_instances_id_seq OWNED BY public.nexpose_data_vulnerability_instances.id;


--
-- Name: nexpose_data_vulnerability_references; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_data_vulnerability_references (
    id integer NOT NULL,
    nexpose_data_vulnerability_definition_id integer,
    vulnerability_reference_id text,
    source text,
    reference text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: nexpose_data_vulnerability_references_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nexpose_data_vulnerability_references_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nexpose_data_vulnerability_references_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nexpose_data_vulnerability_references_id_seq OWNED BY public.nexpose_data_vulnerability_references.id;


--
-- Name: nexpose_result_exceptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_result_exceptions (
    id integer NOT NULL,
    user_id integer,
    nx_scope_type text,
    nx_scope_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    automatic_exploitation_match_result_id integer,
    nexpose_result_export_run_id integer,
    expiration_date timestamp without time zone,
    reason text,
    comments text,
    approve boolean,
    sent_to_nexpose boolean,
    sent_at timestamp without time zone,
    state text,
    nexpose_response text
);


--
-- Name: nexpose_result_exceptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nexpose_result_exceptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nexpose_result_exceptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nexpose_result_exceptions_id_seq OWNED BY public.nexpose_result_exceptions.id;


--
-- Name: nexpose_result_export_runs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_result_export_runs (
    id integer NOT NULL,
    state text,
    user_id integer,
    workspace_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: nexpose_result_export_runs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nexpose_result_export_runs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nexpose_result_export_runs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nexpose_result_export_runs_id_seq OWNED BY public.nexpose_result_export_runs.id;


--
-- Name: nexpose_result_validations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nexpose_result_validations (
    id integer NOT NULL,
    user_id integer,
    nexpose_data_asset_id integer,
    verified_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    automatic_exploitation_match_result_id integer,
    nexpose_result_export_run_id integer,
    sent_to_nexpose boolean,
    sent_at timestamp without time zone,
    state text,
    nexpose_response text
);


--
-- Name: nexpose_result_validations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nexpose_result_validations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nexpose_result_validations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nexpose_result_validations_id_seq OWNED BY public.nexpose_result_validations.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notes (
    id integer NOT NULL,
    created_at timestamp without time zone,
    ntype character varying(512),
    workspace_id integer DEFAULT 1 NOT NULL,
    service_id integer,
    host_id integer,
    updated_at timestamp without time zone,
    critical boolean,
    seen boolean,
    data text,
    vuln_id integer
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;


--
-- Name: notification_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_messages (
    id integer NOT NULL,
    workspace_id integer,
    task_id integer,
    title character varying,
    content text,
    url character varying,
    kind character varying,
    created_at timestamp without time zone
);


--
-- Name: notification_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notification_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notification_messages_id_seq OWNED BY public.notification_messages.id;


--
-- Name: notification_messages_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_messages_users (
    id integer NOT NULL,
    user_id integer,
    message_id integer,
    read boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: notification_messages_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notification_messages_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_messages_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notification_messages_users_id_seq OWNED BY public.notification_messages_users.id;


--
-- Name: payloads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payloads (
    id integer NOT NULL,
    name character varying,
    uuid character varying,
    uuid_mask integer,
    "timestamp" integer,
    arch character varying,
    platform character varying,
    urls character varying,
    description character varying,
    raw_payload character varying,
    raw_payload_hash character varying,
    build_status character varying,
    build_opts character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: payloads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payloads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payloads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payloads_id_seq OWNED BY public.payloads.id;


--
-- Name: pnd_pcap_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pnd_pcap_files (
    id integer NOT NULL,
    task_id integer,
    loot_id integer,
    status character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pnd_pcap_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pnd_pcap_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pnd_pcap_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pnd_pcap_files_id_seq OWNED BY public.pnd_pcap_files.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    active boolean DEFAULT true,
    name text,
    owner text,
    settings bytea
);


--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.profiles_id_seq OWNED BY public.profiles.id;


--
-- Name: refs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refs (
    id integer NOT NULL,
    ref_id integer,
    created_at timestamp without time zone,
    name character varying(512),
    updated_at timestamp without time zone
);


--
-- Name: refs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.refs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.refs_id_seq OWNED BY public.refs.id;


--
-- Name: report_artifacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.report_artifacts (
    id integer NOT NULL,
    report_id integer NOT NULL,
    file_path character varying(1024) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    accessed_at timestamp without time zone,
    format character varying
);


--
-- Name: report_artifacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.report_artifacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: report_artifacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.report_artifacts_id_seq OWNED BY public.report_artifacts.id;


--
-- Name: report_custom_resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.report_custom_resources (
    id integer NOT NULL,
    workspace_id integer NOT NULL,
    created_by character varying,
    resource_type character varying,
    name character varying,
    file_path character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: report_custom_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.report_custom_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: report_custom_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.report_custom_resources_id_seq OWNED BY public.report_custom_resources.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reports (
    id integer NOT NULL,
    workspace_id integer NOT NULL,
    created_by character varying,
    report_type character varying,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    file_formats character varying,
    options text,
    sections character varying,
    report_template character varying,
    included_addresses text,
    state character varying DEFAULT 'unverified'::character varying NOT NULL,
    started_at timestamp without time zone,
    completed_at timestamp without time zone,
    excluded_addresses text,
    se_campaign_id integer,
    app_run_id integer,
    order_vulns_by character varying,
    usernames_reported text,
    skip_data_check boolean DEFAULT false,
    email_recipients text,
    logo_path text
);


--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reports_id_seq OWNED BY public.reports.id;


--
-- Name: routes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.routes (
    id integer NOT NULL,
    session_id integer,
    subnet character varying,
    netmask character varying
);


--
-- Name: routes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.routes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: routes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.routes_id_seq OWNED BY public.routes.id;


--
-- Name: run_stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.run_stats (
    id integer NOT NULL,
    name character varying,
    data double precision,
    task_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: run_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.run_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: run_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.run_stats_id_seq OWNED BY public.run_stats.id;


--
-- Name: scheduled_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scheduled_tasks (
    id integer NOT NULL,
    kind character varying,
    last_run_at timestamp without time zone,
    state character varying,
    last_run_status character varying,
    task_chain_id integer,
    "position" integer,
    config_hash text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    form_hash text,
    report_hash text,
    file_upload character varying,
    legacy boolean DEFAULT false
);


--
-- Name: scheduled_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scheduled_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scheduled_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scheduled_tasks_id_seq OWNED BY public.scheduled_tasks.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: se_campaign_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_campaign_files (
    id integer NOT NULL,
    attachable_type character varying,
    attachable_id integer,
    attachment character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    content_disposition character varying,
    type character varying,
    workspace_id integer,
    user_id integer,
    name character varying,
    file_size integer
);


--
-- Name: se_campaign_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_campaign_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_campaign_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_campaign_files_id_seq OWNED BY public.se_campaign_files.id;


--
-- Name: se_campaigns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_campaigns (
    id integer NOT NULL,
    user_id integer,
    workspace_id integer,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    state character varying DEFAULT 'unconfigured'::character varying,
    prefs text,
    port integer,
    started_at timestamp without time zone,
    config_type character varying,
    started_by_user_id integer,
    notification_enabled boolean,
    notification_email_address character varying,
    notification_email_message text,
    notification_email_subject character varying,
    last_target_interaction_at timestamp without time zone,
    ssl_cert_id integer,
    ssl_cipher text DEFAULT 'EECDH+AESGCM:EDH+AESGCM:ECDHE-RSA-AES128-GCM-SHA256:AES256+EECDH:DHE-RSA-AES128-GCM-SHA256:AES256+EDH:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4:!SSLv3'::text
);


--
-- Name: se_campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_campaigns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_campaigns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_campaigns_id_seq OWNED BY public.se_campaigns.id;


--
-- Name: se_email_openings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_email_openings (
    id integer NOT NULL,
    email_id integer,
    human_target_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    address inet
);


--
-- Name: se_email_openings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_email_openings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_email_openings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_email_openings_id_seq OWNED BY public.se_email_openings.id;


--
-- Name: se_email_sends; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_email_sends (
    id integer NOT NULL,
    email_id integer,
    human_target_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sent boolean,
    status_message character varying
);


--
-- Name: se_email_sends_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_email_sends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_email_sends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_email_sends_id_seq OWNED BY public.se_email_sends.id;


--
-- Name: se_email_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_email_templates (
    id integer NOT NULL,
    user_id integer,
    content text,
    name character varying,
    workspace_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: se_email_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_email_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_email_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_email_templates_id_seq OWNED BY public.se_email_templates.id;


--
-- Name: se_emails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_emails (
    id integer NOT NULL,
    user_id integer,
    content text,
    name character varying,
    subject character varying,
    campaign_id integer,
    template_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    from_address character varying,
    from_name character varying,
    target_list_id integer,
    email_template_id integer,
    prefs text,
    attack_type character varying,
    status character varying,
    sent_at timestamp without time zone,
    origin_type character varying,
    editor_type character varying,
    exclude_tracking boolean DEFAULT false
);


--
-- Name: se_emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_emails_id_seq OWNED BY public.se_emails.id;


--
-- Name: se_human_targets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_human_targets (
    id integer NOT NULL,
    first_name character varying,
    last_name character varying,
    email_address character varying,
    workspace_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: se_human_targets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_human_targets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_human_targets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_human_targets_id_seq OWNED BY public.se_human_targets.id;


--
-- Name: se_phishing_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_phishing_results (
    id integer NOT NULL,
    human_target_id integer,
    web_page_id integer,
    data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    address inet,
    raw_data text,
    browser_name character varying,
    browser_version character varying,
    os_name character varying,
    os_version character varying
);


--
-- Name: se_phishing_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_phishing_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_phishing_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_phishing_results_id_seq OWNED BY public.se_phishing_results.id;


--
-- Name: se_portable_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_portable_files (
    id integer NOT NULL,
    campaign_id integer,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    prefs text,
    file_name character varying,
    exploit_module_path character varying,
    dynamic_stagers boolean DEFAULT false
);


--
-- Name: se_portable_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_portable_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_portable_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_portable_files_id_seq OWNED BY public.se_portable_files.id;


--
-- Name: se_target_list_human_targets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_target_list_human_targets (
    id integer NOT NULL,
    target_list_id integer,
    human_target_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: se_target_list_human_targets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_target_list_human_targets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_target_list_human_targets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_target_list_human_targets_id_seq OWNED BY public.se_target_list_human_targets.id;


--
-- Name: se_target_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_target_lists (
    id integer NOT NULL,
    name character varying,
    file_name character varying,
    user_id integer,
    workspace_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: se_target_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_target_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_target_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_target_lists_id_seq OWNED BY public.se_target_lists.id;


--
-- Name: se_tracking_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_tracking_links (
    id integer NOT NULL,
    external_destination_url character varying,
    email_id integer,
    web_page_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: se_tracking_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_tracking_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_tracking_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_tracking_links_id_seq OWNED BY public.se_tracking_links.id;


--
-- Name: se_trackings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_trackings (
    id bigint NOT NULL,
    uuid uuid NOT NULL,
    human_target_id bigint NOT NULL,
    email_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: se_trackings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_trackings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_trackings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_trackings_id_seq OWNED BY public.se_trackings.id;


--
-- Name: se_visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_visits (
    id integer NOT NULL,
    human_target_id integer,
    web_page_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email_id integer,
    address inet
);


--
-- Name: se_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_visits_id_seq OWNED BY public.se_visits.id;


--
-- Name: se_web_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_web_pages (
    id integer NOT NULL,
    campaign_id integer,
    path character varying,
    content text,
    clone_url character varying,
    online boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    prefs text,
    template_id integer,
    attack_type character varying,
    origin_type character varying,
    phishing_redirect_origin character varying,
    save_form_data boolean DEFAULT true,
    original_content character varying
);


--
-- Name: se_web_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_web_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_web_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_web_pages_id_seq OWNED BY public.se_web_pages.id;


--
-- Name: se_web_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.se_web_templates (
    id integer NOT NULL,
    name character varying,
    workspace_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    content text,
    clone_url character varying,
    origin_type character varying
);


--
-- Name: se_web_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.se_web_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: se_web_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.se_web_templates_id_seq OWNED BY public.se_web_templates.id;


--
-- Name: services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.services (
    id integer NOT NULL,
    host_id integer,
    created_at timestamp without time zone,
    port integer NOT NULL,
    proto character varying(16) NOT NULL,
    state character varying,
    name character varying,
    updated_at timestamp without time zone,
    info text
);


--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- Name: session_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session_events (
    id integer NOT NULL,
    session_id integer,
    etype character varying,
    command bytea,
    output bytea,
    remote_path character varying,
    local_path character varying,
    created_at timestamp without time zone
);


--
-- Name: session_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.session_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: session_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.session_events_id_seq OWNED BY public.session_events.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    host_id integer,
    stype character varying,
    via_exploit character varying,
    via_payload character varying,
    "desc" character varying,
    port integer,
    platform character varying,
    datastore text,
    opened_at timestamp without time zone NOT NULL,
    closed_at timestamp without time zone,
    close_reason character varying,
    local_id integer,
    last_seen timestamp without time zone,
    campaign_id integer,
    module_run_id integer
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: sonar_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sonar_accounts (
    id integer NOT NULL,
    email character varying,
    api_key character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sonar_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sonar_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sonar_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sonar_accounts_id_seq OWNED BY public.sonar_accounts.id;


--
-- Name: sonar_data_fdns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sonar_data_fdns (
    id integer NOT NULL,
    import_run_id integer,
    hostname character varying,
    address inet,
    last_seen timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sonar_data_fdns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sonar_data_fdns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sonar_data_fdns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sonar_data_fdns_id_seq OWNED BY public.sonar_data_fdns.id;


--
-- Name: sonar_data_import_runs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sonar_data_import_runs (
    id integer NOT NULL,
    user_id integer,
    workspace_id integer,
    domain character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_seen integer DEFAULT 30
);


--
-- Name: sonar_data_import_runs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sonar_data_import_runs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sonar_data_import_runs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sonar_data_import_runs_id_seq OWNED BY public.sonar_data_import_runs.id;


--
-- Name: ssl_certs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ssl_certs (
    id integer NOT NULL,
    name character varying,
    file character varying,
    workspace_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ssl_certs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ssl_certs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ssl_certs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ssl_certs_id_seq OWNED BY public.ssl_certs.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    user_id integer,
    name character varying(1024),
    "desc" text,
    report_summary boolean DEFAULT false NOT NULL,
    report_detail boolean DEFAULT false NOT NULL,
    critical boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: task_chains; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_chains (
    id integer NOT NULL,
    schedule text,
    name character varying,
    last_run_at timestamp without time zone,
    next_run_at timestamp without time zone,
    user_id integer,
    workspace_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    state character varying DEFAULT 'ready'::character varying,
    clear_workspace_before_run boolean,
    legacy boolean DEFAULT true,
    active_task_id integer,
    schedule_hash text,
    active_scheduled_task_id integer,
    active_report_id integer,
    last_run_task_id integer,
    last_run_report_id integer
);


--
-- Name: task_chains_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.task_chains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_chains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.task_chains_id_seq OWNED BY public.task_chains.id;


--
-- Name: task_creds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_creds (
    id integer NOT NULL,
    task_id integer NOT NULL,
    cred_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: task_creds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.task_creds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_creds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.task_creds_id_seq OWNED BY public.task_creds.id;


--
-- Name: task_hosts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_hosts (
    id integer NOT NULL,
    task_id integer NOT NULL,
    host_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: task_hosts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.task_hosts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_hosts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.task_hosts_id_seq OWNED BY public.task_hosts.id;


--
-- Name: task_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_services (
    id integer NOT NULL,
    task_id integer NOT NULL,
    service_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: task_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.task_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.task_services_id_seq OWNED BY public.task_services.id;


--
-- Name: task_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_sessions (
    id integer NOT NULL,
    task_id integer NOT NULL,
    session_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: task_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.task_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.task_sessions_id_seq OWNED BY public.task_sessions.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks (
    id integer NOT NULL,
    workspace_id integer DEFAULT 1 NOT NULL,
    created_by character varying,
    module character varying,
    completed_at timestamp without time zone,
    path character varying(1024),
    info character varying,
    description character varying,
    progress integer,
    options text,
    error text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    result text,
    module_uuid character varying(8),
    settings bytea,
    app_run_id integer,
    presenter character varying,
    state character varying DEFAULT 'unstarted'::character varying
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: usage_metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usage_metrics (
    id integer NOT NULL,
    key character varying NOT NULL,
    value character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: usage_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usage_metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usage_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usage_metrics_id_seq OWNED BY public.usage_metrics.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying,
    crypted_password character varying,
    password_salt character varying,
    persistence_token character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fullname character varying,
    email character varying,
    phone character varying,
    company character varying,
    prefs character varying(524288),
    admin boolean DEFAULT true NOT NULL,
    notification_center_count integer DEFAULT 0,
    last_request_at timestamp without time zone,
    failed_login_count integer,
    current_login_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vuln_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vuln_attempts (
    id integer NOT NULL,
    vuln_id integer,
    attempted_at timestamp without time zone,
    exploited boolean,
    fail_reason character varying,
    username character varying,
    module text,
    session_id integer,
    loot_id integer,
    fail_detail text,
    last_fail_reason character varying
);


--
-- Name: vuln_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vuln_attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vuln_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vuln_attempts_id_seq OWNED BY public.vuln_attempts.id;


--
-- Name: vuln_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vuln_details (
    id integer NOT NULL,
    vuln_id integer,
    cvss_score double precision,
    cvss_vector character varying,
    title character varying,
    description text,
    solution text,
    proof bytea,
    nx_console_id integer,
    nx_device_id integer,
    nx_vuln_id character varying,
    nx_severity double precision,
    nx_pci_severity double precision,
    nx_published timestamp without time zone,
    nx_added timestamp without time zone,
    nx_modified timestamp without time zone,
    nx_tags text,
    nx_vuln_status text,
    nx_proof_key text,
    src character varying,
    nx_scan_id integer,
    nx_vulnerable_since timestamp without time zone,
    nx_pci_compliance_status character varying
);


--
-- Name: vuln_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vuln_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vuln_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vuln_details_id_seq OWNED BY public.vuln_details.id;


--
-- Name: vulns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vulns (
    id integer NOT NULL,
    host_id integer,
    service_id integer,
    created_at timestamp without time zone,
    name character varying,
    updated_at timestamp without time zone,
    info character varying(65536),
    exploited_at timestamp without time zone,
    vuln_detail_count integer DEFAULT 0,
    vuln_attempt_count integer DEFAULT 0,
    nexpose_data_vuln_def_id integer,
    origin_id integer,
    origin_type character varying
);


--
-- Name: vulns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vulns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vulns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vulns_id_seq OWNED BY public.vulns.id;


--
-- Name: vulns_refs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vulns_refs (
    ref_id integer,
    vuln_id integer,
    id integer NOT NULL
);


--
-- Name: vulns_refs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vulns_refs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vulns_refs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vulns_refs_id_seq OWNED BY public.vulns_refs.id;


--
-- Name: web_attack_cross_site_scriptings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_attack_cross_site_scriptings (
    id integer NOT NULL,
    encloser_type character varying NOT NULL,
    escaper_type character varying NOT NULL,
    evader_type character varying NOT NULL,
    executor_type character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: web_attack_cross_site_scriptings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_attack_cross_site_scriptings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_attack_cross_site_scriptings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_attack_cross_site_scriptings_id_seq OWNED BY public.web_attack_cross_site_scriptings.id;


--
-- Name: web_cookies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_cookies (
    id integer NOT NULL,
    name character varying NOT NULL,
    value character varying NOT NULL,
    request_group_id integer NOT NULL,
    domain character varying NOT NULL,
    path character varying,
    secure boolean DEFAULT false NOT NULL,
    http_only boolean DEFAULT false NOT NULL,
    version integer,
    commnet character varying,
    comment_url character varying,
    discard boolean DEFAULT false NOT NULL,
    ports text,
    max_age integer,
    expires_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: web_cookies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_cookies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_cookies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_cookies_id_seq OWNED BY public.web_cookies.id;


--
-- Name: web_forms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_forms (
    id integer NOT NULL,
    web_site_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    path text,
    method character varying(1024),
    params text,
    query text
);


--
-- Name: web_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_forms_id_seq OWNED BY public.web_forms.id;


--
-- Name: web_headers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_headers (
    id integer NOT NULL,
    attack_vector boolean NOT NULL,
    name character varying NOT NULL,
    value character varying NOT NULL,
    "position" integer NOT NULL,
    request_group_id integer NOT NULL
);


--
-- Name: web_headers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_headers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_headers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_headers_id_seq OWNED BY public.web_headers.id;


--
-- Name: web_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_pages (
    id integer NOT NULL,
    web_site_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    path text,
    query text,
    code integer NOT NULL,
    cookie text,
    auth text,
    ctype text,
    mtime timestamp without time zone,
    location text,
    headers text,
    body bytea,
    request bytea
);


--
-- Name: web_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_pages_id_seq OWNED BY public.web_pages.id;


--
-- Name: web_parameters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_parameters (
    id integer NOT NULL,
    attack_vector boolean NOT NULL,
    name character varying NOT NULL,
    value character varying NOT NULL,
    request_id integer NOT NULL,
    "position" integer NOT NULL
);


--
-- Name: web_parameters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_parameters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_parameters_id_seq OWNED BY public.web_parameters.id;


--
-- Name: web_proofs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_proofs (
    id integer NOT NULL,
    image character varying,
    text text,
    vuln_id integer NOT NULL
);


--
-- Name: web_proofs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_proofs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_proofs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_proofs_id_seq OWNED BY public.web_proofs.id;


--
-- Name: web_request_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_request_groups (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer NOT NULL,
    workspace_id integer NOT NULL
);


--
-- Name: web_request_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_request_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_request_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_request_groups_id_seq OWNED BY public.web_request_groups.id;


--
-- Name: web_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_requests (
    id integer NOT NULL,
    method character varying NOT NULL,
    virtual_host_id integer NOT NULL,
    path character varying NOT NULL,
    attack boolean DEFAULT true,
    requested boolean,
    attack_vector boolean,
    request_group_id integer,
    cross_site_scripting_id integer
);


--
-- Name: web_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_requests_id_seq OWNED BY public.web_requests.id;


--
-- Name: web_sites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_sites (
    id integer NOT NULL,
    service_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    vhost character varying(2048),
    comments text,
    options text
);


--
-- Name: web_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_sites_id_seq OWNED BY public.web_sites.id;


--
-- Name: web_transmitted_cookies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_transmitted_cookies (
    id integer NOT NULL,
    transmitted boolean,
    request_id integer,
    cookie_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: web_transmitted_cookies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_transmitted_cookies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_transmitted_cookies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_transmitted_cookies_id_seq OWNED BY public.web_transmitted_cookies.id;


--
-- Name: web_transmitted_headers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_transmitted_headers (
    id integer NOT NULL,
    transmitted boolean,
    request_id integer,
    header_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: web_transmitted_headers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_transmitted_headers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_transmitted_headers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_transmitted_headers_id_seq OWNED BY public.web_transmitted_headers.id;


--
-- Name: web_virtual_hosts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_virtual_hosts (
    id integer NOT NULL,
    name character varying NOT NULL,
    service_id integer NOT NULL
);


--
-- Name: web_virtual_hosts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_virtual_hosts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_virtual_hosts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_virtual_hosts_id_seq OWNED BY public.web_virtual_hosts.id;


--
-- Name: web_vuln_category_metasploits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_vuln_category_metasploits (
    id integer NOT NULL,
    name character varying NOT NULL,
    summary character varying NOT NULL
);


--
-- Name: web_vuln_category_metasploits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_vuln_category_metasploits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_vuln_category_metasploits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_vuln_category_metasploits_id_seq OWNED BY public.web_vuln_category_metasploits.id;


--
-- Name: web_vuln_category_owasps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_vuln_category_owasps (
    id integer NOT NULL,
    detectability character varying NOT NULL,
    exploitability character varying NOT NULL,
    impact character varying NOT NULL,
    name character varying NOT NULL,
    prevalence character varying NOT NULL,
    rank integer NOT NULL,
    summary character varying NOT NULL,
    target character varying NOT NULL,
    version character varying NOT NULL
);


--
-- Name: web_vuln_category_owasps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_vuln_category_owasps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_vuln_category_owasps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_vuln_category_owasps_id_seq OWNED BY public.web_vuln_category_owasps.id;


--
-- Name: web_vuln_category_projection_metasploit_owasps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_vuln_category_projection_metasploit_owasps (
    id integer NOT NULL,
    metasploit_id integer NOT NULL,
    owasp_id integer NOT NULL
);


--
-- Name: web_vuln_category_projection_metasploit_owasps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_vuln_category_projection_metasploit_owasps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_vuln_category_projection_metasploit_owasps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_vuln_category_projection_metasploit_owasps_id_seq OWNED BY public.web_vuln_category_projection_metasploit_owasps.id;


--
-- Name: web_vulns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_vulns (
    id integer NOT NULL,
    web_site_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    path text NOT NULL,
    method character varying(1024) NOT NULL,
    params text,
    pname text,
    risk integer NOT NULL,
    name character varying(1024) NOT NULL,
    query text,
    legacy_category text,
    confidence integer NOT NULL,
    description text,
    blame text,
    request bytea,
    owner character varying,
    payload text,
    request_id integer,
    category_id integer
);


--
-- Name: web_vulns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_vulns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_vulns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_vulns_id_seq OWNED BY public.web_vulns.id;


--
-- Name: wizard_procedures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wizard_procedures (
    id integer NOT NULL,
    config_hash text,
    state character varying,
    task_chain_id integer,
    type character varying,
    workspace_id integer,
    user_id integer
);


--
-- Name: wizard_procedures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wizard_procedures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wizard_procedures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wizard_procedures_id_seq OWNED BY public.wizard_procedures.id;


--
-- Name: wmap_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wmap_requests (
    id integer NOT NULL,
    host character varying,
    address inet,
    port integer,
    ssl integer,
    meth character varying(32),
    path text,
    headers text,
    query text,
    body text,
    respcode character varying(16),
    resphead text,
    response text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: wmap_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wmap_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wmap_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wmap_requests_id_seq OWNED BY public.wmap_requests.id;


--
-- Name: wmap_targets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wmap_targets (
    id integer NOT NULL,
    host character varying,
    address inet,
    port integer,
    ssl integer,
    selected integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: wmap_targets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wmap_targets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wmap_targets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wmap_targets_id_seq OWNED BY public.wmap_targets.id;


--
-- Name: workspace_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workspace_members (
    workspace_id integer NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: workspaces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workspaces (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    boundary text,
    description character varying(4096),
    owner_id integer,
    limit_to_network boolean DEFAULT false NOT NULL,
    import_fingerprint boolean DEFAULT false
);


--
-- Name: workspaces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workspaces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workspaces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workspaces_id_seq OWNED BY public.workspaces.id;


--
-- Name: api_keys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys ALTER COLUMN id SET DEFAULT nextval('public.api_keys_id_seq'::regclass);


--
-- Name: app_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_categories ALTER COLUMN id SET DEFAULT nextval('public.app_categories_id_seq'::regclass);


--
-- Name: app_categories_apps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_categories_apps ALTER COLUMN id SET DEFAULT nextval('public.app_categories_apps_id_seq'::regclass);


--
-- Name: app_runs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_runs ALTER COLUMN id SET DEFAULT nextval('public.app_runs_id_seq'::regclass);


--
-- Name: apps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.apps ALTER COLUMN id SET DEFAULT nextval('public.apps_id_seq'::regclass);


--
-- Name: async_callbacks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.async_callbacks ALTER COLUMN id SET DEFAULT nextval('public.async_callbacks_id_seq'::regclass);


--
-- Name: automatic_exploitation_match_results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automatic_exploitation_match_results ALTER COLUMN id SET DEFAULT nextval('public.automatic_exploitation_match_results_id_seq'::regclass);


--
-- Name: automatic_exploitation_match_sets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automatic_exploitation_match_sets ALTER COLUMN id SET DEFAULT nextval('public.automatic_exploitation_match_sets_id_seq'::regclass);


--
-- Name: automatic_exploitation_matches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automatic_exploitation_matches ALTER COLUMN id SET DEFAULT nextval('public.automatic_exploitation_matches_id_seq'::regclass);


--
-- Name: automatic_exploitation_runs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automatic_exploitation_runs ALTER COLUMN id SET DEFAULT nextval('public.automatic_exploitation_runs_id_seq'::regclass);


--
-- Name: banner_message_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.banner_message_users ALTER COLUMN id SET DEFAULT nextval('public.banner_message_users_id_seq'::regclass);


--
-- Name: banner_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.banner_messages ALTER COLUMN id SET DEFAULT nextval('public.banner_messages_id_seq'::regclass);


--
-- Name: brute_force_guess_attempts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brute_force_guess_attempts ALTER COLUMN id SET DEFAULT nextval('public.brute_force_guess_attempts_id_seq'::regclass);


--
-- Name: brute_force_guess_cores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brute_force_guess_cores ALTER COLUMN id SET DEFAULT nextval('public.brute_force_guess_cores_id_seq'::regclass);


--
-- Name: brute_force_reuse_attempts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brute_force_reuse_attempts ALTER COLUMN id SET DEFAULT nextval('public.brute_force_reuse_attempts_id_seq'::regclass);


--
-- Name: brute_force_reuse_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brute_force_reuse_groups ALTER COLUMN id SET DEFAULT nextval('public.brute_force_reuse_groups_id_seq'::regclass);


--
-- Name: brute_force_runs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brute_force_runs ALTER COLUMN id SET DEFAULT nextval('public.brute_force_runs_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: creds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creds ALTER COLUMN id SET DEFAULT nextval('public.creds_id_seq'::regclass);


--
-- Name: delayed_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs ALTER COLUMN id SET DEFAULT nextval('public.delayed_jobs_id_seq'::regclass);


--
-- Name: egadz_result_ranges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.egadz_result_ranges ALTER COLUMN id SET DEFAULT nextval('public.egadz_result_ranges_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: exploit_attempts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exploit_attempts ALTER COLUMN id SET DEFAULT nextval('public.exploit_attempts_id_seq'::regclass);


--
-- Name: exploited_hosts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exploited_hosts ALTER COLUMN id SET DEFAULT nextval('public.exploited_hosts_id_seq'::regclass);


--
-- Name: exports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exports ALTER COLUMN id SET DEFAULT nextval('public.exports_id_seq'::regclass);


--
-- Name: generated_payloads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_payloads ALTER COLUMN id SET DEFAULT nextval('public.generated_payloads_id_seq'::regclass);


--
-- Name: host_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.host_details ALTER COLUMN id SET DEFAULT nextval('public.host_details_id_seq'::regclass);


--
-- Name: hosts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hosts ALTER COLUMN id SET DEFAULT nextval('public.hosts_id_seq'::regclass);


--
-- Name: hosts_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hosts_tags ALTER COLUMN id SET DEFAULT nextval('public.hosts_tags_id_seq'::regclass);


--
-- Name: known_ports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.known_ports ALTER COLUMN id SET DEFAULT nextval('public.known_ports_id_seq'::regclass);


--
-- Name: listeners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listeners ALTER COLUMN id SET DEFAULT nextval('public.listeners_id_seq'::regclass);


--
-- Name: loots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loots ALTER COLUMN id SET DEFAULT nextval('public.loots_id_seq'::regclass);


--
-- Name: macros id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.macros ALTER COLUMN id SET DEFAULT nextval('public.macros_id_seq'::regclass);


--
-- Name: metasploit_credential_core_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_core_tags ALTER COLUMN id SET DEFAULT nextval('public.metasploit_credential_core_tags_id_seq'::regclass);


--
-- Name: metasploit_credential_cores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_cores ALTER COLUMN id SET DEFAULT nextval('public.metasploit_credential_cores_id_seq'::regclass);


--
-- Name: metasploit_credential_login_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_login_tags ALTER COLUMN id SET DEFAULT nextval('public.metasploit_credential_login_tags_id_seq'::regclass);


--
-- Name: metasploit_credential_logins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_logins ALTER COLUMN id SET DEFAULT nextval('public.metasploit_credential_logins_id_seq'::regclass);


--
-- Name: metasploit_credential_origin_cracked_passwords id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_origin_cracked_passwords ALTER COLUMN id SET DEFAULT nextval('public.metasploit_credential_origin_cracked_passwords_id_seq'::regclass);


--
-- Name: metasploit_credential_origin_imports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_origin_imports ALTER COLUMN id SET DEFAULT nextval('public.metasploit_credential_origin_imports_id_seq'::regclass);


--
-- Name: metasploit_credential_origin_manuals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_origin_manuals ALTER COLUMN id SET DEFAULT nextval('public.metasploit_credential_origin_manuals_id_seq'::regclass);


--
-- Name: metasploit_credential_origin_services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_origin_services ALTER COLUMN id SET DEFAULT nextval('public.metasploit_credential_origin_services_id_seq'::regclass);


--
-- Name: metasploit_credential_origin_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_origin_sessions ALTER COLUMN id SET DEFAULT nextval('public.metasploit_credential_origin_sessions_id_seq'::regclass);


--
-- Name: metasploit_credential_privates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_privates ALTER COLUMN id SET DEFAULT nextval('public.metasploit_credential_privates_id_seq'::regclass);


--
-- Name: metasploit_credential_publics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_publics ALTER COLUMN id SET DEFAULT nextval('public.metasploit_credential_publics_id_seq'::regclass);


--
-- Name: metasploit_credential_realms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_realms ALTER COLUMN id SET DEFAULT nextval('public.metasploit_credential_realms_id_seq'::regclass);


--
-- Name: mm_domino_edges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mm_domino_edges ALTER COLUMN id SET DEFAULT nextval('public.mm_domino_edges_id_seq'::regclass);


--
-- Name: mm_domino_nodes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mm_domino_nodes ALTER COLUMN id SET DEFAULT nextval('public.mm_domino_nodes_id_seq'::regclass);


--
-- Name: mm_domino_nodes_cores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mm_domino_nodes_cores ALTER COLUMN id SET DEFAULT nextval('public.mm_domino_nodes_cores_id_seq'::regclass);


--
-- Name: mod_refs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mod_refs ALTER COLUMN id SET DEFAULT nextval('public.mod_refs_id_seq'::regclass);


--
-- Name: module_actions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_actions ALTER COLUMN id SET DEFAULT nextval('public.module_actions_id_seq'::regclass);


--
-- Name: module_archs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_archs ALTER COLUMN id SET DEFAULT nextval('public.module_archs_id_seq'::regclass);


--
-- Name: module_authors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_authors ALTER COLUMN id SET DEFAULT nextval('public.module_authors_id_seq'::regclass);


--
-- Name: module_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_details ALTER COLUMN id SET DEFAULT nextval('public.module_details_id_seq'::regclass);


--
-- Name: module_mixins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_mixins ALTER COLUMN id SET DEFAULT nextval('public.module_mixins_id_seq'::regclass);


--
-- Name: module_platforms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_platforms ALTER COLUMN id SET DEFAULT nextval('public.module_platforms_id_seq'::regclass);


--
-- Name: module_refs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_refs ALTER COLUMN id SET DEFAULT nextval('public.module_refs_id_seq'::regclass);


--
-- Name: module_runs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_runs ALTER COLUMN id SET DEFAULT nextval('public.module_runs_id_seq'::regclass);


--
-- Name: module_targets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_targets ALTER COLUMN id SET DEFAULT nextval('public.module_targets_id_seq'::regclass);


--
-- Name: nexpose_consoles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_consoles ALTER COLUMN id SET DEFAULT nextval('public.nexpose_consoles_id_seq'::regclass);


--
-- Name: nexpose_data_assets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_assets ALTER COLUMN id SET DEFAULT nextval('public.nexpose_data_assets_id_seq'::regclass);


--
-- Name: nexpose_data_exploits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_exploits ALTER COLUMN id SET DEFAULT nextval('public.nexpose_data_exploits_id_seq'::regclass);


--
-- Name: nexpose_data_import_runs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_import_runs ALTER COLUMN id SET DEFAULT nextval('public.nexpose_data_import_runs_id_seq'::regclass);


--
-- Name: nexpose_data_ip_addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_ip_addresses ALTER COLUMN id SET DEFAULT nextval('public.nexpose_data_ip_addresses_id_seq'::regclass);


--
-- Name: nexpose_data_scan_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_scan_templates ALTER COLUMN id SET DEFAULT nextval('public.nexpose_data_scan_templates_id_seq'::regclass);


--
-- Name: nexpose_data_services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_services ALTER COLUMN id SET DEFAULT nextval('public.nexpose_data_services_id_seq'::regclass);


--
-- Name: nexpose_data_sites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_sites ALTER COLUMN id SET DEFAULT nextval('public.nexpose_data_sites_id_seq'::regclass);


--
-- Name: nexpose_data_vulnerabilities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_vulnerabilities ALTER COLUMN id SET DEFAULT nextval('public.nexpose_data_vulnerabilities_id_seq'::regclass);


--
-- Name: nexpose_data_vulnerability_definitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_vulnerability_definitions ALTER COLUMN id SET DEFAULT nextval('public.nexpose_data_vulnerability_definitions_id_seq'::regclass);


--
-- Name: nexpose_data_vulnerability_instances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_vulnerability_instances ALTER COLUMN id SET DEFAULT nextval('public.nexpose_data_vulnerability_instances_id_seq'::regclass);


--
-- Name: nexpose_data_vulnerability_references id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_vulnerability_references ALTER COLUMN id SET DEFAULT nextval('public.nexpose_data_vulnerability_references_id_seq'::regclass);


--
-- Name: nexpose_result_exceptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_result_exceptions ALTER COLUMN id SET DEFAULT nextval('public.nexpose_result_exceptions_id_seq'::regclass);


--
-- Name: nexpose_result_export_runs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_result_export_runs ALTER COLUMN id SET DEFAULT nextval('public.nexpose_result_export_runs_id_seq'::regclass);


--
-- Name: nexpose_result_validations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_result_validations ALTER COLUMN id SET DEFAULT nextval('public.nexpose_result_validations_id_seq'::regclass);


--
-- Name: notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);


--
-- Name: notification_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_messages ALTER COLUMN id SET DEFAULT nextval('public.notification_messages_id_seq'::regclass);


--
-- Name: notification_messages_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_messages_users ALTER COLUMN id SET DEFAULT nextval('public.notification_messages_users_id_seq'::regclass);


--
-- Name: payloads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payloads ALTER COLUMN id SET DEFAULT nextval('public.payloads_id_seq'::regclass);


--
-- Name: pnd_pcap_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pnd_pcap_files ALTER COLUMN id SET DEFAULT nextval('public.pnd_pcap_files_id_seq'::regclass);


--
-- Name: profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles ALTER COLUMN id SET DEFAULT nextval('public.profiles_id_seq'::regclass);


--
-- Name: refs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refs ALTER COLUMN id SET DEFAULT nextval('public.refs_id_seq'::regclass);


--
-- Name: report_artifacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_artifacts ALTER COLUMN id SET DEFAULT nextval('public.report_artifacts_id_seq'::regclass);


--
-- Name: report_custom_resources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_custom_resources ALTER COLUMN id SET DEFAULT nextval('public.report_custom_resources_id_seq'::regclass);


--
-- Name: reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports ALTER COLUMN id SET DEFAULT nextval('public.reports_id_seq'::regclass);


--
-- Name: routes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routes ALTER COLUMN id SET DEFAULT nextval('public.routes_id_seq'::regclass);


--
-- Name: run_stats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.run_stats ALTER COLUMN id SET DEFAULT nextval('public.run_stats_id_seq'::regclass);


--
-- Name: scheduled_tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_tasks ALTER COLUMN id SET DEFAULT nextval('public.scheduled_tasks_id_seq'::regclass);


--
-- Name: se_campaign_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_campaign_files ALTER COLUMN id SET DEFAULT nextval('public.se_campaign_files_id_seq'::regclass);


--
-- Name: se_campaigns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_campaigns ALTER COLUMN id SET DEFAULT nextval('public.se_campaigns_id_seq'::regclass);


--
-- Name: se_email_openings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_email_openings ALTER COLUMN id SET DEFAULT nextval('public.se_email_openings_id_seq'::regclass);


--
-- Name: se_email_sends id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_email_sends ALTER COLUMN id SET DEFAULT nextval('public.se_email_sends_id_seq'::regclass);


--
-- Name: se_email_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_email_templates ALTER COLUMN id SET DEFAULT nextval('public.se_email_templates_id_seq'::regclass);


--
-- Name: se_emails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_emails ALTER COLUMN id SET DEFAULT nextval('public.se_emails_id_seq'::regclass);


--
-- Name: se_human_targets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_human_targets ALTER COLUMN id SET DEFAULT nextval('public.se_human_targets_id_seq'::regclass);


--
-- Name: se_phishing_results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_phishing_results ALTER COLUMN id SET DEFAULT nextval('public.se_phishing_results_id_seq'::regclass);


--
-- Name: se_portable_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_portable_files ALTER COLUMN id SET DEFAULT nextval('public.se_portable_files_id_seq'::regclass);


--
-- Name: se_target_list_human_targets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_target_list_human_targets ALTER COLUMN id SET DEFAULT nextval('public.se_target_list_human_targets_id_seq'::regclass);


--
-- Name: se_target_lists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_target_lists ALTER COLUMN id SET DEFAULT nextval('public.se_target_lists_id_seq'::regclass);


--
-- Name: se_tracking_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_tracking_links ALTER COLUMN id SET DEFAULT nextval('public.se_tracking_links_id_seq'::regclass);


--
-- Name: se_trackings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_trackings ALTER COLUMN id SET DEFAULT nextval('public.se_trackings_id_seq'::regclass);


--
-- Name: se_visits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_visits ALTER COLUMN id SET DEFAULT nextval('public.se_visits_id_seq'::regclass);


--
-- Name: se_web_pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_web_pages ALTER COLUMN id SET DEFAULT nextval('public.se_web_pages_id_seq'::regclass);


--
-- Name: se_web_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_web_templates ALTER COLUMN id SET DEFAULT nextval('public.se_web_templates_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- Name: session_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_events ALTER COLUMN id SET DEFAULT nextval('public.session_events_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: sonar_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sonar_accounts ALTER COLUMN id SET DEFAULT nextval('public.sonar_accounts_id_seq'::regclass);


--
-- Name: sonar_data_fdns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sonar_data_fdns ALTER COLUMN id SET DEFAULT nextval('public.sonar_data_fdns_id_seq'::regclass);


--
-- Name: sonar_data_import_runs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sonar_data_import_runs ALTER COLUMN id SET DEFAULT nextval('public.sonar_data_import_runs_id_seq'::regclass);


--
-- Name: ssl_certs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ssl_certs ALTER COLUMN id SET DEFAULT nextval('public.ssl_certs_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: task_chains id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_chains ALTER COLUMN id SET DEFAULT nextval('public.task_chains_id_seq'::regclass);


--
-- Name: task_creds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_creds ALTER COLUMN id SET DEFAULT nextval('public.task_creds_id_seq'::regclass);


--
-- Name: task_hosts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_hosts ALTER COLUMN id SET DEFAULT nextval('public.task_hosts_id_seq'::regclass);


--
-- Name: task_services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_services ALTER COLUMN id SET DEFAULT nextval('public.task_services_id_seq'::regclass);


--
-- Name: task_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_sessions ALTER COLUMN id SET DEFAULT nextval('public.task_sessions_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: usage_metrics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usage_metrics ALTER COLUMN id SET DEFAULT nextval('public.usage_metrics_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vuln_attempts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vuln_attempts ALTER COLUMN id SET DEFAULT nextval('public.vuln_attempts_id_seq'::regclass);


--
-- Name: vuln_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vuln_details ALTER COLUMN id SET DEFAULT nextval('public.vuln_details_id_seq'::regclass);


--
-- Name: vulns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulns ALTER COLUMN id SET DEFAULT nextval('public.vulns_id_seq'::regclass);


--
-- Name: vulns_refs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulns_refs ALTER COLUMN id SET DEFAULT nextval('public.vulns_refs_id_seq'::regclass);


--
-- Name: web_attack_cross_site_scriptings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_attack_cross_site_scriptings ALTER COLUMN id SET DEFAULT nextval('public.web_attack_cross_site_scriptings_id_seq'::regclass);


--
-- Name: web_cookies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_cookies ALTER COLUMN id SET DEFAULT nextval('public.web_cookies_id_seq'::regclass);


--
-- Name: web_forms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_forms ALTER COLUMN id SET DEFAULT nextval('public.web_forms_id_seq'::regclass);


--
-- Name: web_headers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_headers ALTER COLUMN id SET DEFAULT nextval('public.web_headers_id_seq'::regclass);


--
-- Name: web_pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_pages ALTER COLUMN id SET DEFAULT nextval('public.web_pages_id_seq'::regclass);


--
-- Name: web_parameters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_parameters ALTER COLUMN id SET DEFAULT nextval('public.web_parameters_id_seq'::regclass);


--
-- Name: web_proofs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_proofs ALTER COLUMN id SET DEFAULT nextval('public.web_proofs_id_seq'::regclass);


--
-- Name: web_request_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_request_groups ALTER COLUMN id SET DEFAULT nextval('public.web_request_groups_id_seq'::regclass);


--
-- Name: web_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_requests ALTER COLUMN id SET DEFAULT nextval('public.web_requests_id_seq'::regclass);


--
-- Name: web_sites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_sites ALTER COLUMN id SET DEFAULT nextval('public.web_sites_id_seq'::regclass);


--
-- Name: web_transmitted_cookies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_transmitted_cookies ALTER COLUMN id SET DEFAULT nextval('public.web_transmitted_cookies_id_seq'::regclass);


--
-- Name: web_transmitted_headers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_transmitted_headers ALTER COLUMN id SET DEFAULT nextval('public.web_transmitted_headers_id_seq'::regclass);


--
-- Name: web_virtual_hosts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_virtual_hosts ALTER COLUMN id SET DEFAULT nextval('public.web_virtual_hosts_id_seq'::regclass);


--
-- Name: web_vuln_category_metasploits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_vuln_category_metasploits ALTER COLUMN id SET DEFAULT nextval('public.web_vuln_category_metasploits_id_seq'::regclass);


--
-- Name: web_vuln_category_owasps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_vuln_category_owasps ALTER COLUMN id SET DEFAULT nextval('public.web_vuln_category_owasps_id_seq'::regclass);


--
-- Name: web_vuln_category_projection_metasploit_owasps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_vuln_category_projection_metasploit_owasps ALTER COLUMN id SET DEFAULT nextval('public.web_vuln_category_projection_metasploit_owasps_id_seq'::regclass);


--
-- Name: web_vulns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_vulns ALTER COLUMN id SET DEFAULT nextval('public.web_vulns_id_seq'::regclass);


--
-- Name: wizard_procedures id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wizard_procedures ALTER COLUMN id SET DEFAULT nextval('public.wizard_procedures_id_seq'::regclass);


--
-- Name: wmap_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wmap_requests ALTER COLUMN id SET DEFAULT nextval('public.wmap_requests_id_seq'::regclass);


--
-- Name: wmap_targets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wmap_targets ALTER COLUMN id SET DEFAULT nextval('public.wmap_targets_id_seq'::regclass);


--
-- Name: workspaces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspaces ALTER COLUMN id SET DEFAULT nextval('public.workspaces_id_seq'::regclass);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: app_categories_apps app_categories_apps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_categories_apps
    ADD CONSTRAINT app_categories_apps_pkey PRIMARY KEY (id);


--
-- Name: app_categories app_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_categories
    ADD CONSTRAINT app_categories_pkey PRIMARY KEY (id);


--
-- Name: app_runs app_runs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_runs
    ADD CONSTRAINT app_runs_pkey PRIMARY KEY (id);


--
-- Name: apps apps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.apps
    ADD CONSTRAINT apps_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: async_callbacks async_callbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.async_callbacks
    ADD CONSTRAINT async_callbacks_pkey PRIMARY KEY (id);


--
-- Name: automatic_exploitation_match_results automatic_exploitation_match_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automatic_exploitation_match_results
    ADD CONSTRAINT automatic_exploitation_match_results_pkey PRIMARY KEY (id);


--
-- Name: automatic_exploitation_match_sets automatic_exploitation_match_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automatic_exploitation_match_sets
    ADD CONSTRAINT automatic_exploitation_match_sets_pkey PRIMARY KEY (id);


--
-- Name: automatic_exploitation_matches automatic_exploitation_matches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automatic_exploitation_matches
    ADD CONSTRAINT automatic_exploitation_matches_pkey PRIMARY KEY (id);


--
-- Name: automatic_exploitation_runs automatic_exploitation_runs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automatic_exploitation_runs
    ADD CONSTRAINT automatic_exploitation_runs_pkey PRIMARY KEY (id);


--
-- Name: banner_message_users banner_message_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.banner_message_users
    ADD CONSTRAINT banner_message_users_pkey PRIMARY KEY (id);


--
-- Name: banner_messages banner_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.banner_messages
    ADD CONSTRAINT banner_messages_pkey PRIMARY KEY (id);


--
-- Name: brute_force_guess_attempts brute_force_guess_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brute_force_guess_attempts
    ADD CONSTRAINT brute_force_guess_attempts_pkey PRIMARY KEY (id);


--
-- Name: brute_force_guess_cores brute_force_guess_cores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brute_force_guess_cores
    ADD CONSTRAINT brute_force_guess_cores_pkey PRIMARY KEY (id);


--
-- Name: brute_force_reuse_attempts brute_force_reuse_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brute_force_reuse_attempts
    ADD CONSTRAINT brute_force_reuse_attempts_pkey PRIMARY KEY (id);


--
-- Name: brute_force_reuse_groups brute_force_reuse_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brute_force_reuse_groups
    ADD CONSTRAINT brute_force_reuse_groups_pkey PRIMARY KEY (id);


--
-- Name: brute_force_runs brute_force_runs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brute_force_runs
    ADD CONSTRAINT brute_force_runs_pkey PRIMARY KEY (id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: creds creds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creds
    ADD CONSTRAINT creds_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: egadz_result_ranges egadz_result_ranges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.egadz_result_ranges
    ADD CONSTRAINT egadz_result_ranges_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: exploit_attempts exploit_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exploit_attempts
    ADD CONSTRAINT exploit_attempts_pkey PRIMARY KEY (id);


--
-- Name: exploited_hosts exploited_hosts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exploited_hosts
    ADD CONSTRAINT exploited_hosts_pkey PRIMARY KEY (id);


--
-- Name: exports exports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exports
    ADD CONSTRAINT exports_pkey PRIMARY KEY (id);


--
-- Name: generated_payloads generated_payloads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_payloads
    ADD CONSTRAINT generated_payloads_pkey PRIMARY KEY (id);


--
-- Name: host_details host_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.host_details
    ADD CONSTRAINT host_details_pkey PRIMARY KEY (id);


--
-- Name: hosts hosts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT hosts_pkey PRIMARY KEY (id);


--
-- Name: hosts_tags hosts_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hosts_tags
    ADD CONSTRAINT hosts_tags_pkey PRIMARY KEY (id);


--
-- Name: known_ports known_ports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.known_ports
    ADD CONSTRAINT known_ports_pkey PRIMARY KEY (id);


--
-- Name: listeners listeners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listeners
    ADD CONSTRAINT listeners_pkey PRIMARY KEY (id);


--
-- Name: loots loots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loots
    ADD CONSTRAINT loots_pkey PRIMARY KEY (id);


--
-- Name: macros macros_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.macros
    ADD CONSTRAINT macros_pkey PRIMARY KEY (id);


--
-- Name: metasploit_credential_core_tags metasploit_credential_core_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_core_tags
    ADD CONSTRAINT metasploit_credential_core_tags_pkey PRIMARY KEY (id);


--
-- Name: metasploit_credential_cores metasploit_credential_cores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_cores
    ADD CONSTRAINT metasploit_credential_cores_pkey PRIMARY KEY (id);


--
-- Name: metasploit_credential_login_tags metasploit_credential_login_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_login_tags
    ADD CONSTRAINT metasploit_credential_login_tags_pkey PRIMARY KEY (id);


--
-- Name: metasploit_credential_logins metasploit_credential_logins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_logins
    ADD CONSTRAINT metasploit_credential_logins_pkey PRIMARY KEY (id);


--
-- Name: metasploit_credential_origin_cracked_passwords metasploit_credential_origin_cracked_passwords_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_origin_cracked_passwords
    ADD CONSTRAINT metasploit_credential_origin_cracked_passwords_pkey PRIMARY KEY (id);


--
-- Name: metasploit_credential_origin_imports metasploit_credential_origin_imports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_origin_imports
    ADD CONSTRAINT metasploit_credential_origin_imports_pkey PRIMARY KEY (id);


--
-- Name: metasploit_credential_origin_manuals metasploit_credential_origin_manuals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_origin_manuals
    ADD CONSTRAINT metasploit_credential_origin_manuals_pkey PRIMARY KEY (id);


--
-- Name: metasploit_credential_origin_services metasploit_credential_origin_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_origin_services
    ADD CONSTRAINT metasploit_credential_origin_services_pkey PRIMARY KEY (id);


--
-- Name: metasploit_credential_origin_sessions metasploit_credential_origin_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_origin_sessions
    ADD CONSTRAINT metasploit_credential_origin_sessions_pkey PRIMARY KEY (id);


--
-- Name: metasploit_credential_privates metasploit_credential_privates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_privates
    ADD CONSTRAINT metasploit_credential_privates_pkey PRIMARY KEY (id);


--
-- Name: metasploit_credential_publics metasploit_credential_publics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_publics
    ADD CONSTRAINT metasploit_credential_publics_pkey PRIMARY KEY (id);


--
-- Name: metasploit_credential_realms metasploit_credential_realms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metasploit_credential_realms
    ADD CONSTRAINT metasploit_credential_realms_pkey PRIMARY KEY (id);


--
-- Name: mm_domino_edges mm_domino_edges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mm_domino_edges
    ADD CONSTRAINT mm_domino_edges_pkey PRIMARY KEY (id);


--
-- Name: mm_domino_nodes_cores mm_domino_nodes_cores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mm_domino_nodes_cores
    ADD CONSTRAINT mm_domino_nodes_cores_pkey PRIMARY KEY (id);


--
-- Name: mm_domino_nodes mm_domino_nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mm_domino_nodes
    ADD CONSTRAINT mm_domino_nodes_pkey PRIMARY KEY (id);


--
-- Name: mod_refs mod_refs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mod_refs
    ADD CONSTRAINT mod_refs_pkey PRIMARY KEY (id);


--
-- Name: module_actions module_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_actions
    ADD CONSTRAINT module_actions_pkey PRIMARY KEY (id);


--
-- Name: module_archs module_archs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_archs
    ADD CONSTRAINT module_archs_pkey PRIMARY KEY (id);


--
-- Name: module_authors module_authors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_authors
    ADD CONSTRAINT module_authors_pkey PRIMARY KEY (id);


--
-- Name: module_details module_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_details
    ADD CONSTRAINT module_details_pkey PRIMARY KEY (id);


--
-- Name: module_mixins module_mixins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_mixins
    ADD CONSTRAINT module_mixins_pkey PRIMARY KEY (id);


--
-- Name: module_platforms module_platforms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_platforms
    ADD CONSTRAINT module_platforms_pkey PRIMARY KEY (id);


--
-- Name: module_refs module_refs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_refs
    ADD CONSTRAINT module_refs_pkey PRIMARY KEY (id);


--
-- Name: module_runs module_runs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_runs
    ADD CONSTRAINT module_runs_pkey PRIMARY KEY (id);


--
-- Name: module_targets module_targets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_targets
    ADD CONSTRAINT module_targets_pkey PRIMARY KEY (id);


--
-- Name: nexpose_consoles nexpose_consoles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_consoles
    ADD CONSTRAINT nexpose_consoles_pkey PRIMARY KEY (id);


--
-- Name: nexpose_data_assets nexpose_data_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_assets
    ADD CONSTRAINT nexpose_data_assets_pkey PRIMARY KEY (id);


--
-- Name: nexpose_data_exploits nexpose_data_exploits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_exploits
    ADD CONSTRAINT nexpose_data_exploits_pkey PRIMARY KEY (id);


--
-- Name: nexpose_data_import_runs nexpose_data_import_runs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_import_runs
    ADD CONSTRAINT nexpose_data_import_runs_pkey PRIMARY KEY (id);


--
-- Name: nexpose_data_ip_addresses nexpose_data_ip_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_ip_addresses
    ADD CONSTRAINT nexpose_data_ip_addresses_pkey PRIMARY KEY (id);


--
-- Name: nexpose_data_scan_templates nexpose_data_scan_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_scan_templates
    ADD CONSTRAINT nexpose_data_scan_templates_pkey PRIMARY KEY (id);


--
-- Name: nexpose_data_services nexpose_data_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_services
    ADD CONSTRAINT nexpose_data_services_pkey PRIMARY KEY (id);


--
-- Name: nexpose_data_sites nexpose_data_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_sites
    ADD CONSTRAINT nexpose_data_sites_pkey PRIMARY KEY (id);


--
-- Name: nexpose_data_vulnerabilities nexpose_data_vulnerabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_vulnerabilities
    ADD CONSTRAINT nexpose_data_vulnerabilities_pkey PRIMARY KEY (id);


--
-- Name: nexpose_data_vulnerability_definitions nexpose_data_vulnerability_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_vulnerability_definitions
    ADD CONSTRAINT nexpose_data_vulnerability_definitions_pkey PRIMARY KEY (id);


--
-- Name: nexpose_data_vulnerability_instances nexpose_data_vulnerability_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_vulnerability_instances
    ADD CONSTRAINT nexpose_data_vulnerability_instances_pkey PRIMARY KEY (id);


--
-- Name: nexpose_data_vulnerability_references nexpose_data_vulnerability_references_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_data_vulnerability_references
    ADD CONSTRAINT nexpose_data_vulnerability_references_pkey PRIMARY KEY (id);


--
-- Name: nexpose_result_exceptions nexpose_result_exceptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_result_exceptions
    ADD CONSTRAINT nexpose_result_exceptions_pkey PRIMARY KEY (id);


--
-- Name: nexpose_result_export_runs nexpose_result_export_runs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_result_export_runs
    ADD CONSTRAINT nexpose_result_export_runs_pkey PRIMARY KEY (id);


--
-- Name: nexpose_result_validations nexpose_result_validations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nexpose_result_validations
    ADD CONSTRAINT nexpose_result_validations_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: notification_messages notification_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_messages
    ADD CONSTRAINT notification_messages_pkey PRIMARY KEY (id);


--
-- Name: notification_messages_users notification_messages_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_messages_users
    ADD CONSTRAINT notification_messages_users_pkey PRIMARY KEY (id);


--
-- Name: payloads payloads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payloads
    ADD CONSTRAINT payloads_pkey PRIMARY KEY (id);


--
-- Name: pnd_pcap_files pnd_pcap_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pnd_pcap_files
    ADD CONSTRAINT pnd_pcap_files_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: refs refs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refs
    ADD CONSTRAINT refs_pkey PRIMARY KEY (id);


--
-- Name: report_artifacts report_artifacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_artifacts
    ADD CONSTRAINT report_artifacts_pkey PRIMARY KEY (id);


--
-- Name: report_custom_resources report_custom_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_custom_resources
    ADD CONSTRAINT report_custom_resources_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: routes routes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- Name: run_stats run_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.run_stats
    ADD CONSTRAINT run_stats_pkey PRIMARY KEY (id);


--
-- Name: scheduled_tasks scheduled_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_tasks
    ADD CONSTRAINT scheduled_tasks_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: se_campaign_files se_campaign_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_campaign_files
    ADD CONSTRAINT se_campaign_files_pkey PRIMARY KEY (id);


--
-- Name: se_campaigns se_campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_campaigns
    ADD CONSTRAINT se_campaigns_pkey PRIMARY KEY (id);


--
-- Name: se_email_openings se_email_openings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_email_openings
    ADD CONSTRAINT se_email_openings_pkey PRIMARY KEY (id);


--
-- Name: se_email_sends se_email_sends_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_email_sends
    ADD CONSTRAINT se_email_sends_pkey PRIMARY KEY (id);


--
-- Name: se_email_templates se_email_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_email_templates
    ADD CONSTRAINT se_email_templates_pkey PRIMARY KEY (id);


--
-- Name: se_emails se_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_emails
    ADD CONSTRAINT se_emails_pkey PRIMARY KEY (id);


--
-- Name: se_human_targets se_human_targets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_human_targets
    ADD CONSTRAINT se_human_targets_pkey PRIMARY KEY (id);


--
-- Name: se_phishing_results se_phishing_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_phishing_results
    ADD CONSTRAINT se_phishing_results_pkey PRIMARY KEY (id);


--
-- Name: se_portable_files se_portable_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_portable_files
    ADD CONSTRAINT se_portable_files_pkey PRIMARY KEY (id);


--
-- Name: se_target_list_human_targets se_target_list_human_targets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_target_list_human_targets
    ADD CONSTRAINT se_target_list_human_targets_pkey PRIMARY KEY (id);


--
-- Name: se_target_lists se_target_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_target_lists
    ADD CONSTRAINT se_target_lists_pkey PRIMARY KEY (id);


--
-- Name: se_tracking_links se_tracking_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_tracking_links
    ADD CONSTRAINT se_tracking_links_pkey PRIMARY KEY (id);


--
-- Name: se_trackings se_trackings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_trackings
    ADD CONSTRAINT se_trackings_pkey PRIMARY KEY (id);


--
-- Name: se_visits se_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_visits
    ADD CONSTRAINT se_visits_pkey PRIMARY KEY (id);


--
-- Name: se_web_pages se_web_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_web_pages
    ADD CONSTRAINT se_web_pages_pkey PRIMARY KEY (id);


--
-- Name: se_web_templates se_web_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.se_web_templates
    ADD CONSTRAINT se_web_templates_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: session_events session_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_events
    ADD CONSTRAINT session_events_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sonar_accounts sonar_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sonar_accounts
    ADD CONSTRAINT sonar_accounts_pkey PRIMARY KEY (id);


--
-- Name: sonar_data_fdns sonar_data_fdns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sonar_data_fdns
    ADD CONSTRAINT sonar_data_fdns_pkey PRIMARY KEY (id);


--
-- Name: sonar_data_import_runs sonar_data_import_runs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sonar_data_import_runs
    ADD CONSTRAINT sonar_data_import_runs_pkey PRIMARY KEY (id);


--
-- Name: ssl_certs ssl_certs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ssl_certs
    ADD CONSTRAINT ssl_certs_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: task_chains task_chains_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_chains
    ADD CONSTRAINT task_chains_pkey PRIMARY KEY (id);


--
-- Name: task_creds task_creds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_creds
    ADD CONSTRAINT task_creds_pkey PRIMARY KEY (id);


--
-- Name: task_hosts task_hosts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_hosts
    ADD CONSTRAINT task_hosts_pkey PRIMARY KEY (id);


--
-- Name: task_services task_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_services
    ADD CONSTRAINT task_services_pkey PRIMARY KEY (id);


--
-- Name: task_sessions task_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_sessions
    ADD CONSTRAINT task_sessions_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: usage_metrics usage_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usage_metrics
    ADD CONSTRAINT usage_metrics_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vuln_attempts vuln_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vuln_attempts
    ADD CONSTRAINT vuln_attempts_pkey PRIMARY KEY (id);


--
-- Name: vuln_details vuln_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vuln_details
    ADD CONSTRAINT vuln_details_pkey PRIMARY KEY (id);


--
-- Name: vulns vulns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulns
    ADD CONSTRAINT vulns_pkey PRIMARY KEY (id);


--
-- Name: vulns_refs vulns_refs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulns_refs
    ADD CONSTRAINT vulns_refs_pkey PRIMARY KEY (id);


--
-- Name: web_attack_cross_site_scriptings web_attack_cross_site_scriptings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_attack_cross_site_scriptings
    ADD CONSTRAINT web_attack_cross_site_scriptings_pkey PRIMARY KEY (id);


--
-- Name: web_cookies web_cookies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_cookies
    ADD CONSTRAINT web_cookies_pkey PRIMARY KEY (id);


--
-- Name: web_forms web_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_forms
    ADD CONSTRAINT web_forms_pkey PRIMARY KEY (id);


--
-- Name: web_headers web_headers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_headers
    ADD CONSTRAINT web_headers_pkey PRIMARY KEY (id);


--
-- Name: web_pages web_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_pages
    ADD CONSTRAINT web_pages_pkey PRIMARY KEY (id);


--
-- Name: web_parameters web_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_parameters
    ADD CONSTRAINT web_parameters_pkey PRIMARY KEY (id);


--
-- Name: web_proofs web_proofs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_proofs
    ADD CONSTRAINT web_proofs_pkey PRIMARY KEY (id);


--
-- Name: web_request_groups web_request_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_request_groups
    ADD CONSTRAINT web_request_groups_pkey PRIMARY KEY (id);


--
-- Name: web_requests web_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_requests
    ADD CONSTRAINT web_requests_pkey PRIMARY KEY (id);


--
-- Name: web_sites web_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_sites
    ADD CONSTRAINT web_sites_pkey PRIMARY KEY (id);


--
-- Name: web_transmitted_cookies web_transmitted_cookies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_transmitted_cookies
    ADD CONSTRAINT web_transmitted_cookies_pkey PRIMARY KEY (id);


--
-- Name: web_transmitted_headers web_transmitted_headers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_transmitted_headers
    ADD CONSTRAINT web_transmitted_headers_pkey PRIMARY KEY (id);


--
-- Name: web_virtual_hosts web_virtual_hosts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_virtual_hosts
    ADD CONSTRAINT web_virtual_hosts_pkey PRIMARY KEY (id);


--
-- Name: web_vuln_category_metasploits web_vuln_category_metasploits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_vuln_category_metasploits
    ADD CONSTRAINT web_vuln_category_metasploits_pkey PRIMARY KEY (id);


--
-- Name: web_vuln_category_owasps web_vuln_category_owasps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_vuln_category_owasps
    ADD CONSTRAINT web_vuln_category_owasps_pkey PRIMARY KEY (id);


--
-- Name: web_vuln_category_projection_metasploit_owasps web_vuln_category_projection_metasploit_owasps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_vuln_category_projection_metasploit_owasps
    ADD CONSTRAINT web_vuln_category_projection_metasploit_owasps_pkey PRIMARY KEY (id);


--
-- Name: web_vulns web_vulns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_vulns
    ADD CONSTRAINT web_vulns_pkey PRIMARY KEY (id);


--
-- Name: wizard_procedures wizard_procedures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wizard_procedures
    ADD CONSTRAINT wizard_procedures_pkey PRIMARY KEY (id);


--
-- Name: wmap_requests wmap_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wmap_requests
    ADD CONSTRAINT wmap_requests_pkey PRIMARY KEY (id);


--
-- Name: wmap_targets wmap_targets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wmap_targets
    ADD CONSTRAINT wmap_targets_pkey PRIMARY KEY (id);


--
-- Name: workspaces workspaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_pkey PRIMARY KEY (id);


--
-- Name: brute_force_guess_attempts_brute_force_guess_core_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX brute_force_guess_attempts_brute_force_guess_core_ids ON public.brute_force_guess_attempts USING btree (brute_force_guess_core_id);


--
-- Name: brute_force_reuse_attempts_metasploit_credential_core_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX brute_force_reuse_attempts_metasploit_credential_core_ids ON public.brute_force_reuse_attempts USING btree (metasploit_credential_core_id);


--
-- Name: by_asset_site; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX by_asset_site ON public.nexpose_data_assets_sites USING btree (nexpose_data_asset_id, nexpose_data_site_id);


--
-- Name: by_host_assets; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX by_host_assets ON public.hosts_nexpose_data_assets USING btree (host_id, nexpose_data_asset_id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delayed_jobs_priority ON public.delayed_jobs USING btree (priority, run_at);


--
-- Name: index_app_categories_apps_on_app_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_app_categories_apps_on_app_category_id ON public.app_categories_apps USING btree (app_category_id);


--
-- Name: index_app_categories_apps_on_app_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_app_categories_apps_on_app_id ON public.app_categories_apps USING btree (app_id);


--
-- Name: index_app_runs_on_app_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_app_runs_on_app_id ON public.app_runs USING btree (app_id);


--
-- Name: index_app_runs_on_workspace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_app_runs_on_workspace_id ON public.app_runs USING btree (workspace_id);


--
-- Name: index_automatic_exploitation_match_results_on_match_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_automatic_exploitation_match_results_on_match_id ON public.automatic_exploitation_match_results USING btree (match_id);


--
-- Name: index_automatic_exploitation_match_results_on_run_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_automatic_exploitation_match_results_on_run_id ON public.automatic_exploitation_match_results USING btree (run_id);


--
-- Name: index_automatic_exploitation_match_sets_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_automatic_exploitation_match_sets_on_user_id ON public.automatic_exploitation_match_sets USING btree (user_id);


--
-- Name: index_automatic_exploitation_match_sets_on_workspace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_automatic_exploitation_match_sets_on_workspace_id ON public.automatic_exploitation_match_sets USING btree (workspace_id);


--
-- Name: index_automatic_exploitation_matches_on_module_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_automatic_exploitation_matches_on_module_detail_id ON public.automatic_exploitation_matches USING btree (module_detail_id);


--
-- Name: index_automatic_exploitation_matches_on_module_fullname; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_automatic_exploitation_matches_on_module_fullname ON public.automatic_exploitation_matches USING btree (module_fullname);


--
-- Name: index_automatic_exploitation_matches_on_nexpose_data_exploit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_automatic_exploitation_matches_on_nexpose_data_exploit_id ON public.automatic_exploitation_matches USING btree (nexpose_data_exploit_id);


--
-- Name: index_automatic_exploitation_runs_on_match_set_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_automatic_exploitation_runs_on_match_set_id ON public.automatic_exploitation_runs USING btree (match_set_id);


--
-- Name: index_automatic_exploitation_runs_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_automatic_exploitation_runs_on_user_id ON public.automatic_exploitation_runs USING btree (user_id);


--
-- Name: index_automatic_exploitation_runs_on_workspace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_automatic_exploitation_runs_on_workspace_id ON public.automatic_exploitation_runs USING btree (workspace_id);


--
-- Name: index_brute_force_guess_attempts_on_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_brute_force_guess_attempts_on_service_id ON public.brute_force_guess_attempts USING btree (service_id);


--
-- Name: index_brute_force_guess_cores_on_private_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_brute_force_guess_cores_on_private_id ON public.brute_force_guess_cores USING btree (private_id);


--
-- Name: index_brute_force_guess_cores_on_public_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_brute_force_guess_cores_on_public_id ON public.brute_force_guess_cores USING btree (public_id);


--
-- Name: index_brute_force_guess_cores_on_realm_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_brute_force_guess_cores_on_realm_id ON public.brute_force_guess_cores USING btree (realm_id);


--
-- Name: index_brute_force_guess_cores_on_workspace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_brute_force_guess_cores_on_workspace_id ON public.brute_force_guess_cores USING btree (workspace_id);


--
-- Name: index_brute_force_reuse_attempts_on_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_brute_force_reuse_attempts_on_service_id ON public.brute_force_reuse_attempts USING btree (service_id);


--
-- Name: index_brute_force_reuse_groups_on_workspace_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_brute_force_reuse_groups_on_workspace_id_and_name ON public.brute_force_reuse_groups USING btree (workspace_id, name);


--
-- Name: index_hosts_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hosts_on_name ON public.hosts USING btree (name);


--
-- Name: index_hosts_on_os_flavor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hosts_on_os_flavor ON public.hosts USING btree (os_flavor);


--
-- Name: index_hosts_on_os_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hosts_on_os_name ON public.hosts USING btree (os_name);


--
-- Name: index_hosts_on_purpose; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hosts_on_purpose ON public.hosts USING btree (purpose);


--
-- Name: index_hosts_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hosts_on_state ON public.hosts USING btree (state);


--
-- Name: index_hosts_on_workspace_id_and_address; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hosts_on_workspace_id_and_address ON public.hosts USING btree (workspace_id, address);


--
-- Name: index_known_ports_on_port; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_known_ports_on_port ON public.known_ports USING btree (port);


--
-- Name: index_loots_on_module_run_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_loots_on_module_run_id ON public.loots USING btree (module_run_id);


--
-- Name: index_metasploit_credential_core_tags_on_core_id_and_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_metasploit_credential_core_tags_on_core_id_and_tag_id ON public.metasploit_credential_core_tags USING btree (core_id, tag_id);


--
-- Name: index_metasploit_credential_cores_on_origin_type_and_origin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_metasploit_credential_cores_on_origin_type_and_origin_id ON public.metasploit_credential_cores USING btree (origin_type, origin_id);


--
-- Name: index_metasploit_credential_cores_on_private_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_metasploit_credential_cores_on_private_id ON public.metasploit_credential_cores USING btree (private_id);


--
-- Name: index_metasploit_credential_cores_on_public_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_metasploit_credential_cores_on_public_id ON public.metasploit_credential_cores USING btree (public_id);


--
-- Name: index_metasploit_credential_cores_on_realm_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_metasploit_credential_cores_on_realm_id ON public.metasploit_credential_cores USING btree (realm_id);


--
-- Name: index_metasploit_credential_cores_on_workspace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_metasploit_credential_cores_on_workspace_id ON public.metasploit_credential_cores USING btree (workspace_id);


--
-- Name: index_metasploit_credential_login_tags_on_login_id_and_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_metasploit_credential_login_tags_on_login_id_and_tag_id ON public.metasploit_credential_login_tags USING btree (login_id, tag_id);


--
-- Name: index_metasploit_credential_logins_on_core_id_and_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_metasploit_credential_logins_on_core_id_and_service_id ON public.metasploit_credential_logins USING btree (core_id, service_id);


--
-- Name: index_metasploit_credential_logins_on_service_id_and_core_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_metasploit_credential_logins_on_service_id_and_core_id ON public.metasploit_credential_logins USING btree (service_id, core_id);


--
-- Name: index_metasploit_credential_origin_imports_on_task_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_metasploit_credential_origin_imports_on_task_id ON public.metasploit_credential_origin_imports USING btree (task_id);


--
-- Name: index_metasploit_credential_origin_manuals_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_metasploit_credential_origin_manuals_on_user_id ON public.metasploit_credential_origin_manuals USING btree (user_id);


--
-- Name: index_metasploit_credential_privates_on_type_and_data; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_metasploit_credential_privates_on_type_and_data ON public.metasploit_credential_privates USING btree (type, data) WHERE (NOT (((type)::text = 'Metasploit::Credential::SSHKey'::text) OR ((type)::text = 'Metasploit::Credential::Pkcs12'::text)));


--
-- Name: index_metasploit_credential_privates_on_type_and_data_pkcs12; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_metasploit_credential_privates_on_type_and_data_pkcs12 ON public.metasploit_credential_privates USING btree (type, decode(md5(data), 'hex'::text)) WHERE ((type)::text = 'Metasploit::Credential::Pkcs12'::text);


--
-- Name: index_metasploit_credential_privates_on_type_and_data_sshkey; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_metasploit_credential_privates_on_type_and_data_sshkey ON public.metasploit_credential_privates USING btree (type, decode(md5(data), 'hex'::text)) WHERE ((type)::text = 'Metasploit::Credential::SSHKey'::text);


--
-- Name: index_metasploit_credential_publics_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_metasploit_credential_publics_on_username ON public.metasploit_credential_publics USING btree (username);


--
-- Name: index_metasploit_credential_realms_on_key_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_metasploit_credential_realms_on_key_and_value ON public.metasploit_credential_realms USING btree (key, value);


--
-- Name: index_mm_domino_edges_on_dest_node_id_and_run_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_mm_domino_edges_on_dest_node_id_and_run_id ON public.mm_domino_edges USING btree (dest_node_id, run_id);


--
-- Name: index_mm_domino_edges_on_login_id_and_run_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_mm_domino_edges_on_login_id_and_run_id ON public.mm_domino_edges USING btree (login_id, run_id);


--
-- Name: index_mm_domino_edges_on_run_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mm_domino_edges_on_run_id ON public.mm_domino_edges USING btree (run_id);


--
-- Name: index_mm_domino_nodes_cores_on_node_id_and_core_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_mm_domino_nodes_cores_on_node_id_and_core_id ON public.mm_domino_nodes_cores USING btree (node_id, core_id);


--
-- Name: index_mm_domino_nodes_on_host_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mm_domino_nodes_on_host_id ON public.mm_domino_nodes USING btree (host_id);


--
-- Name: index_mm_domino_nodes_on_host_id_and_run_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_mm_domino_nodes_on_host_id_and_run_id ON public.mm_domino_nodes USING btree (host_id, run_id);


--
-- Name: index_mm_domino_nodes_on_run_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mm_domino_nodes_on_run_id ON public.mm_domino_nodes USING btree (run_id);


--
-- Name: index_module_actions_on_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_module_actions_on_detail_id ON public.module_actions USING btree (detail_id);


--
-- Name: index_module_archs_on_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_module_archs_on_detail_id ON public.module_archs USING btree (detail_id);


--
-- Name: index_module_authors_on_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_module_authors_on_detail_id ON public.module_authors USING btree (detail_id);


--
-- Name: index_module_details_on_description; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_module_details_on_description ON public.module_details USING btree (description);


--
-- Name: index_module_details_on_mtype; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_module_details_on_mtype ON public.module_details USING btree (mtype);


--
-- Name: index_module_details_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_module_details_on_name ON public.module_details USING btree (name);


--
-- Name: index_module_details_on_refname; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_module_details_on_refname ON public.module_details USING btree (refname);


--
-- Name: index_module_mixins_on_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_module_mixins_on_detail_id ON public.module_mixins USING btree (detail_id);


--
-- Name: index_module_platforms_on_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_module_platforms_on_detail_id ON public.module_platforms USING btree (detail_id);


--
-- Name: index_module_refs_on_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_module_refs_on_detail_id ON public.module_refs USING btree (detail_id);


--
-- Name: index_module_refs_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_module_refs_on_name ON public.module_refs USING btree (name);


--
-- Name: index_module_runs_on_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_module_runs_on_session_id ON public.module_runs USING btree (session_id);


--
-- Name: index_module_runs_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_module_runs_on_user_id ON public.module_runs USING btree (user_id);


--
-- Name: index_module_targets_on_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_module_targets_on_detail_id ON public.module_targets USING btree (detail_id);


--
-- Name: index_nexpose_data_assets_on_asset_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nexpose_data_assets_on_asset_id ON public.nexpose_data_assets USING btree (asset_id);


--
-- Name: index_nexpose_data_exploits_on_nexpose_exploit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_nexpose_data_exploits_on_nexpose_exploit_id ON public.nexpose_data_exploits USING btree (nexpose_exploit_id);


--
-- Name: index_nexpose_data_exploits_on_source_and_source_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nexpose_data_exploits_on_source_and_source_key ON public.nexpose_data_exploits USING btree (source, source_key);


--
-- Name: index_nexpose_data_import_runs_on_new_scan; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nexpose_data_import_runs_on_new_scan ON public.nexpose_data_import_runs USING btree (new_scan) WHERE (new_scan IS NOT NULL);


--
-- Name: index_nexpose_data_import_runs_on_nx_console_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nexpose_data_import_runs_on_nx_console_id ON public.nexpose_data_import_runs USING btree (nx_console_id);


--
-- Name: index_nexpose_data_ip_addresses_on_nexpose_data_asset_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nexpose_data_ip_addresses_on_nexpose_data_asset_id ON public.nexpose_data_ip_addresses USING btree (nexpose_data_asset_id);


--
-- Name: index_nexpose_data_scan_templates_on_nx_console_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nexpose_data_scan_templates_on_nx_console_id ON public.nexpose_data_scan_templates USING btree (nx_console_id);


--
-- Name: index_nexpose_data_scan_templates_on_scan_template_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nexpose_data_scan_templates_on_scan_template_id ON public.nexpose_data_scan_templates USING btree (scan_template_id);


--
-- Name: index_nexpose_data_services_on_nexpose_data_asset_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nexpose_data_services_on_nexpose_data_asset_id ON public.nexpose_data_services USING btree (nexpose_data_asset_id);


--
-- Name: index_nexpose_data_sites_on_nexpose_data_import_run_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nexpose_data_sites_on_nexpose_data_import_run_id ON public.nexpose_data_sites USING btree (nexpose_data_import_run_id);


--
-- Name: index_nexpose_data_sites_on_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nexpose_data_sites_on_site_id ON public.nexpose_data_sites USING btree (site_id);


--
-- Name: index_nexpose_data_vulnerabilities_on_vulnerability_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_nexpose_data_vulnerabilities_on_vulnerability_id ON public.nexpose_data_vulnerabilities USING btree (vulnerability_id);


--
-- Name: index_nexpose_result_exceptions_on_nexpose_result_export_run_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nexpose_result_exceptions_on_nexpose_result_export_run_id ON public.nexpose_result_exceptions USING btree (nexpose_result_export_run_id);


--
-- Name: index_nexpose_result_exceptions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nexpose_result_exceptions_on_user_id ON public.nexpose_result_exceptions USING btree (user_id);


--
-- Name: index_notes_on_ntype; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_ntype ON public.notes USING btree (ntype);


--
-- Name: index_notes_on_vuln_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_vuln_id ON public.notes USING btree (vuln_id);


--
-- Name: index_nx_data_exploits_vuln_defs_on_exploit_id_and_vuln_def_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nx_data_exploits_vuln_defs_on_exploit_id_and_vuln_def_id ON public.nexpose_data_exploits_vulnerability_definitions USING btree (exploit_id, vulnerability_definition_id);


--
-- Name: index_nx_data_exploits_vuln_defs_on_vuln_def_id_and_exploit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nx_data_exploits_vuln_defs_on_vuln_def_id_and_exploit_id ON public.nexpose_data_exploits_vulnerability_definitions USING btree (vulnerability_definition_id, exploit_id);


--
-- Name: index_nx_data_vuln_def_on_vulnerability_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_nx_data_vuln_def_on_vulnerability_definition_id ON public.nexpose_data_vulnerability_definitions USING btree (vulnerability_definition_id);


--
-- Name: index_nx_data_vuln_inst_on_asset_id_and_vulnerability_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nx_data_vuln_inst_on_asset_id_and_vulnerability_id ON public.nexpose_data_vulnerability_instances USING btree (asset_id, vulnerability_id);


--
-- Name: index_nx_data_vuln_inst_on_nexpose_data_asset_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nx_data_vuln_inst_on_nexpose_data_asset_id ON public.nexpose_data_vulnerability_instances USING btree (nexpose_data_asset_id);


--
-- Name: index_nx_data_vuln_inst_on_nexpose_data_vulnerability_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nx_data_vuln_inst_on_nexpose_data_vulnerability_id ON public.nexpose_data_vulnerability_instances USING btree (nexpose_data_vulnerability_id);


--
-- Name: index_nx_data_vuln_inst_on_vulnerability_id_and_asset_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nx_data_vuln_inst_on_vulnerability_id_and_asset_id ON public.nexpose_data_vulnerability_instances USING btree (vulnerability_id, asset_id);


--
-- Name: index_nx_data_vuln_on_nexpose_data_vuln_def_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nx_data_vuln_on_nexpose_data_vuln_def_id ON public.nexpose_data_vulnerabilities USING btree (nexpose_data_vulnerability_definition_id);


--
-- Name: index_nx_r_exceptions_on_nx_scope_type_and_nx_scope_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nx_r_exceptions_on_nx_scope_type_and_nx_scope_id ON public.nexpose_result_exceptions USING btree (nx_scope_type, nx_scope_id);


--
-- Name: index_nx_result_validations_on_nx_result_export_run_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nx_result_validations_on_nx_result_export_run_id ON public.nexpose_result_validations USING btree (nexpose_result_export_run_id);


--
-- Name: index_refs_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_refs_on_name ON public.refs USING btree (name);


--
-- Name: index_se_email_sends_on_email_id_and_human_target_id_and_sent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_se_email_sends_on_email_id_and_human_target_id_and_sent ON public.se_email_sends USING btree (email_id, human_target_id, sent);


--
-- Name: index_se_trackings_on_email_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_se_trackings_on_email_id ON public.se_trackings USING btree (email_id);


--
-- Name: index_se_trackings_on_human_target_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_se_trackings_on_human_target_id ON public.se_trackings USING btree (human_target_id);


--
-- Name: index_services_on_host_id_and_port_and_proto; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_services_on_host_id_and_port_and_proto ON public.services USING btree (host_id, port, proto);


--
-- Name: index_services_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_services_on_name ON public.services USING btree (name);


--
-- Name: index_services_on_port; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_services_on_port ON public.services USING btree (port);


--
-- Name: index_services_on_proto; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_services_on_proto ON public.services USING btree (proto);


--
-- Name: index_services_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_services_on_state ON public.services USING btree (state);


--
-- Name: index_sessions_on_module_run_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_module_run_id ON public.sessions USING btree (module_run_id);


--
-- Name: index_sonar_data_fdns_on_import_run_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sonar_data_fdns_on_import_run_id ON public.sonar_data_fdns USING btree (import_run_id);


--
-- Name: index_sonar_data_fdns_on_import_run_id_and_hostname_and_address; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sonar_data_fdns_on_import_run_id_and_hostname_and_address ON public.sonar_data_fdns USING btree (import_run_id, hostname, address);


--
-- Name: index_sonar_data_import_runs_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sonar_data_import_runs_on_user_id ON public.sonar_data_import_runs USING btree (user_id);


--
-- Name: index_sonar_data_import_runs_on_workspace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sonar_data_import_runs_on_workspace_id ON public.sonar_data_import_runs USING btree (workspace_id);


--
-- Name: index_vulns_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulns_on_name ON public.vulns USING btree (name);


--
-- Name: index_vulns_on_nexpose_data_vuln_def_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulns_on_nexpose_data_vuln_def_id ON public.vulns USING btree (nexpose_data_vuln_def_id);


--
-- Name: index_vulns_on_origin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulns_on_origin_id ON public.vulns USING btree (origin_id);


--
-- Name: index_web_cookies_on_request_group_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_cookies_on_request_group_id_and_name ON public.web_cookies USING btree (request_group_id, name);


--
-- Name: index_web_forms_on_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_forms_on_path ON public.web_forms USING btree (path);


--
-- Name: index_web_pages_on_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_pages_on_path ON public.web_pages USING btree (path);


--
-- Name: index_web_pages_on_query; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_pages_on_query ON public.web_pages USING btree (query);


--
-- Name: index_web_requests_on_cross_site_scripting_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_requests_on_cross_site_scripting_id ON public.web_requests USING btree (cross_site_scripting_id);


--
-- Name: index_web_requests_on_request_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_requests_on_request_group_id ON public.web_requests USING btree (request_group_id);


--
-- Name: index_web_sites_on_comments; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_sites_on_comments ON public.web_sites USING btree (comments);


--
-- Name: index_web_sites_on_options; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_sites_on_options ON public.web_sites USING btree (options);


--
-- Name: index_web_sites_on_vhost; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_sites_on_vhost ON public.web_sites USING btree (vhost);


--
-- Name: index_web_virtual_hosts_on_service_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_web_virtual_hosts_on_service_id_and_name ON public.web_virtual_hosts USING btree (service_id, name);


--
-- Name: index_web_vuln_category_metasploits_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_web_vuln_category_metasploits_on_name ON public.web_vuln_category_metasploits USING btree (name);


--
-- Name: index_web_vuln_category_owasps_on_target_and_version_and_rank; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_web_vuln_category_owasps_on_target_and_version_and_rank ON public.web_vuln_category_owasps USING btree (target, version, rank);


--
-- Name: index_web_vuln_category_project_metasploit_id_and_owasp_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_web_vuln_category_project_metasploit_id_and_owasp_id ON public.web_vuln_category_projection_metasploit_owasps USING btree (metasploit_id, owasp_id);


--
-- Name: index_web_vulns_on_method; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_vulns_on_method ON public.web_vulns USING btree (method);


--
-- Name: index_web_vulns_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_vulns_on_name ON public.web_vulns USING btree (name);


--
-- Name: index_web_vulns_on_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_vulns_on_path ON public.web_vulns USING btree (path);


--
-- Name: index_wizard_procedures_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_wizard_procedures_on_type ON public.wizard_procedures USING btree (type);


--
-- Name: originating_credential_cores; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX originating_credential_cores ON public.metasploit_credential_origin_cracked_passwords USING btree (metasploit_credential_core_id);


--
-- Name: se_human_targets_compound_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX se_human_targets_compound_idx ON public.se_human_targets USING btree (workspace_id, btrim(lower((email_address)::text)));


--
-- Name: se_target_list_human_targets_compound_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX se_target_list_human_targets_compound_idx ON public.se_target_list_human_targets USING btree (target_list_id, human_target_id);


--
-- Name: se_target_list_human_targets_r_compound_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX se_target_list_human_targets_r_compound_idx ON public.se_target_list_human_targets USING btree (human_target_id, target_list_id);


--
-- Name: unique_brute_force_guess_attempts; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_brute_force_guess_attempts ON public.brute_force_guess_attempts USING btree (brute_force_run_id, brute_force_guess_core_id, service_id);


--
-- Name: unique_brute_force_reuse_attempts; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_brute_force_reuse_attempts ON public.brute_force_reuse_attempts USING btree (brute_force_run_id, metasploit_credential_core_id, service_id);


--
-- Name: unique_brute_force_reuse_groups_metasploit_credential_cores; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_brute_force_reuse_groups_metasploit_credential_cores ON public.brute_force_reuse_groups_metasploit_credential_cores USING btree (brute_force_reuse_group_id, metasploit_credential_core_id);


--
-- Name: unique_complete_metasploit_credential_cores; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_complete_metasploit_credential_cores ON public.metasploit_credential_cores USING btree (workspace_id, realm_id, public_id, private_id) WHERE ((realm_id IS NOT NULL) AND (public_id IS NOT NULL) AND (private_id IS NOT NULL));


--
-- Name: unique_metasploit_credential_origin_services; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_metasploit_credential_origin_services ON public.metasploit_credential_origin_services USING btree (service_id, module_full_name);


--
-- Name: unique_metasploit_credential_origin_sessions; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_metasploit_credential_origin_sessions ON public.metasploit_credential_origin_sessions USING btree (session_id, post_reference_name);


--
-- Name: unique_private_metasploit_credential_cores; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_private_metasploit_credential_cores ON public.metasploit_credential_cores USING btree (workspace_id, private_id) WHERE ((realm_id IS NULL) AND (public_id IS NULL) AND (private_id IS NOT NULL));


--
-- Name: unique_privateless_metasploit_credential_cores; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_privateless_metasploit_credential_cores ON public.metasploit_credential_cores USING btree (workspace_id, realm_id, public_id) WHERE ((realm_id IS NOT NULL) AND (public_id IS NOT NULL) AND (private_id IS NULL));


--
-- Name: unique_public_metasploit_credential_cores; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_public_metasploit_credential_cores ON public.metasploit_credential_cores USING btree (workspace_id, public_id) WHERE ((realm_id IS NULL) AND (public_id IS NOT NULL) AND (private_id IS NULL));


--
-- Name: unique_publicless_metasploit_credential_cores; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_publicless_metasploit_credential_cores ON public.metasploit_credential_cores USING btree (workspace_id, realm_id, private_id) WHERE ((realm_id IS NOT NULL) AND (public_id IS NULL) AND (private_id IS NOT NULL));


--
-- Name: unique_realmless_metasploit_credential_cores; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_realmless_metasploit_credential_cores ON public.metasploit_credential_cores USING btree (workspace_id, public_id, private_id) WHERE ((realm_id IS NULL) AND (public_id IS NOT NULL) AND (private_id IS NOT NULL));


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('0'),
('1'),
('10'),
('11'),
('12'),
('13'),
('14'),
('15'),
('16'),
('17'),
('18'),
('19'),
('2'),
('20'),
('20100819123300'),
('20100824151500'),
('20100908001428'),
('20100911122000'),
('20100916151530'),
('20100916175000'),
('20100920012100'),
('20100926214000'),
('20101001000000'),
('20101002000000'),
('20101007000000'),
('20101008111800'),
('20101009023300'),
('20101104135100'),
('20101203000000'),
('20101203000001'),
('20101206212033'),
('20110112154300'),
('20110204112800'),
('20110317144932'),
('20110414180600'),
('20110415175705'),
('20110422000000'),
('20110425095900'),
('20110513143900'),
('20110517160800'),
('20110527000000'),
('20110527000001'),
('20110606000001'),
('20110608113500'),
('20110622000000'),
('20110624000001'),
('20110625000001'),
('20110630000001'),
('20110630000002'),
('20110717000001'),
('20110727163801'),
('20110730000001'),
('20110812000001'),
('20110922000000'),
('20110928101300'),
('20111011110000'),
('20111203000000'),
('20111204000000'),
('20111210000000'),
('20120126110000'),
('20120214173547'),
('20120214180627'),
('20120216175354'),
('20120222200922'),
('20120222211846'),
('20120222215615'),
('20120224210032'),
('20120224210251'),
('20120302211405'),
('20120322034657'),
('20120322035142'),
('20120327234013'),
('20120402171703'),
('20120411173220'),
('20120508153439'),
('20120521200021'),
('20120601152442'),
('20120607205748'),
('20120611022859'),
('20120611151726'),
('20120615191457'),
('20120619201707'),
('20120620144555'),
('20120621231906'),
('20120622204822'),
('20120622211713'),
('20120624211412'),
('20120625000000'),
('20120625000001'),
('20120625000002'),
('20120625000003'),
('20120625000004'),
('20120625000005'),
('20120625000006'),
('20120625000007'),
('20120625000008'),
('20120627170349'),
('20120628212319'),
('20120629171559'),
('20120702232922'),
('20120705220353'),
('20120706214120'),
('20120709182326'),
('20120709190111'),
('20120709190832'),
('20120710024953'),
('20120710221438'),
('20120711171500'),
('20120718202805'),
('20120807215156'),
('20120808203149'),
('20120814152312'),
('20120814190330'),
('20120820163240'),
('20120820164934'),
('20120829073017'),
('20120829183633'),
('20120830204014'),
('20120907202200'),
('20120919185804'),
('20121001202233'),
('20121004142927'),
('20121023183338'),
('20121112185301'),
('20121114171655'),
('20121116213357'),
('20121116213558'),
('20121116230408'),
('20121117071957'),
('20130104082355'),
('20130104182355'),
('20130130153815'),
('20130130193940'),
('20130130202350'),
('20130130215920'),
('20130201164531'),
('20130206153738'),
('20130206170059'),
('20130207204554'),
('20130208144847'),
('20130208192816'),
('20130208201622'),
('20130208205216'),
('20130214172625'),
('20130215162238'),
('20130216014001'),
('20130219151930'),
('20130219172323'),
('20130219190624'),
('20130221033344'),
('20130221203157'),
('20130221223222'),
('20130222175046'),
('20130223102526'),
('20130223171130'),
('20130226151306'),
('20130226203506'),
('20130226203526'),
('20130227191633'),
('20130228193109'),
('20130228193351'),
('20130228204548'),
('20130228214900'),
('20130228214901'),
('20130228214902'),
('20130301203008'),
('20130305194320'),
('20130308191559'),
('20130308200346'),
('20130308203109'),
('20130326155446'),
('20130326164623'),
('20130327210928'),
('20130327212613'),
('20130328163951'),
('20130402220630'),
('20130404162220'),
('20130412154159'),
('20130412171844'),
('20130412173121'),
('20130412173640'),
('20130412174254'),
('20130412174719'),
('20130412175040'),
('20130423211152'),
('20130425275209'),
('20130426172211'),
('20130430151353'),
('20130430162145'),
('20130502051220'),
('20130502214512'),
('20130509204359'),
('20130510021637'),
('20130510163306'),
('20130515164311'),
('20130515172727'),
('20130516204810'),
('20130522001343'),
('20130522032517'),
('20130522041110'),
('20130525015035'),
('20130525212420'),
('20130529183040'),
('20130530184206'),
('20130530184216'),
('20130530184226'),
('20130530184236'),
('20130531144949'),
('20130603161456'),
('20130604145732'),
('20130605130805'),
('20130605175148'),
('20130605180434'),
('20130605195015'),
('20130611180506'),
('20130616200853'),
('20130617234902'),
('20130618005943'),
('20130619002830'),
('20130621223520'),
('20130625163103'),
('20130713201916'),
('20130714210748'),
('20130717150737'),
('20130723172207'),
('20130909161125'),
('20130912003743'),
('20130916172858'),
('20130916173041'),
('20130918192935'),
('20130918225446'),
('20130924190444'),
('20130925161132'),
('20130926192707'),
('20130926215014'),
('20130926215420'),
('20130926221414'),
('20130927170839'),
('20130930182546'),
('20130930190641'),
('20131002004641'),
('20131002164449'),
('20131003161836'),
('20131003184552'),
('20131004144220'),
('20131007015724'),
('20131007182256'),
('20131007223847'),
('20131008175447'),
('20131008213344'),
('20131009185103'),
('20131009190247'),
('20131010053502'),
('20131010194200'),
('20131011162000'),
('20131011184338'),
('20131014194612'),
('20131015183918'),
('20131016174540'),
('20131017150735'),
('20131017160756'),
('20131017201435'),
('20131018030838'),
('20131020212347'),
('20131020212504'),
('20131021185657'),
('20131021230028'),
('20131022022052'),
('20131022041731'),
('20131023221505'),
('20131027230811'),
('20131027232332'),
('20131028163019'),
('20131031051123'),
('20131031170750'),
('20131106204241'),
('20131119184509'),
('20131119213009'),
('20131119234551'),
('20131126181005'),
('20131210191238'),
('20131217221431'),
('20131227085944'),
('20140123170446'),
('20140123192615'),
('20140204172553'),
('20140206213023'),
('20140207175151'),
('20140210203055'),
('20140213192518'),
('20140219180722'),
('20140221003649'),
('20140306005831'),
('20140318174815'),
('20140331173835'),
('20140407195724'),
('20140407212345'),
('20140410132401'),
('20140410161611'),
('20140410191213'),
('20140410205410'),
('20140411142102'),
('20140411205325'),
('20140414192550'),
('20140417140933'),
('20140428203822'),
('20140429144029'),
('20140505174356'),
('20140507000330'),
('20140520140817'),
('20140603163708'),
('20140605173747'),
('20140606165728'),
('20140701184757'),
('20140702184622'),
('20140703144541'),
('20140708175508'),
('20140711184807'),
('20140722174919'),
('20140728191933'),
('20140729162740'),
('20140801150537'),
('20140804161504'),
('20140905031549'),
('20140909191631'),
('20140912163522'),
('20140912194642'),
('20140916162714'),
('20140917145416'),
('20140922170030'),
('20140930193425'),
('20140930203020'),
('20141001173504'),
('20141001183658'),
('20141029152449'),
('20141031190206'),
('20141112234624'),
('20141119153655'),
('20141124200327'),
('20141125170243'),
('20141201195259'),
('20141208002728'),
('20141210203237'),
('20150106201450'),
('20150112203945'),
('20150126191220'),
('20150205192745'),
('20150206170204'),
('20150206201513'),
('20150209195939'),
('20150212214222'),
('20150219173821'),
('20150219215039'),
('20150225173656'),
('20150226151459'),
('20150302212619'),
('20150310151024'),
('20150312155312'),
('20150317145455'),
('20150326183742'),
('20150406194935'),
('20150421211719'),
('20150427204508'),
('20150429030017'),
('20150514182921'),
('20150615195014'),
('20150710194833'),
('20150730163948'),
('20150811153243'),
('20150817165134'),
('20150819171430'),
('20150819200435'),
('20151119175203'),
('20151123224123'),
('20151124043724'),
('20151201172151'),
('20151210213133'),
('20151221191036'),
('20151222204507'),
('20151230185859'),
('20160119190447'),
('20160128212651'),
('20160208194940'),
('20160209224629'),
('20160210201010'),
('20160217173725'),
('20160218164041'),
('20160310192344'),
('20160310212705'),
('20160316200504'),
('20160415153312'),
('20160523162358'),
('20160524192553'),
('20160712155656'),
('20160715142314'),
('20160818151322'),
('20161004165612'),
('20161107153145'),
('20161107203710'),
('20161129120000'),
('20161227212223'),
('20170109000000'),
('20170206194551'),
('20170514000000'),
('20170516201455'),
('20170627000000'),
('20180302164552'),
('20180404151931'),
('20180626161738'),
('20180904120211'),
('20190114174651'),
('20190308134512'),
('20190401151804'),
('20190415154041'),
('20190507120211'),
('20200207162404'),
('20200326000000'),
('20200501000000'),
('20210504144323'),
('20210706195826'),
('20220621141054'),
('20221209005658'),
('21'),
('22'),
('23'),
('24'),
('25'),
('26'),
('3'),
('4'),
('5'),
('6'),
('7'),
('8'),
('9');


