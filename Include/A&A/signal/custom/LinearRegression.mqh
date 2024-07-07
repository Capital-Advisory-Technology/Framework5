#include <A&A/signal/Signal.mqh>

class LinearRegression : public Signal {    
    private:
        string linregPath;
        int linregHandle;

    public:
        LinearRegression(void){};
        
        ~LinearRegression(void) {
            IndicatorRelease(linregHandle);
        }

        void Init(int mPeriod, ENUM_APPLIED_PRICE mPrice) {
            linregPath = "Linear Regression";
            linregHandle = iCustom(NULL, 0, linregPath, mPeriod, mPrice);
        }
    
    virtual ENUM_SIGNAL_TYPE GetSignal();
    virtual ENUM_SIGNAL_TYPE GetBias();
};

extern LinearRegression *linearRegression;

/* Value change (crossover) logic.*/
ENUM_SIGNAL_TYPE LinearRegression::GetSignal() {
    double _linreg_signal[];
    
    ResetLastError();

    ArraySetAsSeries(_linreg_signal, true);

    // buffer num. set as 1 for color reference
    // buffer num. 0 returns calculated values
    CopyBuffer(linregHandle, 1, 0, 5, _linreg_signal);
    
    // 0.0 - grey, 1.0 - sell, 2.0 - buy
    if (_linreg_signal[0] == 2.0 && _linreg_signal[1] == 1.0) {
        return SIGNAL_LONG;
    } else if (_linreg_signal[0] == 1.0 && _linreg_signal[1] == 2.0) {
        return SIGNAL_SHORT;
    }

    return SIGNAL_IGNORE;
}

ENUM_SIGNAL_TYPE LinearRegression::GetBias() {
    
    return SIGNAL_IGNORE;
}