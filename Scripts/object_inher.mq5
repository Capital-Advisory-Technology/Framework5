void OnStart() {
    Child *child = new Child;

    child.init();
}

class Parent {
    public:
        Parent(void){};
        ~Parent(void){};

        void init(){
            Print("Parent init");
        }};
class Child : public Parent {
    public:
        Child(void){};
        ~Child(void){};

        void init(){
            Print("Child init");
}};