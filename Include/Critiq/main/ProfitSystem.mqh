#include <Critiq/main/PositionManager.mqh>

class ProfitSystem {
    protected:
        double target1;
        double target2;
        double stop1;
        double stop2;
        double breakeven;

        bool t1Flag;
        bool s1Flag;
        bool breakevenFlag;
    public:
        ProfitSystem(double cT1, double cT2, double cS1, double cS2, double cBE);
        ~ProfitSystem();

        bool TakePartials();
        bool MoveStops();
        bool BreakEven();

        void ClearFlags();

};

ProfitSystem::ProfitSystem(double cT1, double cT2, double cS1, double cS2, double cBE) {
    target1 = cT1;
    target2 = cT2;
    stop1 = cS1;
    stop2 = cS2;
    breakeven = cBE;

    t1Flag = false;
    s1Flag = false;
    breakevenFlag = false;
}

ProfitSystem::~ProfitSystem() {
}

bool ProfitSystem::TakePartials() {
    if (!t1Flag) {
    
        if (PositionSelect(_Symbol)) { 
            double oop = PositionGetDouble(POSITION_PRICE_OPEN);
            double otp = PositionGetDouble(POSITION_TP);
            double volume = PositionGetDouble(POSITION_VOLUME);
            ulong type = PositionGetInteger(POSITION_TYPE);
            double delta = MathAbs(otp - oop);
            double closeVolume;
            if (type == ORDER_TYPE_BUY) { 
                double target1_price = NormalizeDouble((target1 * delta) + oop, _Digits);
                if (iHigh(_Symbol, PERIOD_CURRENT, 1) >= target1_price) {
                    closeVolume = NormalizeDouble(volume/2, 2);
                    positionManager.OrderPartialClose(closeVolume);
                    t1Flag = true;
                }
            } else if (type == ORDER_TYPE_SELL) {
                double target1_price = NormalizeDouble(oop - (target1 * delta), _Digits);
                if (iLow(_Symbol, PERIOD_CURRENT, 1) <= target1_price) {
                    closeVolume = NormalizeDouble(volume/2, 2);
                    positionManager.OrderPartialClose(closeVolume);
                    t1Flag = true;
                }
            }
        }
    }
    return t1Flag;
}

bool ProfitSystem::MoveStops() {
    if (!s1Flag) {
        if (PositionSelect(_Symbol)) { 
            double oop = PositionGetDouble(POSITION_PRICE_OPEN);
            double otp = PositionGetDouble(POSITION_TP);
            double osl = PositionGetDouble(POSITION_SL);
            ulong type = PositionGetInteger(POSITION_TYPE);
            double delta = MathAbs(otp - oop);
            double newStop;

            if (type == ORDER_TYPE_BUY) { 
                double trigger_price = NormalizeDouble((target1 * delta) + oop, _Digits);
                if (iHigh(_Symbol, PERIOD_CURRENT,1) >= trigger_price) {
                    newStop = NormalizeDouble(oop + (stop1 * delta), _Digits);
                    positionManager.OrderModify(newStop, otp);
                    s1Flag = true;
                }
            } else if (type == ORDER_TYPE_SELL) {
                double trigger_price = NormalizeDouble(oop - (target1 * delta), _Digits);
                if (iLow(_Symbol, PERIOD_CURRENT,1) <= trigger_price) {
                    newStop = NormalizeDouble(oop - (stop1 * delta), _Digits);
                    positionManager.OrderModify(newStop, otp);
                    s1Flag = true;
                }
            }
        }
    } 
    return s1Flag;
}

bool ProfitSystem::BreakEven() {
    if (!breakevenFlag) {
        if (PositionSelect(_Symbol)) { 
            double oop = PositionGetDouble(POSITION_PRICE_OPEN);
            double otp = PositionGetDouble(POSITION_TP);
            double osl = PositionGetDouble(POSITION_SL);
            ulong type = PositionGetInteger(POSITION_TYPE);
            double delta = MathAbs(otp - oop);

            if (type == ORDER_TYPE_BUY) { 
                double trigger_price = NormalizeDouble(oop + (breakeven * delta), _Digits);
                if (iHigh(_Symbol, PERIOD_CURRENT,1) >= trigger_price) {
                    positionManager.OrderModify(oop, otp);
                    breakevenFlag = true;
                }
            } else if (type == ORDER_TYPE_SELL) {
                double trigger_price = NormalizeDouble(oop - (breakeven * delta), _Digits);
                if (iLow(_Symbol, PERIOD_CURRENT,1) <= trigger_price) {
                    positionManager.OrderModify(oop, otp);
                    breakevenFlag = true;
                }
            }
        }
    } 
    return breakevenFlag;
}

void ProfitSystem::ClearFlags() {
    t1Flag = false;
    s1Flag = false;
    breakevenFlag = false;
}
