#include <TFile.h>
#include <TTree.h>
#include <TChain.h>
#include <TF1.h>
#include <TRandom3.h>
#include <TRandom.h>

void genie2lund(char* inputfilename, char* outputfilename) {

  FILE *output = fopen(outputfilename, "w");;

  TChain *locTree = new TChain("gst");
  locTree->Add(inputfilename);

  std::vector <double> loc_Px, loc_Py, loc_Pz, loc_Energy;
  std::vector <int> loc_Pid;
  double Px[20], Py[20], Pz[20], Energy[20];
  int Pid[20];
  double Weight = 0.0, Lep_Px = 0.0, Lep_Py = 0.0, Lep_Pz = 0.0, Lep_Energy = 0.0;

  locTree->SetBranchAddress("wght", &Weight);
  locTree->SetBranchAddress("pxf", &Px);
  locTree->SetBranchAddress("pyf", &Py);
  locTree->SetBranchAddress("pzf", &Pz);
  locTree->SetBranchAddress("Ef", &Energy);
  locTree->SetBranchAddress("pxl", &Lep_Px);
  locTree->SetBranchAddress("pyl", &Lep_Py);
  locTree->SetBranchAddress("pzl", &Lep_Pz);
  locTree->SetBranchAddress("El", &Lep_Energy);
  locTree->SetBranchAddress("pdgf", &Pid);

  float vertex_x, vertex_y, vertex_z;
  TF1 *myfuncx = new TF1("myfuncx","TMath::BreitWigner(x, 0.1398, 0.366507 )",-2,2);
  TF1 *myfuncy = new TF1("myfuncy","TMath::BreitWigner(x, -0.0989511, 0.408273 )",-2,2);
  TRandom *r3 = new TRandom3(0);

  std::cout << "data File has " << locTree->GetEntries()<<" entries " << std::endl;

  for(int loc_i = 0; loc_i<locTree->GetEntries(); ++loc_i){
    locTree->GetEvent(loc_i);
    if(loc_i % 10000 == 0){
      fprintf (stderr, "%d Thousand\r ", loc_i/1000);
      fflush (stderr);
    }

    Int_t nParticles = 0;
    for(Int_t i_ptcle = 0; i_ptcle < sizeof(Pz)/sizeof(Pz[0]); i_ptcle++){
      if(Energy[i_ptcle] < 0.0001)continue; // This is annoying, but GENIE's gst file saves everything as an array, which is a pain to deal with
      nParticles++;
    }

    vertex_x=myfuncx->GetRandom();
    vertex_y=myfuncy->GetRandom();
    vertex_z=r3->Uniform(-5,1); // Give the z vertex a unifrorm value between the two extrema

    // The header file stuff
    fprintf(output, "%i ", nParticles + 1); // + 1 because we need to do scattered lepton too
    fprintf(output, "%i ", 2);
    fprintf(output, "%i ", 1);
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
    for(Int_t i_ptcle = 0; i_ptcle < nParticles; i_ptcle++){
      if(Energy[i_ptcle] < 0.0001)continue;
      mass = 0.0;
      Charge = 0.0;
      if(Pid[i_ptcle] == 11){
        mass = 0.0005;
        Charge = -1.0;
      }
      else if(Pid[i_ptcle] == 111){
        mass = 0.1349;
        Charge = 0.0;
      }
      else if(Pid[i_ptcle] == 211){
        mass = 0.1396;
        Charge = 1.0;
      }
      else if(Pid[i_ptcle] == -211){
        mass = 0.1396;
        Charge = -1.0;
      }
      else if(Pid[i_ptcle] == 321){
        mass = 0.495;
        Charge = 1.0;
      }
      else if(Pid[i_ptcle] == -321){
        mass = 0.495;
        Charge = -1.0;
      }
      else if(Pid[i_ptcle] == 311 || Pid[i_ptcle] == -311){
        mass = 0.495;
        Charge = 0.0;
      }
      else if(Pid[i_ptcle] == 2212){
        mass = 0.938;
        Charge = 1.0;
      }
      else if(Pid[i_ptcle] == -2212){
        mass = 0.938;
        Charge = -1.0;
      }
      else if(Pid[i_ptcle] == 2112){
        mass = 0.939;
        Charge = 0.0;
      }
      fprintf(output, "%s ", "");
      fprintf(output, "%i ", i_ptcle + 2);
      fprintf(output, "%i ", Charge);
      fprintf(output, "%i ", 1);
      fprintf(output, "%i ", Pid[i_ptcle]);
      fprintf(output, "%i ", 0);
      fprintf(output, "%i ", 0);
      fprintf(output, "%.4e ", Px[i_ptcle]);
      fprintf(output, "%.4e ", Py[i_ptcle]);
      fprintf(output, "%.4e ", Pz[i_ptcle]);
      fprintf(output, "%.4e ", Energy[i_ptcle]);
      fprintf(output, "%.4e ", mass);
      fprintf(output, "%.4e ", vertex_x);
      fprintf(output, "%.4e ", vertex_y);
      fprintf(output, "%.4e ", vertex_z);
      fprintf(output, "\n");
    }

    // Clear the array at the end of an event so we don't carry over data to other events
    for(int i_arr = 0; i_arr < 20; i_arr++){
      Energy[i_arr] = 0;
    }

  }

  fclose(output);

}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        printf("Usage:  gibuu2lund  GiBUU-ROOT-filename LUND-filename\n");
        exit(1);
    }
    genie2lund(argv[1],argv[2]);
}

