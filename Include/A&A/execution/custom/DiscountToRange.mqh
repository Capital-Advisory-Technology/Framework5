#include <A&A/execution/Execution.mqh>
#property strict

class DiscountToRange : public Execution {
    private:
        int lookBack;
    
    public:
        DiscountToRange(void) {};
        ~DiscountToRange(void) {};

        void Init(int cLookBack) {
            lookBack = cLookBack;
        }

        virtual ENUM_ORDER_TYPE Go(PositionParams &params);
};

extern DiscountToRange *discountToRange;

ENUM_ORDER_TYPE DiscountToRange::Go(PositionParams &params) {
    if (signal == SIGNAL_NONE)
        return ORDER_TYPE_NONE;

    double limitPrice = calculateLimitPrice(PositionParams &params);

    if (limitPrice == 0)
        return ORDER_TYPE_NONE;

    return (signal == SIGNAL_BUY) ? ORDER_TYPE_BUY_LIMIT : ORDER_TYPE_SELL_LIMIT;
}

double DiscountToRange::calculateLimitPrice(PositionParams &params) {
    double high = 0, low = 0;

    for (int i = 1; i <= lookBack; i++) {
        
        double highPrice = iHigh(_Symbol, _Period, i);
        double lowPrice = iLow(_Symbol, _Period, i);

        if (highPrice > high) high = highPrice;
        if (lowPrice < low) low = lowPrice;
    
    }

    if (high == 0 || low == 0) {
        SetUserError(0);
        return 0;
    }

    double range = high - low;
    double midpoint = low + (range * 0.5);

    return (signal == SIGNAL_BUY) ? midpoint : midpoint;

}