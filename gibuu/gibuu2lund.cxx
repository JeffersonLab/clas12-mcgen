#include <TFile.h>
#include <TTree.h>
#include <TChain.h>
#include <TF1.h>
#include <TDatabasePDG.h>
#include <TParticlePDG.h>

struct event {
    double weight=0;
    double Q2=0;
    double nu=0;
    double eps=0;
    double phiL=0;
    std::vector <double> *px=0;
    std::vector <double> *py=0;
    std::vector <double> *pz=0;
    std::vector <double> *e=0;
    std::vector <int> *barcode=0;
    std::vector <int> *pid=0;
};

void gibuu2lund(char* inputfilename, char* outputfilename) {

  FILE *output = fopen(outputfilename, "w");

  double ebeam = 11.0;

  struct event t;

  TChain *tree = new TChain("RootTuple");
  tree->Add(inputfilename);
  tree->SetBranchAddress("barcode", &t.pid);
  tree->SetBranchAddress("Px", &t.px);
  tree->SetBranchAddress("Py", &t.py);
  tree->SetBranchAddress("Pz", &t.pz);
  tree->SetBranchAddress("E",  &t.e); 
  tree->SetBranchAddress("weight", &t.weight);
  tree->SetBranchAddress("Q2", &t.Q2);
  tree->SetBranchAddress("nu", &t.nu);
  tree->SetBranchAddress("eps",&t.eps);
  tree->SetBranchAddress("phiL", &t.phiL);

  const float vertex_x=0;
  const float vertex_y=0;
  const float vertex_z=0;

  for(int ievent = 0; ievent < tree->GetEntries(); ++ievent) {
    
    tree->GetEvent(ievent);

    // The event header:
    fprintf(output, "%lu ", t.px->size()+1);
    fprintf(output, "%i ", 4); // Number of nucleons in the nucleus N
    fprintf(output, "%i ", 2); // Number of protons in the nucleus Z
    fprintf(output, "%i ", 0);
    fprintf(output, "%i ", 0);
    fprintf(output, "%.4e ", 0.00051184);
    fprintf(output, "%.4e ", 5.986);
    fprintf(output, "%.4e ", 2212.0);
    fprintf(output, "%.4e ", 1.0);
    fprintf(output, "%.4e ", t.weight);
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
    for(int ipart = 0; ipart < t.pid->size(); ipart++){
      TParticlePDG *p = TDatabasePDG::Instance()->GetParticle(t.pid->at(ipart));
      fprintf(output, "%s ", "");
      fprintf(output, "%i ", (ipart + 2));
      fprintf(output, "%i ", int(p->Charge()/3));
      fprintf(output, "%i ", 1);
      fprintf(output, "%i ", t.pid->at(ipart));
      fprintf(output, "%i ", 0);
      fprintf(output, "%i ", 0);
      fprintf(output, "%.4e ", t.px->at(ipart));
      fprintf(output, "%.4e ", t.py->at(ipart));
      fprintf(output, "%.4e ", t.pz->at(ipart));
      fprintf(output, "%.4e ", t.e->at(ipart));
      fprintf(output, "%.4e ", p->Mass());
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
        printf("Usage:  gibuu2lund [-ebeam #] GiBUU-ROOT-filename LUND-filename\n");
        exit(1);
    }
    gibuu2lund(argv[1],argv[2]);
}

