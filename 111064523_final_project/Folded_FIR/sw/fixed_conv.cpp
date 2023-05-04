#include <iostream>
#include <vector>
#include "gFix.cpp"

using namespace std;

vector<double> fixed_conv(vector<double> &s, vector<double> &h, int iwl, int wl){

    int size = s.size() + h.size() - 1;
    vector<double> r(size, 0);
    gFix *fixed_r = new gFix[size];
    for(int i=0; i<s.size(); i++){
        for(int j=0; j<h.size(); j++){
            gFix fixed_s(iwl, wl, s[i]);
            gFix fixed_h(iwl, wl, h[j]);
            gFix temp = fixed_s * fixed_h;
            fixed_r[i+j] = fixed_r[i+j] + temp;
        }
    }

    for(int i=0; i<size; i++){
        r[i] = fixed_r[i].fixed_val*pow(2, -(wl-iwl));
    }
    
    return r;
}

