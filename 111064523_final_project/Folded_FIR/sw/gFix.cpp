#include <iostream>
#include <cmath>
#include "gFix.h"

using namespace std;

gFix::gFix(){

}

gFix::~gFix(){

}

gFix::gFix(int integer_wordlength, int wordlength, double floating_val){
    iwl = integer_wordlength;
    wl = wordlength;
    fixed_val = round(floating_val * (1 << (wordlength - integer_wordlength)));
}

gFix& operator + (gFix& x, gFix& y){

    gFix *z = new gFix;
    z->iwl = y.iwl;
    z->wl = y.wl;
    int z_fwl = z->wl - z->iwl;
    z->fixed_val = x.fixed_val + y.fixed_val;
    // cout << (z->fixed_val >> z_fwl)  << endl;
    // cout << (1 << (z->iwl-1))-1 << endl;
    if(z->fixed_val>0){
        if((z->fixed_val >> z_fwl) > (1 << (z->iwl-1))-1){
            cout << "+++njkhk" << endl;
            z->fixed_val = (x.fixed_val >> 1) + (y.fixed_val>> 1);
        }
    }
    else{
        if(abs((z->fixed_val >> z_fwl)) > (1 << (z->iwl-1))){
            cout << "+++njkhk" << endl;
            z->fixed_val = (x.fixed_val >> 1) + (y.fixed_val>> 1);
        }
    }
    return *z;
    
}

gFix& operator * (gFix& x, gFix& y){

    gFix *z = new gFix;
    int z_fwl = (x.wl + y.wl) - (x.iwl + y.iwl);
    z->iwl = y.iwl;
    z->wl = y.wl;
    z->fixed_val = (x.fixed_val * y.fixed_val) >> z_fwl/2;

    // cout << (z->fixed_val >> z_fwl/2) << endl;
    // cout << (1 << (z->iwl-1))-1 << endl;

    // cout << z->fixed_val << endl;

    if(z->fixed_val>0){
        if((z->fixed_val >> z_fwl/2) > (1 << (z->iwl-1))-1){
            cout << "***njkhk" << endl;
            // z->fixed_val = ((x.fixed_val >> z->iwl) * (y.fixed_val >> z->iwl)) << 1;
            z->fixed_val = z->fixed_val >> 1;
        }
    }
    else{
        if(abs(z->fixed_val >> z_fwl/2) > (1 << (z->iwl-1))){
            cout << "***njkhk" << endl;
            // z->fixed_val = ((x.fixed_val >> z->iwl) * (y.fixed_val >> z->iwl)) << 1;
            z->fixed_val = z->fixed_val >> 1;
        }
    }

    return *z;

}

gFix& gFix::operator = (gFix& x){

    iwl = x.iwl;
    wl = x.wl;
    fixed_val = x.fixed_val;
    return *this;

}
