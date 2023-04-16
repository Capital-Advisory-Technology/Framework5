#include <Critiq-Include/Signals/ReturnSignal.mqh>
#include <Indicators/Indicators.mqh>

class TrendFlex {    
    protected:
        // CiCustom trendFlex;
        
        int inpFastPeriod; 
        int inpSlowPeriod;
   
    public:
        TrendFlex(void);
        ~TrendFlex(void);

        void setFastPeriod(int value) { inpFastPeriod = value;}
        void setSlowPeriod(int value) { inpSlowPeriod = value;}

        int getFastPeriod() { return inpFastPeriod; }
        int getSlowPeriod() { return inpSlowPeriod; }

        double checkForSignal(int inpFastPeriod, int inpSlowPeriod) {return true;};
        // virtual bool InitIndicators(CIndicators *indicators);

        // virtual int LongCondition(void);
        // virtual int ShortCondition(void);

    protected:
        // bool InitDema(CIndicators *indicators);

};
void TrendFlex::TrendFlex(void) : inpFastPeriod(50),
                                  inpSlowPeriod(25) {}
void TrendFlex::~TrendFlex(void) {
  
}

double checkForSignal(int inpFastPeriod, int inpSlowPeriod) { 
  double fastPeriodValue = iCustom(Symbol(), Period(), "TrendFlex2.mq5", inpFastPeriod, inpSlowPeriod, 0, 1);
  double fastPeriodValuePrev = iCustom(Symbol(), Period(), "TrendFlex2.mq5", inpFastPeriod, inpSlowPeriod, 0, 2);

  double slowPeriodValue = iCustom(Symbol(), Period(), "TrendFlex2.mq5", inpFastPeriod, inpSlowPeriod, 1, 1);
  double slowPeriodValuePrev = iCustom(Symbol(), Period(), "TrendFlex2.mq5", inpFastPeriod, inpSlowPeriod, 1, 2);

  Print("fastPeriodValue: " + fastPeriodValue);
  Print("fastPeriodValuePrev: " + fastPeriodValuePrev);
  Print("slowPeriodValue: " + slowPeriodValue);
  Print("slowPeriodValuePrev: " + slowPeriodValuePrev);

  return true;
}

// bool TrendFlex::InitIndicators(CIndicators *indicators) {
//     if(indicators == NULL) // Checks for pointer
//         return(false);

//     if(!InitTrendFlex(indicators)) // Create and initialize Custom indicator
//         return(false);
    
//     return(true);
// }

// bool TrendFlex::InitTrendFlex(CIndicators *indicators) {
//     if(indicators == NULL)                            // Checks for pointer
//         return(false);

//    if(!indicators.Add(GetPointer(trendFlex))) {           // Add object to collection
//       printf(__FUNCTION__+": error adding object");
//       return(false);
//      }
// //--- initialize object
//    if(!trendFlex.Initialize(Symbol(),Period(), 2, inpFastPeriod, inpSlowPeriod))
//      {
//       printf(__FUNCTION__+": error initializing object");
//       return(false);
//      }
// //--- ok
//    return(true);
//   }

