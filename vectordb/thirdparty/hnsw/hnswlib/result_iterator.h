#pragma once

#include <memory>

namespace hnswlib {

	template<typename dist_t>
	class ResultIterator
	{
	public:
		ResultIterator(const AlgorithmInterface<dist_t>* index, const void* p_target)
			:m_index_(index),
			m_target_(p_target)
		{
			m_queryResult_ = std::make_unique<QueryResult<dist_t>>();
			m_workspace_ = index->getFreeWorkSpace();
			m_isFirstResult_ = true;
		}

		~ResultIterator() {
			if (m_workspace_ != nullptr) {
				m_index_->searchIndexIterativeEnd(m_workspace_);
				m_workspace_ = nullptr;
			}
			m_queryResult_ = nullptr;
		}

		QueryResult<dist_t>* Next() {
			m_queryResult_->SetHasResult(false);
			m_index_->searchKnnIterative(m_target_, m_workspace_.get(), *m_queryResult_, m_isFirstResult_);
			m_isFirstResult_ = false;
			return m_queryResult_.get();
		}

		void Close() {
			if (m_workspace_ != nullptr) {
				m_index_->searchIndexIterativeEnd(m_workspace_);
				m_workspace_ = nullptr;
			}
		}

		QueryResult<dist_t>* GetQuery() const {
			return m_queryResult_.get();
		}
	private:
		const AlgorithmInterface<dist_t>* m_index_;
		const void* m_target_;
		std::unique_ptr<QueryResult<dist_t>> m_queryResult_;
		std::shared_ptr<WorkSpace<dist_t>> m_workspace_;
		bool m_isFirstResult_;
	};
} // namespace hnswlib
