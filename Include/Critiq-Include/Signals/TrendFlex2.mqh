#include <Critiq-Include/Signals/ReturnSignal.mqh>
#include <Indicators/Indicators.mqh>

class TrendFlex : public CiCustom {    
    protected:
        CiCustom trendFlex;
        
        int inpFastPeriod; 
        int inpSlowPeriod;
   
    public:
        TrendFlex(void);
        ~TrendFlex(void);

        void setFastPeriod(int value) { inpFastPeriod = value;}
        void setSlowPeriod(int value) { inpSlowPeriod = value;}

        int getFastPeriod() { return inpFastPeriod; }
        int getSlowPeriod() { return inpSlowPeriod; }

        virtual bool InitIndicators(CIndicators *indicators);

        virtual int LongCondition(void);
        virtual int ShortCondition(void);

    protected:
        bool InitDema(CIndicators *indicators);

};

void TrendFlex::TrendFlex(void) : inpFastPeriod(50),
                                  inpSlowPeriod(25) {}

void TrendFlex::~TrendFlex(void) {}

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

