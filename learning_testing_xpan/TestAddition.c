#include "../../Unity/src/unity.h"
#include "addition.h"

void setUp(void) {}

void tearDown(void) {}

void test_addition(){
    TEST_ASSERT_EQUAL(5, add(2, 3));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_addition);
    return UNITY_END();
}