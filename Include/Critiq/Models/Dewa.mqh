#include <Critiq/backend/Model.mqh>
#include <Critiq/common/Enums.mqh>

string demaPath = "Critiq-Indicators\\GeneralizedDoubleDEMA";
string waddahPath = "Critiq-Indicators\\modified_explosion";

class Dewa : public Model {
    protected:
        int demaHandle;
        int waddahHandle;

    public:
        Dewa(void){};
        ~Dewa(void){
            IndicatorRelease(demaHandle);
            IndicatorRelease(waddahHandle);
        };

        void Init(int period, double volume, ENUM_APPLIED_PRICE price,
                ENUM_PRICE_DERIVATIVE inpPrice, int inpSensitivity, int inpFastLength,
                int inpSlowLength, int inpBbLength, double inpBDev, ENUM_YES_NO inpSmooth)
                {    
                    demaHandle = iCustom(NULL, 0, demaPath, period, volume, price);
                    
                    waddahHandle = iCustom(NULL, 0, waddahPath, inpPrice, inpSensitivity,
                                            inpFastLength, inpSlowLength, inpBbLength, inpBDev, inpSmooth);
                };
        
        virtual ENUM_ORDER_TYPE GetSignal();
};

extern Dewa *dewa;

// Confirms signal with Waddah Explosion colour
ENUM_ORDER_TYPE Dewa::GetSignal() {
    double _dema_signal[];
    double _waddah_colour[];

    ResetLastError();
    ArraySetAsSeries(_dema_signal, true);
    ArraySetAsSeries(_waddah_colour, true);

    CopyBuffer(demaHandle,1,0,5,_dema_signal);
    CopyBuffer(waddahHandle, 1, 0, 5, _waddah_colour);

    if(_dema_signal[0] == 1.0 && _dema_signal[1] == 2.0) {
        if (_waddah_colour[0] == 0.0 || _waddah_colour[1] == 1.0)
            return ORDER_TYPE_BUY;
    } else if(_dema_signal[0] == 2.0 && _dema_signal[1] == 1.0) {
        if (_waddah_colour[0] == 2.0 || _waddah_colour[1] == 3.0)
        return ORDER_TYPE_SELL;
    } 
    
    return ORDER_TYPE_CLOSE_BY;    
}
