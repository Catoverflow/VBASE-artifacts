#pragma once

#include<cstdint>

namespace hnswlib {
    typedef std::uint64_t labeltype;

    template<typename dist_t>
    class QueryResult
    {
    public:
        void SetHasResult(bool hasResult)
        {
            hasResult_ = hasResult;
        }

        bool HasResult()
        {
            return hasResult_;
        }

        void SetLabel(labeltype label)
        {
            label_ = label;
        }

        labeltype GetLabel()
        {
            return label_;
        }

        void SetDistance(dist_t distance)
        {
            distance_ = distance;
        }

        dist_t GetDistance()
        {
            return distance_;
        }

    private:
        labeltype label_;
        dist_t distance_;
        bool hasResult_;
    };
} // namespace hnswlib