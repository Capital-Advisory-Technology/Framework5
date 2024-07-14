#include <A&A/signal/Signal.mqh>

class LinearRegression : public Signal {    
    private:
        string linregPath;
        int linregHandle;

    public:
        LinearRegression(void){}; // can be used for doing the init function (less code?)
        
        ~LinearRegression(void) {
            IndicatorRelease(linregHandle);
        }

        void init(int mPeriod, ENUM_APPLIED_PRICE mPrice) {
            linregPath = "Linear Regression";
            linregHandle = iCustom(NULL, 0, linregPath, mPeriod, mPrice);
        }
    
        virtual SIGNAL_TYPE getSignal();
        virtual SIGNAL_TYPE getBias();
};

extern LinearRegression *linearRegression;

/* Value change (crossover) logic.*/
SIGNAL_TYPE LinearRegression::getSignal() {
    double _linreg_signal[];
    
    ResetLastError();

    ArraySetAsSeries(_linreg_signal, true);

    // buffer num. set as 1 for color reference
    // buffer num. 0 returns calculated values
    CopyBuffer(linregHandle, 1, 0, 5, _linreg_signal);
    
    // 0.0 - grey, 1.0 - sell, 2.0 - buy
    if (_linreg_signal[0] == 2.0 && _linreg_signal[1] == 1.0) {
        return SIGNAL_BUY;
    } else if (_linreg_signal[0] == 1.0 && _linreg_signal[1] == 2.0) {
        return SIGNAL_SELL;
    }

    return SIGNAL_IGNORE;
}

SIGNAL_TYPE LinearRegression::getBias() {
    
    return SIGNAL_IGNORE;
}