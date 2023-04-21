#!/bin/bash
psql -U vectordb -f /artifacts/scripts/vbase/load_data/load.sql
