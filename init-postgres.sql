-- This is run when you start the Docker postgres container.
-- Create separate databases for each application.
-- This only runs if the postgresql data directory is empty.
--   See the "Initialization scripts" section of https://hub.docker.com/_/postgres

CREATE DATABASE app_rails;