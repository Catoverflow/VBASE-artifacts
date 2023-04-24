#pragma once

#include "visited_list_pool.h"
#include <queue>
#include <utility>
#include <mutex>
#include <deque>
#include <memory>

namespace hnswlib {
	typedef unsigned int tableint;

	template<typename dist_t>
	class WorkSpace
	{
	public:
		struct CompareByFirst {
			constexpr bool operator()(std::pair<dist_t, tableint> const& a,
				std::pair<dist_t, tableint> const& b) const noexcept {
				return a.first < b.first;
			}
		};
		void Reset(VisitedList* v)
		{
			candidate_set = {};
			vl = v;
		}
		VisitedList* vl;
		std::priority_queue<std::pair<dist_t, tableint>, std::vector<std::pair<dist_t, tableint>>, CompareByFirst> candidate_set;
	};

	/*
	template<typename dist_t>
	class WorkSpacePool {
	public:
		WorkSpacePool(int initmaxpools) {
			for (int i = 0; i < initmaxpools; i++)
				pool_.push_front(std::make_shared<WorkSpace<dist_t>>());
		}

		~WorkSpacePool() {
			while (pool_.size()) {
				std::shared_ptr<WorkSpace<dist_t>> rez = pool_.front();
				pool_.pop_front();
				rez = nullptr;
			}
		};

		std::shared_ptr<WorkSpace<dist_t>> getFreeWorkSpace() {
			std::shared_ptr<WorkSpace<dist_t>> rez;
			{
				std::unique_lock<std::mutex> lock(poolguard_);
				if (pool_.size() > 0) {
					rez = pool_.front();
					pool_.pop_front();
				}
				else {
					rez = std::make_shared<WorkSpace<dist_t>>();
				}
			}
			return rez;
		};

		void releaseWorkSpace(std::shared_ptr<WorkSpace<dist_t>> ws) {
			std::unique_lock<std::mutex> lock(poolguard_);
			pool_.push_front(ws);
		};

	private:
		std::deque<std::shared_ptr<WorkSpace<dist_t>>> pool_;
		std::mutex poolguard_;
	};
	*/
} // namespace hnswlib
