struct OpenTradeParams {
    ENUM_ORDER_TYPE type;
    double volume;
    double openPrice;
    double slPrice;
    double tpPrice;
};

class RiskModel {

    public:
        RiskModel(void){};
        ~RiskModel(void){};

        virtual double GetValue()=0;

};