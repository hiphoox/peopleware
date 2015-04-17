#!/bin/tcsh

psql -d peopleware -U peopleware -c "drop schema public cascade;"
psql -d peopleware -U peopleware -c "create schema public;"  
psql -d peopleware -U peopleware -f peopleware.sql

