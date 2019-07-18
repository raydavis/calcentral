--
-- PostgreSQL database schema clean
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

DROP TABLE public.canvas_synchronization;
DROP TABLE public.notifications;
DROP TABLE public.oauth2_data;
DROP TABLE public.recent_uids;
DROP TABLE public.saved_uids;
DROP TABLE public.schema_migrations;
DROP TABLE public.schema_migrations_backup;
DROP TABLE public.schema_migrations_fixed_backup;
DROP TABLE public.user_data;
DROP TABLE public.user_visits;
DROP TABLE public.webcast_course_site_log;
