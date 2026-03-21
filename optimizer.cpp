#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <unordered_map>
using namespace std;

// Function to check if string is number
bool isNumber(string s) {
    for (char c : s) {
        if (!isdigit(c)) return false;
    }
    return true;
}

int main() {
    cout << "Enter TAC (type END to stop):\n";

    vector<string> code;
    string line;

    // Input TAC
    while (true) {
        getline(cin, line);
        if (line == "END") break;
        code.push_back(line);
    }

    cout << "\n--- Original Code ---\n";
    for (auto &l : code) cout << l << endl;

    cout << "\n--- Optimized Code ---\n";

    unordered_map<string, int> values; // for constant propagation

    for (auto &l : code) {
        stringstream ss(l);
        string lhs, eq, op1, op, op2;

        ss >> lhs >> eq >> op1 >> op >> op2;

        // Case 1: Constant Folding
        if (isNumber(op1) && isNumber(op2)) {
            int a = stoi(op1);
            int b = stoi(op2);
            int result;

            if (op == "+") result = a + b;
            else if (op == "-") result = a - b;
            else if (op == "*") result = a * b;
            else if (op == "/") result = b != 0 ? a / b : 0;

            cout << lhs << " = " << result << endl;

            values[lhs] = result;
        }

        // Case 2: Constant Propagation
        else if (values.count(op1) && isNumber(op2)) {
            int a = values[op1];
            int b = stoi(op2);
            int result;

            if (op == "+") result = a + b;
            else if (op == "-") result = a - b;
            else if (op == "*") result = a * b;
            else if (op == "/") result = b != 0 ? a / b : 0;

            cout << lhs << " = " << result << endl;
            values[lhs] = result;
        }

        // Default case
        else {
            cout << l << endl;
        }
    }

    cout << "\nOptimization Completed!\n";

    return 0;
}