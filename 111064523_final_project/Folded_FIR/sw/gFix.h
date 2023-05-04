#ifndef GFIX_H
#define GFIX_H

class gFix{

    public:
        gFix();
        gFix(int integer_wordlength, int word_length, double floating_val);

        ~gFix();
        friend gFix& operator + (gFix& x, gFix& y);
        friend gFix& operator * (gFix& x, gFix& y);

        // assignment operators
        gFix& operator = (gFix& x);

        // class member
        int iwl;
        int wl;
        long long int fixed_val;


};

#endif