#include "ranger_sel.hpp"
#include "util.hpp"
#include "operator.hpp"
// #include "../thirdparty/hnsw/hnswlib/space_ip.h"
extern "C"
{
#include <postgres.h>
// global vars
#include <miscadmin.h>
#include <fmgr.h>
#include <nodes/pg_list.h>
#include <nodes/supportnodes.h>
#include <optimizer/optimizer.h>
#include <utils/selfuncs.h>
}

extern "C"
{
    Datum inner_product_cost(PG_FUNCTION_ARGS)
    {
        Node *rawreq = (Node *) PG_GETARG_POINTER(0);
        Node *ret = NULL;
        // as a support function, there're other types of support request
        // see postgres/src/test/regress/regress.c test_support_func for ref
        
        if (IsA(rawreq, SupportRequestCost))
        {
            // ereport(INFO, errmsg("cost_support called"));
            SupportRequestCost *req = (SupportRequestCost *) rawreq;
            int arraylength = DEFAULT_ARRAY_LENGTH;
            if (IsA(req->node, OpExpr))
            {
                List *l = ((OpExpr *) req->node)->args;
                // var1 op var2 (or func or subquery)
                if (list_length(l) == 2)
                {
                    Node *left = (Node *) linitial(l);
                    Node *right = (Node *) lsecond(l);
                    // the first element of <<*>> is r instead of query
                    if (IsA(left, Const))
                        arraylength = estimate_array_length((Node *) left) - 1;
                    else if (IsA(right, Const))
                        arraylength = estimate_array_length((Node *) right) - 1;
                    else
                    {
                        // ereport(INFO, errmsg("array is non-const, we can't get its length for the moment"));
                        arraylength = DEFAULT_ARRAY_LENGTH;
                    }
                }
            }
            req->startup = 0;
            // according to previous test result
            // we tested on L2 distance, maybe less precise on inner product
            req->per_tuple = arraylength * cpu_operator_cost * DISTANCE_COST_COEFFI;
            ret = (Node *) req;
            // ereport(INFO, errmsg("array length: %d", arraylength));
        }
        PG_RETURN_POINTER(ret);
    }

    PG_FUNCTION_INFO_V1(inner_product_cost);
}


double ranger_inner_product_sel_internal(Datum arraydatum)
{
    auto array = convert_array_to_vector(arraydatum);
    // currently we can't get the name of relation that behind the var, so just skip
    std::string path = std::string(DataDir) + std::string("/") + std::string(DatabasePath) + std::string("/ranger.bin");
    auto ranger = std::make_shared<RangeRSelEsti>(path);
    auto r = array[0];
    auto query = std::vector<float>(array.begin() + 1, array.end());
    return ranger->selectivity(query, r);
}

extern "C"
{
    // reference: postgres/src/backend/util/adt/selfuncs.c L1817
    Datum ranger_inner_product_sel_restriction(PG_FUNCTION_ARGS)
    {
        // ereport(INFO, errmsg("restriction selectivity called"));
        PlannerInfo *root = (PlannerInfo *) PG_GETARG_POINTER(0);
        Oid operatorid = PG_GETARG_OID(1);
        List *args = (List *) PG_GETARG_POINTER(2);
        int varRelid = PG_GETARG_INT32(3);
        Oid collation = PG_GET_COLLATION();
        VariableStatData vardata;
        Node *other;
        bool varonleft;
        if (!get_restriction_variable(
                root, args, varRelid, &vardata, &other, &varonleft))
        {
            // ereport(INFO, errmsg("get_restriction_variable failed"));
            PG_RETURN_FLOAT8(DEFAULT_RANGER_SEL);
        }
        if (!IsA(other, Const))
        {
            // ereport(INFO, errmsg("array is non-const, return default selectivity %f", DEFAULT_RANGER_SEL));
            ReleaseVariableStats(vardata);
            PG_RETURN_FLOAT8(DEFAULT_RANGER_SEL);
        }
        ReleaseVariableStats(vardata);
        Datum array = ((Const *) other)->constvalue;
        bool arrayisnull = ((Const *) other)->constisnull;
        if (arrayisnull)
            PG_RETURN_FLOAT8(0.0);
        Selectivity sel = ranger_inner_product_sel_internal(array);
        ereport(INFO, errmsg("estimated selectivity: %f", sel));
        PG_RETURN_FLOAT8(sel);
    }
    Datum ranger_inner_product_sel_join(PG_FUNCTION_ARGS)
    {
        Selectivity selec = 0.5;
        // ereport(INFO, errmsg("join selectivity called, not implemented yet, return %f", selec));
        PG_RETURN_FLOAT8(selec);
    }

    PG_FUNCTION_INFO_V1(ranger_inner_product_sel_restriction);
    PG_FUNCTION_INFO_V1(ranger_inner_product_sel_join);
}