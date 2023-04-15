#include <Critiq-Include/common/Logger.mqh>

class Risk {
    protected:
       bool riskShield;         // Risk models on/off
       bool riskDatetime;
       bool riksIndicator; 

       double riskPerTrade;         
       double riskPerDatetime;

    public:
        Risk(void);
        ~Risk(void);

        
        double CalculateRisk();
        double GetRisk();  
};