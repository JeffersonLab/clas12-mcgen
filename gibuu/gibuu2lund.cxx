#include <TFile.h>
#include <TTree.h>
#include <TChain.h>
#include <TF1.h>

struct tree {
    double Q2=0;
    double nu=0;
    double eps=0;
    double phiL=0;
    std::vector <double> *px=0;
    std::vector <double> *py=0;
    std::vector <double> *pz=0;
    std::vector <double> *energy=0;
    std::vector <double> *weight=0;
    std::vector <int> *barcode=0;
    std::vector <int> *pid=0;
};

void gibuu2lund(char* inputfilename, char* outputfilename) {

  FILE *output = fopen(outputfilename, "w");

  std::vector <double> *Px = 0, *Py = 0, *Pz = 0, *Energy = 0;
  std::vector <int> *Pid = 0;
  double Weight = 0.0, Lep_Px = 0.0, Lep_Py = 0.0, Lep_Pz = 0.0, Lep_Energy = 0.0;

  double ebeam = 11.0;

  struct tree t;

  TChain *locTree = new TChain("RootTuple");
  locTree->Add(inputfilename);
  locTree->SetBranchAddress("barcode", &Pid);
  locTree->SetBranchAddress("Px", &Px);
  locTree->SetBranchAddress("Py", &Py);
  locTree->SetBranchAddress("Pz", &Pz);
  locTree->SetBranchAddress("E",  &Energy); 
  locTree->SetBranchAddress("weight", &Weight);
  locTree->SetBranchAddress("Q2", &t.Q2);
  locTree->SetBranchAddress("nu", &t.nu);
  locTree->SetBranchAddress("eps",&t.eps);
  locTree->SetBranchAddress("phiL", &t.phiL);

  const float vertex_x=0;
  const float vertex_y=0;
  const float vertex_z=0;

  for(int i = 0; i < locTree->GetEntries(); ++i) {
    
    locTree->GetEvent(i);

    // The event header:
    fprintf(output, "%lu ", Px->size());
    fprintf(output, "%i ", 4); // Number of nucleons in the nucleus N
    fprintf(output, "%i ", 2); // Number of protons in the nucleus Z
    fprintf(output, "%i ", 0);
    fprintf(output, "%i ", 0);
    fprintf(output, "%.4e ", 0.00051184);
    fprintf(output, "%.4e ", 5.986);
    fprintf(output, "%.4e ", 2212.0);
    fprintf(output, "%.4e ", 1.0);
    fprintf(output, "%.4e ", Weight);
    fprintf(output, "\n");

    // The scattered lepton:
    const double e = ebeam - t.nu;
    const double theta = 2*asin(sqrt(t.Q2/4/ebeam/e));
    const double px = e*sin(theta)*cos(t.phiL);
    const double py = e*sin(theta)*sin(t.phiL);
    const double pz = e*cos(theta);
    fprintf(output, "%s ", "");
    fprintf(output, "%i ", 1);
    fprintf(output, "%i ", -1);
    fprintf(output, "%i ", 1);
    fprintf(output, "%i ", 11);
    fprintf(output, "%i ", 0);
    fprintf(output, "%i ", 0);
    fprintf(output, "%.4e ", px);
    fprintf(output, "%.4e ", py);
    fprintf(output, "%.4e ", pz);
    fprintf(output, "%.4e ", e);
    fprintf(output, "%.4e ", 0.000511);
    fprintf(output, "%.4e ", vertex_x);
    fprintf(output, "%.4e ", vertex_y);
    fprintf(output, "%.4e ", vertex_z);
    fprintf(output, "\n");

    // The other final state particles:
    Double_t mass;
    Int_t Charge;
    for(Int_t i_ptcle = 0; i_ptcle < Pid->size(); i_ptcle++){
      mass = 0.0;
      Charge = 0.0;
      if(Pid->at(i_ptcle) == 11){
        mass = 0.0005;
        Charge = -1.0;
      }
      else if(Pid->at(i_ptcle) == 111){
        mass = 0.1349;
        Charge = 0.0;
      }
      else if(Pid->at(i_ptcle) == 211){
        mass = 0.1396;
        Charge = 1.0;
      }
      else if(Pid->at(i_ptcle) == -211){
        mass = 0.1396;
        Charge = -1.0;
      }
      else if(Pid->at(i_ptcle) == 321){
        mass = 0.495;
        Charge = 1.0;
      }
      else if(Pid->at(i_ptcle) == -321){
        mass = 0.495;
        Charge = -1.0;
      }
      else if(Pid->at(i_ptcle) == 311 || Pid->at(i_ptcle) == -311){
        mass = 0.495;
        Charge = 0.0;
      }
      else if(Pid->at(i_ptcle) == 2212){
        mass = 0.938;
        Charge = 1.0;
      }
      else if(Pid->at(i_ptcle) == -2212){
        mass = 0.938;
        Charge = -1.0;
      }
      else if(Pid->at(i_ptcle) == 2112){
        mass = 0.939;
        Charge = 0.0;
      }
      fprintf(output, "%s ", "");
      fprintf(output, "%i ", i_ptcle + 2);
      fprintf(output, "%i ", Charge);
      fprintf(output, "%i ", 1);
      fprintf(output, "%i ", Pid->at(i_ptcle));
      fprintf(output, "%i ", 0);
      fprintf(output, "%i ", 0);
      fprintf(output, "%.4e ", Px->at(i_ptcle));
      fprintf(output, "%.4e ", Py->at(i_ptcle));
      fprintf(output, "%.4e ", Pz->at(i_ptcle));
      fprintf(output, "%.4e ", Energy->at(i_ptcle));
      fprintf(output, "%.4e ", mass);
      fprintf(output, "%.4e ", vertex_x);
      fprintf(output, "%.4e ", vertex_y);
      fprintf(output, "%.4e ", vertex_z);
      fprintf(output, "\n");
    }

  }

  fclose(output);

}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        printf("Usage:  gibuu2lund  GiBUU-ROOT-filename LUND-filename\n");
        exit(1);
    }
    gibuu2lund(argv[1],argv[2]);
}

