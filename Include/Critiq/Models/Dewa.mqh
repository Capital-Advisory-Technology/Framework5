#include <Critiq/backend/Model.mqh>
#include <Critiq/common/Enums.mqh>

class Dewa : public Model {
    protected:
        int dema_handle;
        int waddah_handle;

        int inpPeriod;
        double inpVolume;
        ENUM_APPLIED_PRICE inpPrice;
        
        ENUM_PRICE_DERIVATIVE inp_price;
        int inp_sensitivity;         
        int inp_fastlength;
        int inp_slowlength;
        int inp_bblength;  
        double inp_bbstdev;
        ENUM_YES_NO inp_smoothyesno;

    public:
        Dewa(void);
        ~Dewa(void);

        void Init(int period, double volume, ENUM_APPLIED_PRICE price,
                ENUM_PRICE_DERIVATIVE inp_price, int inp_sensitivity, int inp_fastlength,
                int inp_slowlength, int inp_bblength, double inp_bbstdev, ENUM_YES_NO inp_smoothyesno);
        
        virtual ENUM_ORDER_TYPE GetSignal();
        
};

extern Dewa *dewa = new Dewa;

void Dewa::Dewa(void) : inpPeriod(14), inpVolume(0.7), inpPrice(PRICE_CLOSE),
                        inp_price(Close), inp_sensitivity(150), inp_fastlength(20), inp_slowlength(40),
                        inp_bblength(20), inp_bbstdev(2), inp_smoothyesno(Yes)
                        {}

void Dewa::~Dewa(void) {
    IndicatorRelease(dema_handle);
    IndicatorRelease(waddah_handle);
}

void Dewa::Init(int period, double volume, ENUM_APPLIED_PRICE price,
                ENUM_PRICE_DERIVATIVE inp_price, int inp_sensitivity, int inp_fastlength,
                int inp_slowlength, int inp_bblength, double inp_bbstdev, ENUM_YES_NO inp_smoothyesno) {

    path = "Critiq-Indicators\\GeneralizedDoubleDEMA";
    dema_handle = iCustom(NULL, 0, path, period, volume, price);

    waddah_handle = iCustom(NULL, 0, "Critiq-Indicators\\modified_explosion", inp_price, inp_sensitivity,
                            inp_fastlength, inp_slowlength, inp_bblength, inp_bbstdev, inp_smoothyesno);

}

// Confirms signal with Waddah Explosion colour
ENUM_ORDER_TYPE Dewa::GetSignal() {
    double _dema_signal[];
    double _waddah_colour[];

    // need colour & baseline & deadzone signal 

    ResetLastError();
    ArraySetAsSeries(_dema_signal, true);
    ArraySetAsSeries(_waddah_colour, true);

    CopyBuffer(dema_handle,1,0,5,_dema_signal);
    CopyBuffer(waddah_handle, 1, 0, 5, _waddah_colour);

    Print("Current: ", _waddah_colour[1], " Previous: ", _waddah_colour[2]);

    if(_dema_signal[0] == 1.0 && _dema_signal[1] == 2.0) {
        if (_waddah_colour[0] == 0.0 || _waddah_colour[1] == 1.0)
            return ORDER_TYPE_BUY;
    } else if(_dema_signal[0] == 2.0 && _dema_signal[1] == 1.0) {
        if (_waddah_colour[0] == 2.0 || _waddah_colour[1] == 3.0)
        return ORDER_TYPE_SELL;
    } 
    
    return ORDER_TYPE_CLOSE_BY;    
}
