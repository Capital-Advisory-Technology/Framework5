#include <A&A/risk/Risk.mqh>
#include <A&A/common/Calculations.mqh>

class Atr : public Risk {
    protected:
        int atr_handle;

        int inpPeriod;
        double inpMultiplier;

    public:
        
        Atr(void) : inpPeriod(14),
                     inpMultiplier(0.7) {}
        
        ~Atr(void) {
            IndicatorRelease(atr_handle);
        }

        void init(int period, double multiplier);
        
        virtual double getPipCount();
};

extern Atr *atr;

void Atr::init(int cPeriod, double cMultiplier) {
    inpPeriod = cPeriod;
    inpMultiplier = cMultiplier;

    atr_handle = iATR(NULL, 0, inpPeriod);
}

double Atr::getPipCount() {
    double _atr_value[];
    ResetLastError();
    ArraySetAsSeries(_atr_value, true);
    CopyBuffer(atr_handle,0,1,1,_atr_value);
    return NormalizeDouble(_atr_value[0] * inpMultiplier, _Digits);
}
