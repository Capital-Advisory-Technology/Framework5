#include <Critiq\common\Structures.mqh>


class OrderFailSafe {
    protected:
        ENUM_ORDER_TYPE failedOpens[];
        PositionModifyParams failedModifies[];
        double failedSizeOuts[];

        void removeFailedOpen(int index);
        void removeFailedModify(int index);
        void removeFailedSizeOut(int index);

    public:
        OrderFailSafe(void);
        ~OrderFailSafe(void);

        void addFailedOpen(ENUM_ORDER_TYPE cOrderType);
        void addFailedModify(double sl, double tp);
        void addFailedSizeOut(double volume);

        int getFailedOpenSize() { return ArraySize(failedOpens); }
        int getFailedModifySize() { return ArraySize(failedModifies); }
        int getFailedSizeOutSize() { return ArraySize(failedSizeOuts); }

        ENUM_ORDER_TYPE getFailedOpen(int index);
        PositionModifyParams getFailedModify(int index);
        double getFailedSizeOut(int index);

};

extern OrderFailSafe *orderFailSafe = new OrderFailSafe;

OrderFailSafe::OrderFailSafe(void) {}
OrderFailSafe::~OrderFailSafe(void) {
    ArrayFree(failedOpens);
    ArrayFree(failedModifies);
}

void OrderFailSafe::removeFailedOpen(int index) {
    int len = ArraySize(failedOpens);
    ArrayRemove(failedOpens, index, 1);

    if (len == 1) ArrayFree(failedOpens);
    else ArrayResize(failedOpens, len - 1);
}

void OrderFailSafe::removeFailedModify(int index) {
    int len = ArraySize(failedModifies);
    ArrayRemove(failedModifies, index, 1);

    if (len == 1) ArrayFree(failedModifies);
    else ArrayResize(failedModifies, len - 1);
}

void OrderFailSafe::removeFailedSizeOut(int index) {
    int len = ArraySize(failedSizeOuts);
    ArrayRemove(failedSizeOuts, index, 1);

    if (len == 1) ArrayFree(failedSizeOuts);
    else ArrayResize(failedSizeOuts, len - 1);
}


void OrderFailSafe::addFailedOpen(ENUM_ORDER_TYPE cOrderType) {
    ArrayResize(failedOpens, ArraySize(failedOpens) + 1);
    failedOpens[ArraySize(failedOpens) - 1] = cOrderType;
}

void OrderFailSafe::addFailedModify(double sl, double tp) {
    PositionModifyParams params = {sl, tp};
    ArrayResize(failedModifies, ArraySize(failedModifies) + 1);
    failedModifies[ArraySize(failedModifies) - 1] = params;
}

void OrderFailSafe::addFailedSizeOut(double volume) {
    ArrayResize(failedSizeOuts, ArraySize(failedSizeOuts) + 1);
    failedSizeOuts[ArraySize(failedSizeOuts) - 1] = volume;
}

ENUM_ORDER_TYPE OrderFailSafe::getFailedOpen(int index) {
    ENUM_ORDER_TYPE orderType = failedOpens[index];
    removeFailedOpen(index);
    return orderType;
}

PositionModifyParams OrderFailSafe::getFailedModify(int index) {
    PositionModifyParams params = failedModifies[index];
    removeFailedModify(index);
    return params;
}

double OrderFailSafe::getFailedSizeOut(int index) {
    double volume = failedSizeOuts[index];
    removeFailedSizeOut(index);
    return volume;
}