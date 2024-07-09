#include <A&A/common/Structures.mqh>
#include <Trade/Trade.mqh>

class Execution {
    protected:
        CTrade *trade;

    private:

    public:
        virtual ENUM_ORDER_TYPE Go(PositionParams &params) { return 0; }
};