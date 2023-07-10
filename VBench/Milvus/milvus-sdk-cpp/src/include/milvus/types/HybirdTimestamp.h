// Licensed to the LF AI & Data foundation under one
// or more contributor license agreements. See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership. The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#pragma once
#include <chrono>

#include "Constants.h"

namespace milvus {

template <typename Duration>
struct _is_std_duration;

template <typename _Rep, typename _Period>
struct _is_std_duration<std::chrono::duration<_Rep, _Period>> {
    static const bool value = true;
};

/**
 * @brief Hybird Timestamp
 */
class HybirdTimestamp {
    uint64_t ts_{0};

 public:
    HybirdTimestamp();

    explicit HybirdTimestamp(uint64_t ts);

    HybirdTimestamp(uint64_t physical, uint64_t logical);

    /**
     * @brief Hybird timestamp value
     */
    uint64_t
    Timestamp() const;

    /**
     * @brief logical value
     */
    uint64_t
    Logical() const;

    /**
     * @brief Physical value in milliseconds
     */
    uint64_t
    Physical() const;

    /**
     * @brief Increase duration in physical part
     *
     */
    template <typename Duration>
    typename std::enable_if<_is_std_duration<Duration>::value, HybirdTimestamp&>::type
    operator+=(Duration duration) {
        auto milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(duration).count();
        return *this += milliseconds;
    }

    /**
     * @brief Increase milliseconds in physical part
     *
     * @param milliseconds
     * @return HybirdTimestamp
     */
    HybirdTimestamp&
    operator+=(uint64_t milliseconds);

    /**
     * @brief Add duration in physical part
     *
     * @param duration Duration
     * @return HybirdTimestamp
     */
    template <typename Duration>
    typename std::enable_if<_is_std_duration<Duration>::value, HybirdTimestamp>::type
    operator+(Duration duration) {
        auto milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(duration).count();
        return *this + milliseconds;
    }

    /**
     * @brief Add milliseconds in physical part
     *
     * @param milliseconds
     * @return HybirdTimestamp
     */
    HybirdTimestamp
    operator+(uint64_t milliseconds);

    /**
     * @brief Create hybird timestamp from unix time
     */
    static HybirdTimestamp
    CreateFromUnixtime(uint64_t epoch_in_milliseconds);
};
}  // namespace milvus
