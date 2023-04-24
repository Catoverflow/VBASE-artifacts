#include "util.h"

std::vector<float> str2vec(std::string str, std::string delim){
    std::vector<float> result;
    size_t head = 0, tail, end = str.size();
    while ( head < end ){
        tail = str.find(delim, head);
        // tail = std::min(end, tail);
        if ( tail == std::string::npos ) tail = end;
        if ( head == tail ) break;
        float elem = std::stof(str.substr(head, tail-head));
        result.push_back(elem);
        head = tail + 1;
    }
    return result;
}

