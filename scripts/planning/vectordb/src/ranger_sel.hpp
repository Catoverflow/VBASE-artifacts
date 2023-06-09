/*
  This file provides support for rangeR selectivity evaluation.
  The evaluation is based on the verified assumption:
    a small number of vector selected randomly can reflect on the distribution of whole data
  We tested that on recipe1M dataset, with a small sample rate of 0.0002,
  the estimation of selectivity can still well represent the actual result.
  The RangeRSelEsti class here provide support for sampling and selectivity estimation.
*/

#ifndef RANGER_ESTIMATION_HPP
#define RANGER_ESTIMATION_HPP

#include <vector>
#include <fstream>
#include <iterator>
#include <cstdlib>
#include <memory>

/*
Current solution:
brute-force search on sampled data and give a selectivity of quary
Also only merged into index->amcostestimate

Best solution(WIP):
(maybe unnecessary given the tiny sample rate) build an index on sampled data
Store rangeR infomation in vardata->statsTuple, give these sample a niche in postgres
*/

// usually T is set to double
// in case current implementation in SPTAG index only support float, I use template to support both.

// range-r selectivity estimation class
class RangeRSelEsti
{
    #define default_sel 0.33
private:
    std::vector<std::vector<float>> sampled_data;
    size_t dimension = 0;
public:
    // initialize with already sampled data from file
    RangeRSelEsti(const std::string &record_path);
    // initialize with an empty sample table,
    // RangeRSelEsti::feed_tuple need to be called to create a new sample
    RangeRSelEsti();
    // return true if this vector is sampled (rand < sample_rate)
    bool add_tuple(const std::vector<float> &vec, const double &sample_rate);
    // sample_rate = 0.001 if not defined
    bool add_tuple(const std::vector<float> &vec);
    // save sampled data to file, note distance function is not included
    void save(std::string record_path);
    // test the query on sampled data and return the result as estimated selectivity
    double selectivity(const std::vector<float> &query, const float &radius);

};

#endif
