#include "ranger_sel.hpp"
#include <immintrin.h>
#include <hnswlib.h>
static hnswlib::InnerProductSpace IPDistance(0);

RangeRSelEsti::RangeRSelEsti(const std::string &record_path)
{
    std::ifstream fin(record_path, std::ios::in | std::ios::binary);
    if (!fin)
    {
        this->sampled_data = std::vector<std::vector<float>>();
        return ;
    }
    this->sampled_data = std::vector<std::vector<float>>();
    size_t sample_count;
    fin.read((char *)&sample_count, sizeof(sample_count));
    fin.read((char *)&this->dimension, sizeof(this->dimension));
    this->sampled_data.resize(sample_count);
    for (size_t i = 0; i < sample_count; i++)
    {
        this->sampled_data[i].resize(this->dimension);
        fin.read(reinterpret_cast<char*>(&this->sampled_data[i][0]), this->dimension * sizeof(sampled_data[i][0]));
    }
    if(!fin.good())
    {
        throw std::runtime_error("error when reading");
    }
    fin.close();
}

RangeRSelEsti::RangeRSelEsti()
{
    this->sampled_data = std::vector<std::vector<float>>();
}

bool RangeRSelEsti::add_tuple(const std::vector<float> &vec)
{
    return add_tuple(vec, 0.001);
}

bool RangeRSelEsti::add_tuple(const std::vector<float> &vec, const double &sample_rate)
{
    if (this->dimension == 0)
    {
        this->dimension = vec.size();
    }
    else if (this->dimension != vec.size())
    {
        throw std::runtime_error("dimension mismatch");
    }
    if (double(rand()) / RAND_MAX < sample_rate)
    {
        this->sampled_data.push_back(vec);
        return true;
    }
    return false;
}

void RangeRSelEsti::save(std::string record_path)
{
    std::ofstream output(record_path, std::ios::out | std::ios::binary);
    if (!output)
    {
        throw std::runtime_error("cannot open file " + record_path);
    }
    size_t sample_count = this->sampled_data.size();
    output.write((char *) &sample_count, sizeof(sample_count));
    output.write((char *) &this->dimension, sizeof(this->dimension));
    for (size_t i = 0; i < sample_count; i ++)
    {
        output.write(reinterpret_cast<const char*>(&this->sampled_data[i][0]), this->dimension * sizeof(this->sampled_data[i][0]));
    }
    if (!output.good())
    {
        throw std::runtime_error("error when writing");
    }
    output.close();
}


double RangeRSelEsti::selectivity(const std::vector<float> &query, const float &radius)
{
    if (this->sampled_data.empty())
        return default_sel;
    double selected = 0;
    const size_t dim = query.size();
    for (auto &sample : this->sampled_data)
    {
        if (IPDistance.get_dist_func()(&query[0], &sample[0], &dim) <= radius)
            selected += 1;
    }
    return selected / this->sampled_data.size();
}