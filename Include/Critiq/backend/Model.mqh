class Model {
    protected:
        string path;

    public:
        Model(void){};
        ~Model(void){};

        void Init();
        ENUM_ORDER_TYPE GetSignal(){ return true;}
};