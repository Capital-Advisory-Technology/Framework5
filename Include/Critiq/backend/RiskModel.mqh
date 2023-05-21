struct OpenTradeParams {
    ENUM_ORDER_TYPE type;
    double volume;
    double slPrice;
    double tpPrice;
};

class RiskModel {
    protected:
        string path;

    public:
        RiskModel(void){};
        ~RiskModel(void){};

        void Init();
        virtual OpenTradeParams CalcTradeParams(ENUM_ORDER_TYPE orderType)=0;
};