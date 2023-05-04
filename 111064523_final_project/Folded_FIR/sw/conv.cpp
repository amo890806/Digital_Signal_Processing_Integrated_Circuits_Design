#include <iostream>
#include <vector>

using namespace std;

vector<double> conv(vector<double> &s, vector<double> &h){
    int size = s.size() + h.size() - 1;
    // cout << size << endl;

    vector<double> padding_s(s.size()+2*(h.size()-1), 0);
    vector<double> zeros(h.size()-1, 0);
    copy(zeros.begin(), zeros.end(), padding_s.begin());
    copy(s.begin(), s.end(), padding_s.begin()+zeros.size());
    copy(zeros.begin(), zeros.end(), padding_s.begin()+zeros.size()+s.size());

    vector<double> r(size, 0);
    for(int i=0; i<s.size(); i++){
        for(int j=0; j<h.size(); j++){
            r[i+j] += s[i]*h[j];
        }
    }
    // for(int i=0; i<size; i++){
    //     for(int j=0; j<h.size()/2; j++){
    //         double preadd = padding_s[i+j] + padding_s[i+(h.size()-1-j)];
    //         r[i] += preadd*h[j];
    //         // if(i==0){
    //         //     cout << padding_s[i+j] << " " << padding_s[i+(h.size()-1-j)] << endl;
    //         // }
    //     }
    // }

    // cout << padding_s.size() << endl;
    
    return r;
}