#include <stdio.h>
#include <stdlib.h>

typedef struct {
  char riff[4];
  int chunkSize;
  char wave[4];
  char fmt[4];
  int subchunk1Size;
  short audioFormat;
  short numChannels;
  int sampleRate;
  int byteRate;
  short blockAlign;
  short bitsPerSample;
  char data[4];
  int dataSize;
} WavHeader;

extern void echo(u_int16_t * arr_ptr, u_int32_t numSamples, float alfa, int offset);

int main(int argc, char **argv) {

  char filename[256];
  snprintf(filename, sizeof(filename), "%s.wav", argv[1]);
  float alfa = atof(argv[2]);
  int offset = atoi(argv[3]);

  FILE *file = fopen(filename, "rb");
  if (file == NULL) {
    printf("Could not open file\n");
    return 1;
  }
  WavHeader header;
  fread(&header, sizeof(WavHeader), 1, file);

  u_int32_t numSamples = header.dataSize / (header.bitsPerSample / 8);

  u_int16_t *samples = malloc(numSamples * sizeof(short));

  for (int i = 0; i < numSamples; i++) {
    fread(&samples[i], sizeof(short), 1, file);
  }

  int copy[numSamples];
  for (int i = 0; i < numSamples; ++i) {
    copy[i] = samples[i];
  }

  echo(samples, numSamples, alfa, offset);
  

  FILE *newFile = fopen(filename, "wb");
  if (newFile == NULL) {
    printf("Nie udało się utworzyć nowego pliku\n");
    return 1;
  }
  fwrite(&header, sizeof(WavHeader), 1, newFile);

  for (int i = 0; i < numSamples; i++) {
    fwrite(&samples[i], sizeof(short), 1, newFile);
  }

  free(samples);

  fclose(file);
  fclose(newFile);
  return 0;
}