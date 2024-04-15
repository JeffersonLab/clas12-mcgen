#include <TFile.h>
#include <TTree.h>
#include <TChain.h>
#include <TF1.h>
#include <TRandom3.h>
#include <TRandom.h>

void gibuu2lund(char* inputfilename, char* outputfilename) {

  FILE *output = fopen(outputfilename, "w");

  std::vector <double> *Px = 0, *Py = 0, *Pz = 0, *Energy = 0;
  std::vector <int> *Pid = 0;
  double Weight = 0.0, Lep_Px = 0.0, Lep_Py = 0.0, Lep_Pz = 0.0, Lep_Energy = 0.0;

  TChain *locTree = new TChain("gst");
  locTree->Add(inputfilename);
  locTree->SetBranchAddress("weight", &Weight);
  locTree->SetBranchAddress("Px", &Px);
  locTree->SetBranchAddress("Py", &Py);
  locTree->SetBranchAddress("Pz", &Pz);
  locTree->SetBranchAddress("E", &Energy);
  locTree->SetBranchAddress("lepOut_Px", &Lep_Px);
  locTree->SetBranchAddress("lepOut_Py", &Lep_Py);
  locTree->SetBranchAddress("lepOut_Pz", &Lep_Pz);
  locTree->SetBranchAddress("lepOut_E", &Lep_Energy);
  locTree->SetBranchAddress("barcode", &Pid);
  std::cout << "data File has " << locTree->GetEntries()<<" entries " << std::endl;

  float vertex_x, vertex_y, vertex_z;
  TF1 *myfuncx = new TF1("myfuncx","TMath::BreitWigner(x, 0.1398, 0.366507 )",-2,2);
  TF1 *myfuncy = new TF1("myfuncy","TMath::BreitWigner(x, -0.0989511, 0.408273 )",-2,2);
  TRandom *r3 = new TRandom3(0);

  for(int loc_i = 0; loc_i < locTree->GetEntries(); ++loc_i) {
    locTree->GetEvent(loc_i);

    if(loc_i % 10000 == 0){
      fprintf (stderr, "%d Thousand\r ", loc_i/1000);
      fflush (stderr);
    }

    vertex_x=myfuncx->GetRandom();
    vertex_y=myfuncy->GetRandom();
    vertex_z=r3->Uniform(-5,1); // Give the z vertex a unifrorm value between the two extrema

    // The header file stuff
    fprintf(output, "%lu ", Px->size() + 1); // + 1 because we need to do scattered lepton too
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

    // Fill in the data according to the GEMC LUND file structure for the scattered lepton
    fprintf(output, "%s ", "");
    fprintf(output, "%i ", 1);
    fprintf(output, "%i ", -1);
    fprintf(output, "%i ", 1);
    fprintf(output, "%i ", 11);
    fprintf(output, "%i ", 0);
    fprintf(output, "%i ", 0);
    fprintf(output, "%.4e ", Lep_Px);
    fprintf(output, "%.4e ", Lep_Py);
    fprintf(output, "%.4e ", Lep_Pz);
    fprintf(output, "%.4e ", Lep_Energy);
    fprintf(output, "%.4e ", 0.000511);
    fprintf(output, "%.4e ", vertex_x);
    fprintf(output, "%.4e ", vertex_y);
    fprintf(output, "%.4e ", vertex_z);
    fprintf(output, "\n");

    // Now we will fill the final state particles by sorting their masses and charges
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

