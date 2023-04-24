#ifndef OPERATOR_
#define OPERATOR_
#define DEFAULT_RANGER_SEL 0.3
// adjusted by testing
// AVX throughput 2
#define DISTANCE_COST_COEFFI 0.05
// prevent zero returns, which will result in insane zero cost
#define DEFAULT_ARRAY_LENGTH 500
#endif