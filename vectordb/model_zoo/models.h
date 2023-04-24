#include <vector>

extern "C"{
std::vector<float> img2vec(char* imgpath);
std::vector<float> word2vec(char* input);
}
