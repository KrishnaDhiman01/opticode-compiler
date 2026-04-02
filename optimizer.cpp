#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <unordered_map>
using namespace std;

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

    while (true) {
        getline(cin, line);
        if (line == "END") break;
        code.push_back(line);
    }

    cout << "\n--- Original Code ---\n";
    for (auto &l : code) cout << l << endl;

    cout << "\n--- Optimized Code ---\n";

    unordered_map<string, int> values;          // constant propagation

    // First pass: constant folding + propagation storage
    vector<string> tempOutput;

    for (auto &l : code) {
        stringstream ss(l);
        string lhs, eq, op1, op, op2;

        ss >> lhs >> eq >> op1 >> op >> op2;

        if (lhs == "" || eq != "=") continue;

        // Replace with known values (propagation)
        if (values.count(op1)) op1 = to_string(values[op1]);
        if (values.count(op2)) op2 = to_string(values[op2]);

        // Constant folding
        if (isNumber(op1) && isNumber(op2)) {
            int a = stoi(op1);
            int b = stoi(op2);
            int result = 0;

            if (op == "+") result = a + b;
            else if (op == "-") result = a - b;
            else if (op == "*") result = a * b;
            else if (op == "/") result = (b != 0) ? a / b : 0;

            values[lhs] = result;
            tempOutput.push_back(lhs + " = " + to_string(result));
        } else {
            tempOutput.push_back(lhs + " = " + op1 + " " + op + " " + op2);
        }
    }

    // Second pass: apply propagation again for full optimization
    for (auto &line : tempOutput) {
        stringstream ss(line);
        string lhs, eq, op1, op, op2;

        ss >> lhs >> eq >> op1 >> op >> op2;

        if (values.count(op1)) op1 = to_string(values[op1]);
        if (values.count(op2)) op2 = to_string(values[op2]);

        if (op == "") {
            cout << line << endl;
        } else if (isNumber(op1) && isNumber(op2)) {
            int a = stoi(op1);
            int b = stoi(op2);
            int result = 0;

            if (op == "+") result = a + b;
            else if (op == "-") result = a - b;
            else if (op == "*") result = a * b;
            else if (op == "/") result = (b != 0) ? a / b : 0;

            cout << lhs << " = " << result << endl;
        } else {
            cout << lhs << " = " << op1 << " " << op << " " << op2 << endl;
        }
    }

    cout << "\nOptimization Completed!\n";
    return 0;
}