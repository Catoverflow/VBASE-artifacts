// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#include "inc/Test.h"
#include "inc/Helper/SimpleIniReader.h"
#include "inc/Core/VectorIndex.h"
#include "inc/Core/ResultIterator.h"
#include "inc/Core/Common/CommonUtils.h"

#include <unordered_set>
#include <chrono>

template <typename T>
void BuildIndex(SPTAG::IndexAlgoType algo, std::string distCalcMethod, std::shared_ptr<SPTAG::VectorSet>& vec, std::shared_ptr<SPTAG::MetadataSet>& meta, const std::string out)
{

    std::shared_ptr<SPTAG::VectorIndex> vecIndex = SPTAG::VectorIndex::CreateInstance(algo, SPTAG::GetEnumValueType<T>());
    BOOST_CHECK(nullptr != vecIndex);

    vecIndex->SetParameter("DistCalcMethod", distCalcMethod);
    vecIndex->SetParameter("NumberOfThreads", "16");

    BOOST_CHECK(SPTAG::ErrorCode::Success == vecIndex->BuildIndex(vec, meta));
    BOOST_CHECK(SPTAG::ErrorCode::Success == vecIndex->SaveIndex(out));
}

template <typename T>
void SearchIterative(const std::string folder, T* vec, SPTAG::SizeType n, int k, std::string* truthmeta)
{
    std::shared_ptr<SPTAG::VectorIndex> vecIndex;
    BOOST_CHECK(SPTAG::ErrorCode::Success == SPTAG::VectorIndex::LoadIndex(folder, vecIndex));
    BOOST_CHECK(nullptr != vecIndex);
    SPTAG::BasicResult result;
    std::shared_ptr<SPTAG::ResultIterator> resultIterator = vecIndex->GetIterator(vec, true);
    for (int i = 0; i < 100; i++) {
        bool hasResult = resultIterator->Next(result);
        if (!hasResult) break;
        std::cout << "hasResult: " << hasResult << std::endl;
        std::cout << "result: " << result.VID << std::endl;  
    }
    resultIterator->Close();
}

template <typename T>
void TestIterativeScan(SPTAG::IndexAlgoType algo, std::string distCalcMethod)
{
    SPTAG::SizeType n = 2000, q = 3;
    SPTAG::DimensionType m = 10;
    int k = 3;
    std::vector<T> vec;
    for (SPTAG::SizeType i = 0; i < n; i++) {
        for (SPTAG::DimensionType j = 0; j < m; j++) {
            vec.push_back((T)i);
        }
    }

    std::vector<T> query;
    for (SPTAG::SizeType i = 0; i < q; i++) {
        for (SPTAG::DimensionType j = 0; j < m; j++) {
            query.push_back((T)i * 2);
        }
    }

    std::vector<char> meta;
    std::vector<std::uint64_t> metaoffset;
    for (SPTAG::SizeType i = 0; i < n; i++) {
        metaoffset.push_back((std::uint64_t)meta.size());
        std::string a = std::to_string(i);
        for (size_t j = 0; j < a.length(); j++)
            meta.push_back(a[j]);
    }
    metaoffset.push_back((std::uint64_t)meta.size());

    std::shared_ptr<SPTAG::VectorSet> vecset(new SPTAG::BasicVectorSet(
        SPTAG::ByteArray((std::uint8_t*)vec.data(), sizeof(T) * n * m, false),
        SPTAG::GetEnumValueType<T>(), m, n));

    std::shared_ptr<SPTAG::MetadataSet> metaset(new SPTAG::MemMetadataSet(
        SPTAG::ByteArray((std::uint8_t*)meta.data(), meta.size() * sizeof(char), false),
        SPTAG::ByteArray((std::uint8_t*)metaoffset.data(), metaoffset.size() * sizeof(std::uint64_t), false),
        n));

    BuildIndex<T>(algo, distCalcMethod, vecset, metaset, "testindices");
    std::string truthmeta1[] = { "0", "1", "2", "2", "1", "3", "4", "3", "5" };
    SearchIterative<T>("testindices", query.data(), q, k, truthmeta1);
}

BOOST_AUTO_TEST_SUITE(IterativeScanTest)

BOOST_AUTO_TEST_CASE(BKTTest)
{
    TestIterativeScan<float>(SPTAG::IndexAlgoType::BKT, "L2");
}

BOOST_AUTO_TEST_SUITE_END()
