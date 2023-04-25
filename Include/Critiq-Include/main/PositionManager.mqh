#include <Trade/Trade.mqh>

#include <Critiq-Include/backend/Risk.mqh>
#include <Critiq-Include/backend/Calculations.mqh>

class PositionManager {

    protected:  
        CTrade* trade;
        float riskPerTrade;
        float SLRatio;
        float TPRatio;
        
        // calculations
        int ATRPeriod;
        int slippage;

        // settings
        float breakEven;
        bool fixedSLTP;

    public:

        PositionManager(void);
        ~PositionManager(void);

        void OrderOpen(ENUM_ORDER_TYPE orderType);
        void OrderClose();

        void setRisk(float risk) { riskPerTrade = risk; }
        void setRatioTP(float ratio) {} 
        void setRatioSL(float ratio) { SLRatio = ratio; }
};

extern PositionManager *positionManager;

PositionManager::PositionManager(void): 
    trade(new CTrade),
    riskPerTrade(0),
    SLRatio(0),
    TPRatio(0),
    ATRPeriod(14),
    slippage(0),
    breakEven(0),
    fixedSLTP(false)
    {}

void PositionManager::~PositionManager(void) {
    delete trade;
}

void PositionManager::OrderOpen(ENUM_ORDER_TYPE orderType) {
    int PointsSL = CalculateSL_ATR(SLRatio, ATRPeriod, fixedSLTP);
    int PointsTP = CalculateTP_Ratio(TPRatio, PointsSL, false);
    float volume = float(CalculateLotSize(riskPerTrade, PointsSL));
    double slPrice = GetSLprice(PointsSL, orderType);
    double tpPrice = GetTPprice(PointsTP, orderType); 

    string symbol = Symbol();
    
    switch (orderType) {
    case (ORDER_TYPE_BUY):
        trade.PositionOpen(symbol, orderType, volume,
                            SymbolInfoDouble(symbol, SYMBOL_ASK),
                             slPrice, tpPrice, "Hello, Casino!");
        break;
    case (ORDER_TYPE_SELL):
        trade.PositionOpen(symbol, orderType, volume,
                            SymbolInfoDouble(symbol, SYMBOL_BID),
                            slPrice, tpPrice, "Hello, gay bear!");
        break;
    default:
        break;
    }
} 

void PositionManager::OrderClose() {    
    ulong oticket = PositionGetTicket(0);  
    trade.PositionClose(oticket, ULONG_MAX);     
}

// OrdersTotal()