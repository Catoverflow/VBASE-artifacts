#include "cpptest.h"
#include "lib.h"

#include <algorithm>
#include <vector>

int cpp_test() {
  std::vector<int> vec{2, 4, 6, 3, 1, 5, 8, 7};
  std::sort(vec.begin(), vec.end());
  return *vec.begin() + test();
}
