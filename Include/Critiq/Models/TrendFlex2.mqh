#include <Critiq/Signals/ReturnSignal.mqh>

class TrendFlex {    
    protected:
        int tf_handle;
    
        int inpFastPeriod; 
        int inpSlowPeriod;
   
        double _tf_fast[];
        double _tf_slow[];
   
    public:
        TrendFlex(void);
        ~TrendFlex(void);
        
        void init(int fast_period, int slow_period);
        int CheckCondition();
};

extern TrendFlex *trendFlex;

void TrendFlex::TrendFlex(void) : inpFastPeriod(50),
                                  inpSlowPeriod(25) {}

void TrendFlex::~TrendFlex(void) {}

void TrendFlex::init(int fast_period, int slow_period) {
  SetIndexBuffer(0, _tf_fast, INDICATOR_DATA);
  SetIndexBuffer(1, _tf_slow, INDICATOR_DATA);   
  ResetLastError();
  ArraySetAsSeries(_tf_fast, true);
  ArraySetAsSeries(_tf_slow, true);

  tf_handle = iCustom(NULL, PERIOD_CURRENT, 
  "Critiq-Indicators\\TrendFlex2", fast_period, slow_period); 
} 

int TrendFlex::CheckCondition() {
  //  ArraySetAsSeries(_tf_fast, true);
  //  ArraySetAsSeries(_tf_slow, true);
   
   CopyBuffer(tf_handle,0,0,20,_tf_fast);
   CopyBuffer(tf_handle,1,0,20,_tf_slow);
   
   if(LongCrossOver(_tf_fast[0], _tf_slow[0], _tf_fast[1], _tf_slow[1]))
     return 1; 
   
   if(ShortCrossOver(_tf_fast[0], _tf_slow[0], _tf_fast[1], _tf_slow[1]))
     return 2;
     
   return 0; 
}
