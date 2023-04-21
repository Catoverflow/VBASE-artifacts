#!/bin/bash
psql -U vectordb -f /artifacts/scripts/postgres/load_data/load.sql
