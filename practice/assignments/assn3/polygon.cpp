#include <cstdint>
#include <iostream>
#include <vector>
using namespace std;

uint64_t area(vector<pair<int, int>> &points) {
  // This code has signed overflows. :)
  // Please fix this so it correctly evaluates area..!
  __int128_t total = 0;
  size_t n = points.size();

  vector<pair<uint64_t, int>> cal;

  for (unsigned i = 0; i < n; i++) {
    unsigned j = (i + 1) % n;
    int64_t x_i = points[i].first;
    int64_t y_i = points[i].second;
    int64_t x_j = points[j].first;
    int64_t y_j = points[j].second;
    total += x_i * y_j - y_i * x_j;
  }
  total /= 2;
  return total;
}