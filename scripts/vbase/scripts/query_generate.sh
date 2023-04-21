#/bin/bash
mkdir /artifacts/scripts/vbase/query_run/table5/sql
mkdir /artifacts/scripts/vbase/query_run/table5/result
mkdir /artifacts/scripts/vbase/query_run/table6/sql
mkdir /artifacts/scripts/vbase/query_run/table6/result
python3 /artifacts/scripts/vbase/query_run/table5/query_1.py
python3 /artifacts/scripts/vbase/query_run/table5/query_2.py
python3 /artifacts/scripts/vbase/query_run/table5/query_3.py
python3 /artifacts/scripts/vbase/query_run/table5/query_4.py
python3 /artifacts/scripts/vbase/query_run/table5/query_5.py
python3 /artifacts/scripts/vbase/query_run/table5/query_6.py
python3 /artifacts/scripts/vbase/query_run/table5/query_7.py
python3 /artifacts/scripts/vbase/query_run/table5/query_8.py
python3 /artifacts/scripts/vbase/query_run/table6/query_selectivity_0.03.py
python3 /artifacts/scripts/vbase/query_run/table6/query_selectivity_0.3.py
python3 /artifacts/scripts/vbase/query_run/table6/query_selectivity_0.9.py
