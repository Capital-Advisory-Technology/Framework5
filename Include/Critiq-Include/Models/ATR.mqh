
class ATR {
    protected:
        int atr_handle;

        int inpPeriod;

        double _atr_signal[];

    public:
        ATR(void);
        ~ATR(void);

        void init(int period);
        double GetLast();

};

extern ATR *slATR = new ATR;

void ATR::ATR(void) : inpPeriod(14) {}
void ATR::~ATR(void) {}

void ATR::init(int period) {
    SetIndexBuffer(0, _atr_signal, INDICATOR_DATA);
    ResetLastError();
    ArraySetAsSeries(_atr_signal, true);

    atr_handle = iATR(NULL, 0, period);
    if(atr_handle==INVALID_HANDLE)
     {
      Print("Error creating \"ATR\" indicator");
     }
}

double ATR::GetLast() {
    if(CopyBuffer(atr_handle,0,0,2,_atr_signal)==2) {
        return _atr_signal[1];
    }
    else {
        Print("Error copying buffer");
        return 0;
    }
}