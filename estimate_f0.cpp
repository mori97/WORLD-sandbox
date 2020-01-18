#include <audioio.h>
#include <getopt.h>
#include <world/dio.h>
#include <world/stonemask.h>

#include <cstdlib>
#include <fstream>
#include <iostream>
#include <vector>

const struct option longopts[] = {{"input", required_argument, NULL, 'i'},
                                  {"output", required_argument, NULL, 'o'},
                                  {0, 0, 0, 0}};

std::vector<std::pair<double, double>> f0_analysis(std::vector<double> &sound,
                                                   int fs) {
  DioOption option;
  InitializeDioOption(&option);

  int f0_len = GetSamplesForDIO(fs, sound.size(), option.frame_period);
  std::vector<double> f0(f0_len);
  std::vector<double> time_axis(f0_len);
  std::vector<double> refined_f0(f0_len);

  Dio(sound.data(), sound.size(), fs, &option, time_axis.data(), f0.data());
  StoneMask(sound.data(), sound.size(), fs, time_axis.data(), f0.data(),
            f0.size(), refined_f0.data());

  std::vector<std::pair<double, double>> ret;
  for (std::size_t i = 0; i < time_axis.size(); i++) {
    ret.push_back({time_axis.at(i), refined_f0.at(i)});
  }
  return ret;
}

int main(int argc, char *argv[]) {
  /* Parse command-line arguments */
  int opt;
  // Default values
  std::string input = "./input.wav";
  std::string output = "./output.csv";
  while ((opt = getopt_long(argc, argv, "i:o:", longopts, NULL)) != -1) {
    switch (opt) {
      case 'i':
        input = optarg;
        break;
      case 'o':
        output = optarg;
        break;
      default: /* '?' */
        std::cout << "Usage: " << argv[0]
                  << " [--input INPUT] [--output OUTPUT]" << std::endl
                  << "optional arguments:" << std::endl
                  << "  --input INPUT, -i INPUT       Input .wav file"
                  << std::endl
                  << "  --output OUTPUT, -o OUTPUT    Output .csv file"
                  << std::endl;
        return EXIT_FAILURE;
    }
  }

  /* Load audio file */
  int sound_len = GetAudioLength(input.c_str());
  if (sound_len <= 0) {
    if (sound_len == 0) {
      std::cerr << "Error: " << input << " not found." << std::endl;
    } else {
      std::cerr << "Error: " << input << " is not a .wav file." << std::endl;
    }
    return EXIT_FAILURE;
  }

  std::vector<double> sound(sound_len);
  int fs, nbit;
  wavread(input.c_str(), &fs, &nbit, sound.data());

  /* F0 frequency estimation */
  auto f0_result = f0_analysis(sound, fs);

  /* Save */
  std::ofstream fout(output);
  fout << "Time,F0 Frequency" << std::endl;
  for (auto i : f0_result) {
    auto [t, f0] = i;
    fout << t << ',' << f0 << std::endl;
  }
  fout.close();

  return EXIT_SUCCESS;
}
