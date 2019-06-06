int main() {
    int a = 1;
    int b = 1;
    int c = 0;
    int d = 10;
    
    while (c < 1000) {
        c = a + b;
        a = b;
        b = c;
        
        d = d - 1;
        if (d < 0) {
            d = 1000 / 2;
        }
    }
}
