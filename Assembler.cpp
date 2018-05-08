#include<bits/stdc++.h>
using namespace std;

string codeFilePath = "code.txt";
string dataFilePath = "data.txt";
string instrFilePath = "instr.txt";
string memInstrFilePath = "instr.mem";
string memDataFilePath = "data.mem";

string int2binary(int num, int nBits)
{
	string ans;
	if (num == 0) {
		ans += "0";
		nBits--;
	}
	else {
		int x = 0;
		while (num > 0)
		{
			x = num % 2;
			num /= 2;
			ans += ('0' + x);
			nBits--;
		}
	}
	reverse(ans.begin(), ans.end());
	while (nBits--)
	{
		ans = "0" + ans;
	}
	return ans;
}

// function to convert decimal to hexadecimal
void decToHexa(int n, ofstream &file)
{
	// char array to store hexadecimal number
	char hexaDeciNum[100];

	// counter for hexadecimal number array
	int i = 0;
	while (n != 0)
	{
		// temporary variable to store remainder
		int temp = 0;

		// storing remainder in temp variable.
		temp = n % 16;

		// check if temp < 10
		if (temp < 10)
		{
			hexaDeciNum[i] = temp + 48;
			i++;
		}
		else
		{
			hexaDeciNum[i] = temp + 55;
			i++;
		}

		n = n / 16;
	}

	// printing hexadecimal number array in reverse order
	bool f = false;
	for (int j = i - 1; j >= 0; j--) {
		if (hexaDeciNum[j] >= 'A'&& hexaDeciNum[j] <= 'F') {
			char ch = tolower(hexaDeciNum[j]);
			file << ch;
		}
		else
			file << hexaDeciNum[j];
		f = true;
	}
	if (!f)file << '0';
}

class MyAssembler {

	ifstream codeFile; // the file which contains the source code
	string codeFilePath;

	ofstream dataFile;
	string dataFilePath;

	ofstream instrFile;
	string instrFilePath;

	map<string, string>instrTable; // codes of instructions
	map<int, string>registerTable; // codes of registers
	vector<string>DataMem;
	vector<string>instrMem;

	bool syntaxError; // boolean to check if there is a syntax error or not
	int readDataSegment;
	int numLine;      // the current line which is been decoding
	int codePointer;  /* pointer to the address that will be filled by the next
					  instruction in the RAM
					  */
	int dataPointer;
	int finishedDataSegment;
	string deleteComments(string line)
	{
		int idx = line.find(';');
		if(idx != -1)
		{
			line = line.substr(0 , idx);
		}
		return line;
	}
	void generateTables() {

		instrTable["nop"] = "0000000000000000";
		instrTable["out"] = "0000000000###111";
		instrTable["clrc"] = "0000001110000010";
		instrTable["setc"] = "0000001110000011";
		instrTable["jmp"] = "0000001100000###";
		instrTable["jn"] = "0000001100001###";
		instrTable["jc"] = "0000001100010###";
		instrTable["jz"] = "0000001100100###";
		instrTable["in"] = "0100000000111###";
		instrTable["mov"] = "0100000000######";
		instrTable["add"] = "0100000010######";
		instrTable["mul"] = "0100001111######";
		instrTable["sub"] = "0100000011######";
		instrTable["and"] = "0100000101######";
		instrTable["or"] = "0100000110######";
		instrTable["rlc"] = "0100001010######";
		instrTable["rrc"] = "0100001011######";
		instrTable["not"] = "0100000111######";
		instrTable["inc"] = "0100000001######";
		instrTable["dec"] = "0100000100######";
		instrTable["shl"] = "01####1000######";
		instrTable["shr"] = "01####1001######";
		instrTable["ret"] = "0110000001110000";
		instrTable["rti"] = "0110000001110001";
		instrTable["push"] = "0110100100110###";
		instrTable["call"] = "0110111101110###";
		instrTable["pop"] = "0111000001110###";
		instrTable["std"] = "10#0############";
		instrTable["ldd"] = "10#1############";
		instrTable["ldm"] = "1100000000000###";

	}
	void lineParsing(string sLine){
		if (sLine == "") {
		return;
	        }else{
		   string tmp = "";
		   for(int i = 0; i < sLine.size(); ++i){
			if(sLine[i]==' ')continue;
			if(sLine[i]== ';' && tmp==""){
			   return;
			}else{
			  tmp+=sLine[i];
			}
		   }
		   if(tmp[0] < '0' || tmp[0] > '9'){
		     this->finishedDataSegment = 1;
		   }
		}
	if (this->finishedDataSegment == 0) {
		string tmp = "";
		for (int i = 0; i < sLine.size(); i++)
		{
			if (sLine[i] == ' ' && !tmp.empty())break;
			if (sLine[i] >= '0' && sLine[i] <= '9') {
				tmp += sLine[i];
			}
		}

		if(this->readDataSegment == 0){
		   this->instrMem[0] = 	int2binary(stoi(tmp), 16);
		   codePointer = stoi(tmp);
		   this->readDataSegment++;
		}else if(this->readDataSegment == 1) {
		   this->instrMem[1] = 	int2binary(stoi(tmp), 16);
		   this->readDataSegment++;
		}else{
			if (!tmp.empty()) {
				this->DataMem[dataPointer++] = int2binary(stoi(tmp), 16);
			}
		}
	} else {
		// parsing to know the instruction
		int idx = 0;
		string inst = "";
		for (int i = idx; i < sLine.size(); i++,idx++)
		{
			if (sLine[i] == ' ' && inst.empty())continue;
			if (sLine[i] != ' ') {
				inst += sLine[i];
			}
			else {
				break;
			}
		}

		if (inst[0] == '.') {
			if (int2binary(stoi(inst.substr(1, inst.size()-1)),16) != this->instrMem[1]) {
				cout << inst << " is not equal to instrMem[1]" << endl;
				cout << "\"" << instrMem[1] << "\"" << endl;
			}
			else {
				codePointer = stoi(inst.substr(1, inst.size() - 1));
			}
			return;
		}

		// toLower string (inst)
		for (int i = 0; i < inst.size(); i++) {
			inst[i] = tolower(inst[i]);
		}

		if (this->instrTable.count(inst) == 0) {
			this->syntaxError = true;
			return;
		}

		this->instrMem[codePointer] = this->instrTable[inst];

		if (inst == "shl" || inst == "shr") {
			// three operands

			string op1 = "", op2 = "", op3 = "";
			for (int i = idx; i < sLine.size(); i++,idx++)
			{
				if (sLine[i] == ',') {
					idx++;
					break;
				}
				if (sLine[i] == ' ' && op1.empty())continue;
				if (sLine[i] != ' ')op1 += sLine[i];
			}

			for (int i = idx; i < sLine.size(); i++,idx++)
			{
				if (sLine[i] == ',') {
					idx++;
					break;
				}
				if (sLine[i] == ' ' && op2.empty())continue;
				if (sLine[i] != ' ' && sLine[i] <= '9' && sLine[i] >= '0')op2 += sLine[i];
			}
			for (int i = idx; i < sLine.size(); i++, idx++)
			{
				if (sLine[i] == ' ' && op3.empty())continue;
				if (sLine[i] == ' ' && !op3.empty())break;
				if (sLine[i] != ' ')op3 += sLine[i];
			}
			if (op1.empty() || op2.empty() || op3.empty()
				|| !(op1.size() == 2 && tolower(op1[0]) == 'r' && op1[1] >= '0' && op1[1] <= '5'
				&& op3.size() == 2 && tolower(op3[0]) == 'r' && op3[1] >= '0' && op3[1] <= '5')) {
				this->syntaxError = true;
				return;
			}
			this->instrMem[codePointer] = this->instrTable[inst];

			this->instrMem[codePointer] =
				this->instrMem[codePointer].substr(0,2) +
				int2binary(stoi(op2), 16).substr(12,4) +
				this->instrMem[codePointer].substr(6,4) +
				int2binary(op1[1] - '0', 3) +
				int2binary(op3[1] - '0', 3);
			codePointer++;


		}
		else if (inst == "nop" || inst == "setc"
			|| inst == "clrc" || inst == "ret"
			|| inst == "rti") {
			// no operand
			this->instrMem[codePointer++] = this->instrTable[inst];

		}
		else if (inst == "mov" || inst == "add"
			|| inst == "mul" || inst == "sub"
			|| inst == "and" || inst == "or"
			|| inst == "ldm" || inst == "ldd" || inst == "std") {
			// two operands

			string op1 = "", op2 = "";
			for (int i = idx; i < sLine.size(); i++, idx++)
			{
				if (sLine[i] == ',') {
					idx++;
					break;
				}
				if (sLine[i] == ' ' && op1.empty())continue;
				if (sLine[i] != ' ')op1 += sLine[i];
			}

			for (int i = idx; i < sLine.size(); i++, idx++)
			{
				if (sLine[i] == ' ' && op2.empty())continue;
				if (sLine[i] == ' ' && !op2.empty())break;
				if (sLine[i] != ' ')op2 += sLine[i];
			}

			if (inst != "ldm" && inst != "ldd" && inst != "std") {

				if (op1.empty() || op2.empty()
					|| !(op1.size() == 2 && tolower(op1[0]) == 'r' && op1[1] >= '0' && op1[1] <= '5'
						&& op2.size() == 2 && tolower(op2[0]) == 'r' && op2[1] >= '0' && op2[1] <= '5')) {
					this->syntaxError = true;
					return;
				}
				this->instrMem[codePointer] = this->instrMem[codePointer].substr(0, 10) +
					int2binary(op1[1] - '0', 3) + int2binary(op2[1] - '0', 3);
					codePointer++;


			}
			else if(inst == "ldm") {
				cout << "LDM : " << op1 << " ,  " << op2 << endl;
				this->instrMem[codePointer] = this->instrMem[codePointer].substr(0,13)+
					int2binary(op1[1] - '0', 3);
				this->instrMem[++codePointer] = int2binary(stoi(op2),16);
				codePointer++;

			}
			else {
				//if (inst == "ldd" || inst == "std")
				string EA = int2binary(stoi(op2),10);
				this->instrMem[codePointer][2] = EA[0];

				this->instrMem[codePointer] = this->instrMem[codePointer].substr(0,4) +
					EA.substr(1, 9) + int2binary(op1[1] - '0', 3);
				codePointer++;
			}

		}
		else {
			 // one operand
			string op1;
			for (int i = idx; i < sLine.size(); i++, idx++)
			{
				if (sLine[i] == ' ' && op1.empty())continue;
				if (sLine[i] == ' ' && !op1.empty())break;
				if (sLine[i] != ' ')op1 += sLine[i];
			}

			if (op1.empty() || !(op1.size() == 2 && tolower(op1[0]) == 'r' && op1[1] >= '0' && op1[1] <= '5')) {
				this->syntaxError = true;
				return;
			}
			if (inst == "out") {
				this->instrMem[codePointer] = this->instrMem[codePointer].substr(0, 10) +
					int2binary(op1[1] - '0', 3) + this->instrMem[codePointer].substr(13,3);
			}
			else if (inst == "rlc" || inst == "rrc" || inst == "not" || inst == "inc" || inst == "dec") {
				this->instrMem[codePointer] = this->instrMem[codePointer].substr(0,10)+
					int2binary(op1[1] - '0', 3) + int2binary(op1[1] - '0', 3);
			}
			else {

				this->instrMem[codePointer] = this->instrMem[codePointer].substr(0, 13) +
					int2binary(op1[1] - '0', 3);
			}
			codePointer++;

		}

	}
	}

public:
	MyAssembler(string cfPath, string dfPath,string ifPath) {
		generateTables();
		this->codeFile.open(cfPath.c_str());
		this->dataFile.open(dfPath.c_str());
		this->instrFile.open(ifPath.c_str());
		this->DataMem.resize(512);
		this->instrMem.resize(512);
		this->dataPointer = 2;
	        this->codePointer = this->readDataSegment = this->syntaxError = this->finishedDataSegment = 0;
	}
	void run(){

			string line;
		while (!this->codeFile.eof() && !syntaxError) {
			getline(codeFile, line);
			line = deleteComments(line);
			lineParsing(line);
			numLine++;
		}
		if (syntaxError) {
			cout << "syntaxError at line " << numLine << " : " << line << endl;
			cout << line.size() << endl;
		}
		else {
			// print binary codes to dataFile & instrFile
			for (int i = 0; i < DataMem.size(); i++) {
				if (DataMem[i] == "") {
					this->dataFile << endl;
					continue;
				}
				this->dataFile << DataMem[i] << endl;
			}

			for (int i = 0; i < instrMem.size(); i++) {
				if (instrMem[i] == "") {
					this->instrFile << endl;
					continue;
				}
				this->instrFile << instrMem[i] << endl;
			}
		}

	}
	int stoi(string str){
		int ret = 0;
		for(int i = 0; i < str.length(); ++i) {
			ret *= 10;
			ret += str[i] - '0';
		}
		return ret;
	}
	void convertToMemFile(string instrfpath, string datafpath){
			ofstream file;
		file.open(instrfpath.c_str());
		file << "// memory data file (do not edit the following line - required for mem load use)\n";
		file << "// instance=/pu/RAM_LAB/MEMORY\n";
		file << "// format=bin addressradix=h dataradix=b version=1.0 wordsperline=1";
		file << "wordsperline=1" << endl;
		for (int i = 0; i < this->instrMem.size(); i++)
		{
			if (i <= 0xf) {
				file << "  @";
			}
			else if (i <= 0xff) {
				file << " @";
			}
			else {
				file << "@";
			}
			decToHexa(i, file);
			file << " ";
			if (this->instrMem[i] == "") {
				int x = 16;
				while (x--) {
					file << '0';
				}
			}
			else {
				file << this->instrMem[i];
			}
			file << endl;
		}
		file.close();

		file.open(datafpath.c_str());
		file << "// memory data file (do not edit the following line - required for mem load use)\n";
		file << "// instance=/pu/RAM_LAB/MEMORY\n";
		file << "// format=bin addressradix=h dataradix=b version=1.0 wordsperline=1";
		file << "wordsperline=1" << endl;
		for (int i = 0; i < this->DataMem.size(); i++)
		{
			if (i <= 0xf) {
				file << "  @";
			}
			else if (i <= 0xff) {
				file << " @";
			}
			else {
				file << "@";
			}
			decToHexa(i, file);
			file << " ";
			if (this->DataMem[i] == "") {
				int x = 16;
				while (x--) {
					file << 'X';
				}
			}
			else {
				file << this->DataMem[i];
			}
			file << endl;
		}
	}
	bool get_syntaxError(){
		return syntaxError;
	}
	~MyAssembler(){
		this->codeFile.close();
		if (this->get_syntaxError()) {
			this->codeFile.clear();
			this->codeFile.open(this->codeFilePath.c_str());
			this->codeFile.close();
		}
		this->codeFile.close();
	}

};

int main() {


	MyAssembler Assembler(codeFilePath, dataFilePath, instrFilePath);
	Assembler.run();
	if (!Assembler.get_syntaxError()) {
		cout << "Converting to mem file , please wait ..." << endl;
		Assembler.convertToMemFile(memInstrFilePath, memDataFilePath);
		cout << "Done -- Have Fun" << endl;
	}

	return 0;
}
