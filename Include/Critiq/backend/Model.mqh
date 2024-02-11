class Model {
    protected:
        string path;

    public:
        Model(void){};
        ~Model(void){};

        void Init();
        virtual ENUM_ORDER_TYPE getSignal() { return 0; }
};