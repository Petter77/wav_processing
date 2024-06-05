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

void printHeader(WavHeader *header) {
  printf("riff: %s\n", header->riff);
  printf("chunkSize: %i\n", header->chunkSize);
  printf("wave: %s\n", header->wave);
  printf("fmt: %s\n", header->fmt);
  printf("subchunk1Size: %i\n", header->subchunk1Size);
  printf("audioFormat: %i\n", header->audioFormat);
  printf("numChannels: %i\n", header->numChannels);
  printf("sampleRate: %i\n", header->sampleRate);
  printf("byteRate: %i\n", header->byteRate);
  printf("blockAlign: %i\n", header->blockAlign);
  printf("bitsPerSample: %i\n", header->bitsPerSample);
  printf("data: %s\n", header->data);
  printf("dataSize: %i\n", header->dataSize);
}

extern void echo(u_int16_t * arr_ptr, u_int32_t numSamples, float alfa, int offset);

int main() {
  FILE *file = fopen("example.wav", "rb");
  if (file == NULL) {
    printf("Could not open file\n");
    return 1;
  }
  WavHeader header;
  fread(&header, sizeof(WavHeader), 1, file);

  u_int32_t numSamples = header.dataSize / (header.bitsPerSample / 8);
  printf("%i", numSamples);

  u_int16_t *samples = malloc(numSamples * sizeof(short)); //wskaźnik na tablicę

  // Odczyt próbek z pliku
  for (int i = 0; i < numSamples; i++) {
    fread(&samples[i], sizeof(short), 1, file);
  }

  float alfa = .7f;
  int offset = 7;


  echo(samples, numSamples, alfa, offset);

  free(samples);
  fclose(file);
  return 0;
}