#include <Trade/Trade.mqh>

#include <Critiq-Include/backend/Risk.mqh>
#include <Critiq-Include/backend/Calculations.mqh>

class PositionManager {

    protected:  
        CTrade* trade;
        double riskPerTrade;
        double posRatio;
        
        // calculations
        int ATRPeriod;
        int slippage;

        // settings
        double breakEven;

    public:

        PositionManager(void);
        ~PositionManager(void);

        void OrderOpen(ENUM_ORDER_TYPE orderType);
        void OrderClose();
        bool isOrderOpen() { return PositionsTotal() != 0;};

        void setRisk(double risk) { riskPerTrade = risk; }
        void setPosRatio(double ratio) { posRatio = ratio; } 

};

extern PositionManager *positionManager;

PositionManager::PositionManager(void): 
    trade(new CTrade),
    riskPerTrade(0),
    posRatio(0),
    ATRPeriod(14),
    slippage(0),
    breakEven(0)
    {}

void PositionManager::~PositionManager(void) {
    delete trade;
}

void PositionManager::OrderOpen(ENUM_ORDER_TYPE orderType) {
    Print("Opening order!!!");
    Print("posRatio: ", posRatio);
    int points = CalculatePoints_ATR(posRatio, ATRPeriod);
    // int pointsTP = CalculateTP_Ratio(posRatio, pointsSL);
    double volume = CalculateLotSize(riskPerTrade, points);
    double slPrice = GetSLprice(points, orderType);
    double tpPrice = GetTPprice(points, orderType, posRatio); 
    Print("sl:", slPrice, " tp:", tpPrice, " vol:", volume, " type:", orderType);
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
