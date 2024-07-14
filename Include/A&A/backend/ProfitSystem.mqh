class ProfitSystem {
    protected:
        double breakevenTarget;
        double target1;
        double target2;
        double stop1;
        double stop2;

    private:
        double profitZone(double target, double stop);

    public:
        ProfitSystem(double cBE, double cT1, double cT2, double cS1, double cS2);
        ~ProfitSystem(); // techically don't need this defined

        double breakeven();
        double profitZone1();
        double profitZone2();
};

ProfitSystem::ProfitSystem(double cBE = 0, double cT1 = 0, double cT2 = 0, double cS1 = 0, double cS2 = 0) {
    breakevenTarget = cBE;
    target1         = cT1;
    target2         = cT2;
    stop1           = cS1;
    stop2           = cS2;
}

double ProfitSystem::profitZone(double target, double stop) {
    if(target == 0 && stop == 0) return 0;

    int    type        = (int)PositionGetInteger(POSITION_TYPE);
    double oop         = PositionGetDouble(POSITION_PRICE_OPEN);
    double otp         = PositionGetDouble(POSITION_TP);
    double osl         = PositionGetDouble(POSITION_SL);
    double delta       = MathAbs(otp - oop);
    double targetDelta = delta * target;
    double stopDelta   = delta * stop;

    double targetPrice, stopPrice;
    double lastHigh, lastLow;

    switch(type) {
        case ORDER_TYPE_BUY:
            targetPrice = NormalizeDouble(oop + targetDelta, _Digits);
            stopPrice   = NormalizeDouble(oop + stopDelta, _Digits);

            lastHigh = iHigh(_Symbol, PERIOD_CURRENT, 1);
            if(osl < stopPrice && lastHigh >= targetPrice) 
                return stopPrice;

        case ORDER_TYPE_SELL:
            targetPrice = NormalizeDouble(oop - targetDelta, _Digits);
            stopPrice   = NormalizeDouble(oop - stopDelta, _Digits);

            lastLow = iLow(_Symbol, PERIOD_CURRENT, 1);
            if(osl > stopPrice && (lastLow <= targetPrice))
                return stopPrice;
        default:
            return 0;
    }

    return 0;
}

/*
 *  Break even function.
 *  Checks if the last high hit target price: (otp - oop) * target
 *  Target - n% of the distance between open and take profit
 *  @return double - 0 if not at breakeven, oop if at breakeven
 */
double ProfitSystem::breakeven() {
    if(breakevenTarget == 0) return 0;
    if(PositionGetDouble(POSITION_SL) == PositionGetDouble(POSITION_PRICE_OPEN)) return 0;

    int    type     = (int)PositionGetInteger(POSITION_TYPE);
    double oop      = PositionGetDouble(POSITION_PRICE_OPEN);
    double otp      = PositionGetDouble(POSITION_TP);
    double osl      = PositionGetDouble(POSITION_SL);
    double delta    = MathAbs(otp - oop) * breakevenTarget;
    double lastHigh = iHigh(_Symbol, PERIOD_CURRENT, 1);
    double lastLow  = iLow(_Symbol, PERIOD_CURRENT, 1);
    double targetPrice;

    switch(type) {
        case ORDER_TYPE_BUY:
            if(osl > oop)
                return 0;
            targetPrice = NormalizeDouble(oop + delta, _Digits);
            if(osl < oop && lastHigh >= targetPrice)
                return oop;
        case ORDER_TYPE_SELL:
            if(osl < oop)
                return 0;
            targetPrice = NormalizeDouble(oop - delta, _Digits);
            if(osl > oop && lastLow <= targetPrice)
                return oop;
        default:
            return 0;
    }

    return 0;
}

double ProfitSystem::profitZone1() {
    return profitZone(target1, stop1);
}

double ProfitSystem::profitZone2() {
    return profitZone(target2, stop2);
}