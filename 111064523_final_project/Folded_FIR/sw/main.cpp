#define ORDER 24
#define SAMPLE 40000

#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>
#include "conv.cpp"
#include "fixed_conv.cpp"

using namespace std;

const int iwl = 2;
const int wl = 32;

int main(){

    ofstream outFile("snr.txt", ios::out);

    ifstream inFile_coeff("coeff.txt", ios::in);
    if(!inFile_coeff){
        cerr << "Faided opening" << endl;
        exit(1);
    }
    vector <double> coeff;
    double temp = 0;
    for(int i=0; i<ORDER; i++){
        inFile_coeff >> temp;
        coeff.push_back(temp);
    }
    // for(int i=0; i<ORDER; i++){
    //     cout << setprecision(16) << coeff.at(i) << endl;
    // }

    ifstream inFile_data_in("input_24bits.txt", ios::in);
    ifstream inFile_fixed_data_in("input_8bits.txt", ios::in);
    if(!inFile_data_in){
        cerr << "Faided opening" << endl;
        exit(1);
    }
    if(!inFile_fixed_data_in){
        cerr << "Faided opening" << endl;
        exit(1);
    }
    vector <double> data_in;
    vector <double> fixed_data_in;
    for(int i=0; i<SAMPLE; i++){
        inFile_data_in >> temp;
        data_in.push_back(temp);
        inFile_fixed_data_in >> temp;
        fixed_data_in.push_back(temp);
    }
    // for(int i=0; i<SAMPLE; i++){
    //     cout << setprecision(8) << data_in[i] << endl;
    // }

    vector<double> data_out = conv(data_in, coeff);
    // for(int i=0; i<20; i++){
    //     cout << setprecision(8) << data_out[i] << endl;
    // }


    for(int k=iwl; k<=wl; k++){

        vector<double> fixed_data_out = fixed_conv(fixed_data_in, coeff, iwl, k);
        // for(int i=0; i<20; i++){
        //     cout << setprecision(8) << fixed_data_out[i] << endl;
        // }

        double snr = 0;
        double floating_power = 0;
        double diff_power = 0;
        for(int i=0; i<data_out.size(); i++){
            floating_power += pow(data_out[i], 2);
            diff_power += pow((fixed_data_out[i]-data_out[i]), 2);
        }
        // floating_power = sqrt(floating_power);
        // diff_power = sqrt(diff_power);

        snr = 10*log10(floating_power/diff_power);

        // if(k == 33){
        //     cout << floating_power << endl;
        //     cout << diff_power << endl;
        // }

        cout << k << ":" << snr << endl;
        outFile << k << " " << snr << endl;
    }

}